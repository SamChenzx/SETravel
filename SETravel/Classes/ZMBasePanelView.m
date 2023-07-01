//
//  ZMBasePanelView.m
//  iZipow
//
//  Created by Sam Chen on 6/29/23.
//  Copyright © 2023 Zoom Video Communications, Inc. All rights reserved.
//

#if !__has_feature(objc_arc)
#error ARC (-fobjc-arc) is required to build this code.
#endif

#import "ZMBasePanelView.h"
#import "UIColor+Hex.h"

ZMMeetingPanelStyle const ZMMeetingPanelBottomStyle = @"bottomStyle";
ZMMeetingPanelStyle const ZMMeetingPanelMiddleStyle = @"middleStyle";
ZMMeetingPanelStyle const ZMMeetingPanelTopStyle = @"topStyle";

@interface ZMBasePanelView ()

@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) UIView *dragIndictor;

@end

#pragma clang diagnostic push
#pragma clang diagnostic error "-Wprotocol"
#pragma clang diagnostic error "-Wobjc-protocol-property-synthesis"
@implementation ZMBasePanelView
#pragma clang diagnostic pop

- (CGFloat)maxPanelHeight {
    return self.frame.size.height;
}

- (CGFloat)minPanelHeight {
    return 0;
}

- (CGFloat)panelTopY {
    return CGRectGetHeight(self.superview.frame) - self.maxPanelHeight;
}

- (CGFloat)panelBottomY {
    return CGRectGetHeight(self.superview.frame) - self.minPanelHeight;
}

- (void)slideToStyle:(ZMMeetingPanelStyle)style {
    if (![self.validStyles containsObject:style] || !self.superview) {
        return;
    }
    CGFloat top = CGRectGetHeight(self.superview.frame) - self.maxPanelHeight;
    CGFloat bottom = CGRectGetHeight(self.superview.frame) - self.minPanelHeight;
    CGFloat middle = (top + bottom)/2;
    if (style == ZMMeetingPanelTopStyle) {
        [self scrollToPosition:top];
    } else if (style == ZMMeetingPanelMiddleStyle) {
        [self scrollToPosition:middle];
    } else if (style == ZMMeetingPanelBottomStyle) {
        [self scrollToPosition:bottom];
    }
}

- (NSArray<ZMMeetingPanelStyle> *)validStyles {
    return @[ZMMeetingPanelBottomStyle, ZMMeetingPanelMiddleStyle, ZMMeetingPanelTopStyle];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.backgroundColor = [UIColor staticColorWithHex:0x242424 alpha:1];
    self.layer.cornerRadius = 16.0f;
    self.dragToCloseEnabled = YES;
    [self addSubview:self.dragIndictor];
    [self addGestureRecognizer:self.panGesture];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.dragIndictor.frame = CGRectMake((CGRectGetWidth(self.frame)-50)/2, 9, 50, 5);
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)pan {
    if (!self.superview) {
        return;
    }
    CGPoint translation = [pan translationInView:self.superview];
    CGPoint velocity = [pan velocityInView:self.superview];
    CGFloat panelCurrY = CGRectGetMinY(self.frame);
    if (panelCurrY <= self.panelTopY && velocity.y < 0) {
        return;
    }
    UIGestureRecognizerState state = pan.state;
    CGFloat topConstant = panelCurrY + translation.y;
    topConstant = MAX(self.panelTopY, topConstant);
    topConstant = MIN(self.panelBottomY, topConstant);
    CGRect frame = self.frame;
    frame.origin.y = topConstant;
    self.frame = frame;
    [pan setTranslation:CGPointZero inView:self];
    if (state == UIGestureRecognizerStateEnded || state == UIGestureRecognizerStateCancelled) {
        [self scrollToProperPosition:topConstant velocity:velocity];
    }
}

- (void)scrollToProperPosition:(CGFloat)currentPosition velocity:(CGPoint)velocity {
    CGFloat top = self.panelTopY;
    CGFloat bottom = self.panelBottomY;
    CGFloat middle = (top + bottom)/2;
    CGFloat threshold = 1200;
    if (velocity.y > threshold) {
        if ([self.validStyles containsObject:ZMMeetingPanelMiddleStyle] && currentPosition < middle) {
            [self scrollToPosition:middle];
        } else {
            [self scrollToPosition:bottom];
        }
        return;
    } else if (velocity.y < -threshold) {
        if ([self.validStyles containsObject:ZMMeetingPanelMiddleStyle] && currentPosition > middle) {
            [self scrollToPosition:middle];
        } else {
            [self scrollToPosition:top];
        }
        return;
    }
    [self backToProperPosition:currentPosition];
}

- (void)scrollToPosition:(CGFloat)position {
    CGRect newFrame = CGRectMake(self.frame.origin.x, position, self.frame.size.width, self.frame.size.height);
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.frame = newFrame;
    } completion:^(BOOL finished) {
        if ([self.panelDelegate respondsToSelector:@selector(panel:didScrollToPosition:)]) {
            [self.panelDelegate panel:self didScrollToPosition:position];
        }
    }];
}

- (void)backToProperPosition:(CGFloat)currentPosition {
    CGFloat top = self.panelTopY;
    CGFloat bottom = self.panelBottomY;
    CGFloat middle = (top + bottom)/2;
    
    CGFloat nearPosition = 0;
    if (currentPosition < middle) {
        nearPosition = (top+middle) / 2;
        if ([self.validStyles containsObject:ZMMeetingPanelMiddleStyle] && currentPosition > nearPosition) {
            [self scrollToPosition:middle];
        } else {
            [self scrollToPosition:top];
        }
    } else {
        nearPosition = (bottom+middle) / 2;
        if ([self.validStyles containsObject:ZMMeetingPanelMiddleStyle] && currentPosition > nearPosition) {
            [self scrollToPosition:bottom];
        } else {
            [self scrollToPosition:middle];
        }
    }
}

#pragma mark - setter/getter

- (UIPanGestureRecognizer *)panGesture {
    if (!_panGesture) {
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    }
    return _panGesture;
}

- (UIView *)dragIndictor {
    if (!_dragIndictor) {
        _dragIndictor = [[UIView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.frame)-50)/2, 9, 50, 5)];
        _dragIndictor.layer.cornerRadius = 2.5f;
        _dragIndictor.backgroundColor = [UIColor staticColorWithHex:0x757575 alpha:1];
    }
    return _dragIndictor;
}

- (void)setDragToCloseEnabled:(BOOL)dragToCloseEnabled {
    _dragToCloseEnabled = dragToCloseEnabled;
    self.panGesture.enabled = _dragToCloseEnabled;
    self.dragIndictor.hidden = !_dragToCloseEnabled;
}

@end
