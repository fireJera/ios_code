//
//  NSObject+JJ_Leak.m
//  MemoryLeak
//
//  Created by Jeremy on 2019/6/21.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import "NSObject+JJ_Leak.h"
#import "JJObjectProxy.h"
#import "JJLeakFinder.h"
#import <objc/runtime.h>
#import <UIKit/UIKit.h>

static const void *const kViewStackKey = &kViewStackKey;
static const void *const kParentStackKey = &kParentStackKey;
const void *const kLatestSenderKey = &kLatestSenderKey;

@implementation NSObject (JJ_Leak)

- (BOOL)willDealloc {
    NSString *className = NSStringFromClass([self class]);
    if ([[NSObject classNameWhiteList] containsObject:className])
        return NO;
    
    NSNumber *senderPtr = objc_getAssociatedObject([UIApplication sharedApplication], kLatestSenderKey);
    if ([senderPtr isEqualToNumber:@((uintptr_t)self)])
        return NO;
    
    __weak id weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __strong id strongSelf = weakSelf;
        [strongSelf assertNotDealloc];
    });
    
    return YES;
}

- (void)assertNotDealloc {
    if ([JJObjectProxy isAnyObjectLeakedAtPtrs:[self parentPtrs]])
        return;
    [JJObjectProxy addLeakedObject:self];
    
    NSString * className = NSStringFromClass([self class]);
    NSLog(@"Possibly Memory Leak.\nIn case that %@ should not be dealloced, override -willDealloc in %@ by returning NO.\nView-ViewController stack:%@", className, className, [self viewStack]);
}

- (void)willReleaseObject:(id)object relationship:(NSString *)relationship {
    if ([relationship hasPrefix:@"self"]) {
        relationship = [relationship stringByReplacingCharactersInRange:NSMakeRange(0, 4) withString:@""];
    }
    
    NSString * className = NSStringFromClass([object class]);
    className = [NSString stringWithFormat:@"%@(%@), ", relationship, className];
    
    [object setViewStack:[[self viewStack] arrayByAddingObject:className]];
    [object setParentPtrs:[[self parentPtrs] setByAddingObject:@((uintptr_t)object)]];
    [object willDealloc];
}

- (void)willReleaseChild:(id)child {
    if (!child) return;
    [self willReleaseChildren:@[child]];
}

- (void)willReleaseChildren:(NSArray *)children {
    NSArray * viewStack = [self viewStack];
    NSSet *parentPtrs = [self parentPtrs];
    for (id child in children) {
        NSString * className = NSStringFromClass([child class]);
        [child setViewStack:[viewStack arrayByAddingObject:className]];
        [child setParentPtrs:[parentPtrs setByAddingObject:@((uintptr_t)child)]];
        [child willDealloc];
    }
}

- (NSArray *)viewStack {
    NSArray * viewStack = objc_getAssociatedObject(self, kViewStackKey);
    if (viewStack) {
        return viewStack;
    }
    NSString * className = NSStringFromClass([self class]);
    return @[className];
}

- (void)setViewStack:(NSArray *)viewStack {
    objc_setAssociatedObject(self, kViewStackKey, viewStack, OBJC_ASSOCIATION_RETAIN);
}

- (void)setParentPtrs:(NSSet *)parentPtrs {
    objc_setAssociatedObject(self, kParentStackKey, parentPtrs, OBJC_ASSOCIATION_RETAIN);
}

- (NSSet *)parentPtrs {
    NSSet * parentPtrs = objc_getAssociatedObject(self, kParentStackKey);
    if (!parentPtrs)
        parentPtrs = [[NSSet alloc] initWithObjects:@((uintptr_t)self), nil];
    return parentPtrs;
}

+ (NSMutableSet *)classNameWhiteList {
    static NSMutableSet * whitList = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        whitList = [NSMutableSet setWithObjects:
                    @"UIFieldEditor",
                    @"UINavigationBar",
                    @"_UIAlertControllerActionView",
                    @"_UIVisualEffectBackDropView",
                    nil];
        
        NSString * systemVersion = [UIDevice currentDevice].systemVersion;
        if ([systemVersion compare:@"10.0" options:NSNumericSearch] != NSOrderedAscending) {
            [whitList addObject:@"UISwitch"];
        }
    });
    return whitList;
}

+ (void)addClassNamesToWhitelist:(NSArray *)classNames {
    [[self classNameWhiteList] addObjectsFromArray:classNames];
}

+ (void)swizzleSEL:(SEL)originalSEL withSEL:(SEL)swizzleSEL {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    });
    
    Class class = [self class];
    Method originalMethod = class_getInstanceMethod(class, originalSEL);
    Method swizzleMethod = class_getInstanceMethod(class, swizzleSEL);
    
    BOOL didAddMethod = class_addMethod(class, originalSEL, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    if (didAddMethod) {
        class_replaceMethod(class, swizzleSEL, method_getImplementation(swizzleMethod), method_getTypeEncoding(swizzleMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzleMethod);
    }
}

@end
