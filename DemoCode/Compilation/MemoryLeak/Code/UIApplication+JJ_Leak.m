//
//  UIApplication+JJ_Leak.m
//  MemoryLeak
//
//  Created by Jeremy on 2019/6/21.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import "UIApplication+JJ_Leak.h"
#import <objc/runtime.h>
#import "NSObject+JJ_Leak.h"

#if _INTERNAL_MLF_ENABLED

@implementation UIApplication (JJ_Leak)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleSEL:@selector(sendAction:to:from:forEvent:) withSEL:@selector(swizzled_sendAction:to:from:forEvent:)];
    });
}

- (BOOL)swizzled_sendAction:(SEL)action to:(id)target from:(id)sender forEvent:(UIEvent *)event {
    objc_setAssociatedObject(self, kLatestSenderKey, @((uintptr_t)sender), OBJC_ASSOCIATION_RETAIN);
    
    return [self swizzled_sendAction:action to:target from:sender forEvent:event];
}

@end

#endif

@implementation UIControl (JJ_Leak)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
//        [self swizzleSEL:@selector(sendAction:to:from:forEvent:) withSEL:@selector(sbtn_sendAction:to:from:forEvent:)];
        [self swizzleSEL:@selector(sendAction:to:forEvent:) withSEL:@selector(sbtn_sendAction:to:forEvent:)];
//        [self swizzleSEL:@selector(sendActionsForControlEvents:) withSEL:@selector(sbtn_sendActionsForControlEvents:)];
    });
}

//- (BOOL)sbtn_sendAction:(SEL)action to:(id)target from:(id)sender forEvent:(UIEvent *)event {
//    return [self sbtn_sendAction:action to:target from:sender forEvent:event];
//}
//
//- (void)sbtn_sendActionsForControlEvents:(UIControlEvents)controlEvents {
//    [self sbtn_sendActionsForControlEvents:controlEvents];
//}
//
- (void)sbtn_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    [self sbtn_sendAction:action to:target forEvent:event];
}

@end
