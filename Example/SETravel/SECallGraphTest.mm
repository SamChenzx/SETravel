//
//  SECallGraphTest.m
//  SETravel_Example
//
//  Created by Sam Chen on 2021/11/13.
//  Copyright © 2021 chenzhixiang. All rights reserved.
//

#import "SECallGraphTest.h"
#import "SECXXTest.hpp"
#import "SECGTProtocol.h"

static SECXXTest* pTest=NULL;

@interface SamObject : NSObject <SECGTTwoProtocol>

@property (nonatomic, copy) NSArray *dataArray;
@property (nonatomic, assign) NSInteger value;

@end

@implementation SamObject

+ (instancetype)sharedObject {
    static SamObject *obj = nil;
    static dispatch_once_t onceToken;
    void(^testblock)(void) = ^{
        NSLog(@"AST test");
    };
    testblock();
    dispatch_once(&onceToken, ^{
        if (!pTest) {
            pTest=new SECXXTest();
        }
        obj = [[SamObject alloc] init];
        [obj giveYouValue:6666];
        [obj printDataArray];
    });
    return obj;
}

- (instancetype)initWithValue:(int)value {
    if (self = [super init]) {
        [self giveYouValue:value];
    }
    return self;
}

- (void)printDataArray {
    for (NSString *str in self.dataArray) {
        if ([str isEqualToString:@"1"]) {
            NSLog(@"find 1 %@\n", str);
        }
    }
    if (pTest) {
        pTest->test();
        SECXXTest::testStatic(666);
    }
}

- (NSArray<NSString *> *)dataArray {
    if (!_dataArray) {
        _dataArray = @[@"1", @"2", @"3"];
    }
    return _dataArray;
}

- (void)giveYouValue:(NSInteger)value {
    self.value = value;
    if (value > 0) {
        NSLog(@"%ld", value);
    }
}

- (void)haveDoubleHappiness {
    NSLog(@"haveDoubleHappiness");
}

@end

@interface SECallGraphTest () <NSCopying, NSCoding, SECGTProtocol>

@property (nonatomic, strong) SamObject *obj;
@property (nonatomic, strong) id<SECGTTwoProtocol> proObj;

@end

@implementation SECallGraphTest

- (instancetype)init {
    if (self = [super init]) {
        // [self testMethod];
        // void(^blockTest)(void) = ^{
        //     [self testBlockMethod];
        //     void(^innerBlock)(void) = ^{
        //         [self testInnerBlockMethod];
        //     };
        // };
        // blockTest();
        // anotherCXXMethod(666);
        [SECallGraphTest classMethod];
        self.obj = [[SamObject sharedObject] initWithValue:666];
        self.proObj = [[SamObject alloc] initWithValue:666];
        [self.proObj haveDoubleHappiness];
        // [self.obj printDataArray];
    }
    return self;
}

// void printSomeThing(int num, int num2) {
//     anotherCXXMethod(num);
//     SamObject *sam = [[SamObject alloc] initWithValue:num];
//     [sam printDataArray];
// }

// void anotherCXXMethod(int num) {
//     printf("%d", num);
// }

// - (void)testMethod {
//     [self testBlockMethod];
//     printSomeThing(666, 777);
// }

// - (void)testBlockMethod {
//     NSLog(@"testBlockMethod");
// }

// - (void)testInnerBlockMethod {
//     NSLog(@"testInnerBlockMethod");
// }

+ (void)classMethod {
    NSLog(@"hihi");
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    SECallGraphTest *CGT = [[[self class] alloc] init];
    return CGT;
}

- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    NSLog(@"encodeWithCoder");
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)coder {
    self = [super init];
    return self;
}

- (void)haveFun {
    NSLog(@"haveFun");
}

@end

@implementation TestA

+(TestA *)shareInstanceA
{
    static TestA *testa = nil;
    static dispatch_once_t token;
    
    dispatch_once(&token, ^{
        
        testa = [[TestA alloc]init];
    });
    NSLog(@"TestA finish");
    return testa;
}

-(instancetype)init
{
    self = [super init];
    
    if (self) {
        
        [[TestA shareInstanceA] show];
    }
    
    return self;
}

- (void)show {
    NSLog(@"A dick show");
}


@end

@implementation TestB

+(TestB *)shareInstanceB
{
    static TestB *testb = nil;
    static dispatch_once_t token;
    
    dispatch_once(&token, ^{
        
        testb = [[TestB alloc]init];
    });
    
    NSLog(@"TestB finish");
    return testb;
}


-(instancetype)init
{
    self = [super init];
    
    if(self)
    {
        [TestA shareInstanceA];
    }
    
    return self;
}

@end


