//
//  FBObjectiveCGraphElement.m
//  MemoryLeak
//
//  Created by Jeremy on 2019/6/24.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import "FBObjectiveCGraphElement+Internal.h"

#import <objc/runtime.h>
#import <objc/message.h>

#import "FBAssociationManager.h"
#import "FBClassStrongLayout.h"
#import "FBObjectGraphConfiguration.h"
#import "FBRetainCycleUtils.h"
#import "FBRetainCycleDetector.h"

@implementation FBObjectiveCGraphElement

- (instancetype)initWithObject:(id)object {
    return [self initWithObject:object configuration:[FBObjectGraphConfiguration new]];
}

- (instancetype)initWithObject:(id)object configuration:(FBObjectGraphConfiguration *)configuration {
    return [self initWithObject:object configuration:configuration namePath:nil];
}

- (instancetype)initWithObject:(id)object configuration:(FBObjectGraphConfiguration *)configuration namePath:(NSArray<NSString *> *)namePath {
    if (self = [super init]) {
#if _INTERNAL_RCD_ENABLED
        // We are trying to mimic how ObjectiveC does storeWeak to not fall into
        // _Objc_fatal path
        // https://github.com/bavarious/objc4/blob/3f282b8dbc0d1e501f97e4ed547a4a99cb3ac10b/runtime/objc-weak.mm#L369
        // https://www.jianshu.com/p/eff6b9443800
        Class aCls = object_getClass(object);
        BOOL (*allowsWeakReference)(id, SEL) = (__typeof__(allowsWeakReference))class_getMethodImplementation(aCls, @selector(allowsWeakReference));
        
        if (allowsWeakReference && (IMP)allowsWeakReference != _objc_msgForward) {
            if (allowsWeakReference(object, @selector(allowsWeakReference))) {
                // This is still racey since allowsWeakReference could change it value by now.
                _object = object;
            }
        } else {
            _object = object;
        }
#endif
        _configuration = configuration;
        _namePath = namePath;
    }
    return self;
}

- (NSSet *)allRetainObjects {
    NSArray * retainedObjectNotWrapped  = [FBAssociationManager associationsForObject:_object];
    NSMutableSet *retainedObjects = [NSMutableSet new];
    
    for (id obj in retainedObjectNotWrapped) {
        FBObjectiveCGraphElement *element = FBWrapObjectGraphElementWithContext(self, obj, _configuration, @[@"__assoicated_object"]);
        if (element) {
            [retainedObjects addObject:element];
        }
    }
    return retainedObjects;
}

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[FBObjectiveCGraphElement class]]) {
        FBObjectiveCGraphElement * objcObject = object;
        return objcObject.object = _object;
    }
    return NO;
}

- (NSUInteger)hash {
    return (size_t)_object;
}

- (NSString *)description
{
    if (_namePath) {
        NSString * namePathStringified = [_namePath componentsJoinedByString:@" -> "];
        return [NSString stringWithFormat:@"-> %@ -> %@", namePathStringified, [self classNameOrNull]];
    }
    return [NSString stringWithFormat:@"-> %@", [self classNameOrNull]];
}

- (size_t)objectAddress {
    return (size_t)_object;
}

- (NSString *)classNameOrNull {
    NSString * className = NSStringFromClass([self objectClass]);
    if (!className) {
        className = @"(null)";
    }
    return className;
}


- (Class)objectClass {
    return object_getClass(_object);
}

@end
