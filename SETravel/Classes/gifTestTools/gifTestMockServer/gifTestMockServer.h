//
//  gifTestMockServer.h
//  gifTestTools
//
//  Created by Sam Chen on 2021/9/3.
//

#import <Foundation/Foundation.h>
#import "gifTestToolsKeyFileMap.h"

@class gifTestMockResponse;

NS_ASSUME_NONNULL_BEGIN

typedef BOOL(^shouldMockRequest)(NSURLRequest* request);
typedef gifTestMockResponse* __nonnull (^mockResponseBlock)(NSURLRequest* request);

@interface gifTestMockServer : NSObject

/**
 * 用gifTestResourceHelper的moduleType和resourceKey创建response
 *
 * @param urlString 需要Mock的URL string
 * @param moduleType 对应的testTarget
 * @param resourceKey 对应的资源Key
 * @param statusCode response的http状态码
 * @param httpHeaders response的http头
 */
+ (void)mockForRequestUrlString:(NSString *)urlString
                         module:(KSTestModuleType)moduleType
               withResponseFile:(KSTestResourceKey)resourceKey
                     statusCode:(NSInteger)statusCode
                        headers:(nullable NSDictionary *)httpHeaders;

/**
 * 通过block，灵活创建需要mock的网络请求
 *
 * @param shouldMockBlock 用于判断当前request是否需要mock，
 *                        例如可以用request的URL，HTTPMethod等属性
 * @param responseBlock 用于创建gifTestMockResponse作为response，可以设置请求延迟，请求返回时间等参数
 * @related 在responseBlock中用-requestTime:responseTime: 方法设置response的请求延迟时间和返回耗时
 */
+ (void)mockForRequest:(shouldMockRequest)shouldMockBlock
      withMockResponse:(mockResponseBlock)responseBlock;

/**
 * 移除所有的mock请求，一般在单元测试的-tearDown方法中调用
 */
+(void)removeAllMockServers;

@end

NS_ASSUME_NONNULL_END
