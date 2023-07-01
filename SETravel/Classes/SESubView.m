//
//  SESubView.m
//  SETravel
//
//  Created by Sam Chen on 8/18/22.
//

#import "SESubView.h"

@implementation SESubView

- (instancetype)init {
    self = [super init];
    if (self) {
        NSLog(@"SESubView %s", __FUNCTION__);
        [self _commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        NSLog(@"SESubView %s", __FUNCTION__);
        [self _commonInit];
    }
    return self;
}

- (void)_commonInit {
    self.userInteractionEnabled = YES;
    self.backgroundColor = [UIColor yellowColor];
    NSLog(@"SESubView %s", __FUNCTION__);
}

@end
