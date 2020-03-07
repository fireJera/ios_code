//
//  JJIvar.m
//  JJCodeCheck
//
//  Created by Jeremy on 2019/7/9.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import "JJIvar.h"

JJIvarType _getTypeFromEncoding(NSString *encoding) {
    const char t = [encoding characterAtIndex:0];
    switch (t) {
        case 'c':
            return JJIvarTypeChar;
            break;
        case 'i':
            return JJIvarTypeInt;
            break;
        case 's':
            return JJIvarTypeShort;
            break;
        case 'l':
            return JJIvarTypeLong;
            break;
        case 'q':
            return JJIvarTypeLonglong;
            break;
        case 'C':
            return JJIvarTypeUnsignedChar;
            break;
        case 'I':
            return JJIvarTypeUnsignedInt;
            break;
        case 'S':
            return JJIvarTypeUnsignedShort;
            break;
        case 'L':
            return JJIvarTypeUnsignedLong;
            break;
        case 'Q':
            return JJIvarTypeUnsignedLonglong;
            break;
        case 'f':
            return JJIvarTypeFloat;
            break;
        case 'd':
            return JJIvarTypeDouble;
            break;
        case 'B':
            return JJIvarTypeCbool;
            break;
        case 'v':
            return JJIvarTypeVoid;
            break;
        case '*':
            return JJIvarTypeCharPointer;
            break;
        case '@':
            return JJIvarTypeObject;
            break;
        case '#':
            return JJIvarTypeClass;
            break;
        case ':':
            return JJIvarTypeSelector;
            break;
        case '[':
            return JJIvarTypeArray;
            break;
        case '{':
            return JJIvarTypeCStructure;
            break;
        case '(':
            return JJIvarTypeUnion;
            break;
        case 'b':
            return JJIvarTypeBit;
            break;
        case '^':
            return JJIvarTypePointer;
            break;
        case '?':
            return JJIvarTypeUnknown;
            break;
    }
    return JJIvarTypeUnknown;
}

//NSString * _clsNameFromEncoding(NSString *encoding) {
//    JJIvarType type = _getTypeFromEncoding(encoding);
//    if (type == JJIvarTypeObject) {
//        return [encoding substringWithRange:NSMakeRange(1, encoding.length - 3)];
//    }
//    else if (type == JJIvarTypeClass) {
//        return @"class";
//    }
//    else if (type == JJIvarTypeArray) {
//        return @"";
//    }
//    else if (type == JJIvarTypeCStructure) {
//        return @"";
//    }
//    else if (type == JJIvarTypeUnion) {
//        return @"";
//    }
//    else if (type == JJIvarTypePointer) {
//        return @"";
//    }
//    return @"";
//}

NSString * _getTypeStringFromEncoding(NSString * encoding) {
    //    NSString * string = [encoding substringFromIndex:2];
//    const char t = [encoding characterAtIndex:0];
    JJIvarType ivarType = _getTypeFromEncoding(encoding);
    switch (ivarType) {
        case JJIvarTypeChar:
            return @"char";
            break;
        case JJIvarTypeInt:
            return @"int";
            break;
        case JJIvarTypeShort:
            return @"short";
            break;
        case JJIvarTypeLong:
            return @"long";
            break;
        case JJIvarTypeLonglong:
            return @"long long";
            break;
        case JJIvarTypeUnsignedChar:
            return @"unsigned char";
            break;
        case JJIvarTypeUnsignedInt:
            return @"unsigned int";
            break;
        case JJIvarTypeUnsignedShort:
            return @"unsigned short";
            break;
        case JJIvarTypeUnsignedLong:
            return @"unsigned long ";
            break;
        case JJIvarTypeUnsignedLonglong:
            return @"unsigned long long";
            break;
        case JJIvarTypeFloat:
            return @"float";
            break;
        case JJIvarTypeDouble:
            return @"double";
            break;
        case JJIvarTypeCbool:
            return @"bool";
            break;
        case JJIvarTypeVoid:
            return @"void";
            break;
        case JJIvarTypeCharPointer:
            return @"char *";
            break;
        case JJIvarTypeObject: {
            if (encoding.length > 1) {
                NSString * clsName;
                if (encoding.length > 3) {
                    clsName = [encoding substringWithRange:NSMakeRange(2, encoding.length - 3)];
                }
                else {
                    clsName = [encoding substringFromIndex:1];
                }
                return [NSString stringWithFormat:@"%@ *", clsName];
            }
            else {
                return @"id";
            }
        }
            break;
        case JJIvarTypeClass:
            return @"Class";
            break;
        case JJIvarTypeSelector:
            return @"SEL";
            break;
        case JJIvarTypeArray: {
            NSString * type = [encoding substringWithRange:NSMakeRange(1, encoding.length - 2)];
            return [NSString stringWithFormat:@"%@[]", type];
        }
            break;
        case JJIvarTypeCStructure: {
            NSString * string = [encoding substringWithRange:NSMakeRange(1, encoding.length - 2)];
            NSString * name = [string componentsSeparatedByString:@"="].firstObject;
            return name;
        }
            break;
        case JJIvarTypeUnion: {
            NSString * string = [encoding substringWithRange:NSMakeRange(1, encoding.length - 2)];
            NSString * name = [string componentsSeparatedByString:@"="].firstObject;
            return name;
        }
            break;
        case JJIvarTypeBit: {
            NSString * string = [encoding substringWithRange:NSMakeRange(1, encoding.length - 2)];
            return [NSString stringWithFormat:@"int a:%@", string];
        }
            break;
        case JJIvarTypePointer: {
            if (encoding.length > 1) {
                NSString * string = [encoding substringFromIndex:1];
                NSString * subString = _getTypeStringFromEncoding(string);
                return [NSString stringWithFormat:@"%@ *", subString];
            }
            else {
                return @"*";
            }
        }
            break;
        case JJIvarTypeUnknown:
            return @"void(*)(void)";
            break;
    }
    return nil;
}

@interface JJIvar ()

@property (nonatomic, copy, readwrite) NSString * prototype;

@end

@implementation JJIvar

- (instancetype)initWithIvar:(Ivar)ivar {
    self = [super init];
    if (!self) return nil;
    _ivar = ivar;
    
    const char * name = ivar_getName(ivar);
    const char * encoding = ivar_getTypeEncoding(ivar);
    ptrdiff_t offset = ivar_getOffset(ivar);
    NSUInteger size, align;
    NSGetSizeAndAlignment(encoding, &size, &align);
//    [layouts addObject:@(offset)];
//    [layouts addObject:@(size)];
//    NSInteger index = offset / vSize;
    //            [indexSet addIndexesInRange:NSMakeRange(offset, size)];
//    ivar.isWeak = ![_strongIndex containsIndex:index];
    _size = size;
    _align = align;
    _name = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
    self.encoding = [NSString stringWithCString:encoding encoding:NSUTF8StringEncoding];
    //            NSLog(@"ivar name : %@, encoding : %s", ivar.name, encoding);
    //            NSLog(@" %d ivar name : %@, offset : %td size: %ld  index :%d", i, ivar.name, offset, size, index);
    _offset = offset;
    return self;
}

//- (instancetype)init {
//    Ivar ivar;
//    return [self initWithIvar:ivar];
//}

- (void)setEncoding:(NSString *)encoding {
    _encoding = encoding;
    _ivarType = _getTypeFromEncoding(encoding);
    _typeName = _getTypeStringFromEncoding(encoding);
}

- (NSString *)prototype {
    if (!_prototype) {
        NSString * string;
        if (_ivarType == JJIvarTypeBit) {
            NSMutableString * temp = [_typeName mutableCopy];
            [temp replaceCharactersInRange:NSMakeRange(5, 1) withString:_name];
            string = [temp copy];
        }
        else if (_ivarType == JJIvarTypeUnknown) {
            NSMutableString * temp = [_typeName mutableCopy];
            [temp insertString:_name atIndex:7];
            string = [temp copy];
        }
        else {
            if (_isWeak && _ivarType == JJIvarTypeObject) {
                string = [NSString stringWithFormat:@"__weak %@ %@", _typeName, _name];
            }
            else {
                string = [NSString stringWithFormat:@"%@ %@", _typeName, _name];
            }
        }
        _prototype = string;
    }
    return _prototype;
}

@end
