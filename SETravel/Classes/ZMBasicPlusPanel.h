//
//  ZMBasicPlusPanel.h
//  iZipow
//
//  Created by Sam Chen on 6/26/23.
//  Copyright © 2023 Zoom Video Communications, Inc. All rights reserved.
//

#import "ZMBasePanelView.h"
#import "ZMBasicPlusPanelDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZMBasicPlusPanel : ZMBasePanelView

@property (nonatomic, weak) id<ZMBasicPlusPanelDelegate> delegate;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame
                       status:(ZMBasicPlusStatus)status;
- (void)updateWithDataSource:(id<ZMBasicPlusPanelDataSource>)data;

@end

NS_ASSUME_NONNULL_END

