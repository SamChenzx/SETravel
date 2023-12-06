//
//  SEPanelView.m
//  SETravel_Example
//
//  Created by Sam Chen on 7/13/22.
//  Copyright © 2022 chenzhixiang. All rights reserved.
//

#import "SEPanelView.h"

@interface SEPanelView ()

@property (nonatomic, strong) UIView *dragIndictor;

@end

@implementation SEPanelView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _commonInit];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.dragIndictor.frame = CGRectMake((CGRectGetWidth(self.frame)-50)/2, 9, 50, 5);
}

- (void)_commonInit {
    [self addSubview:self.dragIndictor];
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
    [self addGestureRecognizer:recognizer];
}

- (void)didPan:(UIPanGestureRecognizer *)pan {
    CGPoint point = [pan translationInView:self.superview];
    self.center = CGPointMake(self.center.x, self.center.y + point.y);
    [pan setTranslation:CGPointZero inView:self.superview];
    if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateCancelled) {
        CGPoint velocity = [pan velocityInView:self.superview];
        velocity.x = 0;
//        [self.delegate panelView:self draggingEndedWithVelocity:velocity];
    } else if (pan.state == UIGestureRecognizerStateBegan) {
//        [self.delegate panelViewBeganDragging:self];
    }
}

- (UIView *)dragIndictor {
    if (!_dragIndictor) {
        _dragIndictor = [[UIView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.frame)-50)/2, 9, 50, 5)];
        _dragIndictor.layer.cornerRadius = 2.5f;
        _dragIndictor.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:1];
    }
    return _dragIndictor;
}


@end
