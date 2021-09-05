//
//  gifTestMockServer.m
//  gifTestTools
//
//  Created by Sam Chen on 2021/9/3.
//

#import "gifTestMockServer.h"
#import "gifTestResourceHelper.h"

@implementation gifTestMockServer

+ (void)mockForRequestUrlString:(NSString *)urlString
                         module:(KSTestModuleType)moduleType
               withResponseFile:(KSTestResourceKey)resourceKey {
    if (!urlString.length) {
        return;
    }
    [[gifTestResourceHelper sharedHelper] fetchResourceForModule:moduleType withResource:resourceKey complationBlock:^(NSString * _Nonnull resourcePath, BOOL isSuccess) {
        if (resourcePath.length && [[NSFileManager defaultManager] fileExistsAtPath:resourcePath]) {
            ;
        };
    }];
    
}

@end
