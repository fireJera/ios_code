//
//  FBNodeEnumerator.h
//  MemoryLeak
//
//  Created by Jeremy on 2019/6/24.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class FBObjectiveCGraphElement;

@interface FBNodeEnumerator : NSEnumerator

- (instancetype)initWithObject:(FBObjectiveCGraphElement *)object;

- (nullable FBNodeEnumerator *)nextObject;

@property (nonatomic, strong, readonly) FBObjectiveCGraphElement * object;

@end

NS_ASSUME_NONNULL_END
