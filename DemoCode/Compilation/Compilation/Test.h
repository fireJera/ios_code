//
//  Test.h
//  Compilation
//
//  Created by Jeremy on 2019/5/9.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TsetKit/TsetKit.h"

NS_ASSUME_NONNULL_BEGIN

@interface Test : NSObject

@property (nonatomic, copy) void(^resultBlock)(void);

- (Test*(^)(NSString *))deal;

//- (Test *(^)(void))dealWithString:(NSString *)string;

@end

@interface TTest : TSTObject

@end

NS_ASSUME_NONNULL_END
