//
//  SECXXTest.hpp
//  SETravel_Example
//
//  Created by Sam Chen on 2021/11/22.
//  Copyright © 2021 chenzhixiang. All rights reserved.
//

#ifndef SECXXTest_hpp
#define SECXXTest_hpp

#include <stdio.h>

class SECXXTest {
    int value;
    
public:
    void CXXMethodTest() {
        printf("666");
    }
    
    void test() {
        printf("test");
    }
    static void testStatic(int num) {
        printf("%d", num);
    }
};


#endif /* SECXXTest_hpp */
