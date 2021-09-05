//
//  gifTestResourceDiskCache.h
//  gifTestTools
//
//  Created by Sam Chen on 2021/8/27.
//

#import <Foundation/Foundation.h>
#import "gifTestToolsKeyFileMap.h"

NS_ASSUME_NONNULL_BEGIN

@interface gifTestResourceDiskCache : NSObject

- (instancetype)initWithPath:(NSString *)rootPath;
- (NSString *)resourceDiskCacheRootPath;
- (NSString *)resourcePathForModule:(KSTestModuleType)moduleType withKey:(KSTestResourceKey)key;
- (BOOL)storeFile:(NSString *)fileName
       sourcePath:(NSString *)sourcePath
           module:(KSTestModuleType)moduleType
           forKey:(KSTestResourceKey)key;
- (BOOL)fileExistsForModule:(KSTestModuleType)moduleType withKey:(KSTestResourceKey)key;

@end

NS_ASSUME_NONNULL_END
