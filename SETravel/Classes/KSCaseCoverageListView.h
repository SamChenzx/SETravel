//
//  KSCaseCoverageListView.h
//  SETravel
//
//  Created by Sam Chen on 2021/11/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, KSCaseCoverageResult) {
    KSCaseCoverageResultPass = 1,
    KSCaseCoverageResultFail = 2,
};

@class KSCaseModel;

@interface KSCaseCoverageListView : UIView

@property (nonatomic, copy) void(^uploadCoverageBlock)(NSDictionary *caseInfoDic);

- (instancetype)initWithFrame:(CGRect)frame caseList:(NSArray<KSCaseModel *> *)caseList NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
