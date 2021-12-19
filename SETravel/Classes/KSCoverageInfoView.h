//
//  KSCoverageInfoView.h
//  gifDebugHelperModule
//
//  Created by Sam Chen on 2021/10/15.
//

//#if KSIsDebugging && KSCOVERAGE

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class KSCoverageSwitchStates;

typedef NS_ENUM(NSInteger, KSCoverageCaseType) {
    KSCoverageCaseTypeQAManual,
    KSCoverageCaseTypeRDManual,
    KSCoverageCaseTypeUIAutomation,
    KSCoverageCaseTypeUISmoke,
};

@interface KSCoverageInfoView : UIView

@property (nonatomic, copy) void(^didCancelBlock)(void);
@property (nonatomic, copy) void(^didConfirmBlock)(NSDictionary * caseInfoDic, BOOL shouldReset);
@property (nonatomic, copy) void(^didSettingDisableBlock)(BOOL isDisable);

- (instancetype)initWithFrame:(CGRect)frame switchStates:(KSCoverageSwitchStates *)switchStates NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END

//#endif

