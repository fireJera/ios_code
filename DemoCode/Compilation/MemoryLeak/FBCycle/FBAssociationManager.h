//
//  FBAssociationManager.h
//  MemoryLeak
//
//  Created by Jeremy on 2019/6/24.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 FBAssoicationManager is tracker of object associations. For given object it can return all objects that are being reatined by this object with objc_setAssociatedObject & retain policy.
 */
@interface FBAssociationManager : NSObject

/*
 Start tracking associations. It will use fishhook to swizzle C methods:
 objc_(set/remove)AssociatedObject and inject some tracker code.
 */
+ (void)hook;

/*
 Stop tarcking associations, fishhooks.
 */
+ (void)unhook;

/*
 For given object return all objects that are retained by it using associated objects.
 
 @return NSArray of objects associated with given object
 */
+ (nullable NSArray *)associationsForObject:(nullable id)object;

@end
