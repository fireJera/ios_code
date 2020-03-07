//
//  FBObjectiveCObject.h
//  MemoryLeak
//
//  Created by Jeremy on 2019/6/24.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBObjectiveCGraphElement.h"

//@class FBGraphEdgeFilterProvider;

/**
 FBObjectiveCGraphElement specialization that can gather all references kept in ivars, as part of collection
 etc.
 */

@interface FBObjectiveCObject : FBObjectiveCGraphElement

@end
