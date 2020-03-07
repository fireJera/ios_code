//
//  FBBlockStrongLayout.h
//  MemoryLeak
//
//  Created by Jeremy on 2019/6/24.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef _cplusplus
extern "C"{
#endif

/*
 Returns an array of id<FBObjectReference> objects that will have only those references that are retained by block
 */
    
NSArray *_Nullable FBGetBlockStrongReferences(void *_Nonnull block);
    
BOOL FBObjectIsBlock(void *_Nullable object);
    
#ifdef _cplusplus
}
#endif
