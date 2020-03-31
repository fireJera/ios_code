//
//  NSTimer+WALME_Block.m
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import "NSTimer+WALME_Block.h"
#import <objc/runtime.h>

@implementation NSTimer (WALME_Block)


+ (NSTimer *)walme_scheduledTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(void))block {
    return [self scheduledTimerWithTimeInterval:interval target:self selector:@selector(p_walme_WALMEBlockInvoke:) userInfo:[block copy] repeats:repeats];
}

+ (void)p_walme_WALMEBlockInvoke:(NSTimer *)timer {
    void(^blcok)(void) = timer.userInfo;
    if (blcok) {
        blcok();
    }
}

@end

@implementation CADisplayLink (WALME_Block)

+ (CADisplayLink *)displayLinkWithExecuteBlock:(WALMEExecuteDisplayLinkBlock)block {
    CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(p_walme_executeDisplayLink:)];
    displayLink.executeBlock = [block copy];
    return displayLink;
}

- (void)setExecuteBlock:(WALMEExecuteDisplayLinkBlock)executeBlock {
    objc_setAssociatedObject(self, @selector(executeBlock), [executeBlock copy], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (WALMEExecuteDisplayLinkBlock)executeBlock{
    return objc_getAssociatedObject(self, @selector(executeBlock));
}

+ (void)p_walme_executeDisplayLink:(CADisplayLink *)displayLink{
    if (displayLink.executeBlock) {
        displayLink.executeBlock(displayLink);
    }
}

@end
