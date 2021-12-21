//
//  main.m
//  SETravel
//
//  Created by chenzhixiang on 12/19/2021.
//  Copyright (c) 2021 chenzhixiang. All rights reserved.
//

@import UIKit;
@import Darwin;
#import "SEAppDelegate.h"

void __sanitizer_cov_trace_pc_guard_init(uint32_t *start,
                                         uint32_t *stop) {
    static uint32_t N;  // Counter for the guards.
    if (start == stop || *start) return;  // Initialize only once.
    printf("INIT: %p %p\n", start, stop);
    for (uint32_t *x = start; x < stop; x++)
    *x = ++N;
}
int sequence = 0;
void __sanitizer_cov_trace_pc_guard(uint32_t *guard) {
    Dl_info info;
    
    void *PC = __builtin_return_address(0);
    dladdr(PC, &info);
    printf("func cov:%p %s sequence:%d\n", PC, info.dli_sname, sequence);
    sequence++;
}

void foo(int *a) {
    if (a)
        *a = 0;
}

int main(int argc, char * argv[])
{
    dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"main block");
        });
    int i=0;
    foo(&i);
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([SEAppDelegate class]));
    }
}
