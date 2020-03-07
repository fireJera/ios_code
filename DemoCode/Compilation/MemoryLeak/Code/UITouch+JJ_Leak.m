//
//  UITouch+JJ_Leak.m
//  MemoryLeak
//
//  Created by Jeremy on 2019/6/21.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import "UITouch+JJ_Leak.h"
#import "NSObject+JJ_Leak.h"
#import <objc/runtime.h>

#if _INTERNAL_MLF_ENABLED

extern const void *const kLatestSenderKey;

@implementation UITouch (JJ_Leak)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleSEL:@selector(setView:) withSEL:@selector(swizzled_setView:)];
    });
}

- (void)swizzled_setView:(UIView *)view {
    [self swizzled_setView:view];
    
    if (view) {
        objc_setAssociatedObject([UIApplication sharedApplication], kLatestSenderKey, @((uintptr_t)view), OBJC_ASSOCIATION_RETAIN);
    }
}

@end

#endif
