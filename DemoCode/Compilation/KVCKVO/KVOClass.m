//
//  KVOClass.m
//  KVCKVO
//
//  Created by Jeremy on 2020/3/23.
//  Copyright © 2020 Jeremy. All rights reserved.
//

#import "KVOClass.h"

@implementation KVOClass

// 改写是否自动触发KVO
//+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key {
//    if ([key isEqualToString:@""]) {
//        return NO;
//    }
//    return YES;
//}


- (void)testKVOCollection {
    [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:[NSIndexSet indexSetWithIndex:0] forKey:@"presons"];
    [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:[NSIndexSet indexSetWithIndex:0] forKey:@"persons"];
}

// when firstname or lastname change, fullName Both change
+ (NSSet<NSString *> *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
    NSSet * keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
    
    if ([key isEqualToString:@"fullName"]) {
        NSArray * affectingKeys = @[@"lastName", @"firstName"];
        keyPaths = [keyPaths setByAddingObjectsFromArray:affectingKeys];
    }
    return keyPaths;
}

// also work 
+ (NSSet<NSString *> *)keyPathsForValuesAffectingFullName
{
    return [NSSet setWithObjects:@"lastName", @"firstName", nil];
}

- (void)addObserToPersonAge {
    [self.persons enumerateObjectsUsingBlock:^(KVOPerson * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj addObserver:self forKeyPath:@"age" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }];
}

- (void)updateTotalAge {
    [self setTotalAge:[[self valueForKeyPath:@"persons.@sum.age"] intValue]];
}

- (void)dealloc
{
    [self.persons enumerateObjectsUsingBlock:^(KVOPerson * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeObserver:self forKeyPath:@"age"];
    }];
}

@end
