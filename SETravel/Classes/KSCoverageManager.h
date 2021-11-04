//
//  KSCoverageManager.h
//  gifDebugHelperModule
//
//  Created by Sam Chen on 2021/10/20.
//

#if KSIsDebugging && KSCOVERAGE

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN



@interface KSCoverageManager : NSObject

+ (instancetype)sharedManager;

- (void)uploadFilesWithInfo:(NSDictionary *)infoDic shouldReset:(BOOL)shouldReset;

@end

NS_ASSUME_NONNULL_END

#endif

