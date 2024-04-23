//
//  ZMBasicPlusModel.m
//  SETravel
//
//  Created by Sam Chen on 7/1/23.
//

#import "ZMBasicPlusModel.h"


@implementation ZMBasicPlusModel

@end

@interface ZMBasicPlusViewModel ()

@property (nonatomic, readwrite) ZMBasicPlusModel *model;

@end

#pragma clang diagnostic push
#pragma clang diagnostic error "-Wprotocol"
#pragma clang diagnostic error "-Wobjc-protocol-property-synthesis"
@implementation ZMBasicPlusViewModel
#pragma clang diagnostic pop

@synthesize mainTitle;
@synthesize subTitle;
@synthesize status;

- (instancetype)initWithModel:(ZMBasicPlusModel *)model {
    self = [super init];
    if (self) {
        _model = model;
    }
    return self;
}

- (void)safelyUpdateBlock {
    if (self.updateBlock) {
        self.updateBlock();
    }
}

@end

