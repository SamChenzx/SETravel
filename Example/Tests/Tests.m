//
//  SETravelTests.m
//  SETravelTests
//
//  Created by chenzhixiang on 05/27/2021.
//  Copyright (c) 2021 chenzhixiang. All rights reserved.
//

@import XCTest;
#import "SEObject.h"

@interface Tests : XCTestCase

@end

@implementation Tests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testShow
{
    SEObject *obj = [[SEObject alloc] init];
    [obj show];
    XCTAssertNotNil(obj, @"not nil");
}

- (void)testCalculate
{
    SEObject *obj = [[SEObject alloc] init];
    [obj calculate];
    XCTAssertNotNil(obj, @"not nil");
}

- (void)testDescription
{
    SEObject *obj = [[SEObject alloc] init];
    XCTAssertGreaterThan([obj description].length, 1, @"has description");
}

- (void)testPositive {
    SEObject *obj = [[SEObject alloc] init];
    BOOL isPositive = [obj isPositive:10];
    XCTAssertTrue(isPositive, @"dick");
}

@end

