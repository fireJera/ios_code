//
//  FBStandardGraphEdgeFilters.h
//  MemoryLeak
//
//  Created by Jeremy on 2019/6/24.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBObjectGraphConfiguration.h"
NS_ASSUME_NONNULL_BEGIN

#ifdef __cplusplus
extern "C" {
#endif
    
/**
 Standard filters mostly filters excluding some UIKit references we have caught during testing on some apps.
*/
NSArray<FBGraphEdgeFilterBlock> *FBGetStandardGraphEdgeFilters(void);

FBGraphEdgeFilterBlock FBFilterBlockWithObjectIvarRelation(Class aCls,
                                                           NSString *ivarName);
FBGraphEdgeFilterBlock FBFilterBlockWithObjectToManyIvarsRelation(Class aCls,
                                                                  NSSet<NSString *> *ivarNames);
    
FBGraphEdgeFilterBlock FBFilterBlokWithObjectIvarObjectRelation(Class fromClass,
                                                                NSString *ivarName,
                                                                Class toClass);
    
#ifdef __cplusplus
}
#endif

NS_ASSUME_NONNULL_END
