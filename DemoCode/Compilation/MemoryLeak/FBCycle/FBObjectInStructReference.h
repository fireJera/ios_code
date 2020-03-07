//
//  FBObjectInStructReference.h
//  MemoryLeak
//
//  Created by Jeremy on 2019/6/24.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FBObjectReference.h"

NS_ASSUME_NONNULL_BEGIN

/*
 Struct Object is an Objective-C object that is created inside
 a struct. In Objective-C++ that object will be retained
 by an object owning the struct, otherwise will be listed in
 ivar layout for the class.
 */

@interface FBObjectInStructReference : NSObject <FBObjectReference>

- (instancetype)initWithIndex:(NSUInteger)index
                     namePath:(nullable NSArray<NSString *> *)namePath;

@end

NS_ASSUME_NONNULL_END
