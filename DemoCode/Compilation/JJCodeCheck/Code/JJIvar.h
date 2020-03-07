//
//  JJIvar.h
//  JJCodeCheck
//
//  Created by Jeremy on 2019/7/9.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

typedef NS_ENUM(NSUInteger, JJIvarType) {
    JJIvarTypeChar,                         // c
    JJIvarTypeInt,                          // i
    JJIvarTypeShort,                        // s
    JJIvarTypeLong,                         // l 老文档出错了 现在已经是q了
    JJIvarTypeLonglong,                     // q
    JJIvarTypeUnsignedChar,                 // C
    JJIvarTypeUnsignedInt,                  // S
    JJIvarTypeUnsignedShort,                // I
    JJIvarTypeUnsignedLong,                 // L 老文档出错了 现在已经是Q了
    JJIvarTypeUnsignedLonglong,             // Q
    JJIvarTypeFloat,                        // f
    JJIvarTypeDouble,                       // d
    JJIvarTypeCbool,                        // B
    JJIvarTypeVoid,                         // v usually used in func, not permitted in ivar
    JJIvarTypeCharPointer,                  // *
    JJIvarTypeObject,                       // @
    JJIvarTypeClass,                        // #
    JJIvarTypeSelector,                     // :
    JJIvarTypeArray,                       // [type]
    JJIvarTypeCStructure,                   // {name=type}
    JJIvarTypeUnion,                        // (name=type)
    JJIvarTypeBit,                          // b
    JJIvarTypePointer,                      // ^ type
    JJIvarTypeUnknown,                      // ? for example function pointer
};

NS_ASSUME_NONNULL_BEGIN

JJIvarType _getTypeFromEncoding(NSString *encoding);
//NSString * _clsNameFromEncoding(NSString *encoding);
NSString * _getTypeStringFromEncoding(NSString * encoding);

@interface JJIvar : NSObject

@property (nonatomic, copy) NSString * name;
@property (nonatomic, assign) NSUInteger size;
@property (nonatomic, assign) NSUInteger align;
@property (nonatomic, assign) Ivar ivar;
@property (nonatomic, assign) ptrdiff_t offset;
@property (nonatomic, copy) NSString * encoding;
@property (nonatomic, assign) BOOL isWeak;

@property (nonatomic, assign) JJIvarType ivarType;

/*
 only return value when ivarType == JJIvarTypeObject || JJIvarTypeClass
 */
@property (nonatomic, copy) NSString *typeName;
@property (nonatomic, copy, readonly) NSString * prototype;

- (instancetype)initWithIvar:(Ivar)ivar NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;

@end
NS_ASSUME_NONNULL_END
