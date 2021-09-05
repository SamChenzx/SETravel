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

#define dispatch_gifPostTest_main_async_safe(block)\
    if ([NSThread isMainThread]) {\
        block();\
    } else {\
        dispatch_async(dispatch_get_main_queue(), block);\
    }

typedef void(^completion)(NSArray<NSString *> * _Nullable useless);

@interface SEViewController ()

@property (nonatomic, strong) UIButton *gifButton;

@end

@implementation SEViewController

NSString* __nullable OHPathForFile(NSString* fileName, Class inBundleForClass)
{
    NSBundle* bundle = [NSBundle bundleForClass:inBundleForClass];
    return OHPathForFileInBundle(fileName, bundle);
}

NSString* __nullable OHPathForFileInBundle(NSString* fileName, NSBundle* bundle)
{
    return [bundle pathForResource:[fileName stringByDeletingPathExtension]
                            ofType:[fileName pathExtension]];
}

NSString* __nullable OHPathForFileInDocumentsDir(NSString* fileName)
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = (paths.count > 0) ? paths[0] : nil;
    return [basePath stringByAppendingPathComponent:fileName];
}

NSBundle* __nullable OHResourceBundle(NSString* bundleBasename, Class inBundleForClass)
{
    NSBundle* classBundle = [NSBundle bundleForClass:inBundleForClass];
    return [NSBundle bundleWithPath:[classBundle pathForResource:bundleBasename
                                                         ofType:@"bundle"]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.gifButton];
    [gifTestMockHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest * _Nonnull request) {
        return [request.URL.path containsString:@"www.baidu.com"];
    } withStubResponse:^gifTestMockResponse * _Nonnull(NSURLRequest * _Nonnull request) {
        NSString *filePath = OHPathForFile(@"resource.response", self.class);
        return [gifTestMockResponse responseWithFileAtPath:filePath statusCode:200 headers:@{@"Content-Type":@"application/zip"}];
    }];

}

- (void)didClickButton {
    
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDownloadTask *task = [session downloadTaskWithURL:[NSURL URLWithString:@"www.baidu.com"] completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"response:%@", response);
    }];
    [task resume];
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
    NSString *path = [[gifTestResourceHelper sharedHelper] syncFetchResourceForModule:KSTestModuleTypePost withResource:KSTestPostKTVAlbumResource ignoreCache:NO];
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
