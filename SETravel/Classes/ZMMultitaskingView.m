//
//  ZMMultitaskingView.m
//  SETravel
//
//  Created by Sam Chen on 3/11/23.
//

#if !__has_feature(objc_arc)
#error ARC (-fobjc-arc) is required to build this code.
#endif

#import "ZMMultitaskingView.h"


@interface ZMMultitaskingView () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIView *toolbarContainerView;
@property (nonatomic, weak) UIView *toolbar;
@property (nonatomic, weak) UIView *featureView;
@property (nonatomic, strong) UIView *featureContainerView;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

@end

@implementation ZMMultitaskingView

static inline CGFloat MaxContainerViewHeight(UIView *view) {
    CGFloat maxHeight = view.frame.size.height;
    UIEdgeInsets safeAreaInsets = view.safeAreaInsets;
    maxHeight -= safeAreaInsets.top;
    return maxHeight;
}

static inline CGFloat MinContainerViewHeight(UIView *view) {
    CGFloat minHeight = 66;
    UIEdgeInsets safeAreaInsets = view.safeAreaInsets;
    minHeight += safeAreaInsets.bottom;
    return minHeight;
}

- (instancetype)initWithFrame:(CGRect)frame toolbar:(UIView *)toolbar {
    self = [super initWithFrame:frame];
    if (self) {
        [self _commonInitWithToolbar:toolbar];
    }
    return self;
}

- (void)_commonInitWithToolbar:(UIView *)toolbar {
    [self addSubview:self.containerView];
    self.containerView.frame = self.bounds;
    [self.containerView addSubview:self.toolbarContainerView];
    [self.containerView addSubview:self.featureContainerView];
    [self addGestureRecognizer:self.panGesture];
    if (toolbar && [toolbar isKindOfClass:UIView.class]) {
        self.toolbar = toolbar;
        CGRect frame = self.containerView.frame;
        [self.toolbarContainerView addSubview:toolbar];
        toolbar.frame = toolbar.bounds;
        frame.size.height = CGRectGetHeight(toolbar.bounds);
        self.toolbarContainerView.frame = frame;
        frame = self.containerView.frame;
        frame.origin.y = CGRectGetHeight(toolbar.bounds);
        frame.size.height = CGRectGetHeight(frame) - CGRectGetHeight(toolbar.bounds);
        self.featureContainerView.frame = frame;
    }
}

- (void)presentFeatureView:(UIView *)featureView {
    if (!featureView || ![featureView isKindOfClass:UIView.class]) {
        return;
    }
    for (UIView *view in self.featureContainerView.subviews) {
        if (view.superview) {
            [view removeFromSuperview];
        }
    }
    self.featureView = featureView;
    [self.featureContainerView addSubview:featureView];
    featureView.frame = self.featureContainerView.bounds;
}

- (void)slideToStyle:(ZMMultitaskingStyle)style {
    CGFloat top = self.frame.size.height - MaxContainerViewHeight(self);
    CGFloat bottom = self.frame.size.height - MinContainerViewHeight(self);
    CGFloat middle = (top + bottom)/2;
    switch (style) {
        case ZMMultitaskingTopStyle:
            [self scrollToPosition:top];
            break;
        case ZMMultitaskingMiddleStyle:
            [self scrollToPosition:middle];
            break;
        case ZMMultitaskingBottomStyle:
            [self scrollToPosition:bottom];
            break;
        default:
            break;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    self.containerView.frame = self.bounds;
//    CGRect frame = self.containerView.frame;
//    self.toolbar.frame = self.toolbar.bounds;
//    frame.size.height = CGRectGetHeight(self.toolbar.bounds);
//    self.toolbarContainerView.frame = frame;
//    frame = self.containerView.frame;
//    frame.origin.y = CGRectGetHeight(self.toolbar.bounds);
//    frame.size.height = CGRectGetHeight(frame) - CGRectGetHeight(self.toolbar.bounds);
//    self.featureContainerView.frame = frame;
}

#pragma mark - Setter/getter

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] initWithFrame:CGRectZero];
        _containerView.backgroundColor = [UIColor clearColor];
        _containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _containerView;
}

- (UIView *)toolbarContainerView {
    if (!_toolbarContainerView) {
        _toolbarContainerView = [[UIView alloc] initWithFrame:CGRectZero];
        _toolbarContainerView.backgroundColor = [UIColor clearColor];
        _toolbarContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _toolbarContainerView;
}

- (UIView *)featureContainerView {
    if (!_featureContainerView) {
        _featureContainerView = [[UIView alloc] initWithFrame:CGRectZero];
        _featureContainerView.clipsToBounds = YES;
        _featureContainerView.backgroundColor = [UIColor clearColor];
        _featureContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _featureContainerView;
}

- (UIPanGestureRecognizer *)panGesture {
    if (!_panGesture) {
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        _panGesture.delegate = self;
    }
    return _panGesture;
}

#pragma mark - Gesture

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGPoint innerPoint = [self convertPoint:point toView:self.containerView];
    if ([self.containerView pointInside:innerPoint withEvent:event]) {
        return YES;
    }
    return NO;
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)pan {
    CGFloat top = self.frame.size.height - MaxContainerViewHeight(self);
    CGPoint translation = [pan translationInView:self];
    CGPoint velocity = [pan velocityInView:self];
    CGFloat containerHeight = CGRectGetHeight(self.containerView.frame);
    CGFloat containerTopY = CGRectGetMinY(self.containerView.frame);
    if (CGRectGetMinY(self.featureContainerView.frame) <= top && velocity.y < 0) {
        return;
    }
    NSLog(@"Sam dev: translation = %@", [NSValue valueWithCGPoint:translation]);
    NSLog(@"Sam dev: velocity = %@", [NSValue valueWithCGPoint:velocity]);
    
    UIGestureRecognizerState state = pan.state;
    CGFloat heightConstant = containerHeight - translation.y;
    CGFloat topConstant = containerTopY + translation.y;
    heightConstant = MIN(MaxContainerViewHeight(self), heightConstant);
    heightConstant = MAX(MinContainerViewHeight(self), heightConstant);
    topConstant = MAX(self.frame.size.height - MaxContainerViewHeight(self), topConstant);
    topConstant = MIN(self.frame.size.height - MinContainerViewHeight(self), topConstant);
    CGRect newFrame = CGRectMake(self.containerView.frame.origin.x, topConstant, self.containerView.frame.size.width, heightConstant);
    self.containerView.frame = newFrame;
    CGRect frame = self.containerView.bounds;
    frame.size.height = CGRectGetHeight(self.toolbar.bounds);
    self.toolbarContainerView.frame = frame;
    frame = self.containerView.bounds;
    frame.origin.y = CGRectGetHeight(self.toolbar.bounds);
    frame.size.height = CGRectGetHeight(frame) - CGRectGetHeight(self.toolbar.bounds);
    self.featureContainerView.frame = frame;
    self.featureView.frame = self.featureContainerView.bounds;
    [pan setTranslation:CGPointZero inView:self];
    if (state == UIGestureRecognizerStateEnded || state == UIGestureRecognizerStateCancelled) {
        [self scrollToProperPosition:topConstant velocity:velocity];
    }
}

- (void)scrollToProperPosition:(CGFloat)currentPosition velocity:(CGPoint)velocity {
    CGFloat top = self.frame.size.height - MaxContainerViewHeight(self);
    CGFloat bottom = self.frame.size.height - MinContainerViewHeight(self);
    CGFloat middle = (top + bottom)/2;
    CGFloat threshold = 1500;
    if (velocity.y > threshold && currentPosition < middle) {
        [self scrollToPosition:middle];
        return;
    } else if (velocity.y < -threshold && currentPosition > middle) {
        [self scrollToPosition:middle];
        return;
    } else if (velocity.y > threshold && currentPosition > middle) {
        [self scrollToPosition:bottom];
        return;
    } else if (velocity.y < -threshold && currentPosition < middle) {
        [self scrollToPosition:top];
        return;
    }
    [self bounceBackToProperPosition:currentPosition];
}

- (void)bounceBackToProperPosition:(CGFloat)currentPosition {
    CGFloat top = self.frame.size.height - MaxContainerViewHeight(self);
    CGFloat bottom = self.frame.size.height - MinContainerViewHeight(self);
    CGFloat middle = (top + bottom)/2;
    CGFloat nearPosition = 0;
    if (currentPosition < middle) {
        nearPosition = (top+middle) / 2;
        if (currentPosition > nearPosition) {
            [self scrollToPosition:middle];
        } else {
            [self scrollToPosition:top];
        }
    } else {
        nearPosition = (bottom+middle) / 2;
        if (currentPosition > nearPosition) {
            [self scrollToPosition:bottom];
        } else {
            [self scrollToPosition:middle];
        }
    }
}

- (void)scrollToPosition:(CGFloat)position {
    CGFloat duration = 0.5;
    CGFloat damping = 0.7;
    CGFloat velocity = 1.0;
    CGRect newFrame = CGRectMake(self.containerView.frame.origin.x, position, self.containerView.frame.size.width, self.frame.size.height-position);
    [UIView animateWithDuration:duration
                          delay:0
         usingSpringWithDamping:damping
          initialSpringVelocity:velocity
                        options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseInOut
                     animations:^{
        self.containerView.frame = newFrame;
        if (self.toolbar) {
            CGRect frame = self.containerView.bounds;
            frame.size.height = CGRectGetHeight(self.toolbar.bounds);
            self.toolbarContainerView.frame = frame;
            frame = self.containerView.bounds;
            frame.origin.y = CGRectGetHeight(self.toolbar.bounds);
            frame.size.height = CGRectGetHeight(frame) - CGRectGetHeight(self.toolbar.bounds);
            self.featureContainerView.frame = frame;
            self.featureView.frame = self.featureContainerView.bounds;
        }
    }
                     completion:nil];
    CGFloat top = self.frame.size.height - MaxContainerViewHeight(self);
    if (position <= top) {
        [UIView animateWithDuration:duration animations:^{
            CGRect frame = self.toolbarContainerView.frame;
            CGFloat height = frame.size.height;
            frame.size.height = 0;
            self.toolbarContainerView.frame = frame;
            frame = self.featureContainerView.frame;
            frame.origin.y -= height;
            frame.size.height += height;
            self.featureContainerView.frame = frame;
            self.featureView.frame = self.featureContainerView.bounds;
        }];
    }
}

@end
