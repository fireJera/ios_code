//
//  FBRetainCycleUtils.m
//  MemoryLeak
//
//  Created by Jeremy on 2019/6/24.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import "FBRetainCycleUtils.h"

#import <objc/runtime.h>
#import "FBBlockStrongLayout.h"
#import "FBClassStrongLayout.h"
#import "FBObjectiveCBlock.h"
#import "FBObjectiveCGraphElement.h"
#import "FBObjectiveCNSCFTimer.h"
#import "FBObjectiveCObject.h"
#import "FBObjectGraphConfiguration.h"

static BOOL _ShouldBreakGraphEdge(FBObjectGraphConfiguration *configuration,
                                  FBObjectiveCGraphElement * fromObject,
                                  NSString *byIvar,
                                  Class toObjectOfClass) {
    for (FBGraphEdgeFilterBlock filterlBlock in configuration.filterBlocks) {
        if (filterlBlock(fromObject, byIvar, toObjectOfClass) == FBGraphEdgeInvalid) {
            return YES;
        }
    }
    return NO;
}

FBObjectiveCGraphElement *FBWrapObjectGraphElementWithContext(FBObjectiveCGraphElement *sourceElement,
                                                              id object,
                                                              FBObjectGraphConfiguration *configuration,
                                                              NSArray<NSString *> *namePath) {
    if (_ShouldBreakGraphEdge(configuration, sourceElement, [namePath firstObject], object_getClass(object))) {
        return nil;
    }
    
    FBObjectiveCGraphElement *newElement;
    if (FBObjectIsBlock((__bridge void *)object)) {
        newElement = [[FBObjectiveCBlock alloc] initWithObject:object configuration:configuration namePath:namePath];
    } else {
        if ([object_getClass(object) isSubclassOfClass:[NSTimer class]] &&
            configuration.shouldInspectTimers) {
            newElement = [[FBObjectiveCNSCFTimer alloc] initWithObject:object configuration:configuration namePath:namePath];
        } else {
            newElement = [[FBObjectiveCObject alloc] initWithObject:object configuration:configuration namePath:namePath];
        }
    }
    return (configuration && configuration.transformerBlock) ? configuration.transformerBlock(newElement) : newElement;
}

FBObjectiveCGraphElement *FBWrapObjectGraphElement(FBObjectiveCGraphElement *sourceElement,
                                                   id object,
                                                   FBObjectGraphConfiguration *configuration) {
    return FBWrapObjectGraphElementWithContext(sourceElement, object, configuration, nil);
}
