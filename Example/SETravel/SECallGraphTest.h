//
//  SECallGraphTest.h
//  SETravel_Example
//
//  Created by Sam Chen on 2021/11/13.
//  Copyright © 2021 chenzhixiang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SECallGraphTest : NSObject

@end

@interface TestA : NSObject

+(TestA *)shareInstanceA;

@end

@interface TestB : NSObject

+(TestA *)shareInstanceB;

@end

NS_ASSUME_NONNULL_END
