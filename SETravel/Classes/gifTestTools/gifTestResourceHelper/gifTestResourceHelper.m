//
//  gifTestResourceHelper.m
//  gifTestTools
//
//  Created by Sam Chen on 2021/8/25.
//

#import "gifTestResourceHelper.h"
#import "gifTestResourceCDNFetcher.h"
#import "gifTestResourceDiskCache.h"
#import "gifTestToolsKeyFileMap.h"

#define dispatch_gifTest_main_async_safe(block)\
    if ([NSThread isMainThread]) {\
        block();\
    } else {\
        dispatch_async(dispatch_get_main_queue(), block);\
    }

@interface gifTestResourceHelper ()

@property (nonatomic, strong) gifTestResourceCDNFetcher *CDNFetcher;
@property (nonatomic, strong) gifTestResourceDiskCache *diskCache;
@property (nonatomic, strong) gifTestToolsKeyFileMap *resourceKeyFileMap;

@end

@implementation gifTestResourceHelper

+ (instancetype)sharedHelper {
    static gifTestResourceHelper *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[gifTestResourceHelper alloc] init];
        instance.CDNFetcher = [[gifTestResourceCDNFetcher alloc] init];
        instance.diskCache = [[gifTestResourceDiskCache alloc] initWithPath:@"com.kuaishou.testCache"];
        instance.resourceKeyFileMap = [[gifTestToolsKeyFileMap alloc] init];
    });
    return instance;
}

- (NSString *)syncFetchResourceForModule:(KSTestModuleType)moduleType
                            withResource:(KSTestResourceKey)resourceKey {
    return [self syncFetchResourceForModule:moduleType
                               withResource:resourceKey
                                ignoreCache:NO];
}

- (NSString *)syncFetchResourceForModule:(KSTestModuleType)moduleType
                            withResource:(KSTestResourceKey)resourceKey
                             ignoreCache:(BOOL)ignoreCache {
    NSString *resourcePath = nil;
    if (!ignoreCache) {
        BOOL isExisting = [self.diskCache fileExistsForModule:moduleType withKey:resourceKey];
        if (isExisting) {
            resourcePath = [self.diskCache resourcePathForModule:moduleType withKey:resourceKey];
            return resourcePath;
        }
    }
    NSArray<NSString *> *URLs = [self.resourceKeyFileMap fileURLsForModule:moduleType withResource:resourceKey];
    NSString *sourcePath = [gifTestResourceCDNFetcher syncFetchResourceWithURLStrings:URLs];
    if (sourcePath.length && [[NSFileManager defaultManager] fileExistsAtPath:sourcePath]) {
        [self saveResourceAt:sourcePath forModule:moduleType withResource:resourceKey];
        resourcePath = [self.diskCache resourcePathForModule:moduleType withKey:resourceKey];
    }
    return resourcePath;
}

- (NSDictionary<KSTestResourceKey, NSString *> *)syncFetchResourceForModule:(KSTestModuleType)moduleType
                                                              withResources:(NSArray<KSTestResourceKey> *)resourceKeys
                                                                ignoreCache:(BOOL)ignoreCache {
    NSMutableDictionary <KSTestResourceKey, NSString *> *resourceDict = [NSMutableDictionary dictionary];
    for (KSTestResourceKey resourceKey in resourceKeys) {
        NSString *resourcePath = [self syncFetchResourceForModule:moduleType withResource:resourceKey ignoreCache:ignoreCache];
        [resourceDict setObject:resourcePath ?: @"" forKey:resourceKey];
    }
    return resourceDict;
}

- (void)fetchResourceForModule:(KSTestModuleType)moduleType
                  withResource:(KSTestResourceKey)resourceKey
               complationBlock:(resourceFetchComplation)complation {
    return [self fetchResourceForModule:moduleType
                           withResource:resourceKey
                            ignoreCache:NO
                        complationBlock:complation];
}

- (void)fetchResourceForModule:(KSTestModuleType)moduleType
                  withResource:(KSTestResourceKey)resourceKey
                   ignoreCache:(BOOL)ignoreCache
               complationBlock:(resourceFetchComplation)complation {
    __block NSString *resourcePath = nil;
    if (!ignoreCache) {
        BOOL isExisting = [self.diskCache fileExistsForModule:moduleType withKey:resourceKey];
        if (isExisting) {
            resourcePath = [self.diskCache resourcePathForModule:moduleType withKey:resourceKey];
            dispatch_gifTest_main_async_safe(^{
                complation(resourcePath, YES);
            });
            return;
        }
    }
    NSArray<NSString *> *URLs = [self.resourceKeyFileMap fileURLsForModule:moduleType withResource:resourceKey];
    [gifTestResourceCDNFetcher fetchResourceWithURLStrings:URLs completionBlock:^(NSString * _Nullable path, NSError * _Nullable error) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            [self saveResourceAt:path forModule:moduleType withResource:resourceKey];
        }
        resourcePath = [self.diskCache resourcePathForModule:moduleType withKey:resourceKey];
        if (complation) {
            if (resourcePath.length && !error) {
                dispatch_gifTest_main_async_safe(^{
                    complation(resourcePath, YES);
                });
            } else {
                dispatch_gifTest_main_async_safe(^{
                    complation(@"", NO);
                });
            }
        }
    }];
}

- (void)fetchResourceForModule:(KSTestModuleType)moduleType
                 withResources:(NSArray<KSTestResourceKey> *)resourceKeys
                   ignoreCache:(BOOL)ignoreCache
               complationBlock:(resourcesFetchComplation)complation {
    NSMutableDictionary <KSTestResourceKey, NSString *> *resourceDict = [NSMutableDictionary dictionary];
    dispatch_group_t group = dispatch_group_create();
    for (KSTestResourceKey resourceKey in resourceKeys) {
        dispatch_group_enter(group);
        [self fetchResourceForModule:moduleType withResource:resourceKey ignoreCache:ignoreCache complationBlock:^(NSString * _Nonnull resourcePath, BOOL isSuccess) {
            [resourceDict setObject:resourcePath ?: @"" forKey:resourceKey];
            dispatch_group_leave(group);
        }];
    }
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if (complation) {
            complation(resourceDict, YES);
        }
    });
}

- (void)saveResourceAt:(NSString *)sourcePath forModule:(KSTestModuleType)moduleType withResource:(KSTestResourceKey)resourceKey {
    NSString *fileName = [self.resourceKeyFileMap fileNameForModule:moduleType withResource:resourceKey];
    [self.diskCache storeFile:fileName
                   sourcePath:sourcePath
                       module:moduleType
                       forKey:resourceKey];
}

@end
