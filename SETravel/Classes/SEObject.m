//
//  SEObject.m
//  SETravel
//
//  Created by Sam Chen on 2021/5/27.
//

#import "SEObject.h"
#import <SSZipArchive/SSZipArchive.h>
#import <CoreMedia/CMTime.h>
#import <CoreMedia/CMTimeRange.h>

@implementation SEObject

- (void)show {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"KaraokeLocalAlbumPhoto" ofType:@"zip"];
    NSString *zipFilePath = path;
    NSLog(@"%@", zipFilePath);
    NSString *desPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"KaraokeLocalAlbumPhoto"];
    [SSZipArchive unzipFileAtPath:zipFilePath toDestination:desPath progressHandler:nil completionHandler:^(NSString *path, BOOL succeeded, NSError *error) {
        NSLog(@"chengogngle");
    }];
    CMTime qqq = CMTimeMakeWithSeconds(11, 600);
    CMTimeRangeMake(kCMTimeZero, qqq);
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ;
    });
}

- (void)calculate {
    NSLog(@"calculate666");
}

- (BOOL)isPositive:(NSInteger)num {
    if (num > 0) {
        return YES;
    } else {
        return NO;
    }
}

@end
