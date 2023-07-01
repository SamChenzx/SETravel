//
//  SEViewController.m
//  SETravel
//
//  Created by chenzhixiang on 08/07/2021.
//  Copyright (c) 2021 chenzhixiang. All rights reserved.
//

#import "SEViewController.h"
#import <SETravel/SEObject.h>
#import <SETravel/gifTestResourceHelper.h>
#import <SETravel/gifTestMockHTTPStubs.h>
#import <SETravel/gifTestMockServer.h>
#import <Photos/Photos.h>
#import <SETravel/KSCoverageInfoView.h>
#import <AFNetworking/AFNetworking.h>
#import <sys/utsname.h>
#import <SSZipArchive/SSZipArchive.h>
#import <SETravel/KSCoverageManager.h>
#import "SEVideoFiltersViewController.h"
#import <SETravel/SETappableLabel.h>
#import <SETravel/SESubView.h>
#import <SETravel/ZMMultitaskingView.h>
#import <SETravel/ZMDrawerTableView.h>
#define dispatch_gifPostTest_main_async_safe(block)\
    if ([NSThread isMainThread]) {\
        block();\
    } else {\
        dispatch_async(dispatch_get_main_queue(), block);\
    }

typedef void(^completion)(NSArray<NSString *> * _Nullable useless);

static NSString *const SECellId = @"SECellId";

@interface SECell : UICollectionViewCell

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation SECell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.titleLabel];
        self.titleLabel.frame = self.bounds;
    }
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
    }
    return _titleLabel;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

@end

@interface SEViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIButton *gifButton;
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) ZMDrawerTableView *tableView;
@property (nonatomic, copy) NSArray<UIColor *> *dataSource;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) ZMMultitaskingView *multitaskingView;
@property (nonatomic, assign) CGFloat lastContentOffset;

@end

@implementation SEViewController

- (NSArray<UIColor *> *)dataSource {
    if (!_dataSource) {
        _dataSource = @[UIColor.redColor, UIColor.greenColor, UIColor.blueColor, UIColor.yellowColor, UIColor.brownColor, UIColor.purpleColor, UIColor.redColor, UIColor.greenColor, UIColor.blueColor, UIColor.yellowColor, UIColor.brownColor, UIColor.purpleColor, UIColor.redColor, UIColor.greenColor, UIColor.blueColor, UIColor.yellowColor, UIColor.brownColor, UIColor.purpleColor, UIColor.redColor, UIColor.greenColor, UIColor.blueColor, UIColor.yellowColor, UIColor.brownColor, UIColor.purpleColor, UIColor.redColor, UIColor.greenColor, UIColor.blueColor, UIColor.yellowColor, UIColor.brownColor, UIColor.purpleColor, UIColor.redColor, UIColor.greenColor, UIColor.blueColor, UIColor.yellowColor, UIColor.brownColor, UIColor.purpleColor];
    }
    return _dataSource;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(60, 60);
        layout.minimumLineSpacing = 20;
        layout.minimumInteritemSpacing = 20;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:SECell.class forCellWithReuseIdentifier:SECellId];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

- (ZMDrawerTableView *)tableView {
    if (!_tableView) {
        _tableView = [[ZMDrawerTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:SECellId];
    }
    return _tableView;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectZero];
        _bgView.backgroundColor = [UIColor yellowColor];
    }
    return _bgView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SECellId];
    cell.backgroundColor = self.dataSource[indexPath.row];
    return cell;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Sam dev:index = %ld", indexPath.row);
    SECell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SECellId forIndexPath:indexPath];
    cell.backgroundColor = self.dataSource[(indexPath.row+self.count)%self.dataSource.count];
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.collectionView];
    self.collectionView.frame = CGRectMake(30, 100, CGRectGetWidth(self.view.bounds), 100);
    [self.view addSubview:self.multitaskingView];
    self.multitaskingView.frame = CGRectMake(0, CGRectGetHeight(self.view.frame)-500, CGRectGetWidth(self.view.frame), 500);
    [self.multitaskingView presentFeatureView:self.tableView];
    [self.multitaskingView slideToStyle:ZMMultitaskingMiddleStyle];
//    for (NSInteger i = 0; i < 100; i++) {
//        ZMMultitaskingView *view = [[ZMMultitaskingView alloc] initWithFrame:self.view.bounds num:i];
//        view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255.0)/255.0 blue:arc4random_uniform(255.0)/255.0 alpha:0.05];
//        [self.view addSubview:view];
//    }
//    [self.view addSubview:self.tableView];
//    [self.tableView addSubview:self.bgView];
//    [self.bgView setFrame:CGRectMake(0, (CGRectGetHeight(self.view.bounds)-100)/2, CGRectGetWidth(self.view.bounds), 100)];
    [self.view addSubview:self.gifButton];
//    self.session = [NSURLSession sharedSession];
//    [[gifTestResourceHelper sharedHelper] fetchResourceForModule:KSTestModuleTypePost withResources:@[KSTestPostVideoResource, KSTestPostKTVBGMResource, KSTestPostKTVVoiceResource, KSTestPostKTVAlbumResource] ignoreCache:NO complationBlock:^(NSDictionary<KSTestResourceKey,NSString *> * _Nonnull resourcePathDict, BOOL isSuccess) {
//        NSLog(@"dic = %@", resourcePathDict);
//    }];
//    [gifTestMockServer mockForRequest:^BOOL(NSURLRequest * _Nonnull request) {
//        return [request.URL.absoluteString containsString:@"/n/file/pipeline/publish"];
//    } withMockResponse:^gifTestMockResponse * _Nonnull(NSURLRequest * _Nonnull request) {
//        return [gifTestMockResponse responseWithDictionary:@{} statusCode:200 headers:@{}];
//    }];
//    NSDictionary *dic = [[gifTestResourceHelper sharedHelper] syncFetchResourceForModule:KSTestModuleTypePost withResources:@[KSTestPostVideoResource, KSTestPostKTVBGMResource, KSTestPostKTVVoiceResource] ignoreCache:NO];
//    NSLog(@"dic = %@", dic);
    UIColor *color1 = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];
    UIColor *color2 = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];
    NSLog(@"color1 == color2 = %@", color1 == color2 ? @"YES" : @"NO");
    NSLog(@"[color1 isEqual:color2] = %@", [color1 isEqual:color2] ? @"YES" : @"NO");
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.multitaskingView.frame = CGRectMake(0, CGRectGetHeight(self.view.frame)-500, CGRectGetWidth(self.view.frame), 500);
}

- (ZMMultitaskingView *)multitaskingView {
    if (!_multitaskingView) {
        _multitaskingView = [[ZMMultitaskingView alloc] initWithFrame:self.view.bounds toolbar:self.collectionView];
        _multitaskingView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _multitaskingView.backgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:0.3];
    }
    return _multitaskingView;
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
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    self.count ++;
    [self.collectionView reloadData];
//    KSCoverageInfoView *infoView = [[KSCoverageInfoView alloc] initWithFrame:self.view.bounds];
//    
//    infoView.didConfirmBlock = ^(NSDictionary * _Nonnull caseInfoDic, BOOL shouldReset) {
//        [[KSCoverageManager sharedManager] uploadFilesWithInfo:caseInfoDic shouldReset:shouldReset];
//    };
//    [self.view addSubview:infoView];
    [self test1];
}

- (void)test {
    SEObjectSub *sub = [[SEObjectSub alloc] init];
//    sub.mString = [[NSMutableString alloc] initWithString:@"70j"];
    sub.mArray = [[NSMutableArray alloc] initWithObjects:@"1", @"2", nil];
//    sub.obj = [[SEObject alloc] init];
//    sub.protocolObj = [[SEProtocolObj alloc] init];
//    [sub.protocolObj print666];
//    [sub.obj isPositive:6];
}

- (void)test1 {
    SEBaseLabel *bLabel = [[SEBaseLabel alloc] init];
//    SESubView *view = [[SESubView alloc] init];
}

- (void)gesture {
    
    SEVideoFiltersViewController *vc = [[SEVideoFiltersViewController alloc] init];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}

- (UIButton *)gifButton {
    if (!_gifButton) {
        _gifButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _gifButton.frame = CGRectMake(100, 230, 100, 100);
        _gifButton.backgroundColor = [UIColor purpleColor];
        [_gifButton addTarget:self action:@selector(didClickButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _gifButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
