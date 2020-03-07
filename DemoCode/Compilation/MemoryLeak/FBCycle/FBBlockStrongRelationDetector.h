//
//  FBBlockStrongRelationDetector.h
//  MemoryLeak
//
//  Created by Jeremy on 2019/6/24.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 We created a detector object that will fake *any* object that block retain.
 
 Using clever trickey from Circle:
 https://github.com/mikeash/Circle/blob/master/Circle/CircleIVarLayout.m
 
 We are also faking that this object can be treated as a block.
 Otherwise if the block is retained by block, it will try to call byref_dispose and our object won't be able to respond
 */

struct _block_byref_block;

@interface FBBlockStrongRelationDetector : NSObject {
    // block fakery
    void *forwarding;
    int flags;      //refCount
    int size;
    void(*byref_keep)(struct _block_byref_block *dst, struct _block_byref_block *src);
    void (*byref_dispose)(struct _block_byref_block *);
    void *captured[16];
}

@property (nonatomic, assign, getter=isStrong) BOOL strong;

- (oneway void)trueRelease;

- (void *)forwarding;

@end
