//
//  JJObjectProxy.h
//  MemoryLeak
//
//  Created by Jeremy on 2019/6/21.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JJObjectProxy : NSObject

+ (BOOL)isAnyObjectLeakedAtPtrs:(NSSet *)ptrs;
+ (void)addLeakedObject:(id)object;

@end

NS_ASSUME_NONNULL_END
