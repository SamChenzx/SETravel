//
//  KSCoverageManager.m
//  gifDebugHelperModule
//
//  Created by Sam Chen on 2021/10/20.
//

//#if KSIsDebugging && KSCOVERAGE

#import "KSCoverageManager.h"
#import <SSZipArchive/SSZipArchive.h>
#import <sys/utsname.h>
#import <AFNetworking/AFNetworking.h>
//#import <gifBaseModelsModule/KSUser+KSCurrent.h>
//#import <gifCommonsModule/UIDevice+KSInfo.h>

@implementation KSCoverageSwitchStates
@end

@implementation KSCaseModel

static NSString *const KSCoverageCaseId = @"case_uniq_id";
static NSString *const KSCoverageCaseName = @"case_name";
static NSString *const KSCoveragePlanId = @"plan_id";
static NSString *const KSCoveragePlanName = @"plan_name";

- (instancetype)initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
        self.caseId = dic[KSCoverageCaseId] ?: @"";
        self.caseName = dic[KSCoverageCaseName] ?: @"";
        self.planId = dic[KSCoveragePlanId] ?: @"";
        self.planName = dic[KSCoveragePlanName] ?: @"";
    }
    return self;
}

@end

@interface KSCoverageManager ()

@property (nonatomic, strong) AFHTTPSessionManager *httpManager;
@property (nonatomic, copy) NSDictionary *jsonInfoDic;
@property (nonatomic, assign) BOOL shouldDisableAutoUpload;
@property (nonatomic, assign) NSTimeInterval autoUploadInterval;
@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, assign) BOOL isSuspend;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSString *> *coverageInfoDic;
@property (nonatomic, strong) KSCoverageSwitchStates* switchStates;

@end

KSCoverageInfoKey const KSCoverageCaseID = @"case_uniq_id";
KSCoverageInfoKey const KSCoveragePlanID = @"plan_id";
KSCoverageInfoKey const KSCoverageCaseResult = @"execute_result";
KSCoverageInfoKey const KSCoverageUserInfo = @"execute_user";
KSCoverageInfoKey const KSCoverageCaseInfo = @"case";
KSCoverageInfoKey const KSCoverageTypeInfo = @"execute_type";
KSCoverageInfoKey const KSCoverageUserID = @"uid";
KSCoverageInfoKey const KSCoverageDeviceID = @"did";

static NSString *const KSCoverageCaseListBaseUrl = @"https://video-quality-backend.test.gifshow.com/coverage/api/v1/case/mobile/query";
static NSString *const KSCoverageURLString = @"KSCoverageURLString";
static NSString *const KSCoverageTaskID = @"KSCoverageTaskID";
static NSString *const KSCoverageCommitID = @"KSCoverageCommitID";
static NSString *const KSCoverageInfo = @"KSCoverageInfo";
static CGFloat const defaultUploadInterval = 15.0f;

@implementation KSCoverageManager

+ (void)load {
//    [KSCoverageManager sharedManager].isSuspend = YES;
//    [[KSCoverageManager sharedManager] resumeTimer];
}

+ (instancetype)sharedManager {
    static KSCoverageManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[KSCoverageManager alloc] init];
        manager.httpManager = [AFHTTPSessionManager manager];
        manager.jsonInfoDic = [manager loadLocalJsonFile];
        manager.coverageInfoDic = [NSMutableDictionary dictionary];
        manager.timer = [manager createTimer];
        manager.switchStates = [[KSCoverageSwitchStates alloc] init];
    });
    return manager;
}

- (NSDictionary *)loadLocalJsonFile {
    NSData *jsonData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:KSCoverageInfo ofType:@"json"]];
    if (!jsonData) {
        return nil;
    }
    NSDictionary* jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
    return jsonDic;
}

- (void)disableAutoUpload:(BOOL)isDisable {
    if (self.shouldDisableAutoUpload == isDisable) {
        return;
    }
    self.shouldDisableAutoUpload = isDisable;
    if (self.shouldDisableAutoUpload) {
        [self suspendTimer];
    } else {
        [self resumeTimer];
    }
}

- (void)updateTimerWithInterval:(NSTimeInterval)interval {
    if (interval > 0) {
        dispatch_source_set_timer(self.timer, DISPATCH_TIME_NOW, (uint64_t)(interval * NSEC_PER_SEC), 0);
    }
}

- (dispatch_source_t)createTimer {
    if (!self.autoUploadInterval) {
        self.autoUploadInterval = defaultUploadInterval;
    }
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
//    uint64_t interval = (uint64_t)(self.autoUploadInterval * NSEC_PER_SEC);
//    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, interval, 0);
//    __weak typeof(self)weakSelf = self;
//    dispatch_source_set_event_handler(timer, ^{
//        __strong typeof(weakSelf)self = weakSelf;
//        [self autoUploadCoverageInfo];
//    });
    return timer;
}

- (void)resumeTimer {
    if (self.isSuspend) {
        dispatch_resume(self.timer);
        self.isSuspend = NO;
    }
}

- (void)suspendTimer {
    if (!self.isSuspend) {
        dispatch_suspend(self.timer);
        self.isSuspend = YES;
    }
}

- (void)dealloc {
    if (_timer) {
        if (_isSuspend) {
            dispatch_resume(_timer);
        }
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
}

- (NSArray<KSCaseModel *> *)syncFetchCaseList {
    __block NSMutableArray<KSCaseModel *> *caseList = [NSMutableArray array];
    NSDictionary *coverageInfo = self.jsonInfoDic[KSCoverageInfo];
    NSString *taskId = [coverageInfo[KSCoverageTaskID] description] ?: @"";
    NSString *caseListUrl = [NSString stringWithFormat:@"%@?coverage_task_id=%@", KSCoverageCaseListBaseUrl, taskId];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:caseListUrl]];
    NSURLSession *session = [NSURLSession sharedSession];
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSError *dataerror = nil;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&dataerror];
        if ([dic objectForKey:@"data"] && [[dic objectForKey:@"data"] isKindOfClass:NSArray.class]) {
            NSArray *dataList = [dic objectForKey:@"data"];
            for (id caseData in dataList) {
                if ([caseData isKindOfClass:NSDictionary.class]) {
                    KSCaseModel *model = [[KSCaseModel alloc] initWithDic:caseData];
                    [caseList addObject:model];
                }
            }
        }
        dispatch_semaphore_signal(semaphore);
    }];
    [task resume];
    dispatch_semaphore_wait(semaphore, dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)));
    return caseList;
}

- (KSCoverageSwitchStates *)coverageSwitchStates {
    return self.switchStates;
}

- (void)autoUploadCoverageInfo {
    [self uploadFilesWithInfo:nil shouldReset:YES isAutoUpload:YES];
}

- (void)uploadFilesWithInfo:(NSDictionary * _Nullable)infoDic shouldReset:(BOOL)shouldReset {
    [self uploadFilesWithInfo:infoDic shouldReset:shouldReset isAutoUpload:NO];
}

- (void)uploadFilesWithInfo:(NSDictionary * _Nullable)infoDic shouldReset:(BOOL)shouldReset isAutoUpload:(BOOL)isAutoUpload {
    //The url, task, commit params should be dynamic inject.
    if (infoDic) {
        self.coverageInfoDic = [NSMutableDictionary dictionaryWithDictionary:infoDic];
    }
    NSString *urlString = [self.jsonInfoDic[KSCoverageURLString] description] ?: @"";
    NSDictionary *coverageInfo = self.jsonInfoDic[KSCoverageInfo];
    if (![coverageInfo isKindOfClass:NSDictionary.class]) {
        return;
    }
    NSString *taskId = [coverageInfo[KSCoverageTaskID] description] ?: @"";
    NSString *gitCommitId = [coverageInfo[KSCoverageCommitID] description] ?: @"";
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *osBuildModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *uuidStr = [[NSUUID UUID] UUIDString];
    NSString *baseDir = [documentsDirectory stringByAppendingString:@"/coverage"];
    NSString *coverageZip = [documentsDirectory stringByAppendingString:@"/coverage.zip"];
//    KSProgressHUD *progressHUD = nil;
//    if (!isAutoUpload) {
//        progressHUD = [KSProgressHUD showHUDAddedTo:KSKeyWindow animated:YES];
//        progressHUD.mode = MBProgressHUDModeAnnularDeterminate;
//        progressHUD.label.text = @"上传进度";
//    }
    __weak typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:baseDir error:nil];
        [fileManager createDirectoryAtPath:baseDir withIntermediateDirectories:NO attributes:nil error:NULL];
        NSString *profileFile = [baseDir stringByAppendingString:@"/profile.profraw"];
        extern int __llvm_profile_write_file(void);
        extern void __llvm_profile_set_filename(char *);
        extern void __llvm_profile_reset_counters(void);
        __llvm_profile_set_filename((char *)[profileFile cStringUsingEncoding:[NSString defaultCStringEncoding]]);
        __llvm_profile_write_file();
        [SSZipArchive createZipFileAtPath:coverageZip withContentsOfDirectory:baseDir];
        // uploading
        [self.httpManager POST:urlString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileData:[NSData dataWithContentsOfFile:coverageZip]
                                        name:@"file"
                                    fileName:[uuidStr stringByAppendingString:@"-coverage.zip"]
                                    mimeType:@"application/x-zip-compressed"];
            [formData appendPartWithFormData:[taskId dataUsingEncoding:NSUTF8StringEncoding]
                                        name:@"task_id"];
            [formData appendPartWithFormData:[@"1" dataUsingEncoding:NSUTF8StringEncoding]
                                        name:@"start_build"];
            [formData appendPartWithFormData:[osBuildModel dataUsingEncoding:NSUTF8StringEncoding]
                                        name:@"os_build_model"];
            [formData appendPartWithFormData:[gitCommitId dataUsingEncoding:NSUTF8StringEncoding]
                                        name:@"git_head_commit"];
            if ([infoDic[KSCoverageUserInfo] description].length) {
                [formData appendPartWithFormData:[infoDic[KSCoverageUserInfo] dataUsingEncoding:NSUTF8StringEncoding]
                                            name:KSCoverageUserInfo];
            }
            if ([infoDic[KSCoverageCaseInfo] description].length) {
                [formData appendPartWithFormData:[infoDic[KSCoverageCaseInfo] dataUsingEncoding:NSUTF8StringEncoding]
                                            name:KSCoverageCaseInfo];
            }
            if ([infoDic[KSCoverageCaseID] description].length) {
                [formData appendPartWithFormData:[infoDic[KSCoverageCaseID] dataUsingEncoding:NSUTF8StringEncoding]
                                            name:KSCoverageCaseID];
            }
            if ([infoDic[KSCoveragePlanID] description].length) {
                [formData appendPartWithFormData:[infoDic[KSCoveragePlanID] dataUsingEncoding:NSUTF8StringEncoding]
                                            name:KSCoveragePlanID];
            }
            if ([infoDic[KSCoverageCaseResult] description].length) {
                [formData appendPartWithFormData:[infoDic[KSCoverageCaseResult] dataUsingEncoding:NSUTF8StringEncoding]
                                            name:KSCoverageCaseResult];
            }
            [formData appendPartWithFormData:[infoDic[KSCoverageTypeInfo] ?: @"manual_qa" dataUsingEncoding:NSUTF8StringEncoding]
                                        name:KSCoverageTypeInfo];
//            if ([KSUser currentUser].user_id.stringValue) {
//                [formData appendPartWithFormData:[[KSUser currentUser].user_id.stringValue dataUsingEncoding:NSUTF8StringEncoding]
//                                            name:KSCoverageUserID];
//            }
//            if ([UIDevice ks_uuid]) {
//                [formData appendPartWithFormData:[[UIDevice ks_uuid] dataUsingEncoding:NSUTF8StringEncoding]
//                                            name:KSCoverageDeviceID];
//            }
            // etc.
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!isAutoUpload) {
//                    progressHUD.progress = uploadProgress.fractionCompleted;
                }
            });
        }  success:^(NSURLSessionDataTask *task, id responseObject) {
            __strong typeof(weakSelf)self = weakSelf;
            if ([responseObject isKindOfClass:NSDictionary.class]) {
                NSDictionary *responseDic = (NSDictionary *)responseObject;
                NSInteger nextUploadDelaySeconds = [[responseDic objectForKey:@"next_upload_delay_seconds"] integerValue];
                if (nextUploadDelaySeconds > 0) {
                    if (self.autoUploadInterval != nextUploadDelaySeconds) {
                        self.autoUploadInterval = nextUploadDelaySeconds;
                        [self updateTimerWithInterval:self.autoUploadInterval];
                    }
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!isAutoUpload) {
//                    [progressHUD hideAnimated:YES];
                }
            });
            if (shouldReset) {
                __llvm_profile_reset_counters();
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!isAutoUpload) {
//                    [progressHUD hideAnimated:YES];
                }
            });
        }];
    });
}

@end

//#endif
