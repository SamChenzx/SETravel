//
//  SETappableLabel.h
//  SETravel
//
//  Created by Sam Chen on 8/18/22.
//

#import <UIKit/UIKit.h>

@interface SEBaseLabel : UILabel

@end

@class SETappableLabel;

NS_ASSUME_NONNULL_BEGIN

@protocol SETappableLabelDelegate <NSObject>

/// A delegate message when a valid tap occurs.
/// @param tappableLabel The label
/// @param substring The substring tapped
/// @param range The range of the tapped sub string
- (void)tappableLabel:(SETappableLabel *)tappableLabel
       tapAtSubstring:(NSString *)substring
                range:(NSRange)range;

@end


@interface SETappableLabel : UILabel

@property (nonatomic, weak) id<SETappableLabelDelegate> delegate;

/// Text bounding rect, with origin {0, 0}.
/// @return Text bounding rect
- (CGRect)textBoundingBox;

/// Add a range to response tap action, if range is invalid to label's text, this method does nothing.
/// @param range The range to response tap action.
- (void)addTapActionForRange:(NSRange)range;

/// Enable a substring to response tap action. The substring needs to be already in the label's text.
/// @param substring The substring to response tap action.
/// @discussion This method will add tap action for all location matched the substring and case insensitive, not only the first occurrence.
- (void)addTapActionForSubstring:(NSString *)substring;

/// Enable substrings to response tap action. The substrings needs to be already in the label's text.
/// @param substrings The substrings to response tap action
/// @discussion This method will add tap action for all location matched the substring and case insensitive, not only the first occurrence.
- (void)addTapActionForSubstrings:(NSArray<NSString *> *)substrings;

- (void)removeAllTappableRange;

@end

NS_ASSUME_NONNULL_END
