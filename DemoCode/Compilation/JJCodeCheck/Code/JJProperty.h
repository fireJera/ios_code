//
//  JJProperty.h
//  JJCodeCheck
//
//  Created by Jeremy on 2019/7/9.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JJIvar.h"

typedef NS_OPTIONS(NSUInteger, JJPropertyAttr) {
    JJPropertyAttrAssign = 0,
    JJPropertyAttrReadonly              = (1 << 1), // R
    JJPropertyAttrCopy                  = (1 << 2), // C
    JJPropertyAttrRetain                = (1 << 3), // &
    JJPropertyAttrNonatomic             = (1 << 4), // N
    JJPropertyAttrCustomGetter          = (1 << 5), // G<name>
    JJPropertyAttrCustomSetter          = (1 << 6), // S<name>
    JJPropertyAttrDynamic               = (1 << 7), // D
    JJPropertyAttrWeak                  = (1 << 8), // W
    JJPropertyAttrGarbageCollection     = (1 << 9), // P
    JJPropertyAttrOldEncode             = (1 << 10),// t<encoding>
};

NS_ASSUME_NONNULL_BEGIN

@interface JJProperty : NSObject

@property (nonatomic, assign) objc_property_t property;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * attribute;
@property (nonatomic, copy) NSArray<NSString *> * attributes;

@property (nonatomic, assign) JJIvarType ivarType;
@property (nonatomic, assign) JJIvarType subType;
//@property (nonatomic, copy) NSString * subTypeName;
@property (nonatomic, assign) JJPropertyAttr propertyAttr;

//@property (nonatomic, readonly) BOOL isNonatomic;
//@property (nonatomic, readonly) BOOL isCopy;
//@property (nonatomic, readonly) BOOL isStrong;
//@property (nonatomic, readonly) BOOL isWeak;
//@property (nonatomic, readonly) BOOL isAssign;
//@property (nonatomic, readonly) BOOL hasCustomGetter;
//@property (nonatomic, readonly) BOOL hasCustomSetter;
//@property (nonatomic, readonly) BOOL isReadonly;
@property (nonatomic, readonly) NSString * prototypeStr;
@property (nonatomic, readonly) NSString * customGetter;
@property (nonatomic, readonly) NSString * customSetter;

- (instancetype)initWithProperty:(objc_property_t)property NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
