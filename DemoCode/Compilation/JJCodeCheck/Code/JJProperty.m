//
//  JJProperty.m
//  JJCodeCheck
//
//  Created by Jeremy on 2019/7/9.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import "JJProperty.h"

static JJPropertyAttr _getOnePropertyAttr(const char attr) {
    switch (attr) {
        case 'R':
            return JJPropertyAttrReadonly;
            break;
        case 'C':
            return JJPropertyAttrCopy;
            break;
        case '&':
            return JJPropertyAttrRetain;
            break;
        case 'N':
            return JJPropertyAttrNonatomic;
            break;
        case 'G':
            return JJPropertyAttrCustomGetter;
            break;
        case 'S':
            return JJPropertyAttrCustomSetter;
            break;
        case 'D':
            return JJPropertyAttrDynamic;
            break;
        case 'W':
            return JJPropertyAttrWeak;
            break;
        case 'P':
            return JJPropertyAttrGarbageCollection;
            break;
        case 't':
            return JJPropertyAttrOldEncode;
            break;
    }
    return JJPropertyAttrAssign;
}

static JJPropertyAttr _getPropertyAttr(NSString * attribute) {
    NSArray<NSString *> * array = [attribute componentsSeparatedByString:@","];
    __block JJPropertyAttr attr = JJPropertyAttrAssign;
    [array enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj hasPrefix:@"T"]) {
            
        }
        else if ([obj hasPrefix:@"V"]) {
            
        }
        else {
            const char a = [obj characterAtIndex:0];
            attr = attr | _getOnePropertyAttr(a);
        }
    }];
    return attr;
}

@interface JJProperty ()

@property (nonatomic, copy, readwrite) NSString * prototypeStr;
@property (nonatomic, copy, readwrite) NSString * customGetter;
@property (nonatomic, copy, readwrite) NSString * customSetter;

@property (nonatomic, copy) NSString * typeAndName;

@end

@implementation JJProperty

- (instancetype)initWithProperty:(objc_property_t)property {
    if (self = [super init]) {
        _property = property;
        const char * attr = property_getAttributes(property);
        const char * name = property_getName(property);
        unsigned int attrCount;
        objc_property_attribute_t * attries = property_copyAttributeList(property, &attrCount);
        NSMutableArray * attrValues = [NSMutableArray array];
        for (int j = 0; j < attrCount; j++) {
            const char * attrName = attries[j].name;
            char * aValue = property_copyAttributeValue(property, attrName);
            NSString * value = [NSString stringWithCString:aValue encoding:NSUTF8StringEncoding];
            [attrValues addObject:value];
        }
        _name = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
        self.attribute = [NSString stringWithCString:attr encoding:NSUTF8StringEncoding];
        //            NSLog(@"name : %@, attribute : %@", pro.name, pro.attribute);
        _attributes = [attrValues copy];
    }
    return self;
}

//- (instancetype)init {
//    objc_property_t property;
//    return [self initWithProperty:property];
//}

- (void)setAttribute:(NSString *)attribute {
    _attribute = attribute;
    _propertyAttr = _getPropertyAttr(attribute);
    NSArray<NSString *> * array = [attribute componentsSeparatedByString:@","];
    
    [array enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj hasPrefix:@"G"]) {
            _customGetter = [NSString stringWithFormat:@"getter=%@", [obj substringFromIndex:1]];
        }
        if ([obj hasPrefix:@"S"]) {
            _customSetter = [NSString stringWithFormat:@"setter=%@", [obj substringFromIndex:1]];
        }
    }];
    
    NSString * typeencoding = array.firstObject;
    NSString * encoding = [typeencoding substringFromIndex:1];
    _typeAndName = _getTypeStringFromEncoding(encoding);
    const char t = [typeencoding characterAtIndex:1];
    _ivarType = _getTypeFromEncoding(encoding);
    if (_ivarType == JJIvarTypePointer) {
        if (typeencoding.length > 2) {
            const char t = [typeencoding characterAtIndex:2];
            _subType = _getTypeFromEncoding(encoding);
        }
    }
    else if (_ivarType == JJIvarTypeObject) {
        
    }
//    else if (_ivarType == JJIvarTypeCStructure) {
//        if (typeencoding.length > 2) {
//            NSString * subEncode = [typeencoding substringFromIndex:2];
//            NSArray * subArray = [subEncode componentsSeparatedByString:@"="];
//            NSString *name = subArray.firstObject;
//            _subTypeName = name;
//        }
//    }
}

- (NSString *)prototypeStr {
    if (!_prototypeStr) {
        NSMutableString * string = [@"@property()" mutableCopy];
        NSMutableArray * array = [NSMutableArray array];
        if (_propertyAttr & JJPropertyAttrNonatomic) {
            [array addObject:@"nonatomic"];
        }
        else {
            [array addObject:@"atomic"];
        }
        if (_propertyAttr & JJPropertyAttrCopy) {
            [array addObject:@"copy"];
        }
        else if (_propertyAttr & JJPropertyAttrRetain) {
            [array addObject:@"strong"];
        }
        else if (_propertyAttr & JJPropertyAttrWeak) {
            [array addObject:@"weak"];
        }
        else {
            [array addObject:@"assign"];
        }
        if (_propertyAttr & JJPropertyAttrCustomGetter) {
            [array addObject:_customGetter];
        }
        if (_propertyAttr & JJPropertyAttrCustomSetter) {
            [array addObject:_customSetter];
        }
        if (_propertyAttr & JJPropertyAttrReadonly) {
            [array addObject:@"readonly"];
        }
        else {
            [array addObject:@"readwrite"];
        }
        NSString * innerString = [array componentsJoinedByString:@", "];
        [string insertString:innerString atIndex:string.length - 1];
        
        NSString * last;
        if (_ivarType == JJIvarTypeBit) {
            NSMutableString * temp = [_typeAndName mutableCopy];
            [temp replaceCharactersInRange:NSMakeRange(5, 1) withString:_name];
            last = [temp copy];
        }
        else if (_ivarType == JJIvarTypeUnknown) {
            NSMutableString * temp = [_typeAndName mutableCopy];
            [temp insertString:_name atIndex:7];
            last = [temp copy];
        }
        else {
            last = [NSString stringWithFormat:@"%@ %@", _typeAndName, _name];
        }
        [string appendString:last];
        _prototypeStr = string;
    }
    return _prototypeStr;
}

@end
