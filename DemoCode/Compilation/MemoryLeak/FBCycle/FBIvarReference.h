//
//  FBIvarReference.h
//  MemoryLeak
//
//  Created by Jeremy on 2019/6/24.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "FBObjectReference.h"

typedef NS_ENUM(NSUInteger, FBType) {
    FBObjectType,
    FBBlockType,
    FBStructType,
    FBUnknowType,
};

NS_ASSUME_NONNULL_BEGIN

@interface FBIvarReference : NSObject <FBObjectReference>

@property (nonatomic, copy, readonly, nullable) NSString * name;
@property (nonatomic, readonly) FBType type;
@property (nonatomic, readonly) ptrdiff_t offset; // ptrdiff_t 通常保存两个指针减操作的结果
@property (nonatomic, readonly) NSUInteger index;
@property (nonatomic, readonly) Ivar ivar;

- (instancetype)initWithIvar:(Ivar)ivar;

@end

NS_ASSUME_NONNULL_END
