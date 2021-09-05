//
//  gifTestMockServer.h
//  gifTestTools
//
//  Created by Sam Chen on 2021/9/3.
//

#import <Foundation/Foundation.h>
#import "gifTestToolsKeyFileMap.h"

@class gifTestMockResponse;

NS_ASSUME_NONNULL_BEGIN

typedef BOOL(^shouldMockRequest)(NSURLRequest* request);
typedef gifTestMockResponse* __nonnull (^mockResponseBlock)(NSURLRequest* request);

@interface gifTestMockServer : NSObject

+ (void)mockForRequest:(shouldMockRequest)shouldMockBlock module:(KSTestModuleType)moduleType withFileResource:(KSTestResourceKey)resourceKey;

+ (void)mockForRequestUrlString:(NSString *)urlString
                         module:(KSTestModuleType)moduleType
               withResponseFile:(KSTestResourceKey)resourceKey;

@end

NS_ASSUME_NONNULL_END
