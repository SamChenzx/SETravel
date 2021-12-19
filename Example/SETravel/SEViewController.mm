//
//  SEViewController.m
//  SETravel
//
//  Created by chenzhixiang on 08/07/2021.
//  Copyright (c) 2021 chenzhixiang. All rights reserved.
//

#import "SEViewController.h"
#import <SETravel/gifTestResourceHelper.h>
#import <SETravel/gifTestMockHTTPStubs.h>
#import <SETravel/gifTestMockServer.h>
#import <Photos/Photos.h>
#import <SETravel/KSCoverageInfoView.h>
#import <AFNetworking/AFNetworking.h>
#import <sys/utsname.h>
#import <SSZipArchive/SSZipArchive.h>
#import <SETravel/KSCoverageManager.h>
#import <SETravel/KSCaseCoverageListView.h>
#import "SECallGraphTest.h"
#define dispatch_gifPostTest_main_async_safe(block)\
    if ([NSThread isMainThread]) {\
        block();\
    } else {\
        dispatch_async(dispatch_get_main_queue(), block);\
    }

typedef void(^completion)(NSArray<NSString *> * _Nullable useless);

@interface SEViewController ()

@property (nonatomic, strong) UIButton *gifButton;
@property (nonatomic, strong) UIButton *coverageButton;
@property (nonatomic, strong) NSURLSession *session;

@end

@implementation SEViewController

+ (void)recordDeviceId {
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *path = [documentPath stringByAppendingPathComponent:@"device_info"];
    NSDictionary *dic = @{@"device_id":[[NSUUID UUID] UUIDString] ? : @""};
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    [data writeToFile:path atomically:YES];
    NSLog(@"dick recordDeviceId");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.gifButton];
    self.session = [NSURLSession sharedSession];
    [[gifTestResourceHelper sharedHelper] fetchResourceForModule:KSTestModuleTypePost withResources:@[KSTestPostVideoResource, KSTestPostKTVBGMResource, KSTestPostKTVVoiceResource, KSTestPostKTVAlbumResource] ignoreCache:NO complationBlock:^(NSDictionary<KSTestResourceKey,NSString *> * _Nonnull resourcePathDict, BOOL isSuccess) {
        NSLog(@"dic = %@", resourcePathDict);
    }];
    [gifTestMockServer mockForRequest:^BOOL(NSURLRequest * _Nonnull request) {
        return [request.URL.absoluteString containsString:@"/n/file/pipeline/publish"];
    } withMockResponse:^gifTestMockResponse * _Nonnull(NSURLRequest * _Nonnull request) {
        return [gifTestMockResponse responseWithDictionary:@{} statusCode:200 headers:@{}];
    }];
//    NSDictionary *dic = [[gifTestResourceHelper sharedHelper] syncFetchResourceForModule:KSTestModuleTypePost withResources:@[KSTestPostVideoResource, KSTestPostKTVBGMResource, KSTestPostKTVVoiceResource] ignoreCache:NO];
//    NSLog(@"dic = %@", dic);
}

//- (NSArray<PHAsset *> *)assetsFromImages:(NSArray<UIImage *> *)images {
//    NSMutableArray<PHAsset *> *assets = [NSMutableArray array];
//    __block NSString *localIdentifier = nil;
//    for (UIImage *image in images) {
//        [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
//            PHAssetChangeRequest *request = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
//            localIdentifier = request.placeholderForCreatedAsset.localIdentifier;
//        } error:nil];
//        PHFetchResult *assetResult = [PHAsset fetchAssetsWithLocalIdentifiers:@[localIdentifier] options:nil];
//        PHAsset *asset = assetResult.firstObject;
//        if (asset.mediaType == PHAssetMediaTypeImage) {
//            [assets addObject:asset];
//        }
//    }
//    return assets;
//}
//
//- (NSArray<PHAsset *> *)assetsFromVideoPaths:(NSArray<NSString *> *)videoPaths {
//    __block NSString *localIdentifier = nil;
//    NSMutableArray<PHAsset *> *assets = [NSMutableArray array];
//    for (NSString *videoPath in videoPaths) {
//        [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
//            PHAssetChangeRequest *request = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:[NSURL fileURLWithPath:videoPath]];
//            localIdentifier = request.placeholderForCreatedAsset.localIdentifier;
//        } error:nil];
//        PHFetchResult *assetResult = [PHAsset fetchAssetsWithLocalIdentifiers:@[localIdentifier] options:nil];
//        PHAsset *asset = assetResult.firstObject;
//        if (asset.mediaType == PHAssetMediaTypeVideo) {
//            [assets addObject:asset];
//        }
//    }
//    return assets;
//}
//
//- (void)removeAssetsWithlocalIdentifiers:(NSArray<NSString *> *)localIdentifiers {
//    PHFetchResult *assetResult = [PHAsset fetchAssetsWithLocalIdentifiers:localIdentifiers options:nil];
//    [assetResult enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
//            [PHAssetChangeRequest deleteAssets:@[obj]];
//        } error:nil];
//    }];
//}

- (void)didClickButton {
    KSCoverageInfoView *infoView = [[KSCoverageInfoView alloc] initWithFrame:self.view.bounds switchStates:[KSCoverageSwitchStates new]];
    infoView.didConfirmBlock = ^(NSDictionary * _Nonnull caseInfoDic, BOOL shouldReset) {
        [[KSCoverageManager sharedManager] uploadFilesWithInfo:caseInfoDic shouldReset:shouldReset];
    };
//    [self.view addSubview:infoView];
    NSArray<KSCaseModel *> *caseList = [[KSCoverageManager sharedManager] syncFetchCaseList];
    KSCaseCoverageListView *listView = [[KSCaseCoverageListView alloc] initWithFrame:self.view.bounds caseList:caseList];
    listView.uploadCoverageBlock = ^(NSDictionary * _Nonnull caseInfoDic) {
        [[KSCoverageManager sharedManager] uploadFilesWithInfo:caseInfoDic shouldReset:YES];
    };
    [self.view addSubview:listView];
}

- (void)didClickCoverageButton {
    
}

- (UIButton *)gifButton {
    if (!_gifButton) {
        _gifButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _gifButton.frame = CGRectMake(100, 100, 100, 100);
        _gifButton.backgroundColor = [UIColor purpleColor];
        [_gifButton addTarget:self action:@selector(didClickButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _gifButton;
}

- (UIButton *)coverageButton {
    if (!_coverageButton) {
        _coverageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _coverageButton.frame = CGRectMake(260, 100, 100, 100);
        _coverageButton.backgroundColor = [UIColor blueColor];
        [_coverageButton addTarget:self action:@selector(didClickCoverageButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _gifButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
