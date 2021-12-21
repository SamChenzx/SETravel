//
//  SECXXTest.cpp
//  SETravel_Example
//
//  Created by Sam Chen on 2021/11/22.
//  Copyright © 2021 chenzhixiang. All rights reserved.
//

#include "SECXXTest.hpp"

int f(void) __attribute__((constructor));

int f(void) {
    printf(" int f() __attribute__((constructor)) 被调用");
    return 0;
}

