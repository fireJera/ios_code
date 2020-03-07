//
//  FBClassStrongLayoutHelpers.m
//  MemoryLeak
//
//  Created by Jeremy on 2019/6/24.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#if __has_feature(objc_arc)
#error This file must be compiled with MRR. Use -fno-objc-arc flag.
#endif

#import "FBClassStrongLayoutHelpers.h"

id FBExtractObjectByOffset(id obj, NSUInteger index) {
    id *idx = (id *)((uintptr_t)obj + (index * sizeof(void *)));
    return *idx;
}
