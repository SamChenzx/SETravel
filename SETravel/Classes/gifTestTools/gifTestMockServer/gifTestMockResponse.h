//
//  gifTestToolsKeyFileMap.h
//  gifTestTools
//
//  Created by Sam Chen on 2021/8/27.
//

#import <Foundation/Foundation.h>
#import "gifTestResourceHelper.h"
// Non-standard download speeds
extern const double
gifTestMockDownloadSpeed1KBPS,					// 1.0 KB per second
gifTestMockDownloadSpeedSLOW;					// 1.5 KB per second

// Standard download speeds.
extern const double
gifTestMockDownloadSpeedGPRS,
gifTestMockDownloadSpeedEDGE,
gifTestMockDownloadSpeed3G,
gifTestMockDownloadSpeed3GPlus,
gifTestMockDownloadSpeedWifi;


NS_ASSUME_NONNULL_BEGIN

@interface gifTestMockResponse : NSObject

/**
 *  HTTP响应头
 */
@property(nonatomic, strong, nullable) NSDictionary* httpHeaders;
/**
 *  返回状态码
 */
@property(nonatomic, assign) NSInteger statusCode;
/**
 *  inputStream used when sending the response.
 *  @note You generally don't manipulate this directly.
 */
@property(nonatomic, strong, nullable) NSInputStream* inputStream;
/**
 *  The size of the fake response body, in bytes.
 */
@property(nonatomic, assign) unsigned long long dataSize;
/**
 *  The duration to wait before faking receiving the response headers.
 *
 *  Defaults to 0.0.
 */
@property(nonatomic, assign) NSTimeInterval requestTime;
/**
 *  The duration to use to send the fake response body.
 *
 * @note if responseTime<0, it is interpreted as a download speed in KBps ( -200 => 200KB/s )
 */
@property(nonatomic, assign) NSTimeInterval responseTime;
/**
 *  The fake error to generate to simulate a network error.
 *
 *  If `error` is non-`nil`, the request will result in a failure and no response will be sent.
 */
@property(nonatomic, strong, nullable) NSError* error;

/**
 * 用gifTestResourceHelper的moduleType和resourceKey创建response
 *
 * @param moduleType 对应的testTarget
 * @param resourceKey 对应的资源Key
 * @param statusCode response的http状态码
 * @param httpHeaders response的http头
 * @return 返回由参数构建好的mock response
 */
+(instancetype)responseForModule:(KSTestModuleType)moduleType
                    WithResource:(KSTestResourceKey)resourceKey
                      statusCode:(NSInteger)statusCode
                         headers:(nullable NSDictionary*)httpHeaders;
+(instancetype)responseWithData:(NSData*)data
                     statusCode:(NSInteger)statusCode
                        headers:(nullable NSDictionary*)httpHeaders;
+(instancetype)responseWithFileAtPath:(NSString *)filePath
                           statusCode:(NSInteger)statusCode
                              headers:(nullable NSDictionary*)httpHeaders;
+(instancetype)responseWithFileURL:(NSURL *)fileURL
                        statusCode:(NSInteger)statusCode
                           headers:(nullable NSDictionary *)httpHeaders;
+(instancetype)responseWithError:(NSError*)error;
-(instancetype)responseTime:(NSTimeInterval)responseTime;
-(instancetype)requestTime:(NSTimeInterval)requestTime responseTime:(NSTimeInterval)responseTime;
-(instancetype)init NS_DESIGNATED_INITIALIZER;
-(instancetype)initWithInputStream:(NSInputStream*)inputStream
                          dataSize:(unsigned long long)dataSize
                        statusCode:(NSInteger)statusCode
                           headers:(nullable NSDictionary*)httpHeaders NS_DESIGNATED_INITIALIZER;
-(instancetype)initWithFileAtPath:(NSString*)filePath
                       statusCode:(NSInteger)statusCode
                          headers:(nullable NSDictionary*)httpHeaders;
-(instancetype)initWithFileURL:(NSURL *)fileURL
                    statusCode:(NSInteger)statusCode
                       headers:(nullable NSDictionary *)httpHeaders;
-(instancetype)initWithData:(NSData*)data
                 statusCode:(NSInteger)statusCode
                    headers:(nullable NSDictionary*)httpHeaders;
-(instancetype)initWithError:(NSError*)error NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
