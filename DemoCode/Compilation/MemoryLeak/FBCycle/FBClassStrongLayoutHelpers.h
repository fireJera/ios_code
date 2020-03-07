//
//  FBClassStrongLayoutHelpers.h
//  MemoryLeak
//
//  Created by Jeremy on 2019/6/24.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import <objc/runtime.h>
#import <Foundation/Foundation.h>

#ifdef __cplusplus
extern "C" {
#endif
    
/*
 Retruns object on given index for obj in its ivar layout.
 It will try to map the object to an Objective-C object, so if the index is invalid it will crash with BAD_ACCESS.
 */
id FBExtractObjectByOffset(id obj, NSUInteger index);

#ifdef __cplusplus
}
#endif
