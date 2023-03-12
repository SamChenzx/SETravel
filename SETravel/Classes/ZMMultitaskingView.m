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

static CGFloat const MinContainerViewHeight = 280;
static CGFloat const MaxContainerViewHeight = 680;

@interface ZMMultitaskingView ()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIView *toolbarContainerView;
@property (nonatomic, strong) UIView *featureContainerView;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

@end

@implementation ZMMultitaskingView

- (instancetype)initWithFrame:(CGRect)frame num:(NSInteger)num {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.label];
        self.label.text = [NSString stringWithFormat:@"View:%ld", num];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _commonInit];
    }
    return self;
}

- (void)_commonInit {
    [self addSubview:self.containerView];
    [self.containerView addSubview:self.toolbarContainerView];
    [self.containerView addSubview:self.featureContainerView];
    [self addGestureRecognizer:self.panGesture];
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
        _featureContainerView.backgroundColor = [UIColor clearColor];
        _featureContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _featureContainerView;
}

- (UIPanGestureRecognizer *)panGesture {
    if (!_panGesture) {
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    }
    return _panGesture;
}

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:self.bounds];
    }
    return _label;
}

#pragma mark - Gesture

- (void)handlePanGesture:(UIPanGestureRecognizer *)pan {
    CGPoint translation = [pan translationInView:self];
    CGPoint velocity = [pan velocityInView:self];
    CGFloat containerHeight = self.frame.size.height;
    CGFloat containerTopY = self.frame.origin.y;
    NSLog(@"Sam dev: translation = %@", [NSValue valueWithCGPoint:translation]);
    NSLog(@"Sam dev: velocity = %@", [NSValue valueWithCGPoint:velocity]);
    
    UIGestureRecognizerState state = pan.state;
    CGFloat heightConstant = containerHeight - translation.y;
    CGFloat topConstant = containerTopY + translation.y;
    heightConstant = MIN(MaxContainerViewHeight, heightConstant);
    heightConstant = MAX(MinContainerViewHeight, heightConstant);
    topConstant = MAX(self.frame.size.height - MaxContainerViewHeight, topConstant);
    topConstant = MIN(self.frame.size.height - MinContainerViewHeight, topConstant);
    CGRect newFrame = CGRectMake(self.frame.origin.x, topConstant, self.frame.size.width, heightConstant);
    self.frame = newFrame;
    [pan setTranslation:CGPointZero inView:self.containerView];
    if (state == UIGestureRecognizerStateEnded || state == UIGestureRecognizerStateCancelled) {
        [self scrollToProperPosition:topConstant velocity:velocity];
    }
}

- (void)scrollToProperPosition:(CGFloat)currentPosition velocity:(CGPoint)velocity {
    CGFloat top = self.frame.size.height - MaxContainerViewHeight;
    CGFloat bottom = self.frame.size.height - MinContainerViewHeight;
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
    CGRect newFrame = CGRectMake(0, position, self.containerView.frame.size.width, self.frame.size.height-position);
    //    if (fabs(self.durationSlider.value - 0.5) > FLT_EPSILON) {
    //        duration = self.durationSlider.value;
    //    }
    //    if (fabs(self.dampingSlider.value - 0.5) > FLT_EPSILON) {
    //        damping = self.dampingSlider.value;
    //    }
    //    if (fabs(self.velocitySlider.value - 0.5) > FLT_EPSILON) {
    //        velocity = self.velocitySlider.value;
    //    }
    [UIView animateWithDuration:duration
                          delay:0
         usingSpringWithDamping:damping
          initialSpringVelocity:velocity
                        options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseInOut
                     animations:^{
        self.containerView.frame = newFrame;
    }
                     completion:nil];
}



@end
