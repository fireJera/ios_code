//
//  Test.m
//  Memory
//
//  Created by super on 2018/12/26.
//  Copyright © 2018 Jeremy. All rights reserved.
//

#import "Test.h"

@interface Test ()

@property (nonatomic, strong) NSTimer * timer;

@end

@implementation Test

- (instancetype)init {
    if (self = [super init]) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(count) userInfo:nil repeats:YES];
//        _timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
//
//        }];
    }
    return self;
}

- (void)count {
    NSLog(@"1");
}

- (void)dealloc {
    [_timer invalidate];
    _timer = nil;
    NSLog(@"%@%@", [self class], NSStringFromSelector(_cmd));
}

@end
