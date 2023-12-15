//
//  SEAnnoViewController.m
//  SETravel_Example
//
//  Created by Sam Chen on 12/6/23.
//  Copyright © 2023 chenzhixiang. All rights reserved.
//

#import "SEAnnoViewController.h"

#import "SETravel_Example-Swift.h"
#import <ZMDevTool/ZMDevTool-Swift.h>


@interface SEAnnoViewController ()

@property (nonatomic, strong) UIButton *devButton;
@property (nonatomic, strong) UIButton *annoButton;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) NSLayoutConstraint *annoBarX;
@property (nonatomic, strong) NSLayoutConstraint *annoBarY;
@property (nonatomic, strong) UIView *safeAreaGuideView;
@property (nonatomic, assign) CGPoint logicalPosition;

@end

@implementation SEAnnoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.devButton];
    [self.devButton setFrame:CGRectMake(100, 100, 100, 100)];
    self.safeAreaGuideView = [[UIView alloc] initWithFrame:CGRectZero];
    self.safeAreaGuideView.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.3];
    self.safeAreaGuideView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.safeAreaGuideView];
    NSLayoutConstraint *topAnchor = [self.safeAreaGuideView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor];
    NSLayoutConstraint *leftAnchor = [self.safeAreaGuideView.leftAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leftAnchor];
    NSLayoutConstraint *bottomAnchor = [self.safeAreaGuideView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor];
    NSLayoutConstraint *rightAnchor = [self.safeAreaGuideView.rightAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.rightAnchor];
    [NSLayoutConstraint activateConstraints:@[topAnchor, leftAnchor, bottomAnchor, rightAnchor]];
    [self.safeAreaGuideView addSubview:self.annoButton];
    self.annoBarX = [self.annoButton.centerXAnchor constraintEqualToAnchor:self.safeAreaGuideView.leftAnchor constant:50];
    self.annoBarY = [self.annoButton.centerYAnchor constraintEqualToAnchor:self.safeAreaGuideView.bottomAnchor constant:-50];
    NSLayoutConstraint *width = [self.annoButton.widthAnchor constraintEqualToConstant:100];
    NSLayoutConstraint *height = [self.annoButton.heightAnchor constraintEqualToConstant:100];
    [NSLayoutConstraint activateConstraints:@[self.annoBarX, self.annoBarY, width, height]];
    [self.annoButton addGestureRecognizer:self.panGesture];
    // Do any additional setup after loading the view.
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        CGPoint actualPoint = [self convertLogicalToActualPosition:self.logicalPosition];
        self.annoButton.center = actualPoint;
        [self adjustFrameWithSafeArea];
    }];
}

- (UIButton *)devButton {
    if (!_devButton) {
        _devButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_devButton addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
        [_devButton setBackgroundColor:UIColor.blueColor];
    }
    return _devButton;
}

- (UIButton *)annoButton {
    if (!_annoButton) {
        _annoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _annoButton.frame = CGRectMake(0, 0, 100, 100);
        [_annoButton addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
        _annoButton.translatesAutoresizingMaskIntoConstraints = NO;
        _annoButton.layer.cornerRadius = 20;
        [_annoButton setBackgroundColor:UIColor.grayColor];
    }
    return _annoButton;
}

- (UIPanGestureRecognizer *)panGesture {
    if (!_panGesture) {
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
    }
    return _panGesture;
}

- (void)didTapButton:(UIButton *)button {
    ZMDevToolViewController *vc = [[ZMDevToolViewController alloc] init];
    [self presentViewController:vc animated:YES completion:^{
        NSLog(@"Sam dev: %s", __FUNCTION__);
    }];
}

- (CGPoint)centerOfAnnoButton {
    CGRect buttonFrame = self.annoButton.frame;
    CGRect safeAreaFrame = self.safeAreaGuideView.bounds;
    NSLog(@"Sam dev: %s button:%@, safeArea:%@, bounds:%@", __FUNCTION__, [NSValue valueWithCGRect:buttonFrame], [NSValue valueWithCGRect:safeAreaFrame], [NSValue valueWithCGRect:self.view.bounds]);
    CGFloat annoBarX = CGRectGetMinX(buttonFrame)+50;
    CGFloat annoBarY = CGRectGetMinY(buttonFrame)+50;
    if (!CGRectContainsRect(safeAreaFrame, buttonFrame)) {
        CGFloat annoBarX = MIN(MAX(CGRectGetMinX(buttonFrame), CGRectGetMinX(safeAreaFrame)), CGRectGetMaxX(safeAreaFrame) - CGRectGetWidth(buttonFrame))+50;
        CGFloat annoBarY = CGRectGetMinY(buttonFrame)+50;
        if (CGRectGetMinY(buttonFrame) < CGRectGetMinY(safeAreaFrame)) {
            annoBarY = CGRectGetMinY(safeAreaFrame)+50;
        }
        if (CGRectGetMaxY(buttonFrame) > CGRectGetMaxY(safeAreaFrame)) {
            annoBarY = CGRectGetMaxY(safeAreaFrame)-50;
        }
        self.annoBarX.constant = annoBarX;
        self.annoBarY.constant = annoBarY-CGRectGetHeight(safeAreaFrame);
    }
    return CGPointMake(annoBarX, annoBarY);
}

- (void)adjustFrameWithSafeArea {
    CGRect buttonFrame = self.annoButton.frame;
    CGRect safeAreaFrame = self.safeAreaGuideView.bounds;
    NSLog(@"Sam dev: %s button:%@, safeArea:%@, bounds:%@", __FUNCTION__, [NSValue valueWithCGRect:buttonFrame], [NSValue valueWithCGRect:safeAreaFrame], [NSValue valueWithCGRect:self.view.bounds]);
    CGPoint buttonCenter = self.annoButton.center;
    CGPoint safeAreaCenter = CGPointMake(CGRectGetMidX(safeAreaFrame), CGRectGetMidY(safeAreaFrame));
    CGFloat annoBarX = self.annoBarX.constant, annoBarY = self.annoBarY.constant;
    if (buttonCenter.y > CGRectGetWidth(buttonFrame) &&  buttonCenter.y < (CGRectGetHeight(safeAreaFrame)-CGRectGetHeight(buttonFrame))) {
        if (buttonCenter.x > safeAreaCenter.x) {
            annoBarX = CGRectGetWidth(safeAreaFrame)-CGRectGetWidth(buttonFrame)/2;
        } else {
            annoBarX = CGRectGetWidth(buttonFrame)/2;
        }
    } else {
        if (buttonCenter.y <= CGRectGetWidth(buttonFrame)) {
            annoBarY = -(CGRectGetHeight(safeAreaFrame)-CGRectGetHeight(buttonFrame)/2);
        } else if (buttonCenter.y >= (CGRectGetHeight(safeAreaFrame)-CGRectGetHeight(buttonFrame))) {
            annoBarY = -CGRectGetHeight(buttonFrame)/2;
        }
    }
    self.annoBarX.constant = annoBarX;
    self.annoBarY.constant = annoBarY;
    [UIView animateWithDuration:0.5 animations:^{
        [self.view updateConstraintsIfNeeded];
    }];
    self.logicalPosition = [self convertActualToLogicalPosition:self.annoButton.center];
}

- (void)didPan:(UIPanGestureRecognizer *)pan {
    CGPoint translation = [pan translationInView:self.view];
    CGFloat annoBarXConstant = self.annoBarX.constant + translation.x;
    CGFloat annoBarYConstant = self.annoBarY.constant + translation.y;
    self.annoBarX.constant = annoBarXConstant;
    self.annoBarY.constant = annoBarYConstant;
    [pan setTranslation:CGPointZero inView:self.view];
    if (pan.state == UIGestureRecognizerStateEnded) {
        [self adjustFrameWithSafeArea];
    }
}

- (CGPoint)convertLogicalToActualPosition:(CGPoint)logicalPosition {
    CGFloat actualX = logicalPosition.x * CGRectGetWidth(self.safeAreaGuideView.bounds) / 100;
    CGFloat actualY = logicalPosition.y * CGRectGetHeight(self.safeAreaGuideView.bounds) / 100;
    return CGPointMake(actualX, actualY);
}

- (CGPoint)convertActualToLogicalPosition:(CGPoint)actualPosition {
    CGFloat logicalX = (actualPosition.x-50) * 100 / CGRectGetWidth(self.safeAreaGuideView.bounds);
    CGFloat logicalY = actualPosition.y * 100 / CGRectGetHeight(self.safeAreaGuideView.bounds);
    return CGPointMake(logicalX, logicalY);
}


@end
