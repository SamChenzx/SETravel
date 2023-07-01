//
//  SEObject.h
//  SETravel
//
//  Created by Sam Chen on 2021/5/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SEObjectProtocol <NSObject>

- (void)print666;

@end

@interface SEObject : NSObject

- (void)show;
- (void)calculate;
- (BOOL)isPositive:(NSInteger)num;

@end

@interface SEProtocolObj : NSObject <SEObjectProtocol>

@property (nonatomic, strong) NSString *six;

@end

@interface SEObjectBase : NSObject

@property (nonatomic, strong, nullable) NSMutableString *mString;
@property (nonatomic, strong) SEObject *obj;

@end

@interface SEObjectSub : NSObject

@property (nonatomic, strong, nullable) NSMutableArray *mArray;
@property (nonatomic, strong) id<SEObjectProtocol> protocolObj;

@end

NS_ASSUME_NONNULL_END
