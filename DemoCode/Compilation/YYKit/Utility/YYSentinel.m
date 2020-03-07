//
//  YYSentinel.m
//  YYKit
//
//  Created by super on 2018/12/27.
//  Copyright © 2018 Jeremy. All rights reserved.
//

#import "YYSentinel.h"
#import <libkern/OSAtomic.h>
#import <stdatomic.h>

@implementation YYSentinel

- (int32_t)increase {
    if (@available(ios 10.0, *)) {
        static atomic_int counter;
        return atomic_fetch_add_explicit(&counter, 1, memory_order_relaxed);
    } else {
        return OSAtomicIncrement32(&_value);
    }
}

@end
