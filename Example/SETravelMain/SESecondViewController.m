//
//  SESecondViewController.m
//  SETravel_Example
//
//  Created by Sam Chen on 8/9/23.
//  Copyright © 2023 chenzhixiang. All rights reserved.
//

#import "SESecondViewController.h"
#import "SEHTMLTextView.h"

@interface ZMToolbarTipView : UIView

@end

@implementation ZMToolbarTipView


- (instancetype)init {
    self = [super init];
    if (self) {
        // 设置抗压缩和抗拉伸的优先级
        [self setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
        [self setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
        [self setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
        [self setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
        self.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return self;
}

- (CGSize)intrinsicContentSize {
    CGFloat width = self.superview.bounds.size.width;  // 获取父视图宽度
    CGFloat height = self.superview.bounds.size.height;  // 获取父视图高度
    
    if (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)) {
        // 竖屏下的大小
        width = 150;  // 留出边距
        height = 150;  // 设置合适的高度
    } else {
        // 横屏下的大小
        width = 300;  // 留出边距
        height = 60;  // 设置合适的高度
    }
    return CGSizeMake(width, height);  // 返回计算后的宽高
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
}

- (void)updateConstraints {
    [super updateConstraints];
    self.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
}


@end

@interface SESecondViewController ()

@property (nonatomic, strong) NSMutableDictionary<NSNumber *, NSTimer *> *alertTimers;
@property (nonatomic, strong) UIButton *actionButton;
@property (nonatomic, strong) UIButton *clearButton;
@property (nonatomic, strong) NSMutableArray<UIAlertController *> *alerts;
@property (nonatomic, strong) SEHTMLTextView *htmlView;
@property (nonatomic, strong) UIStackView *bottomTipsStackView;

@end

@implementation SESecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.title = @"Settings";
    
    UIView *titleView = [[UIView alloc] init];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_toolbar_AIC"]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"Settings";
    titleLabel.font = [UIFont systemFontOfSize:36 weight:UIFontWeightBold];
    
    // 3. 将图片和标签添加到 titleView
    [titleView addSubview:imageView];
    [titleView addSubview:titleLabel];
    
    // 4. 设置布局约束
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [imageView.leadingAnchor constraintEqualToAnchor:titleView.leadingAnchor],
        [imageView.centerYAnchor constraintEqualToAnchor:titleView.centerYAnchor],
        [imageView.widthAnchor constraintEqualToConstant:30],
        [imageView.heightAnchor constraintEqualToConstant:30],
        [titleLabel.leadingAnchor constraintEqualToAnchor:titleView.trailingAnchor],
        [titleLabel.topAnchor constraintEqualToAnchor:imageView.bottomAnchor constant:6],
//        [titleLabel.trailingAnchor constraintEqualToAnchor:titleView.trailingAnchor]
    ]];
    
    // 5. 设置 titleView 的尺寸
    [titleView sizeToFit];
    titleView.backgroundColor = [UIColor yellowColor];
    self.navigationItem.titleView = titleView;
    
    UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
    [appearance configureWithOpaqueBackground];
    appearance.backgroundColor = [UIColor systemBackgroundColor];
    self.navigationController.navigationBar.standardAppearance = appearance;
    self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAlways;
    
    
    //    [self.view addSubview:self.actionButton];
//    [self.view addSubview:self.clearButton];
//    [self.view addSubview:self.htmlView];
//    [self.actionButton setFrame:CGRectMake(100, 500, 100, 100)];
//    [self.clearButton setFrame:CGRectMake(300, 500, 100, 100)];
    ZMToolbarTipView *tipView = [[ZMToolbarTipView alloc] init];
    tipView.backgroundColor = UIColor.blueColor;
    [self.bottomTipsStackView addArrangedSubview:tipView];
    ZMToolbarTipView *tipView1 = [[ZMToolbarTipView alloc] init];
    tipView1.backgroundColor = UIColor.purpleColor;
    [self.bottomTipsStackView addArrangedSubview:tipView1];
    ZMToolbarTipView *tipView2 = [[ZMToolbarTipView alloc] init];
    tipView2.backgroundColor = UIColor.grayColor;
    [self.bottomTipsStackView addArrangedSubview:tipView2];
    [self.view addSubview:self.bottomTipsStackView];
    [NSLayoutConstraint activateConstraints:@[
//        [self.bottomTipsStackView.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:60],
        [self.bottomTipsStackView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:60],
        [self.bottomTipsStackView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-60],
        [self.bottomTipsStackView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-60]
    ]];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        [self.bottomTipsStackView setNeedsLayout];  // 强制标记布局为需要更新
        [self.bottomTipsStackView layoutIfNeeded];  // 强制更新布局
        for (ZMToolbarTipView *tip in self.bottomTipsStackView.arrangedSubviews) {
            for (NSLayoutConstraint *constraint in tip.constraints) {
                if (constraint.firstAttribute == NSLayoutAttributeWidth || constraint.firstAttribute == NSLayoutAttributeHeight) {
                    [tip removeConstraint:constraint];
                }
            }
//            [tip.widthAnchor constraintEqualToConstant:tip.intrinsicContentSize.width].active = YES;
            [tip.widthAnchor constraintLessThanOrEqualToConstant:tip.intrinsicContentSize.width].active = YES;
            [tip.heightAnchor constraintEqualToConstant:tip.intrinsicContentSize.height].active = YES;
            [tip updateConstraintsIfNeeded];
        }

    } completion:nil];
    [self.view setNeedsLayout];
}
- (UIStackView *)bottomTipsStackView {
    if (!_bottomTipsStackView) {
        _bottomTipsStackView = [[UIStackView alloc] init];
        _bottomTipsStackView.axis = UILayoutConstraintAxisVertical;
        _bottomTipsStackView.spacing = 10;
        _bottomTipsStackView.distribution = UIStackViewDistributionFill;
        _bottomTipsStackView.alignment = UIStackViewAlignmentCenter;
        _bottomTipsStackView.translatesAutoresizingMaskIntoConstraints = NO;
        _bottomTipsStackView.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.3];
    }
    return _bottomTipsStackView;
}

- (void)dealloc {
    NSLog(@"Sam dev: %s", __FUNCTION__);
}

- (void)didTap:(UIButton *)button {
    NSString *tabDescription = @"Zoom Realtime Media Stream service has been enabled in this meeting.<br><br><a href=\"https://support.zoom.com/hc/en\" target=\"_blank\">Learn More</a>";
    self.htmlView.tabDescription = tabDescription;
}

- (void)didTapClear:(UIButton *)button {
    self.htmlView.tabDescription = @"";
}

- (UIButton *)actionButton {
    if (!_actionButton) {
        _actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _actionButton.backgroundColor = [UIColor blueColor];
        [_actionButton addTarget:self action:@selector(didTap:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _actionButton;
}

- (UIButton *)clearButton {
    if (!_clearButton) {
        _clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _clearButton.backgroundColor = [UIColor redColor];
        [_clearButton setTitle:@"Clear" forState:UIControlStateNormal];
        [_clearButton addTarget:self action:@selector(didTapClear:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clearButton;
}

- (SEHTMLTextView *)htmlView {
    if (!_htmlView) {
        _htmlView = [[SEHTMLTextView alloc] initWithFrame:CGRectMake(100, 200, 414, 200)];
        _htmlView.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.5];
    }
    return _htmlView;
}

- (NSMutableArray<UIAlertController *> *)alerts {
    if (!_alerts) {
        _alerts = [NSMutableArray array];
    }
    return _alerts;
}

@end
