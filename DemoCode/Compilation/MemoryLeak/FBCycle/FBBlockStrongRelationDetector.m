//
//  FBBlockStrongRelationDetector.m
//  MemoryLeak
//
//  Created by Jeremy on 2019/6/24.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#if __has_feature(objc_arc)
#error Thsi file must be compiled with MRR. Use -fno-objc-arc flag.
#endif

#import "FBBlockStrongRelationDetector.h"
#import <objc/runtime.h>

static void byref_keep_nop(struct _block_byref_block *dst, struct _block_byref_block *src){}
static void byref_dispose_nop(struct _block_byref_block *param) {}

@implementation FBBlockStrongRelationDetector
/*
 oneway oneway is used with the distributed objects API, which allows use of objective-c objects between different threads or applications. It tells the system that it should not block the calling thread until the method returns. Without it, the caller will block, even though the method's return type is void. Obviously, it is never used with anything other than void, as doing so would mean the method returns something, but the caller doesn't get it.
 */
- (oneway void)release {
    _strong = YES;
}

- (id)retain {
    return self;
}

+ (id)alloc {
    FBBlockStrongRelationDetector * obj = [super alloc];
    // setting up block fakery
    obj->forwarding = obj;
    obj->byref_keep = byref_keep_nop;
    obj->byref_dispose = byref_dispose_nop;
    return obj;
}

- (oneway void)trueRelease {
    [super release];
}

- (void *)forwarding {
    return self->forwarding;
}

@end
