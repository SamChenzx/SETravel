//
//  main.m
//  SETravel
//
//  Created by chenzhixiang on 08/07/2021.
//  Copyright (c) 2021 chenzhixiang. All rights reserved.
//

@import UIKit;
#import "SEAppDelegate.h"

@interface Grandparent : NSObject

- (void) One;

@end

@implementation Grandparent

- (void) One {
    NSLog(@"Grandparent One\n");
}

@end

@interface Parent : Grandparent

- (void) One;
- (void) Two;

@end

@implementation Parent

- (void) One {
    NSLog(@"Parent One\n");
}

- (void) Two
{
    [self One];                 // will call One based on the calling object
    [super One];                // will call One based on the defining object - Parent in this case so will Grandparent's One
}

@end

@interface Child : Parent

- (void) One;

@end

@implementation Child

- (void) One {
    NSLog(@"Child One\n");
}

- (void)Two {
    [super Two];
}

@end


int main(int argc, char * argv[])
{
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([SEAppDelegate class]));
    }
}
