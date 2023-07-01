//
//  ZMMultitaskingView.h
//  SETravel
//
//  Created by Sam Chen on 3/11/23.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ZMMultitaskingStyle) {
    ZMMultitaskingBottomStyle,
    ZMMultitaskingMiddleStyle,
    ZMMultitaskingTopStyle,
};

@class ZMMultitaskingView;
NS_ASSUME_NONNULL_BEGIN

@protocol ZMMultitaskingViewDelegate <NSObject>

- (void)multitaskingViewDidFinishAnimation:(ZMMultitaskingView *)multitaskingView;

@end

@interface ZMMultitaskingView : UIView

@property (nonatomic, weak) id<ZMMultitaskingViewDelegate> delegate;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame toolbar:(UIView *)toolbar NS_DESIGNATED_INITIALIZER;
- (void)presentFeatureView:(UIView *)featureView;
- (void)slideToStyle:(ZMMultitaskingStyle)style;

@end

NS_ASSUME_NONNULL_END
