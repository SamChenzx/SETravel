//
//  gifTestResourceHelper.m
//  gifPostTests
//
//  Created by Sam Chen on 2021/8/25.
//

#import "gifTestResourceHelper.h"
#import "gifTestResourceCDNFetcher.h"
#import "gifTestResourceDiskCache.h"
#import "gifTestResourceKeyFileMap.h"

@interface gifTestResourceHelper ()

@property (nonatomic, strong) gifTestResourceCDNFetcher *CDNFetcher;
@property (nonatomic, strong) gifTestResourceDiskCache *diskCache;
@property (nonatomic, strong) gifTestResourceKeyFileMap *resourceKeyFileMap;

@end

@implementation gifTestResourceHelper

+ (instancetype)sharedHelper {
    static gifTestResourceHelper *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[gifTestResourceHelper alloc] init];
        instance.CDNFetcher = [[gifTestResourceCDNFetcher alloc] init];
        instance.diskCache = [[gifTestResourceDiskCache alloc] initWithPath:@"com.kuaishou.testCache"];
        instance.resourceKeyFileMap = [[gifTestResourceKeyFileMap alloc] init];
    });
    return instance;
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
            dispatch_async(dispatch_get_main_queue(), ^{
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
                dispatch_async(dispatch_get_main_queue(), ^{
                    complation(resourcePath, YES);
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    complation(@"", NO);
                });
            }
        }
    }];
}

- (void)saveResourceAt:(NSString *)sourcePath forModule:(KSTestModuleType)moduleType withResource:(KSTestResourceKey)resourceKey {
    NSString *fileName = [self.resourceKeyFileMap fileNameForModule:moduleType withResource:resourceKey];
    [self.diskCache storeFile:fileName
                   sourcePath:sourcePath
                       module:moduleType
                       forKey:resourceKey];
}

@end
