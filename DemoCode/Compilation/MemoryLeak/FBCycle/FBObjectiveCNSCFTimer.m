//
//  FBObjectiveCNSCFTimer.m
//  MemoryLeak
//
//  Created by Jeremy on 2019/6/24.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import "FBObjectiveCNSCFTimer.h"

#import <objc/runtime.h>

#import "FBRetainCycleDetector.h"
#import "FBRetainCycleUtils.h"

@implementation FBObjectiveCNSCFTimer

#if _INTERNAL_RCD_ENABLED

typedef struct {
    long _unknown;  // This is always is 1
    id target;
    SEL selector;
    NSDictionary *userInfo;
} _FBNSCFTimerInfoStruct;

- (NSSet *)allRetainObjects {
    
    // https://www.jianshu.com/p/d0cd6b13fd4b
    // Let's retain our timer
    /**
    表明存储在某些局部变量中的值在优化时不应该被编译器强制释放，
     翻译官方：局部变量标记为id类型或者是指向ObjC对象类型的指针，
     以便存储在这些局部变量中的值在优化时不会被编译器强制释放。
     相反，这些值会在变量再次被赋值之前或者局部变量的作用域结束之前都会被保存。
     其中 objc_precise_lifetime 可在 LLVM ARC 可查
     // 个人再理解 就是 一个局部变量本来应该在这个局部结束之后才会被释放 但是编译器可能会进行如下优化 ，比如只在这个局部的最开始用到了 但是后来就没有再用了 就会提前释放
     */
    __attribute__((objc_precise_lifetime)) NSTimer * timer = self.object;
    
    if (!timer) {
        return nil;
    }
    
    NSMutableSet *retained = [[super allRetainObjects] mutableCopy];
    
    CFRunLoopTimerContext context;
    CFRunLoopTimerGetContext((CFRunLoopTimerRef)timer, &context);
    
    // If it has a retain function, let's assume it retains strongly
    if (context.info && context.retain) {
        _FBNSCFTimerInfoStruct infoStruct = *(_FBNSCFTimerInfoStruct *)(context.info);
        if (infoStruct.target) {
            FBObjectiveCGraphElement *element = FBWrapObjectGraphElementWithContext(self, infoStruct.target, self.configuration, @[@"target"]);
            if (element) {
                [retained addObject:element];
            }
        }
        if (infoStruct.userInfo) {
            FBObjectiveCGraphElement * element = FBWrapObjectGraphElementWithContext(self, infoStruct.userInfo, self.configuration, @[@"userInfo"]);
            if (element) {
                [retained addObject:element];
            }
        }
    }
    return retained;
}

#endif

@end
