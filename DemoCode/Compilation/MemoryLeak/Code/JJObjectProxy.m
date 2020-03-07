//
//  JJObjectProxy.m
//  MemoryLeak
//
//  Created by Jeremy on 2019/6/21.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import "JJObjectProxy.h"
#import "JJLeakFinder.h"
#import "JJLeakMessenger.h"
#import "NSObject+JJ_Leak.h"
#import <objc/runtime.h>
#import <UIKit/UIKit.h>

#if _INTERNAL_MLF_RC_ENABLED
#import <FBReatinCycleDetector/FBReatinCycleDetector.h>
#endif

static NSMutableSet * leakedObjectPtrs;

@interface JJObjectProxy () <UIAlertViewDelegate>

@property (nonatomic, weak) id object;
@property (nonatomic, strong) NSNumber * objectPtr;
@property (nonatomic, strong) NSArray * viewStack;

@end

@implementation JJObjectProxy

+ (BOOL)isAnyObjectLeakedAtPtrs:(NSSet *)ptrs {
    NSAssert([NSThread mainThread], @"must be in main thread.");
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        leakedObjectPtrs = [[NSMutableSet alloc] init];
    });
    if (!ptrs.count) {
        return NO;
    }
    if ([leakedObjectPtrs intersectsSet:ptrs]) return YES;
    else return NO;
}

+ (void)addLeakedObject:(id)object {
    NSAssert([NSThread mainThread], @"Must be in main thread.");
    
    JJObjectProxy * proxy = [JJObjectProxy new];
    proxy.object = object;
    proxy.objectPtr = @((uintptr_t)object);
    proxy.viewStack = [object viewStack];
    static const void * const kLeakedObjectProxyKey = &kLeakedObjectProxyKey;
    objc_setAssociatedObject(self, kLeakedObjectProxyKey, proxy, OBJC_ASSOCIATION_RETAIN);
    
    [leakedObjectPtrs addObject:proxy.objectPtr];
    
#if _INTERNAL_MLF_RC_ENABLED
    [JJLeakMessenger alertWith]
#else
    [JJLeakMessenger alertWithTitle:@"Memory Leak" message:[NSString stringWithFormat:@"%@", proxy.viewStack]];
#endif
}

- (void)dealloc {
    NSNumber * objectPtr = _objectPtr;
    NSArray * viewStack = _viewStack;
    dispatch_async(dispatch_get_main_queue(), ^{
        [leakedObjectPtrs removeObject:objectPtr];
        [JJLeakMessenger alertWithTitle:@"Object Deallocted" message:[NSString stringWithFormat:@"%@", viewStack]];
    });
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (!buttonIndex) {
        return ;
    }
    id object = self.object;
    if (!object) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
    });
}

- (NSArray *)shiftArray:(NSArray *)array toIndex:(NSInteger)index {
    if (index == 0) {
        return array;
    }
    
    NSRange range = NSMakeRange(index, array.count - index);
    NSMutableArray * result = [[array subarrayWithRange:range] mutableCopy];
    [result addObjectsFromArray:[array subarrayWithRange:NSMakeRange(0, index)]];
    return result;
}

@end
