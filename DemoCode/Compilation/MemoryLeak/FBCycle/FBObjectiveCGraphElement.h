//
//  FBObjectiveCGraphElement.h
//  MemoryLeak
//
//  Created by Jeremy on 2019/6/24.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FBObjectGraphConfiguration;

NS_ASSUME_NONNULL_BEGIN

/**
 Base Graph Element representation. It carries some data about the object and should be overridden in subclass
 to provide references that subclass holds strongly (different for blocks, objects, other specializations).
 The Graph Element itself can only provide references from FBAssociationManager.
 */

@interface FBObjectiveCGraphElement : NSObject

/**
 Designated initializer.
 @param object Object this Graph Element will represent.
 @param configuration Provides detector's configuration that contains filters and options
 @para m filterProvider Filter Provider that Graph Element will use to determine which references need to be dropped
 @param namePath Description of how the object was retrieved from it's parent. Check namePath property.
 */
- (instancetype)initWithObject:(nullable id)object
                 configuration:(FBObjectGraphConfiguration *)configuration
                      namePath:(nullable NSArray<NSString *> *)namePath;

- (instancetype)initWithObject:(id)object
                 configuration:(FBObjectGraphConfiguration *)configuration;

@property (nonatomic, copy, readonly, nullable) NSArray<NSString *> *namePath;
@property (nonatomic, weak, nullable) id object;
@property (nonatomic, readonly) FBObjectGraphConfiguration * configuration;

/**
 Main accessor to all objects that the given object is retaining. Thread unsafe.
 
 @return NSSet of all objects this object is retaining.
 */
- (nullable NSSet *)allRetainObjects;

/**
 @return address of the object represented by this element
 */
- (size_t)objectAddress;
- (nullable Class)objectClass;
- (NSString *)classNameOrNull;

@end

NS_ASSUME_NONNULL_END
