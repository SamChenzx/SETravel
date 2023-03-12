//
//  SEPanelBehavior.h
//  SETravel_Example
//
//  Created by Sam Chen on 7/13/22.
//  Copyright © 2022 chenzhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SEPanelBehavior : UIDynamicBehavior

@property (nonatomic) CGPoint targetPoint;
@property (nonatomic) CGPoint velocity;

- (instancetype)initWithItem:(id <UIDynamicItem>)item;

@end

NS_ASSUME_NONNULL_END
