//
//  UIColor+Hex.h
//  SETravel_Example
//
//  Created by Sam Chen on 6/30/23.
//  Copyright © 2023 chenzhixiang. All rights reserved.
//

#define l10nString(key)                     ZMLocalizedString(key, @"")

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (Hex)

NSString* ZMLocalizedString(NSString* key, NSString* comment);

+ (UIColor *)colorWithHexString:(NSString*)hexString;

+ (UIColor *)staticColorWithHexString:(NSString*)hexString;

+ (UIColor*)staticColorWithHex:(uint32_t)rgb alpha:(CGFloat)alpha;

@end


NS_ASSUME_NONNULL_END
