//
//  ZMBasePanelView.h
//  iZipow
//
//  Created by Sam Chen on 6/29/23.
//  Copyright © 2023 Zoom Video Communications, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString *ZMMeetingPanelStyle NS_STRING_ENUM;

FOUNDATION_EXPORT ZMMeetingPanelStyle const ZMMeetingPanelBottomStyle;
FOUNDATION_EXPORT ZMMeetingPanelStyle const ZMMeetingPanelMiddleStyle;
FOUNDATION_EXPORT ZMMeetingPanelStyle const ZMMeetingPanelTopStyle;

@class ZMBasePanelView;

@protocol ZMMeetingPanelProtocol <NSObject>

- (CGFloat)maxPanelHeight;
- (CGFloat)minPanelHeight;
- (void)slideToStyle:(ZMMeetingPanelStyle)style;
- (NSArray<ZMMeetingPanelStyle> *)validStyles;

@end

@protocol ZMMeetingPanelDelegate <NSObject>

- (void)panel:(ZMBasePanelView *)panel didScrollToPosition:(CGFloat)position;

@end

@interface ZMBasePanelView : UIView <ZMMeetingPanelProtocol>

@property (nonatomic, assign) BOOL dragToCloseEnabled;
@property (nonatomic, weak) id<ZMMeetingPanelDelegate> panelDelegate;

- (void)scrollToPosition:(CGFloat)position;

@end

NS_ASSUME_NONNULL_END
