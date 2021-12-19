//
//  gifTestToolsKeyFileMap.h
//  gifTestTools
//
//  Created by Sam Chen on 2021/8/27.
//

#import "gifTestMockResponse.h"

#pragma mark - Defines & Constants
const double gifTestMockDownloadSpeed1KBPS  =-     8 / 8; // kbps -> KB/s
const double gifTestMockDownloadSpeedSLOW   =-    12 / 8; // kbps -> KB/s
const double gifTestMockDownloadSpeedGPRS   =-    56 / 8; // kbps -> KB/s
const double gifTestMockDownloadSpeedEDGE   =-   128 / 8; // kbps -> KB/s
const double gifTestMockDownloadSpeed3G     =-  3200 / 8; // kbps -> KB/s
const double gifTestMockDownloadSpeed3GPlus =-  7200 / 8; // kbps -> KB/s
const double gifTestMockDownloadSpeedWifi   =- 12000 / 8; // kbps -> KB/s

@implementation gifTestMockResponse

+(instancetype)responseForModule:(KSTestModuleType)moduleType
                    WithResource:(KSTestResourceKey)resourceKey
                      statusCode:(NSInteger)statusCode
                         headers:(nullable NSDictionary*)httpHeaders {
    NSString *filePath = [[gifTestResourceHelper sharedHelper] syncFetchResourceForModule:moduleType
                                                                             withResource:resourceKey];
    return [gifTestMockResponse responseWithFileAtPath:filePath
                                            statusCode:statusCode
                                               headers:httpHeaders];
}

+(instancetype)responseWithData:(NSData*)data
                     statusCode:(NSInteger)statusCode
                        headers:(nullable NSDictionary*)httpHeaders
{
    gifTestMockResponse* response = [[self alloc] initWithData:data
                                                  statusCode:statusCode
                                                     headers:httpHeaders];
    return response;
}


#pragma mark > Building response from a file

+(instancetype)responseWithFileAtPath:(NSString *)filePath
                           statusCode:(NSInteger)statusCode
                              headers:(nullable NSDictionary *)httpHeaders
{
    gifTestMockResponse* response = [[self alloc] initWithFileAtPath:filePath
                                                        statusCode:statusCode
                                                           headers:httpHeaders];
    return response;
}

+(instancetype)responseWithFileURL:(NSURL *)fileURL
                        statusCode:(NSInteger)statusCode
                           headers:(nullable NSDictionary *)httpHeaders
{
    gifTestMockResponse* response = [[self alloc] initWithFileURL:fileURL
                                                     statusCode:statusCode
                                                        headers:httpHeaders];
    return response;
}

#pragma mark > Building an error response

+(instancetype)responseWithError:(NSError*)error
{
    gifTestMockResponse* response = [[self alloc] initWithError:error];
    return response;
}

-(instancetype)responseTime:(NSTimeInterval)responseTime
{
    _responseTime = responseTime;
    return self;
}

-(instancetype)requestTime:(NSTimeInterval)requestTime responseTime:(NSTimeInterval)responseTime
{
    _requestTime = requestTime;
    _responseTime = responseTime;
    return self;
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Initializers

-(instancetype)init
{
    self = [super init];
    return self;
}

-(instancetype)initWithInputStream:(NSInputStream*)inputStream
                          dataSize:(unsigned long long)dataSize
                        statusCode:(NSInteger)statusCode
                           headers:(nullable NSDictionary*)httpHeaders {
    if ([super init]) {
        _inputStream = inputStream;
        _dataSize = dataSize;
        _statusCode = statusCode;
        NSMutableDictionary * headers = [NSMutableDictionary dictionaryWithDictionary:httpHeaders];
        static NSString *const ContentLengthHeader = @"Content-Length";
        if (!headers[ContentLengthHeader]) {
            headers[ContentLengthHeader] = [NSString stringWithFormat:@"%llu",_dataSize];
        }
        _httpHeaders = [NSDictionary dictionaryWithDictionary:headers];
    }
    return self;
}

-(instancetype)initWithFileAtPath:(NSString*)filePath
                       statusCode:(NSInteger)statusCode
                          headers:(nullable NSDictionary*)httpHeaders
{
    NSURL *fileURL = filePath ? [NSURL fileURLWithPath:filePath] : nil;
    self = [self initWithFileURL:fileURL
                      statusCode:statusCode
                         headers:httpHeaders];
    return self;
}

-(instancetype)initWithFileURL:(NSURL *)fileURL
                    statusCode:(NSInteger)statusCode
                       headers:(nullable NSDictionary *)httpHeaders {
    if (!fileURL) {
        NSLog(@"%s: nil file path. Returning empty data", __PRETTY_FUNCTION__);
        return [self initWithInputStream:[NSInputStream inputStreamWithData:[NSData data]]
                                dataSize:0
                              statusCode:statusCode
                                 headers:httpHeaders];
    }

    // [NSURL -isFileURL] is only available on iOS 8+
    NSAssert([fileURL.scheme isEqualToString:NSURLFileScheme], @"%s: Only file URLs may be passed to this method.",__PRETTY_FUNCTION__);

    NSNumber *fileSize;
    NSError *error;
    const BOOL success __unused = [fileURL getResourceValue:&fileSize forKey:NSURLFileSizeKey error:&error];

    NSAssert(success && fileSize, @"%s Couldn't get the file size for URL. \
The URL was: %@. \
The operation to retrieve the file size was %@. \
The error associated with that operation was: %@",
             __PRETTY_FUNCTION__, fileURL, success ? @"successful" : @"unsuccessful", error);

    return [self initWithInputStream:[NSInputStream inputStreamWithURL:fileURL]
                            dataSize:[fileSize unsignedLongLongValue]
                          statusCode:statusCode
                             headers:httpHeaders];
}

-(instancetype)initWithData:(NSData*)data
                 statusCode:(NSInteger)statusCode
                    headers:(nullable NSDictionary*)httpHeaders
{
    NSInputStream* inputStream = [NSInputStream inputStreamWithData:data?:[NSData data]];
    self = [self initWithInputStream:inputStream
                            dataSize:data.length
                          statusCode:statusCode
                             headers:httpHeaders];
    return self;
}

-(instancetype)initWithError:(NSError*)error
{
    self = [super init];
    if (self) {
        _error = error;
    }
    return self;
}

-(NSString*)debugDescription
{
    return [NSString stringWithFormat:@"<%@ %p requestTime:%f responseTime:%f status:%ld dataSize:%llu>",
            self.class, self, self.requestTime, self.responseTime, (long)self.statusCode, self.dataSize];
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Accessors

-(void)setRequestTime:(NSTimeInterval)requestTime
{
    NSAssert(requestTime >= 0, @"Invalid Request Time (%f) for gifTestMockResponse. Request time must be greater than or equal to zero",requestTime);
    _requestTime = requestTime;
}

@end
