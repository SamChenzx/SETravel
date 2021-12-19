//
//  NSURLSessionConfiguration+gifTestMock.m
//  gifCommonTests
//
//  Created by Sam Chen on 2021/9/7.
//

#import "NSURLSessionConfiguration+gifTestMock.h"
#import "gifTestMockHTTPStubs.h"
#import <objc/runtime.h>

@implementation NSURLSessionConfiguration (gifTestMock)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self gifTestMockSwizzleSelector:@selector(defaultSessionConfiguration)
                    withSwizzledSelector:@selector(gifTestMock_defaultSessionConfiguration)];
        [self gifTestMockSwizzleSelector:@selector(ephemeralSessionConfiguration)
                    withSwizzledSelector:@selector(gifTestMock_ephemeralSessionConfiguration)];
    });
}

+ (void)gifTestMockSwizzleSelector:(SEL)originalSelector withSwizzledSelector:(SEL)swizzledSelector {
    Method originalMethod = class_getClassMethod(self, originalSelector);
    Method swizzledMethod = class_getClassMethod(self, swizzledSelector);
    
    BOOL isAdd = class_addMethod(object_getClass([NSURLSessionConfiguration class]), originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (isAdd) {
        class_replaceMethod(object_getClass([NSURLSessionConfiguration class]), swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

+ (NSURLSessionConfiguration *)gifTestMock_defaultSessionConfiguration {
    NSURLSessionConfiguration* config = [self gifTestMock_defaultSessionConfiguration];
    [gifTestMockHTTPStubs setEnabled:YES forSessionConfiguration:config];
    return config;
}

+ (NSURLSessionConfiguration *)gifTestMock_ephemeralSessionConfiguration {
    NSURLSessionConfiguration* config = [self gifTestMock_ephemeralSessionConfiguration];
    [gifTestMockHTTPStubs setEnabled:YES forSessionConfiguration:config];
    return config;
}

@end
