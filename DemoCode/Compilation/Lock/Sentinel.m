
//
//  Sentinel.m
//  Lock
//
//  Created by Jeremy on 2019/5/3.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import "Sentinel.h"
#import <libkern/OSAtomic.h>

@implementation Sentinel {
    int32_t _value;
}

- (int32_t)value {
    return _value;
}

- (int32_t)increase {
    return OSAtomicIncrement32(&_value);
}

@end
