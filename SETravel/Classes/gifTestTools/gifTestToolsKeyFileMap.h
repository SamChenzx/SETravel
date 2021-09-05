//
//  gifTestToolsKeyFileMap.h
//  gifTestTools
//
//  Created by Sam Chen on 2021/8/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, KSTestModuleType) {
    KSTestModuleTypeHome,
    KSTestModuleTypeLocal,
    KSTestModuleTypePost,
    KSTestModuleTypeSocial,
};

typedef NSString *KSTestResourceKey NS_EXTENSIBLE_STRING_ENUM;

extern KSTestResourceKey const KSTestPostKTVVoiceResource;
extern KSTestResourceKey const KSTestPostKTVBGMResource;
extern KSTestResourceKey const KSTestPostKTVAlbumResource;
extern KSTestResourceKey const KSTestPostVideoResource;
FOUNDATION_EXTERN NSString *stringForTestModule(KSTestModuleType moduleType);

@interface gifTestToolsKeyFileMap : NSObject

- (NSArray<NSString *> *)fileURLsForModule:(KSTestModuleType)moduleType withResource:(KSTestResourceKey)resourceKey;
- (NSString *)fileNameForModule:(KSTestModuleType)moduleType withResource:(KSTestResourceKey)resourceKey;


@end

NS_ASSUME_NONNULL_END
