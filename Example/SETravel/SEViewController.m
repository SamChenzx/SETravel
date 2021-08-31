//
//  SEViewController.m
//  SETravel
//
//  Created by chenzhixiang on 08/07/2021.
//  Copyright (c) 2021 chenzhixiang. All rights reserved.
//

#import "SEViewController.h"
#import <SETravel/gifTestResourceHelper.h>

typedef void(^completion)(NSArray<NSString *> * _Nullable useless);

@interface SEViewController ()

@property (nonatomic, strong) UIButton *gifButton;

@end

@implementation SEViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.gifButton];

}

- (void)didClickButton {
    completion commmm = ^(NSArray<NSString *> * _Nullable useless) {
        NSLog(@"useless %lu", (unsigned long)useless.count);
    };
    dispatch_async(dispatch_get_main_queue(), ^{
        commmm(@[@"dick", @"bigdick"]);
    });
    [[gifTestResourceHelper sharedHelper] fetchResourceForModule:KSTestModuleTypePost withResource:KSTestPostKTVAlbumResource ignoreCache:NO complationBlock:^(NSString * _Nonnull resourcePath, BOOL isSuccess) {
        NSLog(@"resourcePath: %@", resourcePath);
    }];
}

- (UIButton *)gifButton {
    if (!_gifButton) {
        _gifButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _gifButton.frame = CGRectMake(100, 100, 100, 100);
        _gifButton.backgroundColor = [UIColor purpleColor];
        [_gifButton addTarget:self action:@selector(didClickButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _gifButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
