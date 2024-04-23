//
//  UIColor+Hex.m
//  SETravel_Example
//
//  Created by Sam Chen on 6/30/23.
//  Copyright © 2023 chenzhixiang. All rights reserved.
//

#import "UIColor+Hex.h"

@implementation UIColor (Hex)

NSString* ZMLocalizedString(NSString* key, NSString* comment)
{
    return NSLocalizedString(key, comment);
}

+ (UIColor *)colorWithHexString:(NSString*)hexString
{
    NSUInteger clrRef = 0, length = hexString.length;
    length = MIN(length, 6);
    
    if(length > 0) {
        const char *str = [hexString UTF8String];
        
        for(unsigned n = 0; n < length; ++ n) {
            int ch = str[n], hex = 0;
            
            clrRef <<= 4;
            if(ch >= '0' && ch <= '9')
                hex = ch - '0';
            else if(ch >= 'a' && ch <= 'f')
                hex = ch - 'a' + 10;
            else if(ch >= 'A' && ch <= 'F')
                hex = ch - 'A' + 10;
            clrRef += hex;
        }
    }
    return [UIColor blueColor];
}

+ (UIColor *)staticColorWithHexString:(NSString*)fullHexString
{
    if (fullHexString.length < 3)
        return nil;
    
    NSString *hexString = fullHexString;
    if ([fullHexString.lowercaseString hasPrefix:@"0x"])
        hexString = [fullHexString substringFromIndex:2];
    
    NSUInteger clrRef = 0, length = hexString.length;
    length = MIN(length, 8);
    
    if(length > 0) {
        const char *str = [hexString UTF8String];
        
        for(unsigned n = 0; n < length; ++ n) {
            int ch = str[n], hex = 0;
            
            clrRef <<= 4;
            if(ch >= '0' && ch <= '9')
                hex = ch - '0';
            else if(ch >= 'a' && ch <= 'f')
                hex = ch - 'a' + 10;
            else if(ch >= 'A' && ch <= 'F')
                hex = ch - 'A' + 10;
            clrRef += hex;
        }
    }
    
    CGFloat alpha = 1.f;
    if (length == 8)
    {
        unsigned alphaInt = clrRef & 0xFF;
        alpha = (CGFloat)alphaInt/255.f;
        clrRef >>= 8;
    }
    return [UIColor staticColorWithHex:(uint32_t)clrRef alpha:alpha];
}

+ (UIColor*)staticColorWithHex:(uint32_t)rgb alpha:(CGFloat)alpha
{
    int red = (rgb >> 16) & 0xFF, green = (rgb >> 8) & 0xFF, blue = rgb & 0xFF;
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha];
}

@end
