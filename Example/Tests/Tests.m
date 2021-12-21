//
//  SETravelTests.m
//  SETravelTests
//
//  Created by chenzhixiang on 05/27/2021.
//  Copyright (c) 2021 chenzhixiang. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <SETravel/SEObject.h>
#import <SETravel/KSCoverageManager.h>
#import <sys/utsname.h>
#import <SSZipArchive/SSZipArchive.h>

@interface SETests : XCTestCase

@end

@implementation SETests

+ (void)setUp {
    [super setUp];
}

+ (void)tearDown {
    [super tearDown];
}

- (void)resetCoverageCount {
    extern void __llvm_profile_reset_counters(void);
    __llvm_profile_reset_counters();
}

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
//    [self writeCoverageDataToFile];
    [super tearDown];
}

- (void)testShow {
    SEObject *obj = [[SEObject alloc] init];
    [obj show];
    XCTAssertNotNil(obj, @"not nil");
}

- (void)testCalculate {
    [[KSCoverageManager sharedManager] writeCoverageDataToFile];
    SEObject *obj = [[SEObject alloc] init];
    [obj calculate];
    XCTAssertNotNil(obj, @"not nil");
}

- (void)testCoverage {
    [[KSCoverageManager sharedManager] uploadFilesWithInfo:nil shouldReset:YES];
    XCTAssertNotNil([KSCoverageManager sharedManager], @"not nil");
}

- (void)testDescription {
    SEObject *obj = [[SEObject alloc] init];
    XCTAssertGreaterThan([obj description].length, 1, @"has description");
}

- (void)testPositive {
    SEObject *obj = [[SEObject alloc] init];
    BOOL isPositive = [obj isPositive:10];
    XCTAssertTrue(isPositive, @"dick");
}

@end

