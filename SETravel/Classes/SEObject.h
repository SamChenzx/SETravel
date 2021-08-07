//
//  SEObject.h
//  SETravel
//
//  Created by Sam Chen on 2021/5/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SEObject : NSObject

- (void)show;
- (void)calculate;
- (BOOL)isPositive:(NSInteger)num;

@end

NS_ASSUME_NONNULL_END
