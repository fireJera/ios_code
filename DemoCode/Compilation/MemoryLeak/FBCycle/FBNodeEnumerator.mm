//
//  FBNodeEnumerator.m
//  MemoryLeak
//
//  Created by Jeremy on 2019/6/24.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import "FBNodeEnumerator.h"

#import "FBObjectiveCGraphElement.h"

@implementation FBNodeEnumerator {
    NSSet * _retainedObjectsSnapshot;
    NSEnumerator *_enumerator;
}

- (instancetype)initWithObject:(FBObjectiveCGraphElement *)object {
    if (self = [super init]) {
        _object = object;
    }
    return self;
}

- (FBNodeEnumerator *)nextObject {
    if (!_object) {
        return nil;
    }
    else if (!_retainedObjectsSnapshot) {
        _retainedObjectsSnapshot = [_object allRetainObjects];
        _enumerator = [_retainedObjectsSnapshot objectEnumerator];
    }
    
    FBObjectiveCGraphElement *next = [_enumerator nextObject];
    if (next) {
        return [[FBNodeEnumerator alloc] initWithObject:next];
    }
    
    return nil;
}

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[FBNodeEnumerator class]]) {
        FBNodeEnumerator * enumerator = (FBNodeEnumerator *)object;
        return [self.object isEqual:enumerator.object];
    }
    return NO;
}

- (NSUInteger)hash {
    return [self.object hash];
}

@end
