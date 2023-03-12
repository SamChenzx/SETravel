//
//  SEPanelView.h
//  SETravel_Example
//
//  Created by Sam Chen on 7/13/22.
//  Copyright © 2022 chenzhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SEPanelView;

NS_ASSUME_NONNULL_BEGIN

@protocol SEPanelViewDelegate

- (void)panelView:(SEPanelView *)view draggingEndedWithVelocity:(CGPoint)velocity;
- (void)panelViewBeganDragging:(SEPanelView *)view;

@end

@interface SEPanelView : UIView

@property (nonatomic, weak) id<SEPanelViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
