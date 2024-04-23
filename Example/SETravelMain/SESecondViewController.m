//
//  SESecondViewController.m
//  SETravel_Example
//
//  Created by Sam Chen on 8/9/23.
//  Copyright © 2023 chenzhixiang. All rights reserved.
//

#import "SESecondViewController.h"

@interface SESecondViewController ()

@property (nonatomic, strong) NSMutableDictionary<NSNumber *, NSTimer *> *alertTimers;
@property (nonatomic, strong) UIButton *actionButton;
@property (nonatomic, strong) NSMutableArray<UIAlertController *> *alerts;

@end

@implementation SESecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}



- (void)dealloc {
    NSLog(@"Sam dev: %s", __FUNCTION__);
}

- (void)didTap:(UIButton *)button {
    
}

- (UIButton *)actionButton {
    if (!_actionButton) {
        _actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_actionButton addTarget:self action:@selector(didTap:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _actionButton;
}

- (NSMutableArray<UIAlertController *> *)alerts {
    if (!_alerts) {
        _alerts = [NSMutableArray array];
    }
    return _alerts;
}

@end
