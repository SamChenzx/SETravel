//
//  ZMDrawerTableView.m
//  SETravel
//
//  Created by Sam Chen on 3/12/23.
//

#import "ZMDrawerTableView.h"

@implementation ZMDrawerTableView

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint velocity = [pan velocityInView:self];
        if (self.contentOffset.y <= 0 && velocity.y > 0) {
            return NO;
        }
        if ((CGRectGetHeight(self.bounds)+self.contentOffset.y) >= self.contentSize.height && velocity.y < 0) {
            return NO;
        }
        return YES;
    } else {
        return [super gestureRecognizerShouldBegin:gestureRecognizer];
    }
}

@end
