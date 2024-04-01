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
@property (nonatomic, assign) BOOL landscape;

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
    self.landscape = !self.landscape;
    [self setNeedsUpdateOfSupportedInterfaceOrientations];
//    [self setOrientation:UIDeviceOrientationLandscapeLeft force:YES];
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"this is a alert" message:@"just 666 just 666 just 666" preferredStyle:UIAlertControllerStyleAlert];
//    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
//    [alert addAction:[UIAlertAction actionWithTitle:@"Leave" style:UIAlertActionStyleDefault handler:nil]];
//    [self presentViewController:alert animated:YES completion:nil];
//    ZMDevToolViewController *vc = [[ZMDevToolViewController alloc] init];
//    [self presentViewController:vc animated:YES completion:^{
//        NSLog(@"Sam dev: %s", __FUNCTION__);
//    }];
}


- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (_landscape) {
        return UIInterfaceOrientationMaskLandscape;
    } else {
        return UIInterfaceOrientationMaskPortrait;
    }
}

- (void)setOrientation:(UIDeviceOrientation)orientation force:(BOOL)isForce {
    UIDevice *currentDevice = [UIDevice currentDevice];
    if (!isForce && (currentDevice.orientation == orientation)) {
        return;
    }
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 160000
    if(@available(iOS 16.0, *)) {
        UIInterfaceOrientationMask interfaceOrientations;
        switch(orientation) {
            case UIDeviceOrientationPortrait: interfaceOrientations = UIInterfaceOrientationMaskPortrait; break;
            case UIDeviceOrientationPortraitUpsideDown: interfaceOrientations = UIInterfaceOrientationMaskPortraitUpsideDown; break;
            case UIDeviceOrientationLandscapeLeft: interfaceOrientations = UIInterfaceOrientationMaskLandscapeRight; break;
            case UIDeviceOrientationLandscapeRight: interfaceOrientations = UIInterfaceOrientationMaskLandscapeLeft; break;
            default: return;
        }
        
        //
        UIWindowScene *mainWindowScene = self.mainWindowScene;
        
        UIWindowSceneGeometryPreferencesIOS *geometryPreferences = [[UIWindowSceneGeometryPreferencesIOS alloc] initWithInterfaceOrientations:interfaceOrientations];
        
        [mainWindowScene requestGeometryUpdateWithPreferences:geometryPreferences errorHandler:nil];
        return;
    }
#endif
}

- (UIWindowScene*)mainWindowScene API_AVAILABLE(ios(13.0))
{
    NSSet<UIScene*> *connectedScenes = [UIApplication sharedApplication].connectedScenes; Class clsScene = UIWindowScene.class;
    
    for(UIScene *scene in connectedScenes) {
        if([scene.session.role isEqualToString:UIWindowSceneSessionRoleApplication] && [scene isKindOfClass:clsScene]) {
            return (UIWindowScene*)scene;
        }
    }
    return nil;
}


@end
