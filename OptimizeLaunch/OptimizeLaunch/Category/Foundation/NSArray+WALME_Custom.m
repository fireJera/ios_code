//
//  NSArray+WALME_Custom.m
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import "NSArray+WALME_Custom.h"

@implementation NSArray (WALME_Custom)

- (id)objectOrNilAtIndex:(NSUInteger)index {
    return index < self.count ? self[index] : nil;
}

- (nullable NSArray *)objectsFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)endIndex {
    if (self.count) {
        NSUInteger end = MIN(endIndex, self.count);
        if (end >= fromIndex) {
            return [self subarrayWithRange:NSMakeRange(fromIndex, end)];
        }
    }
    return nil;
}

@end

@implementation NSMutableArray (WALME_Custom)

- (void)removeFirstObject {
    if (self.count) {
        [self removeObjectAtIndex:0];
    }
}

- (id)popFirstObject {
    id pop = nil;
    if (self.count) {
        pop = self.firstObject;
        [self removeFirstObject];
    }
    return pop;
}

- (id)popLastObject {
    id pop = nil;
    if (self.count) {
        pop = self.lastObject;
        [self removeLastObject];
    }
    return pop;
}

- (void)appendObject:(id)anObject {
    [self addObject:anObject];
}

- (void)appendObjects:(nullable NSArray *)objects {
    if (!objects) return;
    [self addObjectsFromArray:objects];
}

- (void)prependObject:(id)anObject {
    [self insertObject:anObject atIndex:0];
}

- (void)prependObjects:(nullable NSArray *)objects {
    if (!objects) return;
    [self insertObjects:objects atIndex:0];
}

- (void)insertObjects:(nullable NSArray *)objects atIndex:(NSUInteger)index {
    if (!objects) return;
    NSUInteger i = index;
    for (id obj in objects) {
        [self insertObject:obj atIndex:i++];
    }
    //    [self insertObjects:objects atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, objects.count)]];
}

//- (id)objectAtIndexedSubscript:(NSUInteger)idx {
//    
//}

- (void)reverse {
    NSUInteger count = self.count;
    NSUInteger times = floor(count / 2);
    for (NSUInteger index = 0; index < times; index++) {
        [self exchangeObjectAtIndex:index withObjectAtIndex:count - (index + 1)];
    }
    
    //    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    //        if (idx >= ceil(self.count / 2)) {
    //            * stop = YES;
    //        }
    //        NSUInteger index = self.count - idx - 1;
    //        [self exchangeObjectAtIndex:idx withObjectAtIndex:index];
    //    }];
}

- (void)shuffle {
    for (NSUInteger i = self.count; i > 1; i--) {
        [self exchangeObjectAtIndex:i - 1 withObjectAtIndex:arc4random_uniform((uint32_t)i)];
    }
}

- (void)removeObjectsFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)endIndex {
    if (self.count) {
        NSUInteger end = MIN(endIndex, self.count);
        if (end >= fromIndex) {
            NSIndexSet * indexset = [[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(fromIndex, end)];
            [self removeObjectsAtIndexes:indexset];
        }
    }
}

- (void)removeObjectsFromIndex:(NSUInteger)fromIndex {
    [self removeObjectsFromIndex:fromIndex toIndex:self.count];
}

- (void)removeObjectsToIndex:(NSUInteger)endIndex {
    [self removeObjectsFromIndex:0 toIndex:endIndex];
}

- (nullable NSArray *)popObjectsFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)endIndex {
    NSArray * array;
    if (self.count) {
        NSUInteger end = MIN(endIndex, self.count);
        if (end >= fromIndex) {
            array = [self objectsFromIndex:fromIndex toIndex:end];
            [self removeObjectsFromIndex:fromIndex toIndex:end];
        }
    }
    return array;
}

- (nullable NSArray *)popObjectsFromIndex:(NSUInteger)fromIndex {
    return [self popObjectsFromIndex:fromIndex toIndex:self.count];
}

- (nullable NSArray *)popObjectsToIndex:(NSUInteger)endIndex {
    return [self popObjectsFromIndex:0 toIndex:endIndex];
}

@end
