//
//  ZMBasicPlusModel.h
//  SETravel
//
//  Created by Sam Chen on 7/1/23.
//

#import <Foundation/Foundation.h>
#import "ZMBasicPlusPanelDefines.h"

@interface ZMBasicPlusModel : NSObject

@property (nonatomic, assign) NSInteger total;
@property (nonatomic, assign) NSInteger unused;
@property (nonatomic, copy) NSString *creditsEffectTime;

@end

typedef void(^updateStatusBlock)(void);

@interface ZMBasicPlusViewModel : NSObject <ZMBasicPlusPanelDataSource>

@property (nonatomic, readonly) ZMBasicPlusModel *model;
@property (nonatomic, copy) updateStatusBlock updateBlock;

- (instancetype)initWithModel:(ZMBasicPlusModel *)model;

@end
