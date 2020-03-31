//
//  NSArray+WALME_Custom.h
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray<__covariant ObjectType> (WALME_Custom)

- (nullable ObjectType)objectOrNilAtIndex:(NSUInteger)index;

- (nullable NSArray *)objectsFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)endIndex;

@end


@interface NSMutableArray<ObjectType> (WALME_Custom)

- (void)removeFirstObject;

//- (void)removeLastObject;

- (nullable ObjectType)popFirstObject;

- (nullable ObjectType)popLastObject;

- (void)appendObject:(id)anObject;

- (void)appendObjects:(nullable NSArray *)objects;

- (void)prependObject:(id)anObject;

- (void)prependObjects:(nullable NSArray *)objects;

- (void)insertObjects:(nullable NSArray *)objects atIndex:(NSUInteger)index;

- (void)reverse;

- (void)shuffle;

- (void)removeObjectsFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)endIndex;
- (void)removeObjectsFromIndex:(NSUInteger)fromIndex ;
- (void)removeObjectsToIndex:(NSUInteger)endIndex;

- (nullable NSArray *)popObjectsFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)endIndex;
- (nullable NSArray *)popObjectsToIndex:(NSUInteger)endIndex;
- (nullable NSArray *)popObjectsFromIndex:(NSUInteger)fromIndex;

@end


NS_ASSUME_NONNULL_END
