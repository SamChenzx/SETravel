//
//  gifTestResourceCDNFetcher.m
//  gifTestTools
//
//  Created by Sam Chen on 2021/8/26.
//

#import "gifTestResourceCDNFetcher.h"

static const NSTimeInterval gifTestResourceFetchTimeout = 120.0f;

@interface gifTestResourceCDNFetcher ()

@property (nonatomic, strong) NSURLSession *fetchSession;

@end

@implementation gifTestResourceCDNFetcher

+ (void)fetchResourceWithURLStrings:(NSArray<NSString *> *)URLStrings completionBlock:(fetchCompletionBlock)completionBlock  {
    if (!URLStrings.count) {
        return;
    }
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *fetchSession = [NSURLSession sessionWithConfiguration:config];
    NSURL *resourceURL = [NSURL URLWithString:URLStrings.lastObject];
    NSURLSessionDownloadTask *downloadTask = [fetchSession downloadTaskWithURL:resourceURL
                                                                  completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (completionBlock) {
            if (!error && location.path.length) {
                completionBlock(location.path, nil);
            } else {
                completionBlock(nil, error);
            }
        }
    }];
    [downloadTask resume];
}

+ (NSString *)syncFetchResourceWithURLStrings:(NSArray<NSString *> *)URLStrings {
    __block NSString *filePath = nil;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *fetchSession = [NSURLSession sessionWithConfiguration:config];
    NSURL *resourceURL = [NSURL URLWithString:URLStrings.firstObject];
    NSURLSessionDownloadTask *downloadTask = [fetchSession downloadTaskWithURL:resourceURL
                                                             completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error && location.path.length) {
            filePath = location.path;
        }
        dispatch_semaphore_signal(semaphore);
    }];
    [downloadTask resume];
    dispatch_semaphore_wait(semaphore, dispatch_time(DISPATCH_TIME_NOW, (int64_t)(gifTestResourceFetchTimeout * NSEC_PER_SEC)));
    return filePath;
}

@end
