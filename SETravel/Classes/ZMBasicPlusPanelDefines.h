//
//  ZMBasicPlusPanelDefines.h
//  iZipow
//
//  Created by Sam Chen on 7/1/23.
//  Copyright © 2023 Zoom Video Communications, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ZMBasicPlusStatus) {
    ZMBasicPlusStatusUnavailable,
    ZMBasicPlusStatusEarlyExtend,
    ZMBasicPlusStatusLateExtend,
    ZMBasicPlusStatusCancel,
    ZMBasicPlusStatusExtended,
    ZMBasicPlusStatusEnding,
};

typedef NS_ENUM(NSInteger, ZMBasicPlusAction) {
    ZMBasicPlusExtendAction,
    ZMBasicPlusCancelAction,
};

@protocol ZMBasicPlusPanelDataSource <NSObject>

@property (nonatomic, copy) NSString *mainTitle;
@property (nonatomic, copy) NSString *subTitle;
@property (nonatomic, assign) ZMBasicPlusStatus status;

@end

@protocol ZMBasicPlusPanelDelegate <NSObject>

- (void)didTapWithAction:(ZMBasicPlusAction)action;

@end


