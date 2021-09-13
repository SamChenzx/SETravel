//
//  SEViewController.m
//  SETravel
//
//  Created by chenzhixiang on 08/07/2021.
//  Copyright (c) 2021 chenzhixiang. All rights reserved.
//

#import "SEViewController.h"
#import <SETravel/gifTestResourceHelper.h>
#import <SETravel/gifTestMockHTTPStubs.h>
#import <SETravel/gifTestMockServer.h>

#define dispatch_gifPostTest_main_async_safe(block)\
    if ([NSThread isMainThread]) {\
        block();\
    } else {\
        dispatch_async(dispatch_get_main_queue(), block);\
    }

typedef void(^completion)(NSArray<NSString *> * _Nullable useless);

@interface SEViewController ()

@property (nonatomic, strong) UIButton *gifButton;
@property (nonatomic, strong) NSURLSession *session;

@end

@implementation SEViewController


//- (AFURLSessionManager *)defaultSessionManager
//{
//    static AFURLSessionManager *sessionManager = nil;
//    static dispatch_once_t onceToken;
//    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
//    //config.requestCachePolicy = NSURLRequestUseProtocolCachePolicy;
//    //config.timeoutIntervalForRequest = 60;
//    //config.timeoutIntervalForResource = 180;
//    config.HTTPShouldUsePipelining = YES;
//    config.allowsCellularAccess = YES;
//    dispatch_once(&onceToken, ^{
//        sessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:config];
////        sessionManager.requestSerializer = [gifTestMockRequestSerializer serializer];
//        [sessionManager setTaskWillPerformHTTPRedirectionBlock:^NSURLRequest *(NSURLSession *session, NSURLSessionTask *task, NSURLResponse *response, NSURLRequest *request) {
//            if (response) {
//                NSMutableURLRequest *mutableURLRequest = request.mutableCopy;
//                [mutableURLRequest setValue:nil forHTTPHeaderField:@"Host"];
//                return mutableURLRequest;
//            } else {
//                return request;
//            }
//        }];
//    });
//    return sessionManager;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.gifButton];
    self.session = [NSURLSession sharedSession];
//    [gifTestMockServer mockForRequest:^BOOL(NSURLRequest * _Nonnull request) {
//        return [request.URL.absoluteString containsString:@"www."];
//    } withMockResponse:^gifTestMockResponse * _Nonnull(NSURLRequest * _Nonnull request) {
//        return [gifTestMockResponse responseForModule:KSTestModuleTypePost WithResource:KSTestPostVideoResource statusCode:407 headers:@{@"Content-Type":@"application/zip"}];
//    }];

}

- (void)didClickButton {
    
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]];
//    [[[self defaultSessionManager] dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//            NSLog(@"response:%@",response);
//        }] resume];
//    NSURLSessionDownloadTask *task = [self.session downloadTaskWithURL:[NSURL URLWithString:@"www.taobao.com"] completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        NSURLSession *session = self.session;
//        NSLog(@"response:%@", response);
//    }];
//    [task resume];
    completion commmm = ^(NSArray<NSString *> * _Nullable useless) {
        NSLog(@"useless %lu", (unsigned long)useless.count);
    };
    dispatch_async(dispatch_get_main_queue(), ^{
        commmm(@[@"dick", @"bigdick"]);
    });
    void (^excuteBlock)() = ^() {
        commmm(@[@"dick"]);
    };
    dispatch_gifPostTest_main_async_safe(excuteBlock);
    NSLog(@"start sync fetch");
    NSString *path = [[gifTestResourceHelper sharedHelper] syncFetchResourceForModule:KSTestModuleTypePost withResource:KSTestPostVideoResource ignoreCache:NO];
    NSLog(@"end sync fetch");
    NSLog(@"path:%@ fileExist:%d", path, [[NSFileManager defaultManager] fileExistsAtPath:path]);
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
