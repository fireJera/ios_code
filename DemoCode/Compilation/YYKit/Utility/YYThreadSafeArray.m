//
//  YYThreadSafeArray.m
//  YYKit
//
//  Created by super on 2018/12/27.
//  Copyright © 2018 Jeremy. All rights reserved.
//

#import "YYThreadSafeArray.h"

#define INIT(...) if (self = [super init]) { \
__VA_ARGS__; \
} \
if (!_array) return nil; \
_lock = dispatch_semaphore_create(1); \
return self;


#define LOCK(...) dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER); \
__VA_ARGS__; \
dispatch_semaphore_signal(_lock);

@implementation YYThreadSafeArray {
    NSMutableArray *_array;
    dispatch_semaphore_t _lock;
}

- (instancetype)init {
    INIT(_array = [[NSMutableArray alloc] init])
}

- (instancetype)initWithCapacity:(NSUInteger)numItems {
    INIT(_array = [[NSMutableArray alloc] initWithCapacity:numItems])
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    INIT(_array = [[NSMutableArray alloc] initWithCoder:aDecoder])
}

- (instancetype)initWithObjects:(const id[])objects count:(NSUInteger)cnt {
    INIT(_array = [[NSMutableArray alloc] initWithObjects:objects count:cnt])
}
//- (instancetype)initWithArray:(NSArray<ObjectType> *)array;
//- (instancetype)initWithArray:(NSArray<ObjectType> *)array copyItems:(BOOL)flag;

@end
