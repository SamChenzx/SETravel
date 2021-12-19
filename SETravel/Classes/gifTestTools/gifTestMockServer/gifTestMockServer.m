//
//  gifTestMockServer.m
//  gifTestTools
//
//  Created by Sam Chen on 2021/9/3.
//

#import "gifTestMockServer.h"
#import "gifTestResourceHelper.h"
#import "gifTestMockHTTPStubs.h"
#import "gifTestMockResponse.h"

@implementation gifTestMockServer

+ (void)mockFor_RequestUrlString:(NSString *)urlString
                         module:(KSTestModuleType)moduleType
               withResponseFile:(KSTestResourceKey)resourceKey
                     statusCode:(NSInteger)statusCode
                        headers:(nullable NSDictionary *)httpHeaders {
    if (!urlString.length) {
        return;
    }
    NSString *resourcePath = [[gifTestResourceHelper sharedHelper] syncFetchResourceForModule:moduleType withResource:resourceKey];
    if (!resourcePath.length) {
        return;
    }
    [gifTestMockHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest * _Nonnull request) {
        return [request.URL.path containsString:urlString];
    } withStubResponse:^gifTestMockResponse * _Nonnull(NSURLRequest * _Nonnull request) {
        return [gifTestMockResponse responseWithFileAtPath:resourcePath statusCode:statusCode headers:httpHeaders];
    }];
}

+ (void)mockForRequest:(shouldMockRequest)shouldMockBlock
      withMockResponse:(mockResponseBlock)responseBlock {
    [gifTestMockHTTPStubs stubRequestsPassingTest:shouldMockBlock
                                 withStubResponse:responseBlock].name = @"AFNetworking stub";
}

+ (void)removeAllMockServers {
    [gifTestMockHTTPStubs removeAllStubs];
}

@end
