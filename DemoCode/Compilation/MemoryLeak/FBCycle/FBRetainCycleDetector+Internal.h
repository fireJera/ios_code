//
//  FBRetainCycleDetector+Internal.h
//  Compilation
//
//  Created by Jeremy on 2019/6/24.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import "FBRetainCycleDetector.h"

@interface FBRetainCycleDetector ()

// Unit tests
- (NSArray *)_shiftToUnifiedCycle:(NSArray *)array;

@end
