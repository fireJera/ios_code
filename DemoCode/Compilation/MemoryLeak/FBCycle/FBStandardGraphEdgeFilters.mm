//
//  FBStandardGraphEdgeFilters.m
//  MemoryLeak
//
//  Created by Jeremy on 2019/6/24.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import "FBStandardGraphEdgeFilters.h"

#import <objc/runtime.h>

#import <UIKit/UIKit.h>

#import "FBObjectiveCGraphElement.h"
#import "FBRetainCycleDetector.h"

FBGraphEdgeFilterBlock FBFilterBlockWithObjectIvarRelation(Class aCls, NSString *ivarName) {
    return FBFilterBlockWithObjectToManyIvarsRelation(aCls, [NSSet setWithObject:ivarName]);
}

FBGraphEdgeFilterBlock FBFilterBlockWithObjectToManyIvarsRelation(Class aCls,
                                                                  NSSet<NSString *> *ivarNames) {
    return ^(FBObjectiveCGraphElement * fromObject,
             NSString *byIvar,
             Class toObjectClass){
        if (aCls &&
            [[fromObject objectClass] isSubclassOfClass:aCls]) {
            // If graph element holds metadata about an ivar, it will be held in the name path, as early as possible
            if ([ivarNames containsObject:byIvar]) {
                return FBGraphEdgeInvalid;
            }
        }
        return FBGraphEdgeValid;
    };
}

FBGraphEdgeFilterBlock FBFilterBlockWithObjectIvarObjectRelation(Class fromClass, NSString* ivarName, Class toClass) {
    return ^(FBObjectiveCGraphElement * fromObject,
             NSString *byIvar,
             Class toObjectClass){
        if (toClass &&
            [toObjectClass isSubclassOfClass:toClass]) {
            return FBFilterBlockWithObjectIvarRelation(fromClass, ivarName)(fromObject, byIvar, toObjectClass);
        }
        return FBGraphEdgeValid;
    };
}

NSArray <FBGraphEdgeFilterBlock> *FBGetStandardGraphEdgeFilters() {
#if _INTERNAL_RCD_ENABLED
    static Class heldActionClass;
    static Class transitionContextClass;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        heldActionClass = NSClassFromString(@"UIHeldAction");
        transitionContextClass = NSClassFromString(@"_UIViewControllerOneToOneTransitionContext");
    });
    
    return @[FBFilterBlockWithObjectIvarRelation([UIView class], @"_subviewCache"),
             FBFilterBlockWithObjectIvarRelation(heldActionClass, @"m_target"),
             FBFilterBlockWithObjectToManyIvarsRelation([UITouch class], [NSSet setWithArray:@[@"_view",
                                                                                               @"_gestureRecognizers",
                                                                                               @"_window",
                                                                                               @"_warpedIntoView"]]),
             FBFilterBlockWithObjectToManyIvarsRelation(transitionContextClass,
                                                        [NSSet setWithArray:@[@"_toViewController",
                                                                              @"_fromViewcontroller"]])];
#else
    return nil;
#endif
}
