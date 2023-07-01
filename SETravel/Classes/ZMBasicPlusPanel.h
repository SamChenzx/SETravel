//
//  ZMBasicPlusPanel.h
//  iZipow
//
//  Created by Sam Chen on 6/26/23.
//  Copyright © 2023 Zoom Video Communications, Inc. All rights reserved.
//

#import "ZMBasePanelView.h"

typedef NS_ENUM(NSInteger, ZMBasicPlusStatus) {
    ZMBasicPlusStatusUnavailable,
    ZMBasicPlusStatusExtend,
    ZMBasicPlusStatusCancel,
    ZMBasicPlusStatusExtended,
    ZMBasicPlusStatusEnding,
};

typedef NS_ENUM(NSInteger, ZMBasicPlusAction) {
    ZMBasicPlusExtendAction,
    ZMBasicPlusCancelAction,
};

NS_ASSUME_NONNULL_BEGIN

@protocol ZMBasicPlusPanelDelegate <NSObject>

- (void)didTapWithAction:(ZMBasicPlusAction)action;

@end

@interface ZMBasicPlusPanel : ZMBasePanelView

@property (nonatomic, weak) id<ZMBasicPlusPanelDelegate> delegate;

@end

NS_ASSUME_NONNULL_END

