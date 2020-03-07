
//
//  UIApplication+Listen.m
//  lifeCycle
//
//  Created by Jeremy on 2019/11/16.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import "UIApplication+Listen.h"
#import <objc/runtime.h>

@implementation UIApplication (Listen)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzlingOriginSel:@selector(sendEvent:) forSwizzleSel:@selector(jer_sendEvent:)];
    });
}

+ (void)swizzlingOriginSel:(SEL)originSel forSwizzleSel:(SEL)swizzleSel {
    Class selfClass = [self class];
    Method originMethod = class_getInstanceMethod(selfClass, originSel);
    Method swizzleMethod = class_getInstanceMethod(selfClass, swizzleSel);
    BOOL didAdd = class_addMethod(selfClass, originSel, method_getImplementation(swizzleMethod), method_getTypeEncoding(swizzleMethod));
    if (didAdd) {
        class_replaceMethod(selfClass, swizzleSel, method_getImplementation(originMethod), method_getTypeEncoding(originMethod));
    }
    else {
        method_exchangeImplementations(originMethod, swizzleMethod);
    }
}

- (void)jer_sendEvent:(UIEvent *)event {
    [self jer_sendEvent:event];
    NSLog(@"✔️✔️✔️jer_sendEvent✔️✔️✔️");
}

@end
