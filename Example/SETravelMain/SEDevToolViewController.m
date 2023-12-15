//
//  SEDevToolViewController.m
//  SETravel_Example
//
//  Created by Sam Chen on 11/17/23.
//  Copyright © 2023 chenzhixiang. All rights reserved.
//

#import "SEDevToolViewController.h"
#import "SETravel_Example-Swift.h"
#import <ZMDevTool/ZMDevTool-Swift.h>


@interface SEDevToolViewController ()

@property (nonatomic, strong) UIButton *devButton;

@end

@implementation SEDevToolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.devButton];
    [self.devButton setFrame:CGRectMake(100, 100, 100, 100)];
    // Do any additional setup after loading the view.
}

- (UIButton *)devButton {
    if (!_devButton) {
        _devButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_devButton addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
        [_devButton setBackgroundColor:UIColor.blueColor];
    }
    return _devButton;
}

- (void)didTapButton:(UIButton *)button {
    ZMDevToolViewController *vc = [[ZMDevToolViewController alloc] init];
    [self presentViewController:vc animated:YES completion:^{
        NSLog(@"Sam dev: %s", __FUNCTION__);
    }];
}


@end
