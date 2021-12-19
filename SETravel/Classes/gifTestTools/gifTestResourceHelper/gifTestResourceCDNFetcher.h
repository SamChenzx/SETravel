//
//  gifTestResourceCDNFetcher.h
//  gifTestTools
//
//  Created by Sam Chen on 2021/8/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^fetchCompletionBlock)(NSString * _Nullable path, NSError * _Nullable error);

@interface gifTestResourceCDNFetcher : NSObject

+ (void)fetchResourceWithURLStrings:(NSArray<NSString *> *)URLStrings completionBlock:(fetchCompletionBlock)completionBlock;
+ (NSString *)syncFetchResourceWithURLStrings:(NSArray<NSString *> *)URLStrings;

@end

NS_ASSUME_NONNULL_END
