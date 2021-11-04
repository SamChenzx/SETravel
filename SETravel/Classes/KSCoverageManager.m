//
//  KSCoverageManager.m
//  gifDebugHelperModule
//
//  Created by Sam Chen on 2021/10/20.
//

#if KSIsDebugging && KSCOVERAGE

#import "KSCoverageManager.h"
#import <SSZipArchive/SSZipArchive.h>
#import <sys/utsname.h>
#import <gifDebugHelperModule/KSCoverageInfoView.h>
#import <AFNetworking/AFNetworking.h>

@interface KSCoverageManager ()

@property (nonatomic, strong) AFHTTPSessionManager *httpManager;
@property (nonatomic, copy) NSDictionary *jsonInfoDic;

@end

static NSString *const KSCoverageURLString = @"KSCoverageURLString";
static NSString *const KSCoverageTaskID = @"KSCoverageTaskID";
static NSString *const KSCoverageCommitID = @"KSCoverageCommitID";
static NSString *const KSCoverageInfo = @"KSCoverageInfo";

@implementation KSCoverageManager

+ (instancetype)sharedManager {
    static KSCoverageManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[KSCoverageManager alloc] init];
        manager.httpManager = [AFHTTPSessionManager manager];
        manager.jsonInfoDic = [manager loadLocalJsonFile];
    });
    return manager;
}

- (NSDictionary *)loadLocalJsonFile {
    NSData *jsonData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:KSCoverageInfo ofType:@"json"]];
    NSDictionary* jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
    return jsonDic;
}

- (void)uploadFilesWithInfo:(NSDictionary *)infoDic shouldReset:(BOOL)shouldReset {
    //The url, task, commit params should be dynamic inject.
    NSString *urlString = [self.jsonInfoDic[KSCoverageURLString] description] ?: @"";
    NSString *taskId = [self.jsonInfoDic[KSCoverageTaskID] description] ?: @"";
    NSString *gitCommitId = [self.jsonInfoDic[KSCoverageCommitID] description] ?: @"";
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *osBuildModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *uuidStr = [[NSUUID UUID] UUIDString];
    NSString *baseDir = [documentsDirectory stringByAppendingString:@"/coverage"];
    NSString *coverageZip = [documentsDirectory stringByAppendingString:@"/coverage.zip"];
    KSProgressHUD *progressHUD = [KSProgressHUD showHUDAddedTo:KSKeyWindow animated:YES];
    progressHUD.mode = MBProgressHUDModeAnnularDeterminate;
    progressHUD.label.text = @"上传进度";
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
            [formData appendPartWithFormData:[infoDic[KSCoverageUserInfo] ?: @"" dataUsingEncoding:NSUTF8StringEncoding]
                                        name:KSCoverageUserInfo];
            [formData appendPartWithFormData:[infoDic[KSCoverageCaseInfo] ?: @"" dataUsingEncoding:NSUTF8StringEncoding]
                                        name:KSCoverageCaseInfo];
            [formData appendPartWithFormData:[infoDic[KSCoverageTypeInfo] ?: @"" dataUsingEncoding:NSUTF8StringEncoding]
                                        name:KSCoverageTypeInfo];
            // etc.
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            dispatch_async(dispatch_get_main_queue(), ^{
                progressHUD.progress = uploadProgress.fractionCompleted;
            });
        }  success:^(NSURLSessionDataTask *task, id responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [progressHUD hideAnimated:YES];
            });
            if (shouldReset) {
                __llvm_profile_reset_counters();
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [progressHUD hideAnimated:YES];
            });
            if (shouldReset) {
                __llvm_profile_reset_counters();
            }
        }];
    });
}

@end

#endif
