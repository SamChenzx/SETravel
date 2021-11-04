//
//  KSCoverageInfoView.h
//  gifDebugHelperModule
//
//  Created by Sam Chen on 2021/10/15.
//

#if KSIsDebugging && KSCOVERAGE

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, KSCoverageCaseType) {
    KSCoverageCaseTypeQAManual,
    KSCoverageCaseTypeRDManual,
    KSCoverageCaseTypeUIAutomation,
};

typedef NSString *KSCoverageInfoKey NS_EXTENSIBLE_STRING_ENUM;

FOUNDATION_EXTERN KSCoverageInfoKey const KSCoverageUserInfo;
FOUNDATION_EXTERN KSCoverageInfoKey const KSCoverageCaseInfo;
FOUNDATION_EXTERN KSCoverageInfoKey const KSCoverageTypeInfo;

@interface KSCoverageInfoView : UIView

@property (nonatomic, copy) void(^didCancelBlock)(void);
@property (nonatomic, copy) void(^didConfirmBlock)(NSDictionary * caseInfoDic, BOOL shouldReset);

@end

NS_ASSUME_NONNULL_END

#endif

