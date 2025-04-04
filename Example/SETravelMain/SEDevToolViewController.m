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
#import <SVGKit/SVGKit.h>
#import <WebKit/WKWebView.h>


@interface SEDevToolViewController ()

@property (nonatomic, strong) UIButton *devButton;
@property (nonatomic, assign) BOOL landscape;
@property (nonatomic, strong) SVGKFastImageView *svgImageView;

@end

@implementation SEDevToolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.view addSubview:self.devButton];
//    [self.devButton setFrame:CGRectMake(100, 100, 100, 100)];
    UIImage *svg1 = [UIImage imageNamed:@"icon_toolbar_ends"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 24, 24)];
    imageView.image = svg1;
    [self.view addSubview:imageView];
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(100, 150, 48, 48)];
    imageView1.image = svg1;
    [self.view addSubview:imageView1];
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(100, 230, 96, 96)];
    imageView2.image = svg1;
    [self.view addSubview:imageView2];
    UIImageView *imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(100, 330, 192, 192)];
    imageView3.image = svg1;
    [self.view addSubview:imageView3];
    
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"icon_toolbar_ends" ofType:@"svg"];
    SVGKImage *svgImage = [SVGKImage imageWithContentsOfFile:imagePath];
    self.svgImageView = [[SVGKFastImageView alloc] initWithSVGKImage:svgImage];
    self.svgImageView.frame = CGRectMake(150, 450, svgImage.size.width*8, svgImage.size.height*8);
    [self.view addSubview:self.svgImageView];    
    
//    NSURL *url = [NSURL fileURLWithPath:imagePath];
//    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
//    webView.contentMode = UIViewContentModeScaleAspectFit;
//    
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    [webView loadRequest:request];
//    [self.view addSubview:webView];
    
    
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(200, 200, 100, 100)];
    webView.opaque = NO;
    webView.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.3];
    NSString *svgPath = [[NSBundle mainBundle] pathForResource:@"icon_toolbar_ends" ofType:@"svg"];
    NSError *error;
    NSString *svgContent = [NSString stringWithContentsOfFile:svgPath encoding:NSUTF8StringEncoding error:&error];
    NSString *htmlContent = [NSString stringWithFormat:
                             @"<html>"
                             "<head>"
                             "<style>"
                             "html, body {"
                             "margin: 0;"
                             "padding: 0;"
                             "height: 100%%;"
                             "width: 100%%;"
                             "overflow: hidden;"
                             "background-color: transparent;"
                             "}"
                             "svg {"
                             "width: 100%%;"
                             "height: 100%%;"
                             "}"
                             "</style>"
                             "</head>"
                             "<body>"
                             "%@"
                             "</body>"
                             "</html>", svgContent];   
    [webView loadHTMLString:htmlContent baseURL:nil];
    [self.view addSubview:webView];
    
    
    
//    NSError *error = nil;
//    NSData *data = [NSData dataWithContentsOfFile:imagePath options:NSDataReadingUncached error:&error];
//    UIImage *imageFromCustomBundle = [UIImage imageWithData:data];
//    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(350, 100, 24, 24)];
//    imgView.image = imageFromCustomBundle;
//    [self.view addSubview:imgView];
//    UIImageView *imgView1 = [[UIImageView alloc] initWithFrame:CGRectMake(350, 150, 48, 48)];
//    imgView1.image = imageFromCustomBundle;
//    [self.view addSubview:imgView1];
//    UIImageView *imgView2 = [[UIImageView alloc] initWithFrame:CGRectMake(350, 230, 96, 96)];
//    imgView2.image = imageFromCustomBundle;
//    [self.view addSubview:imgView2];
//    UIImageView *imgView3 = [[UIImageView alloc] initWithFrame:CGRectMake(350, 330, 192, 192)];
//    imgView3.image = imageFromCustomBundle;
//    [self.view addSubview:imgView3];
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
    if (@available(iOS 16.0, *)) {
        [self setNeedsUpdateOfSupportedInterfaceOrientations];
    }
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
