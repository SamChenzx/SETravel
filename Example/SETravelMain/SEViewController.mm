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
#import "SESecondViewController.h"
#import "SETravel_Example-Swift.h"
#define dispatch_gifPostTest_main_async_safe(block)\
    if ([NSThread isMainThread]) {\
        block();\
    } else {\
        dispatch_async(dispatch_get_main_queue(), block);\
    }

typedef void(^completion)(NSArray<NSString *> * _Nullable useless);

static NSString *const SECellId = @"SECellId";
static NSTimeInterval startTime = 0;
static NSTimeInterval endTime = 0;

@interface SECell : UICollectionViewCell

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, assign) BOOL isAccessibilityFocused;

@end

@implementation SECell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.titleLabel];
        self.isAccessibilityElement = YES;
        self.titleLabel.frame = self.bounds;
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.title = nil;
    self.titleLabel = nil;
    
}
//
//- (BOOL)accessibilityElementIsFocused {
//    return self.isAccessibilityFocused;
//}
//
//- (void)accessibilityElementDidBecomeFocused {
//    self.isAccessibilityFocused = YES;
//    NSLog(@"Sam dev: %s focus = %d", __FUNCTION__, self.isAccessibilityFocused);
//}
//
//- (void)accessibilityElementDidLoseFocus {
//    self.isAccessibilityFocused = NO;
//    NSLog(@"Sam dev: %s focus = %d", __FUNCTION__, self.isAccessibilityFocused);
//}

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

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    startTime = CACurrentMediaTime();
    NSLog(@"Sam dev time: %s startTime = %f", __FUNCTION__, startTime);
    return [super gestureRecognizerShouldBegin:gestureRecognizer];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    startTime = CACurrentMediaTime();
    NSLog(@"Sam dev time: %s startTime = %f", __FUNCTION__, startTime);
    [super touchesBegan:touches withEvent:event];
}

@end

@interface ZMToolbarButton : UIButton

@property (nonatomic, assign) CGPoint toolbarTouchPoint;

@end

@implementation ZMToolbarButton

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = [touches anyObject];
     self.toolbarTouchPoint = [touch locationInView:self];
    NSLog(@"Sam dev: %s touchPoint = %@", __FUNCTION__, [NSValue valueWithCGPoint:self.toolbarTouchPoint]);
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    self.toolbarTouchPoint = [gestureRecognizer locationInView:self];
    NSLog(@"Sam dev: %s", __FUNCTION__);
    startTime = CACurrentMediaTime();
    NSLog(@"Sam dev time: %s startTime = %f", __FUNCTION__, startTime);
    return [super gestureRecognizerShouldBegin:gestureRecognizer];
}

- (CGPoint)menuAttachmentPointForConfiguration:(UIContextMenuConfiguration *)configuration {
    NSLog(@"Sam dev: %s touchPoint = %@", __FUNCTION__, [NSValue valueWithCGPoint:self.toolbarTouchPoint]);
    return CGPointMake(self.toolbarTouchPoint.x, -20);
}

- (UIContextMenuConfiguration *)contextMenuInteraction:(UIContextMenuInteraction *)interaction configurationForMenuAtLocation:(CGPoint)location {
    NSLog(@"Sam dev: %s", __FUNCTION__);
    UIContextMenuConfiguration *configuration = [UIContextMenuConfiguration configurationWithIdentifier:@""
                                                                                        previewProvider:nil
                                                                                         actionProvider:^UIMenu * _Nullable(NSArray<UIMenuElement *> * _Nonnull suggestedActions) {
        if (@available(iOS 15.0, *)) {
            return [UIMenu menuWithTitle:@"" children:[self prepareMenuActions]];
        }
        return nil;
    }];
    return configuration;
}

- (NSArray<UIMenuElement *> *)prepareMenuActions API_AVAILABLE(ios(15.0)) {
    UIDeferredMenuElement *deferredMenu = [UIDeferredMenuElement elementWithUncachedProvider:^(void (^ _Nonnull completion)(NSArray<UIMenuElement *> * _Nonnull)) {
        NSMutableArray *actionArray = [NSMutableArray array];
        for (NSInteger i = 0; i < 6; i++) {
            NSMutableArray *actions = [NSMutableArray array];
            NSInteger num = arc4random_uniform(6);
            for (NSInteger i = 0; i < num; i++) {
                UIAction *action = [UIAction actionWithTitle:[NSString stringWithFormat:@"sub action: %ld", i] image:[UIImage imageNamed:@"icon_toolbar_share_stop"] identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                    NSLog(@"Sam dev: %s action.title = %@", __FUNCTION__, action.title);
                }];
                [actions addObject:action];
            }
    //        UIMenu *menu = [UIMenu menuWithChildren:actions];
    //        UIMenu *menu = [UIMenu menuWithTitle:[NSString stringWithFormat:@"main action: %ld", i] children:actions];
            UIMenu *menu = [UIMenu menuWithTitle:[NSString stringWithFormat:@"main action: %ld", i] image:[UIImage imageNamed:@"icon_extend_meeting"] identifier:[NSString stringWithFormat:@"main action: %ld", i] options:0 children:actions];
            [actionArray addObject:menu];
        }
        endTime = CACurrentMediaTime();
        NSLog(@"Sam dev time: %s endTime = %f, duration = %f", __FUNCTION__, endTime, endTime-startTime);
        completion(actionArray);
    }];
    return @[deferredMenu];
}

@end

@interface ZMTimeButton : UIButton

@end

@implementation ZMTimeButton

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    startTime = CACurrentMediaTime();
    NSLog(@"Sam dev time: %s startTime = %f", __FUNCTION__, startTime);
    return [super gestureRecognizerShouldBegin:gestureRecognizer];
}

@end


@interface SEViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource, UIEditMenuInteractionDelegate>

@property (nonatomic, strong) ZMTimeButton *gifButton;
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) ZMDrawerTableView *tableView;
@property (nonatomic, copy) NSArray<UIColor *> *dataSource;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) ZMMultitaskingView *multitaskingView;
@property (nonatomic, assign) CGFloat lastContentOffset;
@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, strong) NSTimer *myTimer;
@property (nonatomic, strong) UIEditMenuInteraction *editMenuInteraction;
@property (nonatomic, strong) UIButton *menuButton;
@property (nonatomic, strong) ZMToolbarButton *toolbarButton;
@property (nonatomic, assign) NSTimeInterval endTime;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@end

@implementation SEViewController

- (NSArray<UIColor *> *)dataSource {
    if (!_dataSource) {
        NSMutableArray *marray = [NSMutableArray array];
        for (NSInteger i = 0; i < 50000; i++) {
            [marray addObject:[UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1]];
        }
        _dataSource = [marray copy];
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
        _collectionView.remembersLastFocusedIndexPath = NO;
    }
    return _collectionView;
}

- (ZMDrawerTableView *)tableView {
    if (!_tableView) {
        _tableView = [[ZMDrawerTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 60;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SECellId];
    cell.backgroundColor = self.dataSource[indexPath.row];
    return cell;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"Sam dev: %s indexPath = %@", __FUNCTION__, indexPath);
    NSString *identifier = [NSString stringWithFormat:@"Identifier_%d-%d-%d", (int)indexPath.section, (int)indexPath.row, (int)indexPath.item];
    [collectionView registerClass:[SECell class] forCellWithReuseIdentifier:identifier];
    SECell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.backgroundColor = self.dataSource[(indexPath.row+self.count)%self.dataSource.count];
    if (cell.accessibilityElementIsFocused) {
        NSLog(@"Sam dev: %s accessibilityElementIsFocused at %@", __FUNCTION__, indexPath);
    }
    
    return cell;
}

//- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
//    ((SECell *)cell).isAccessibilityFocused = NO;
//    cell.isAccessibilityElement = NO;
//    cell.accessibilityElementsHidden = YES;
//    UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, nil);
//    [self updateFocusIfNeeded];
//    NSLog(@"Sam dev: %s", __FUNCTION__);
//    if ([indexPath isEqual:self.selectedIndexPath]) {
//        UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, cell);
//        [self updateFocusIfNeeded];
//        NSLog(@"Sam dev: %s accessibilityElementIsFocused at %@", __FUNCTION__, indexPath);
//        ((SECell *)cell).isAccessibilityFocused = NO;
//    }
//    cell.isAccessibilityElement = YES;
//    cell.accessibilityElementsHidden = NO;
//}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndexPath = indexPath;
    NSLog(@"Sam dev: %s %@", __FUNCTION__, indexPath);
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.alpha = 0.2;
//    [self reloadItems];
//    CGRect frame = [collectionView cellForItemAtIndexPath:indexPath].frame;
//    frame = [collectionView convertRect:frame toView:self.view];
//    self.menuButton.frame = frame;
//    self.menuButton.layer.zPosition = 100;
    
//    UITapGestureRecognizer *tap = self.menuButton.gestureRecognizers[2];
//    for (UIGestureRecognizer *gesture in self.menuButton.gestureRecognizers) {
//        NSLog(@"Sam dev: %s %@", __FUNCTION__, gesture);
//        [gesture touchesBegan:[[NSSet alloc] init] withEvent:[[UIEvent alloc] init]];
//    }
}

- (void)reloadItems {
    [UIView performWithoutAnimation:^{
        [self.collectionView reloadData];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.collectionView];
    self.collectionView.frame = CGRectMake(30, 100, CGRectGetWidth(self.view.bounds), 100);
//    [self.collectionView addSubview:self.toolbarButton];
//    self.toolbarButton.frame = self.collectionView.bounds;
//    self.toolbarButton.menu = [UIMenu menuWithTitle:@"dude" children:[self prepareMenuActions]];
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
    
    
    SEObject *lbj = [[SEObject alloc] init];
    self.myTimer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        lbj.title = @"666";
    }];
    [self performSelector:@selector(test) withObject:nil afterDelay:10];
}

- (void)testThread {
    for (int i= 0; i<10; i++) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            static void (^testMethod)(int);
            testMethod = ^(int value){
                @synchronized (self) {
                    if (value > 0) {
                      NSLog(@"Sam dev: current value = %d, thread = %@",value, [NSThread currentThread]);
                      testMethod(value - 1);
                    }
                }
            };
            testMethod(10);
        });
    }
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

- (void)didClickButton {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
    self.count ++;
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    UIViewController *hostVC = [[[SwiftUIBridgeViewController alloc] init] createContentView];
    [self presentViewController:hostVC animated:YES completion:nil];
//    KSCoverageInfoView *infoView = [[KSCoverageInfoView alloc] initWithFrame:self.view.bounds];
//    
//    infoView.didConfirmBlock = ^(NSDictionary * _Nonnull caseInfoDic, BOOL shouldReset) {
//        [[KSCoverageManager sharedManager] uploadFilesWithInfo:caseInfoDic shouldReset:shouldReset];
//    };
//    [self.view addSubview:infoView];
//    [self test1];
}



- (void)test {
    if (self.myTimer) {
        [self.myTimer invalidate];
//        self.myTimer = nil;
    }
}

- (void)gesture {
    
    SEVideoFiltersViewController *vc = [[SEVideoFiltersViewController alloc] init];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}

- (ZMTimeButton *)gifButton {
    if (!_gifButton) {
        _gifButton = [[ZMTimeButton alloc] init];
        _gifButton.frame = CGRectMake(100, 230, 100, 100);
        _gifButton.backgroundColor = [UIColor purpleColor];
        _gifButton.overrideUserInterfaceStyle = UIUserInterfaceStyleDark;
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
