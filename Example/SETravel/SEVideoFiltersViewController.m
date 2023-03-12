//
//  SEVideoFiltersViewController.m
//  SETravel_Example
//
//  Created by Sam Chen on 7/12/22.
//  Copyright © 2022 chenzhixiang. All rights reserved.
//

#import "SEVideoFiltersViewController.h"
#import "SEPanelView.h"
#import "SEPanelBehavior.h"
#import <Masonry/Masonry.h>

static CGFloat const MinContainerViewHeight = 280;
static CGFloat const MaxContainerViewHeight = 680;
static NSString *const reuseIdentifier = @"reuseIdentifier";

@interface SEVideoFiltersViewController () <UITableViewDelegate, UITableViewDataSource, SEPanelViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *dataSource;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, strong) UIView *videoView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic) PanelState panelState;
@property (nonatomic) SEPanelView *panelView;
@property (nonatomic) UIDynamicAnimator *animator;
@property (nonatomic, strong) SEPanelBehavior *panelBehavior;

@end

@implementation SEVideoFiltersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:16.0/255 green:22.0/255 blue:25.0/255 alpha:1];
    [self.view addSubview:self.containerView];
    [self.view addSubview:self.videoView];
    [self.view addSubview:self.panelView];
    [self.panelView addSubview:self.tableView];
//    [self.view addSubview:self.bottomView];
//    self.bottomView.frame = CGRectMake(0, self.view.frame.size.height-34, self.view.frame.size.width, 34);
    self.panelView.frame = CGRectMake(0, self.view.frame.size.height-MinContainerViewHeight, self.view.frame.size.width, MinContainerViewHeight);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.panelView.mas_left);
        make.bottom.mas_equalTo(self.panelView.mas_bottom).offset(-34);
        make.right.mas_equalTo(self.panelView.mas_right);
        make.top.mas_equalTo(self.panelView.mas_top).offset(40);
    }];
    self.tableView.frame = CGRectMake(0, 40, self.view.frame.size.width, MinContainerViewHeight-40);
    
    self.containerView.frame = self.panelView.frame;
    [self.view addGestureRecognizer:self.panGestureRecognizer];
}

- (SEPanelView *)panelView {
    if (!_panelView) {
        _panelView = [[SEPanelView alloc] initWithFrame:CGRectZero];
        _panelView.backgroundColor = [UIColor colorWithRed:26.0/255 green:32.0/255 blue:35.0/255 alpha:1];
        _panelView.layer.cornerRadius = 20;
        _panelView.delegate = self;
    }
    return _panelView;
}

- (UIDynamicAnimator *)animator {
    if (!_animator) {
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    }
    return _animator;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomView.backgroundColor = [UIColor colorWithRed:26.0/255 green:32.0/255 blue:35.0/255 alpha:1];
    }
    return _bottomView;
}

- (UIView *)videoView {
    if (!_videoView) {
        _videoView = [[UIView alloc] initWithFrame:CGRectMake(20, 80, self.view.frame.size.width-40, 300)];
        _videoView.backgroundColor = [UIColor blueColor];
    }
    return _videoView;
}

- (NSArray *)dataSource {
    if (!_dataSource) {
        _dataSource = @[@1, @2, @3, @4, @4, @5, @6, @7, @8, @9, @10, @1, @2, @3, @4, @4, @5, @6, @7, @8, @9, @10];
    }
    return _dataSource;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] initWithFrame:CGRectZero];
        _containerView.layer.cornerRadius = 20;
        _containerView.clipsToBounds = YES;
        _containerView.backgroundColor = [UIColor colorWithRed:26.0/255 green:32.0/255 blue:35.0/255 alpha:1];
    }
    return _containerView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
//        _tableView.backgroundColor = [UIColor whiteColor];
        [_tableView registerClass:UITableViewCell.class forCellReuseIdentifier:reuseIdentifier];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

- (UIPanGestureRecognizer *)panGestureRecognizer {
    if (!_panGestureRecognizer) {
        _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                        action:@selector(handlePanGesture:)];
        _panGestureRecognizer.enabled = YES;
    }
    return _panGestureRecognizer;
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)pan {
    CGPoint translation = [pan translationInView:self.containerView];
    CGPoint velocity = [pan velocityInView:self.containerView];
    CGFloat containerHeight = self.containerView.frame.size.height;
    CGFloat containerTopY = self.containerView.frame.origin.y;
    NSLog(@"Sam dev: translation = %@", [NSValue valueWithCGPoint:translation]);
    NSLog(@"Sam dev: velocity = %@", [NSValue valueWithCGPoint:velocity]);
    
    UIGestureRecognizerState state = pan.state;
    CGFloat heightConstant = containerHeight - translation.y;
    CGFloat topConstant = containerTopY + translation.y;
    heightConstant = MIN(MaxContainerViewHeight, heightConstant);
    heightConstant = MAX(MinContainerViewHeight, heightConstant);
    topConstant = MAX(self.view.frame.size.height - MaxContainerViewHeight, topConstant);
    topConstant = MIN(self.view.frame.size.height - MinContainerViewHeight, topConstant);
    CGRect newFrame = CGRectMake(self.containerView.frame.origin.x, topConstant, self.containerView.frame.size.width, heightConstant);
    self.containerView.frame = newFrame;
    [pan setTranslation:CGPointZero inView:self.containerView];
    if (state == UIGestureRecognizerStateEnded || state == UIGestureRecognizerStateCancelled) {
        [self scrollToProperPosition:topConstant velocity:velocity];
    }
}

- (void)scrollToProperPosition:(CGFloat)currentPosition velocity:(CGPoint)velocity {
    CGFloat top = self.view.frame.size.height - MaxContainerViewHeight;
    CGFloat bottom = self.view.frame.size.height - MinContainerViewHeight;
    CGFloat middle = (top + bottom)/2;
    CGFloat threshold = 1500;
//    if (fabs(self.fingerSpeedSlider.value-VFVelocityThreshold) > FLT_EPSILON) {
//        threshold = self.fingerSpeedSlider.value;
//    }
    if (velocity.y > threshold && currentPosition < middle) {
        [self scrollToPosition:bottom];
        return;
    } else if (velocity.y < -threshold && currentPosition > middle) {
        [self scrollToPosition:top];
        return;
    }
    if (currentPosition < middle) {
        [self scrollToPosition:top];
    } else {
        [self scrollToPosition:bottom];
    }
}

- (void)scrollToPosition:(CGFloat)position {
    CGFloat duration = 0.5;
    CGFloat damping = 0.5;
    CGFloat velocity = 0.5;
    CGRect newFrame = CGRectMake(0, position, self.containerView.frame.size.width, self.view.frame.size.height-position);
//    if (fabs(self.durationSlider.value - 0.5) > FLT_EPSILON) {
//        duration = self.durationSlider.value;
//    }
//    if (fabs(self.dampingSlider.value - 0.5) > FLT_EPSILON) {
//        damping = self.dampingSlider.value;
//    }
//    if (fabs(self.velocitySlider.value - 0.5) > FLT_EPSILON) {
//        velocity = self.velocitySlider.value;
//    }
    if (1) {
        [UIView animateWithDuration:duration
                              delay:0
             usingSpringWithDamping:damping
              initialSpringVelocity:velocity
                            options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseInOut
                         animations:^{
            self.containerView.frame = newFrame;
        }
                         completion:nil];
    } else {
        CASpringAnimation *spring = [CASpringAnimation animationWithKeyPath:@"position.y"];
        
        
//        [UIView animateWithDuration:duration animations:^{
//            self.videoFiltersViewHeightConstraint.constant = Position;
//            [self.videoFiltersView layoutIfNeeded];
//        }];
    }
}

- (void)animatePanelWithInitialVelocity:(CGPoint)initialVelocity
{
    if (!self.panelBehavior) {
        self.panelBehavior = [[SEPanelBehavior alloc] initWithItem:self.panelView];
    }
    self.panelBehavior.targetPoint = self.targetPoint;
    self.panelBehavior.velocity = initialVelocity;
    [self.animator addBehavior:self.panelBehavior];
}

- (CGPoint)targetPoint
{
    CGSize size = self.view.bounds.size;
    return self.panelState == PanelStateClosed > 0 ? CGPointMake(size.width/2, size.height * 1.25) : CGPointMake(size.width/2, size.height/2 + 50);
}


#pragma mark - SEPanelViewDelegate

- (void)panelView:(SEPanelView *)view draggingEndedWithVelocity:(CGPoint)velocity {
    PanelState targetState = velocity.y >= 0 ? PanelStateClosed : PanelStateOpen;
    self.panelState = targetState;
    [self animatePanelWithInitialVelocity:velocity];
}

- (void)panelViewBeganDragging:(SEPanelView *)view {
    [self.animator removeAllBehaviors];
}


#pragma mark - tableView delegate & dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@", self.dataSource[indexPath.row]];
    return cell;
}

@end
