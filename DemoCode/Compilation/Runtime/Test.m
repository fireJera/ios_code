//
//  Test.m
//  Runtime
//
//  Created by super on 2018/12/26.
//  Copyright © 2018 Jeremy. All rights reserved.
//

#import "Test.h"
#import <objc/runtime.h>
#import "ForwarTest.h"

/*
 1. isa 找到 class
 2. 先从缓存找 再 class method list 找方法
 3. metaclass->superclass
 4.
 */

@implementation Test {
    NSString *_childName;
    short _e;
    char _f[8];
    NSString *_g;
    int _h;
}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    if ([NSStringFromSelector(sel) isEqualToString:@"msgSend"]) {
        class_addMethod(self, sel, (IMP)addMethod, "v@:");
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}

+ (BOOL)resolveClassMethod:(SEL)sel {
    if ([NSStringFromSelector(sel) isEqualToString:@"someMethod"]) {
        class_addMethod(object_getClass(self), sel, (IMP)addSomeMethod, "v@:");
        return YES;
    }
    return [super resolveClassMethod:sel];
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    if ([NSStringFromSelector(aSelector) isEqualToString:@"forwarInstanceInvacation"]) {
        return nil;
    }
    return [ForwarTest new];
}

+ (id)forwardingTargetForSelector:(SEL)aSelector {
    if ([NSStringFromSelector(aSelector) isEqualToString:@"forwarClassMethod"]) {
        return [ForwarTest class];
    }
    return [super forwardingTargetForSelector:aSelector];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *signature = [ForwarTest instanceMethodSignatureForSelector:aSelector];
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    ForwarTest * receiver = [ForwarTest new];
    if ([receiver respondsToSelector:anInvocation.selector]) {
        anInvocation.target = receiver;
        [anInvocation invoke];
    }
    else {
        return [super forwardInvocation:anInvocation];
    }
}

+ (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *signature = [ForwarTest methodSignatureForSelector:aSelector];
    return signature;
}

+ (void)forwardInvocation:(NSInvocation *)anInvocation {
    if ([ForwarTest respondsToSelector:anInvocation.selector]) {
        anInvocation.target = [ForwarTest class];
        [anInvocation invoke];
    }
    else {
        return [super forwardInvocation:anInvocation];
    }
}

void addMethod(id obj, SEL _cmd) {
    NSLog(@"obj:%@  ----  sel:%@", [obj description], NSStringFromSelector(_cmd));
}

void addSomeMethod(id obj, SEL _cmd) {
    NSLog(@"obj:%@  ----  sel:%@", [obj description], NSStringFromSelector(_cmd));
}

@end
