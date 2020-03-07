//
//  FBClassStrongLayout.h
//  MemoryLeak
//
//  Created by Jeremy on 2019/6/24.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef __cplusplus
extern "C" {
#endif
    
@protocol FBObjectReference;
    
/*
 @return An array of id<FBObjectReference> objects that will have *all* references the objects has (also not retained ivars, structs etc.)
 */
NSArray<id<FBObjectReference>> *_Nonnull FBGetClassReferences(__unsafe_unretained Class _Nullable aCls);
    
/*
@return An array of id<FBObjectReference> objects that will have only those references that are retained by the object. It also goes through parent classes.
 */
NSArray<id<FBObjectReference>> *_Nonnull FBGetObjectStrongReferences(id _Nullable obj,
                                                                     NSMutableDictionary<Class, NSArray<id<FBObjectReference>> *> *_Nullable layoutCache);
    
#ifdef __cplusplus
}
#endif
