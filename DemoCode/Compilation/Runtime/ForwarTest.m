//
//  ForwarTest.m
//  Runtime
//
//  Created by Jeremy on 2019/6/22.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import "ForwarTest.h"

@implementation ForwarTest

- (void)forwarInstanceMethod {
    NSLog(@"forwarInstanceMethod");
}

- (void)forwarInstanceInvacation {
    NSLog(@"forwarInstanceInvacation");
}

+ (void)forwarClassMethod {
    NSLog(@"forwarClassMethod");
}

+ (void)forwarClassInvacation {
    NSLog(@"forwarClassInvacation");
}

@end
