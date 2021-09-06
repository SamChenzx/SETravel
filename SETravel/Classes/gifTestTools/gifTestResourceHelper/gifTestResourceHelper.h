//
//  gifTestResourceHelper.h
//  gifTestTools
//
//  Created by Sam Chen on 2021/8/25.
//

#import <Foundation/Foundation.h>
#import "gifTestToolsKeyFileMap.h"

NS_ASSUME_NONNULL_BEGIN



typedef void(^resourceFetchComplation)(NSString *resourcePath, BOOL isSuccess);
typedef void(^resourcesFetchComplation)(NSArray<NSString *> *resourcePaths, BOOL isSuccess);

@interface gifTestResourceHelper : NSObject

+ (instancetype)sharedHelper;

/**
 * 同步从本地缓存或者CDN上或取对应的资源，超时120秒。
 * 如果资源为zip压缩包，会把压缩包解压，返回解压后的目录
 *
 * @Attention 该方法默认先从本地磁盘查找资源，如不存在，再请求CDN资源
 * @param moduleType 对应的testTarget
 * @param resourceKey 对应的资源Key
 * @return 绝对resource路径，如果资源请求失败，或者超时，返回为nil
 */
- (NSString *)syncFetchResourceForModule:(KSTestModuleType)moduleType
                            withResource:(KSTestResourceKey)resourceKey;

/**
 * 同步从本地缓存或者CDN上或取对应的资源，超时120秒。
 * 如果资源为zip压缩包，会把压缩包解压，返回解压后的目录
 *
 * @param moduleType 对应的testTarget
 * @param ignoreCache 是否忽略缓存，直接从CDN获取资源
 * @param resourceKey 对应的资源Key
 * @return 绝对resource路径，如果资源请求失败，或者超时，返回为nil
 */
- (NSString *)syncFetchResourceForModule:(KSTestModuleType)moduleType
                            withResource:(KSTestResourceKey)resourceKey
                             ignoreCache:(BOOL)ignoreCache;

/**
 * 从本地缓存或者CDN上或取对应的资源，异步获取，并在主线程中回调
 * 如果资源为zip压缩包，会把压缩包解压，返回解压后的目录
 *
 * @Attention 该方法默认先从本地磁盘查找资源，如不存在，再请求CDN资源
 * @param moduleType 对应的testTarget
 * @param resourceKey 对应的资源Key
 * @param complation 完成回调(NSString *resourcePath, BOOL isSuccess)
 */
- (void)fetchResourceForModule:(KSTestModuleType)moduleType
                  withResource:(KSTestResourceKey)resourceKey
               complationBlock:(resourceFetchComplation)complation;

/**
 * 从本地缓存或者CDN上或取对应的资源，异步获取，并在主线程中回调
 * 如果资源为zip压缩包，会把压缩包解压，返回解压后的目录
 * @param moduleType 对应的testTarget
 * @param ignoreCache 是否忽略缓存，直接从CDN获取资源
 * @param resourceKey 对应的资源Key
 * @param complation 完成回调(NSString *resourcePath, BOOL isSuccess)
 */
- (void)fetchResourceForModule:(KSTestModuleType)moduleType
                  withResource:(KSTestResourceKey)resourceKey
                   ignoreCache:(BOOL)ignoreCache
               complationBlock:(resourceFetchComplation)complation;

/**
 * 批量从本地缓存或者CDN上或取对应的资源，异步获取，并在主线程中回调
 * 如果资源为zip压缩包，会把压缩包解压，返回解压后的目录
 * @param moduleType 对应的testTarget
 * @param ignoreCache 是否忽略缓存，直接从CDN获取资源
 * @param resourceKeys 对应的资源Key列表
 * @param complation 完成回调(NSArray<NSString *> *resourcePaths, BOOL isSuccess)
 */
- (void)fetchResourceForModule:(KSTestModuleType)moduleType
                 withResources:(NSArray<KSTestResourceKey> *)resourceKeys
                   ignoreCache:(BOOL)ignoreCache
               complationBlock:(resourcesFetchComplation)complation;

@end

NS_ASSUME_NONNULL_END
