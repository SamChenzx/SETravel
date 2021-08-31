//
//  gifTestResourceKeyFileMap.m
//  SETravel
//
//  Created by Sam Chen on 2021/8/27.
//

#import "gifTestResourceKeyFileMap.h"

static NSString *const cdnBaseUrl = @"https://s2-11424.kwimgs.com/kos/nlav11424/";
static NSString *const cdnBackupBaseUrl = @"https://s2-11424.ssrcdn.com/kos/nlav11424/";

KSTestResourceKey const KSTestPostKTVVoiceResource = @"KSTestPostKTVVoiceResource";
KSTestResourceKey const KSTestPostKTVBGMResource = @"KSTestPostKTVBGMResource";
KSTestResourceKey const KSTestPostKTVAlbumResource = @"KSTestPostKTVAlbumResource";
KSTestResourceKey const KSTestPostVideoResource = @"KSTestPostVideoResource";

NSString * stringForTestModule(KSTestModuleType moduleType) {
    NSString *moduleString = nil;
    switch (moduleType) {
        case KSTestModuleTypeHome:
            moduleString = @"home";
            break;
        case KSTestModuleTypeLocal:
            moduleString = @"local";
            break;
        case KSTestModuleTypePost:
            moduleString = @"post";
            break;
        case KSTestModuleTypeSocial:
            moduleString = @"social";
            break;
        default:
            break;
    }
    return moduleString;
}

@interface gifTestResourceKeyFileMap ()

@property (nonatomic, strong) NSDictionary<NSString *, NSString *> *homeKeyFileMap;
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> *localKeyFileMap;
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> *postKeyFileMap;
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> *socialKeyFileMap;

@end

@implementation gifTestResourceKeyFileMap

- (NSArray<NSString *> *)fileURLsForModule:(KSTestModuleType)moduleType withResource:(KSTestResourceKey)resourceKey {
    NSMutableArray<NSString *> *fileURLs = [NSMutableArray array];
    NSDictionary<NSString *, NSString *> *keyFileMap = [self keyFileMapForModule:moduleType];
    NSString *fileName = [keyFileMap objectForKey:resourceKey];
    if (fileName.length) {
        [fileURLs addObject:[NSString stringWithFormat:@"%@%@", cdnBaseUrl, fileName]];
        [fileURLs addObject:[NSString stringWithFormat:@"%@%@", cdnBackupBaseUrl, fileName]];
    }
    
    return fileURLs;
}

- (NSDictionary<NSString *, NSString *> *)keyFileMapForModule:(KSTestModuleType)moduleType {
    NSDictionary<NSString *, NSString *> *keyFileMap;
    switch (moduleType) {
        case KSTestModuleTypeHome:
            keyFileMap = self.homeKeyFileMap;
            break;
        case KSTestModuleTypeLocal:
            keyFileMap = self.localKeyFileMap;
            break;
        case KSTestModuleTypePost:
            keyFileMap = self.postKeyFileMap;
            break;
        case KSTestModuleTypeSocial:
            keyFileMap = self.socialKeyFileMap;
            break;
        default:
            break;
    }
    return keyFileMap;
}

- (NSString *)fileNameForModule:(KSTestModuleType)moduleType withResource:(KSTestResourceKey)resourceKey {
    NSString *fileName = nil;
    NSDictionary<NSString *, NSString *> *keyFileMap = [self keyFileMapForModule:moduleType];
    fileName = [keyFileMap objectForKey:resourceKey];
    return fileName;
}

- (NSDictionary<NSString *, NSString *> *)homeKeyFileMap {
    if (!_homeKeyFileMap) {
        _homeKeyFileMap = @{
            
        };
    }
    return _homeKeyFileMap;
}

- (NSDictionary<NSString *,NSString *> *)localKeyFileMap {
    if (!_localKeyFileMap) {
        _localKeyFileMap = @{
            
        };
    }
    return _localKeyFileMap;
}

- (NSDictionary<NSString *,NSString *> *)postKeyFileMap {
    if (!_postKeyFileMap) {
        _postKeyFileMap = @{
            KSTestPostKTVVoiceResource : @"record.m4a",
            KSTestPostKTVBGMResource : @"bgm.m4a",
            KSTestPostKTVAlbumResource : @"KaraokeLocalAlbumPhoto.zip",
            KSTestPostVideoResource : @"aaamp4.zip",
        };
    }
    return _postKeyFileMap;
}

- (NSDictionary<NSString *,NSString *> *)socialKeyFileMap {
    if (!_socialKeyFileMap) {
        _socialKeyFileMap = @{

        };
    }
    return _socialKeyFileMap;
}

@end
