//
//  KSCoverageManager.h
//  gifDebugHelperModule
//
//  Created by Sam Chen on 2021/10/20.
//

//#if KSIsDebugging && KSCOVERAGE

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KSCoverageSwitchStates : NSObject

@property (nonatomic, assign) BOOL resetSwitchState;
@property (nonatomic, assign) BOOL disableSwitchState;

@end

@interface KSCaseModel : NSObject

@property (nonatomic, copy) NSString *caseId;
@property (nonatomic, copy) NSString *caseName;
@property (nonatomic, copy) NSString *planId;
@property (nonatomic, copy) NSString *planName;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end

typedef NSString *KSCoverageInfoKey NS_EXTENSIBLE_STRING_ENUM;

FOUNDATION_EXTERN KSCoverageInfoKey const KSCoverageCaseID;
FOUNDATION_EXTERN KSCoverageInfoKey const KSCoveragePlanID;
FOUNDATION_EXTERN KSCoverageInfoKey const KSCoverageCaseResult;
FOUNDATION_EXTERN KSCoverageInfoKey const KSCoverageUserInfo;
FOUNDATION_EXTERN KSCoverageInfoKey const KSCoverageCaseInfo;
FOUNDATION_EXTERN KSCoverageInfoKey const KSCoverageTypeInfo;
FOUNDATION_EXTERN KSCoverageInfoKey const KSCoverageUserID;
FOUNDATION_EXTERN KSCoverageInfoKey const KSCoverageDeviceID;

@interface KSCoverageManager : NSObject

+ (instancetype)sharedManager;

- (void)uploadFilesWithInfo:(NSDictionary * _Nullable)infoDic shouldReset:(BOOL)shouldReset;
- (void)disableAutoUpload:(BOOL)isDisable;
- (KSCoverageSwitchStates *)coverageSwitchStates;
- (NSArray<KSCaseModel *> *)syncFetchCaseList;
- (void)writeCoverageDataToFile;

@end

NS_ASSUME_NONNULL_END

//#endif
