//
//  JJMethod.h
//  JJCodeCheck
//
//  Created by Jeremy on 2019/7/9.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

typedef NS_ENUM(NSUInteger, JJMethodType) {
    JJMethodTypeConst,          // const
    JJMethodTypeIn,             // in
    JJMethodTypeInout,          // inout
    JJMethodTypeOut,            // out
    JJMethodTypeBycopy,         // bycopy
    JJMethodTypeByref,          // byref
    JJMethodTypeOneway,         // oneway
};

NS_ASSUME_NONNULL_BEGIN

@interface JJMethod : NSObject

@property (nonatomic, assign) struct objc_method_description methodDesc;

@property (nonatomic, assign) Method method;
@property (nonatomic, assign) BOOL isMeta;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, assign) char * typeEncoding;
@property (nonatomic, assign) NSUInteger layoutLength;
@property (nonatomic, copy) NSArray<NSNumber *> *layoutIndexes;
@property (nonatomic, copy) NSString * returnType;
@property (nonatomic, copy) NSArray<NSString *> * arguments;

@property (nonatomic, copy, readonly) NSString * prototype;

- (instancetype)initWithMethod:(Method)method NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithMethod:(Method)method isMeta:(BOOL)isMeta NS_DESIGNATED_INITIALIZER;


- (instancetype)initWithMethodDesc:(struct objc_method_description)methodDesc isClass:(BOOL)isClass NS_DESIGNATED_INITIALIZER;
// default no
- (instancetype)initWithMethodDesc:(struct objc_method_description)methodDesc NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
