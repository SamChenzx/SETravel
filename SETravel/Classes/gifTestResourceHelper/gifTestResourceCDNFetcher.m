//
//  gifTestResourceCDNFetcher.m
//  gifPostTests
//
//  Created by Sam Chen on 2021/8/26.
//

#import "gifTestResourceCDNFetcher.h"

@interface gifTestResourceCDNFetcher ()

@property (nonatomic, strong) NSURLSession *fetchSession;

@end

@implementation gifTestResourceCDNFetcher

+ (void)fetchResourceWithURLStrings:(NSArray<NSString *> *)URLStrings completionBlock:(fetchCompletionBlock)completionBlock  {
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *fetchSession = [NSURLSession sessionWithConfiguration:config];
    NSURL *resourceURL = [NSURL URLWithString:URLStrings.firstObject];
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



@end
