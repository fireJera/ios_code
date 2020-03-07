//
//  FBRetainCycleUtils.h
//  MemoryLeak
//
//  Created by Jeremy on 2019/6/24.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FBObjectGraphConfiguration, FBObjectiveCGraphElement;

#ifdef __cplusplus
extern "C" {
#endif
    
FBObjectiveCGraphElement *_Nullable FBWrapObjectGraphElementWithContext(FBObjectiveCGraphElement *_Nullable sourceElement,
                                                                        id _Nullable object,
                                                                        FBObjectGraphConfiguration *_Nullable configuration,
                                                                        NSArray<NSString *> *_Nullable namePath);
FBObjectiveCGraphElement *_Nullable FBWrapObjectGraphElement(FBObjectiveCGraphElement *_Nullable sourceElement,
                                                             id _Nullable object,
                                                             FBObjectGraphConfiguration *_Nullable configuration);
    
#ifdef __cplusplus
}
#endif
