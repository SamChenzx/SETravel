//
//  gifTestResourceDiskCache.m
//  gifPostTests
//
//  Created by Sam Chen on 2021/8/27.
//

#import "gifTestResourceDiskCache.h"
#import <SSZipArchive/SSZipArchive.h>

static NSString *const baseDiskCachePath = @"com.kuaishou.testCache";
static NSString *const KSTestResourceKeyFilePathDic = @"KSTestResourceKeyFilePathDic";
static NSString *const KSTestZIPSuffix = @".zip";

@interface gifTestResourceDiskCache ()

@property (nonatomic, strong) NSString *rootPath;

@end

@implementation gifTestResourceDiskCache

- (instancetype)initWithPath:(NSString *)rootPath {
    if (self = [super init]) {
        if (rootPath) {
            _rootPath = rootPath;
        } else {
            _rootPath = baseDiskCachePath;
        }
        if (![[NSFileManager defaultManager] fileExistsAtPath:[self resourceDiskCacheRootPath]]) {
            NSError *error = nil;
            [[NSFileManager defaultManager] createDirectoryAtPath:[self resourceDiskCacheRootPath] withIntermediateDirectories:YES attributes:nil error:&error];
        }
    }
    return self;
}

- (NSString *)relativeFilePathForKey:(KSTestResourceKey)key {
    NSString *filePath = nil;
    NSDictionary *keyFilePathDic = [[NSUserDefaults standardUserDefaults] objectForKey:KSTestResourceKeyFilePathDic];
    if (!keyFilePathDic) {
        keyFilePathDic = [NSDictionary dictionary];
        [[NSUserDefaults standardUserDefaults] setObject:keyFilePathDic forKey:KSTestResourceKeyFilePathDic];
    }
    filePath = [keyFilePathDic objectForKey:key];
    return filePath;
}

- (NSString *)resourceDiskCacheRootPath {
    NSString *libraryCachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    return [libraryCachePath stringByAppendingPathComponent:self.rootPath];
}

- (NSString *)resourcePathForModule:(KSTestModuleType)moduleType withKey:(KSTestResourceKey)key {
    NSString *relativePath = [self relativeFilePathForKey:key];
    if (![[relativePath stringByDeletingLastPathComponent] isEqualToString:stringForTestModule(moduleType)]) {
        return nil;
    }
    NSString *resourcePath = [[self resourceDiskCacheRootPath] stringByAppendingPathComponent:relativePath];
    if (![[NSFileManager defaultManager] fileExistsAtPath:resourcePath]) {
        return nil;
    }
    return resourcePath;
}

- (BOOL)storeFile:(NSString *)fileName
       sourcePath:(NSString *)sourcePath
           module:(KSTestModuleType)moduleType
           forKey:(KSTestResourceKey)key {
    if (!fileName.length || !sourcePath.length || !key.length) {
        return NO;
    }
    NSError *error = nil;
    NSString *rootPath = [self resourceDiskCacheRootPath];
    NSString *moduleString = stringForTestModule(moduleType);
    if (!moduleString.length) {
        return NO;
    }
    NSString *modulePath = [rootPath stringByAppendingPathComponent:moduleString];
    if (![[NSFileManager defaultManager] fileExistsAtPath:modulePath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:modulePath withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            return NO;
        }
    }
    NSString *destPath = [modulePath stringByAppendingPathComponent:fileName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:destPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:destPath error:&error];
    }
    [[NSFileManager defaultManager] moveItemAtPath:sourcePath toPath:destPath error:&error];
    if (error) {
        return nil;
    } else {
        NSString *lastComponent = fileName;
        if ([fileName hasSuffix:KSTestZIPSuffix]) {
            lastComponent = [fileName stringByReplacingOccurrencesOfString:KSTestZIPSuffix withString:@""];
            NSString *unzipPath = [modulePath stringByAppendingPathComponent:lastComponent];
            if ([[NSFileManager defaultManager] fileExistsAtPath:unzipPath]) {
                [[NSFileManager defaultManager] removeItemAtPath:unzipPath error:nil];
            }
            [SSZipArchive unzipFileAtPath:destPath toDestination:unzipPath];
        }
        NSString *relativePath = [moduleString stringByAppendingPathComponent:lastComponent];
        [self storeFileRelativePath:relativePath forKey:key];
    }
    return YES;
}

- (BOOL)fileExistsForModule:(KSTestModuleType)moduleType withKey:(KSTestResourceKey)key {
    BOOL isExisting = NO;
    NSString *filePath = [self resourcePathForModule:moduleType withKey:key];
    isExisting = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    return isExisting;
}

- (void)storeFileRelativePath:(NSString *)filePath forKey:(NSString *)key {
    NSDictionary *keyFilePathDic = [[NSUserDefaults standardUserDefaults] objectForKey:KSTestResourceKeyFilePathDic];
    if (!keyFilePathDic) {
        keyFilePathDic = [NSDictionary dictionary];
    }
    NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithDictionary:keyFilePathDic];
    [mDic setObject:filePath forKey:key];
    [[NSUserDefaults standardUserDefaults] setObject:mDic forKey:KSTestResourceKeyFilePathDic];
}

@end
