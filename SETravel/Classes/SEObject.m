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

- (void)dealloc {
    NSLog(@"SEObject dealloc");
}

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
    NSLog(@"isPositive: %d", num > 0 ? 1 : 0);
    if (num > 0) {
        return YES;
    } else {
        return NO;
    }
}

@end

@implementation SEProtocolObj

- (void)dealloc {
    NSLog(@"SEProtocolObj dealloc");
}

- (void)print666 {
    NSLog(@"666");
}

@end

@implementation SEObjectBase

- (void)setMString:(NSMutableString *)mString {
    NSLog(@"base setMString: %@", mString);
    _mString = mString;
}

- (void)dealloc {
    NSLog(@"base dealloc");
//    self.mString = nil;
    _mString = nil;
}

@end

@implementation SEObjectSub

//- (void)setMString:(NSMutableString *)mString {
//    NSLog(@"sub setMString: %@", mString);
//    [super setMString:mString];
//}

- (instancetype)init {
    if (self = [super init]) {
        _protocolObj = [[SEProtocolObj alloc] init];
        [_protocolObj print666];
    }
    return self;
}

- (void)setMArray:(NSMutableArray *)mArray {
    NSLog(@"sub setMArray: %@", mArray);
    _mArray = mArray;
}

- (void)dealloc {
    NSLog(@"sub dealloc");
//    self.mString = nil;
//    self.mArray = nil;
//    _mString = nil;
//    _mArray = nil;
}

@end
