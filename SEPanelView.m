//
//  SEPanelView.m
//  SETravel_Example
//
//  Created by Sam Chen on 7/13/22.
//  Copyright © 2022 chenzhixiang. All rights reserved.
//

#import "SEPanelView.h"

@implementation SEPanelView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _commonInit];
    }
    return self;
}

- (void)_commonInit {
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
        [self.delegate panelView:self draggingEndedWithVelocity:velocity];
    } else if (pan.state == UIGestureRecognizerStateBegan) {
        [self.delegate panelViewBeganDragging:self];
    }
}

@end
