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

- (void)writeCoverageDataToFile {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *documentsDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject].path;
    NSString *baseDir = [documentsDirectory stringByAppendingPathComponent:@"coverage"];
    NSString *coverageZip = [documentsDirectory stringByAppendingString:@"/coverage.zip"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:baseDir error:nil];
    [fileManager createDirectoryAtPath:baseDir withIntermediateDirectories:NO attributes:nil error:NULL];
    NSString *profileFile = [baseDir stringByAppendingString:@"/profile.profraw"];
    extern int __llvm_profile_write_file(void);
    extern void __llvm_profile_set_filename(char *);
    __llvm_profile_set_filename((char *)[profileFile cStringUsingEncoding:[NSString defaultCStringEncoding]]);
    __llvm_profile_write_file();
    [SSZipArchive createZipFileAtPath:coverageZip withContentsOfDirectory:baseDir];
}

- (void)resetCoverageCount {
    extern void __llvm_profile_reset_counters(void);
    __llvm_profile_reset_counters();
}

- (void)setUp {
    [super setUp];
    [self resetCoverageCount];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [self writeCoverageDataToFile];
    [super tearDown];
}

- (void)testShow {
    SEObject *obj = [[SEObject alloc] init];
    [obj show];
    XCTAssertNotNil(obj, @"not nil");
}

- (void)testCalculate {
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

