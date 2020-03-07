//
//  FBObjectGraphConfiguration.m
//  MemoryLeak
//
//  Created by Jeremy on 2019/6/24.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import "FBObjectGraphConfiguration.h"

@implementation FBObjectGraphConfiguration

- (instancetype)initWithFilterBlocks:(NSArray<FBGraphEdgeFilterBlock> *)filterBlocks
                 shouldInspectTimers:(BOOL)shouldInspectTimers
                     transformerBlock:(FBObjectiveCGraphElementTransformerBlock)tranformerBlock
           shouldIncludeBlockAddress:(BOOL)shouldIncludeBlockAddress {
    if (self = [super init]) {
        _filterBlocks = filterBlocks;
        _shouldInspectTimers = shouldInspectTimers;
        _transformerBlock = tranformerBlock;
        _shouldIncludeBlockAddress = shouldIncludeBlockAddress;
        _layoutCache = [NSMutableDictionary new];
    }
    return self;
}

- (instancetype)initWithFilterBlocks:(NSArray<FBGraphEdgeFilterBlock> *)filterBlocks
                 shouldInspectTimers:(BOOL)shouldInspectTimers
                    transformerBlock:(FBObjectiveCGraphElementTransformerBlock)transformerBlock {
    return [self initWithFilterBlocks:filterBlocks shouldInspectTimers:shouldInspectTimers transformerBlock:transformerBlock shouldIncludeBlockAddress:NO];
}

- (instancetype)initWithFilterBlocks:(NSArray<FBGraphEdgeFilterBlock> *)filterBlocks
                 shouldInspectTimers:(BOOL)shouldInspectTimers {
    return [self initWithFilterBlocks:filterBlocks shouldInspectTimers:shouldInspectTimers transformerBlock:nil];
}

- (instancetype)init
{
    return [self initWithFilterBlocks:@[] shouldInspectTimers:YES];
}

@end
