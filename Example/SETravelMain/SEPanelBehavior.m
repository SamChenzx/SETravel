//
//  SEPanelBehavior.m
//  SETravel_Example
//
//  Created by Sam Chen on 7/13/22.
//  Copyright © 2022 chenzhixiang. All rights reserved.
//

#import "SEPanelBehavior.h"

@interface SEPanelBehavior ()

@property (nonatomic, strong) UIAttachmentBehavior *attachmentBehavior;
@property (nonatomic, strong) UIDynamicItemBehavior *itemBehavior;
@property (nonatomic, strong) id <UIDynamicItem> item;

@end

@implementation SEPanelBehavior

- (instancetype)initWithItem:(id<UIDynamicItem>)item {
    self = [super init];
    if (self) {
        self.item = item;
        [self _commonInit];
    }
    return self;
}

- (void)_commonInit {
    self.attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:self.item attachedToAnchor:CGPointZero];
    self.attachmentBehavior.frequency = 3.5;
    self.attachmentBehavior.damping = .4;
    self.attachmentBehavior.length = 0;
    [self addChildBehavior:self.attachmentBehavior];

    self.itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.item]];
    self.itemBehavior.density = 100;
    self.itemBehavior.resistance = 10;
    [self addChildBehavior:self.itemBehavior];
}

- (void)setTargetPoint:(CGPoint)targetPoint {
    _targetPoint = targetPoint;
    self.attachmentBehavior.anchorPoint = targetPoint;
}

- (void)setVelocity:(CGPoint)velocity {
    _velocity = velocity;
    CGPoint currentVelocity = [self.itemBehavior linearVelocityForItem:self.item];
    CGPoint velocityDelta = CGPointMake(velocity.x - currentVelocity.x, velocity.y - currentVelocity.y);
    [self.itemBehavior addLinearVelocity:velocityDelta forItem:self.item];
}

@end
