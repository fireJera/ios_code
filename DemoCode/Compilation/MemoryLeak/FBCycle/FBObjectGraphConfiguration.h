//
//  FBObjectGraphConfiguration.h
//  MemoryLeak
//
//  Created by Jeremy on 2019/6/24.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FBObjectiveCGraphElement.h"

typedef NS_ENUM(NSUInteger, FBGraphEdgeType) {
    FBGraphEdgeValid,
    FBGraphEdgeInvalid,
};

@protocol FBObjectReference;

typedef FBGraphEdgeType (^FBGraphEdgeFilterBlock)(FBObjectiveCGraphElement * _Nullable fromObject,
                                                  NSString *_Nullable byIvar,
                                                  Class _Nullable toObjectOfClass);

typedef FBObjectiveCGraphElement *_Nullable(^FBObjectiveCGraphElementTransformerBlock)(FBObjectiveCGraphElement *_Nonnull fromObject);

NS_ASSUME_NONNULL_BEGIN

@interface FBObjectGraphConfiguration : NSObject

@property (nonatomic, copy, readonly, nullable) NSArray<FBGraphEdgeFilterBlock> *filterBlocks;
@property (nonatomic, copy, readonly, nullable) FBObjectiveCGraphElementTransformerBlock transformerBlock;

@property (nonatomic, readonly) BOOL shouldInspectTimers;

@property (nonatomic, readonly) BOOL shouldIncludeBlockAddress;

@property (nonatomic, readonly, nullable) NSMutableDictionary<Class, NSArray<id<FBObjectReference>> *> *layoutCache;
@property (nonatomic, readonly) BOOL shouldCacheLayouts;

- (instancetype)initWithFilterBlocks:(nonnull NSArray<FBGraphEdgeFilterBlock> *)filterBlocks
                 shouldInspectTimers:(BOOL)shouldInspectTimers
                     transformerBlock:(nullable FBObjectiveCGraphElementTransformerBlock)transformerBlock
           shouldIncludeBlockAddress:(BOOL)shouldIncludeBlockAddress NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithFilterBlocks:(NSArray<FBGraphEdgeFilterBlock> *)filterBlocks
                 shouldInspectTimers:(BOOL)shouldInspectTimers
                    transformerBlock:(nullable FBObjectiveCGraphElementTransformerBlock)transformerBlock;

- (instancetype)initWithFilterBlocks:(NSArray<FBGraphEdgeFilterBlock> *)filterBlocks
                 shouldInspectTimers:(BOOL)shouldInspectTimers;
@end

NS_ASSUME_NONNULL_END
