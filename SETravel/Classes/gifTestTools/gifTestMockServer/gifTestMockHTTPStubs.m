//
//  gifTestToolsKeyFileMap.h
//  gifTestTools
//
//  Created by Sam Chen on 2021/8/27.
//

#import "gifTestMockHTTPStubs.h"


@interface gifTestURLProtocol : NSURLProtocol
@end

static NSTimeInterval const kSlotTime = 0.25; // Must be >0. We will send a chunk of the data from the stream each 'slotTime' seconds

@interface gifTestMockHTTPStubs()

+ (instancetype)sharedInstance;
@property(atomic, copy) NSMutableArray* stubDescriptors;
@property(atomic, assign) BOOL enabledState;
@property(atomic, copy, nullable) void (^onStubActivationBlock)(NSURLRequest*, id<gifTestHTTPStubsDescriptor>, gifTestMockResponse*);
@property(atomic, copy, nullable) void (^onStubRedirectBlock)(NSURLRequest*, NSURLRequest*, id<gifTestHTTPStubsDescriptor>, gifTestMockResponse*);
@property(atomic, copy, nullable) void (^afterStubFinishBlock)(NSURLRequest*, id<gifTestHTTPStubsDescriptor>, gifTestMockResponse*, NSError*);
@property(atomic, copy, nullable) void (^onStubMissingBlock)(NSURLRequest*);

@end

@interface gifTestHTTPStubsDescriptor : NSObject <gifTestHTTPStubsDescriptor>

@property(atomic, copy) HTTPStubsTestBlock testBlock;
@property(atomic, copy) HTTPStubsResponseBlock responseBlock;

@end

////////////////////////////////////////////////////////////////////////////////
#pragma mark - gifTestHTTPStubsDescriptor Implementation

@implementation gifTestHTTPStubsDescriptor

@synthesize name = _name;

+ (instancetype)stubDescriptorWithTestBlock:(HTTPStubsTestBlock)testBlock
                              responseBlock:(HTTPStubsResponseBlock)responseBlock {
    gifTestHTTPStubsDescriptor* stub = [gifTestHTTPStubsDescriptor new];
    stub.testBlock = testBlock;
    stub.responseBlock = responseBlock;
    return stub;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"<%@ %p : %@>", self.class, self, self.name];
}

@end

@implementation gifTestMockHTTPStubs

+ (instancetype)sharedInstance {
    static gifTestMockHTTPStubs *sharedInstance = nil;
    
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

+ (void)initialize {
    if (self == [gifTestMockHTTPStubs class]) {
        [self _setEnable:YES];
    }
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _stubDescriptors = [NSMutableArray array];
        _enabledState = YES; // assume initialize has already been run
    }
    return self;
}

- (void)dealloc {
    [self.class _setEnable:NO];
}

+ (id<gifTestHTTPStubsDescriptor>)stubRequestsPassingTest:(HTTPStubsTestBlock)testBlock
                                         withStubResponse:(HTTPStubsResponseBlock)responseBlock {
    gifTestHTTPStubsDescriptor* stub = [gifTestHTTPStubsDescriptor stubDescriptorWithTestBlock:testBlock
                                                                                 responseBlock:responseBlock];
    [gifTestMockHTTPStubs.sharedInstance addStub:stub];
    return stub;
}

+ (BOOL)removeStub:(id<gifTestHTTPStubsDescriptor>)stubDesc {
    return [gifTestMockHTTPStubs.sharedInstance removeStub:stubDesc];
}

+ (void)removeAllStubs {
    [gifTestMockHTTPStubs.sharedInstance removeAllStubs];
}

+ (void)_setEnable:(BOOL)enable {
    if (enable) {
        [NSURLProtocol registerClass:gifTestURLProtocol.class];
    } else {
        [NSURLProtocol unregisterClass:gifTestURLProtocol.class];
    }
}

+ (void)setEnabled:(BOOL)enabled {
    [gifTestMockHTTPStubs.sharedInstance setEnabled:enabled];
}

+ (BOOL)isEnabled {
    return gifTestMockHTTPStubs.sharedInstance.isEnabled;
}

#if defined(__IPHONE_7_0) || defined(__MAC_10_9)
+ (void)setEnabled:(BOOL)enable forSessionConfiguration:(NSURLSessionConfiguration*)sessionConfig {
    // Runtime check to make sure the API is available on this version
    if ([sessionConfig respondsToSelector:@selector(protocolClasses)]
        && [sessionConfig respondsToSelector:@selector(setProtocolClasses:)]) {
        NSMutableArray * urlProtocolClasses = [NSMutableArray arrayWithArray:sessionConfig.protocolClasses];
        Class protoCls = gifTestURLProtocol.class;
        if (enable && ![urlProtocolClasses containsObject:protoCls]) {
            [urlProtocolClasses insertObject:protoCls atIndex:0];
        } else if (!enable && [urlProtocolClasses containsObject:protoCls]) {
            [urlProtocolClasses removeObject:protoCls];
        }
        sessionConfig.protocolClasses = urlProtocolClasses;
    }
}

+ (BOOL)isEnabledForSessionConfiguration:(NSURLSessionConfiguration *)sessionConfig {
    // Runtime check to make sure the API is available on this version
    if ([sessionConfig respondsToSelector:@selector(protocolClasses)]
        && [sessionConfig respondsToSelector:@selector(setProtocolClasses:)]) {
        NSMutableArray * urlProtocolClasses = [NSMutableArray arrayWithArray:sessionConfig.protocolClasses];
        Class protoCls = gifTestURLProtocol.class;
        return [urlProtocolClasses containsObject:protoCls];
    } else {
        return NO;
    }
}
#endif

#pragma mark > Debug Methods

+ (NSArray*)allStubs {
    return [gifTestMockHTTPStubs.sharedInstance stubDescriptors];
}

+ (void)onStubActivation:( nullable void(^)(NSURLRequest* request, id<gifTestHTTPStubsDescriptor> stub, gifTestMockResponse* responseStub) )block {
    [gifTestMockHTTPStubs.sharedInstance setOnStubActivationBlock:block];
}

+ (void)onStubRedirectResponse:( nullable void(^)(NSURLRequest* request, NSURLRequest* redirectRequest, id<gifTestHTTPStubsDescriptor> stub, gifTestMockResponse* responseStub) )block {
    [gifTestMockHTTPStubs.sharedInstance setOnStubRedirectBlock:block];
}

+ (void)afterStubFinish:( nullable void(^)(NSURLRequest* request, id<gifTestHTTPStubsDescriptor> stub, gifTestMockResponse* responseStub, NSError* error) )block {
    [gifTestMockHTTPStubs.sharedInstance setAfterStubFinishBlock:block];
}

+ (void)onStubMissing:( nullable void(^)(NSURLRequest* request) )block {
    [gifTestMockHTTPStubs.sharedInstance setOnStubMissingBlock:block];
}

- (BOOL)isEnabled {
    BOOL enabled = NO;
    @synchronized(self)
    {
        enabled = _enabledState;
    }
    return enabled;
}

- (void)setEnabled:(BOOL)enable {
    @synchronized(self)
    {
        _enabledState = enable;
        [self.class _setEnable:_enabledState];
    }
}

- (void)addStub:(gifTestHTTPStubsDescriptor*)stubDesc {
    @synchronized(_stubDescriptors)
    {
        [_stubDescriptors addObject:stubDesc];
    }
}

- (BOOL)removeStub:(id<gifTestHTTPStubsDescriptor>)stubDesc {
    BOOL handlerFound = NO;
    @synchronized(_stubDescriptors)
    {
        handlerFound = [_stubDescriptors containsObject:stubDesc];
        [_stubDescriptors removeObject:stubDesc];
    }
    return handlerFound;
}

- (void)removeAllStubs {
    @synchronized(_stubDescriptors)
    {
        [_stubDescriptors removeAllObjects];
    }
}

- (gifTestHTTPStubsDescriptor*)firstStubPassingTestForRequest:(NSURLRequest*)request {
    gifTestHTTPStubsDescriptor* foundStub = nil;
    @synchronized(_stubDescriptors)
    {
        for(gifTestHTTPStubsDescriptor* stub in _stubDescriptors.reverseObjectEnumerator) {
            if (stub.testBlock(request)) {
                foundStub = stub;
                break;
            }
        }
    }
    return foundStub;
}

@end


@interface gifTestURLProtocol()

@property(assign) BOOL stopped;
@property(strong) gifTestHTTPStubsDescriptor* stub;
@property(assign) CFRunLoopRef clientRunLoop;
- (void)executeOnClientRunLoopAfterDelay:(NSTimeInterval)delayInSeconds block:(dispatch_block_t)block;

@end

@implementation gifTestURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    BOOL found = ([gifTestMockHTTPStubs.sharedInstance firstStubPassingTestForRequest:request] != nil);
    if (!found && gifTestMockHTTPStubs.sharedInstance.onStubMissingBlock) {
        gifTestMockHTTPStubs.sharedInstance.onStubMissingBlock(request);
    }
    return found;
}

- (id)initWithRequest:(NSURLRequest *)request cachedResponse:(NSCachedURLResponse *)response client:(id<NSURLProtocolClient>)client {
    // Make super sure that we never use a cached response.
    gifTestURLProtocol* proto = [super initWithRequest:request cachedResponse:nil client:client];
    proto.stub = [gifTestMockHTTPStubs.sharedInstance firstStubPassingTestForRequest:request];
    return proto;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    return request;
}

- (NSCachedURLResponse *)cachedResponse {
    return nil;
}

/** Drop certain headers in accordance with
 * https://developer.apple.com/documentation/foundation/urlsessionconfiguration/1411532-httpadditionalheaders
 */
- (NSMutableURLRequest *)clearAuthHeadersForRequest:(NSMutableURLRequest *)request {
    NSArray* authHeadersToRemove = @[
        @"Authorization",
        @"Connection",
        @"Host",
        @"Proxy-Authenticate",
        @"Proxy-Authorization",
        @"WWW-Authenticate"
    ];
    for (NSString* header in authHeadersToRemove) {
        [request setValue:nil forHTTPHeaderField:header];
    }
    return request;
}

- (void)startLoading {
    self.clientRunLoop = CFRunLoopGetCurrent();
    NSURLRequest* request = self.request;
    id<NSURLProtocolClient> client = self.client;
    
    if (!self.stub) {
        NSDictionary* userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"It seems like the stub has been removed BEFORE the response had time to be sent.",
                                  NSLocalizedFailureReasonErrorKey,
                                  @"For more info, see https://github.com/AliSoftware/OHHTTPStubs/wiki/OHHTTPStubs-and-asynchronous-tests",
                                  NSLocalizedRecoverySuggestionErrorKey,
                                  request.URL, // Stop right here if request.URL is nil
                                  NSURLErrorFailingURLErrorKey,
                                  nil];
        NSError* error = [NSError errorWithDomain:@"OHHTTPStubs" code:500 userInfo:userInfo];
        [client URLProtocol:self didFailWithError:error];
        if (gifTestMockHTTPStubs.sharedInstance.afterStubFinishBlock) {
            gifTestMockHTTPStubs.sharedInstance.afterStubFinishBlock(request, self.stub, nil, error);
        }
        return;
    }
    
    gifTestMockResponse* responseStub = self.stub.responseBlock(request);
    if (gifTestMockHTTPStubs.sharedInstance.onStubActivationBlock) {
        gifTestMockHTTPStubs.sharedInstance.onStubActivationBlock(request, self.stub, responseStub);
    }
    
    if (responseStub.error == nil) {
        NSHTTPURLResponse* urlResponse = [[NSHTTPURLResponse alloc] initWithURL:request.URL
                                                                     statusCode:responseStub.statusCode
                                                                    HTTPVersion:@"HTTP/1.1"
                                                                   headerFields:responseStub.httpHeaders];
        
        // Cookies handling
        if (request.HTTPShouldHandleCookies && request.URL) {
            NSArray* cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:responseStub.httpHeaders forURL:request.URL];
            if (cookies) {
                [NSHTTPCookieStorage.sharedHTTPCookieStorage setCookies:cookies forURL:request.URL mainDocumentURL:request.mainDocumentURL];
            }
        }
        
        NSString* redirectLocation = (responseStub.httpHeaders)[@"Location"];
        NSURL* redirectLocationURL;
        if (redirectLocation) {
            redirectLocationURL = [NSURL URLWithString:redirectLocation];
        } else {
            redirectLocationURL = nil;
        }
        [self executeOnClientRunLoopAfterDelay:responseStub.requestTime block:^{
            if (!self.stopped) {
                // Notify if a redirection occurred
                if (((responseStub.statusCode > 300) && (responseStub.statusCode < 400)) && redirectLocationURL) {
                    NSURLRequest *redirectRequest;
                    NSMutableURLRequest *mReq;
                    switch (responseStub.statusCode) {
                        case 301:
                        case 302:
                        case 307:
                        case 308: {
                            //Preserve the original request method and body, and set the new location URL
                            mReq = [self.request mutableCopy];
                            [mReq setURL:redirectLocationURL];
                            
                            mReq = [self clearAuthHeadersForRequest:mReq];
                            
                            redirectRequest = (NSURLRequest*)[mReq copy];
                            break;
                        }
                        default:
                            redirectRequest = [NSURLRequest requestWithURL:redirectLocationURL];
                            break;
                    }
                    
                    [client URLProtocol:self wasRedirectedToRequest:redirectRequest redirectResponse:urlResponse];
                    if (gifTestMockHTTPStubs.sharedInstance.onStubRedirectBlock) {
                        gifTestMockHTTPStubs.sharedInstance.onStubRedirectBlock(request, redirectRequest, self.stub, responseStub);
                    }
                }
                
                // Send the response (even for redirections)
                [client URLProtocol:self didReceiveResponse:urlResponse cacheStoragePolicy:NSURLCacheStorageNotAllowed];
                if(responseStub.inputStream.streamStatus == NSStreamStatusNotOpen) {
                    [responseStub.inputStream open];
                }
                [self streamDataForClient:client
                         withStubResponse:responseStub
                               completion:^(NSError * error) {
                    [responseStub.inputStream close];
                    NSError *blockError = nil;
                    if (error==nil) {
                        [client URLProtocolDidFinishLoading:self];
                    } else {
                        [client URLProtocol:self didFailWithError:responseStub.error];
                        blockError = responseStub.error;
                    }
                    if (gifTestMockHTTPStubs.sharedInstance.afterStubFinishBlock) {
                        gifTestMockHTTPStubs.sharedInstance.afterStubFinishBlock(request, self.stub, responseStub, blockError);
                    }
                }];
            }
        }];
    } else {
        // Send the canned error
        [self executeOnClientRunLoopAfterDelay:responseStub.responseTime block:^{
            if (!self.stopped) {
                [client URLProtocol:self didFailWithError:responseStub.error];
                if (gifTestMockHTTPStubs.sharedInstance.afterStubFinishBlock) {
                    gifTestMockHTTPStubs.sharedInstance.afterStubFinishBlock(request, self.stub, responseStub, responseStub.error);
                }
            }
        }];
    }
}

- (void)stopLoading {
    self.stopped = YES;
}

typedef struct {
    NSTimeInterval slotTime;
    double chunkSizePerSlot;
    double cumulativeChunkSize;
} HTTPStubsStreamTimingInfo;

- (void)streamDataForClient:(id<NSURLProtocolClient>)client
           withStubResponse:(gifTestMockResponse*)stubResponse
                 completion:(void(^)(NSError * error))completion {
    if (!self.stopped) {
        if ((stubResponse.dataSize>0) && stubResponse.inputStream.hasBytesAvailable) {
            // Compute timing data once and for all for this stub
            
            HTTPStubsStreamTimingInfo timingInfo = {
                .slotTime = kSlotTime, // Must be >0. We will send a chunk of data from the stream each 'slotTime' seconds
                .cumulativeChunkSize = 0
            };
            
            if(stubResponse.responseTime < 0) {
                // Bytes send each 'slotTime' seconds = Speed in KB/s * 1000 * slotTime in seconds
                timingInfo.chunkSizePerSlot = (fabs(stubResponse.responseTime) * 1000) * timingInfo.slotTime;
            }
            else if (stubResponse.responseTime < kSlotTime) {
                // We want to send the whole data quicker than the slotTime, so send it all in one chunk.
                timingInfo.chunkSizePerSlot = stubResponse.dataSize;
                timingInfo.slotTime = stubResponse.responseTime;
            } else {
                // Bytes send each 'slotTime' seconds = (Whole size in bytes / response time) * slotTime = speed in bps * slotTime in seconds
                timingInfo.chunkSizePerSlot = ((stubResponse.dataSize/stubResponse.responseTime) * timingInfo.slotTime);
            }
            
            [self streamDataForClient:client
                           fromStream:stubResponse.inputStream
                           timingInfo:timingInfo
                           completion:completion];
        } else {
            [self executeOnClientRunLoopAfterDelay:stubResponse.responseTime block:^{
                if (completion && !self.stopped)
                {
                    completion(nil);
                }
            }];
        }
    }
}

- (void)streamDataForClient:(id<NSURLProtocolClient>)client
                 fromStream:(NSInputStream*)inputStream
                 timingInfo:(HTTPStubsStreamTimingInfo)timingInfo
                 completion:(void(^)(NSError * error))completion {
    NSParameterAssert(timingInfo.chunkSizePerSlot > 0);
    
    if (inputStream.hasBytesAvailable && (!self.stopped)) {
        // This is needed in case we computed a non-integer chunkSizePerSlot, to avoid cumulative errors
        double cumulativeChunkSizeAfterRead = timingInfo.cumulativeChunkSize + timingInfo.chunkSizePerSlot;
        NSUInteger chunkSizeToRead = floor(cumulativeChunkSizeAfterRead) - floor(timingInfo.cumulativeChunkSize);
        timingInfo.cumulativeChunkSize = cumulativeChunkSizeAfterRead;
        
        if (chunkSizeToRead == 0) {
            // Nothing to read at this pass, but probably later
            [self executeOnClientRunLoopAfterDelay:timingInfo.slotTime block:^{
                [self streamDataForClient:client fromStream:inputStream
                               timingInfo:timingInfo completion:completion];
            }];
        } else {
            uint8_t* buffer = (uint8_t*)malloc(sizeof(uint8_t)*chunkSizeToRead);
            NSInteger bytesRead = [inputStream read:buffer maxLength:chunkSizeToRead];
            if (bytesRead > 0) {
                NSData * data = [NSData dataWithBytes:buffer length:bytesRead];
                // Wait for 'slotTime' seconds before sending the chunk.
                // If bytesRead < chunkSizePerSlot (because we are near the EOF), adjust slotTime proportionally to the bytes remaining
                [self executeOnClientRunLoopAfterDelay:((double)bytesRead / (double)chunkSizeToRead) * timingInfo.slotTime block:^{
                    [client URLProtocol:self didLoadData:data];
                    [self streamDataForClient:client fromStream:inputStream
                                   timingInfo:timingInfo completion:completion];
                }];
            } else {
                if (completion) {
                    completion(inputStream.streamError);
                }
            }
            free(buffer);
        }
    } else {
        if (completion) {
            completion(nil);
        }
    }
}

- (void)executeOnClientRunLoopAfterDelay:(NSTimeInterval)delayInSeconds block:(dispatch_block_t)block {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CFRunLoopPerformBlock(self.clientRunLoop, kCFRunLoopDefaultMode, block);
        CFRunLoopWakeUp(self.clientRunLoop);
    });
}

@end
