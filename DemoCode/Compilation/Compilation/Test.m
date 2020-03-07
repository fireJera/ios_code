//
//  Test.m
//  Compilation
//
//  Created by Jeremy on 2019/5/9.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import "Test.h"

@implementation Test

- (Test * _Nonnull (^)(NSString * _Nonnull))deal {
    return ^(NSString * string) {
        [self p_realDeal:string];
        return self;
    };
}

- (void)p_realDeal:(NSString *)string {
    NSLog(@"deal string");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
        if (self.resultBlock) {
            self.resultBlock();
        }
    });
}

//- (instancetype)dealWithString:(NSString *)string {
//    NSLog(@"deal %@", string);
//    return self;
//}

@end
