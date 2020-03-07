//
//  JJMethod.m
//  JJCodeCheck
//
//  Created by Jeremy on 2019/7/9.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import "JJMethod.h"
#import "JJIvar.h"

@interface JJMethod ()

@property (nonatomic, copy, readwrite) NSString * prototype;

@end

@implementation JJMethod

- (instancetype)initWithMethod:(Method)method isMeta:(BOOL)isMeta {
    if (self = [super init]) {
        _method = method;
        _isMeta = isMeta;
        SEL sel = method_getName(method);
        const char * name = sel_getName(sel);
        NSString * mName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
        char * returnType = method_copyReturnType(method);
        unsigned int argumentCount = method_getNumberOfArguments(method);
        NSMutableArray * array = [NSMutableArray array];
        NSMutableArray * sizes = [NSMutableArray array];
        for (unsigned int j = 0; j < argumentCount; j++) {
            char * argumentType = method_copyArgumentType(method, j);
            NSUInteger size, align;
            NSGetSizeAndAlignment(argumentType, &size, &align);
            [sizes addObject:@(size)];
            //                method_getArgumentType(method, j, &argumentType, 512);
            NSString * argumentTString = [NSString stringWithCString:argumentType encoding:NSUTF8StringEncoding];
            [array addObject:argumentTString];
        }
        const char * typeEncoding = method_getTypeEncoding(method);
        NSScanner * scanner = [NSScanner scannerWithString:[NSString stringWithCString:typeEncoding encoding:NSUTF8StringEncoding]];
        NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"1234567890"];
        NSString*lengthStr;
        [scanner scanUpToCharactersFromSet:numbers intoString:NULL];
        [scanner scanCharactersFromSet:numbers intoString:&lengthStr];
        int length = [lengthStr intValue];
        NSMutableArray * layouts = [NSMutableArray array];
        int index = 0;
        while (![scanner isAtEnd]) {
            NSString * offsetStr;
            [scanner scanUpToCharactersFromSet:numbers intoString:NULL];
            [scanner scanCharactersFromSet:numbers intoString:&offsetStr];
            int offset = [offsetStr intValue];
            [layouts addObject:@(offset)];
            [layouts addObject:sizes[index]];
            index++;
        }
        _layoutLength = (NSUInteger)length;
        _layoutIndexes = [layouts copy];
        //            NSLog(@"%s", (*md).types);
        //        struct objc_method_description * md = method_getDescription(method);
        //            @"v16@0:8"
        _returnType = [NSString stringWithCString:returnType encoding:NSUTF8StringEncoding];
        _arguments = array;
        _method = method;
        _name = mName;
        self.typeEncoding = typeEncoding;
//        NSLog(@"name : %s, return : %@, desc : %s argument: %@", name, _returnType, typeEncoding, array);
    }
    return self;
}

- (instancetype)initWithMethod:(Method)method {
    return [self initWithMethod:method isMeta:NO];
}

- (instancetype)initWithMethodDesc:(struct objc_method_description)methodDesc {
    return [self initWithMethodDesc:methodDesc isClass:NO];
}

- (instancetype)initWithMethodDesc:(struct objc_method_description)methodDesc isClass:(BOOL)isClass {
    if (self = [super init]) {
        _methodDesc = methodDesc;
        _isMeta = isClass;
//        struct method_t mt;
//        mt.name = methodDesc.name;
//        mt.types = methodDesc.types;
//        mt.imp =
        
        _typeEncoding = methodDesc.types;
        const char * name = sel_getName(methodDesc.name);
        NSString * mName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
        
        NSMutableArray * array = [NSMutableArray array];
        NSMutableArray * sizes = [NSMutableArray array];
        
        NSScanner * scanner = [NSScanner scannerWithString:[NSString stringWithCString:_typeEncoding encoding:NSUTF8StringEncoding]];
        NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"1234567890"];
        NSString * lengthStr;
        NSString * typeString;
        [scanner scanUpToCharactersFromSet:numbers intoString:&typeString];
        [scanner scanCharactersFromSet:numbers intoString:&lengthStr];
        int length = [lengthStr intValue];
        
        const char * argumentType = typeString.UTF8String;
        
        NSUInteger size, align;
        NSGetSizeAndAlignment(argumentType, &size, &align);
        [sizes addObject:@(size)];
        //                method_getArgumentType(method, j, &argumentType, 512);
        NSString * argumentTString = [NSString stringWithCString:argumentType encoding:NSUTF8StringEncoding];
        [array addObject:argumentTString];
        
        NSMutableArray * layouts = [NSMutableArray array];
        int index = 0;
        while (![scanner isAtEnd]) {
            NSString * offsetStr;
            [scanner scanUpToCharactersFromSet:numbers intoString:&typeString];
            [scanner scanCharactersFromSet:numbers intoString:&offsetStr];
            const char * argumentType = typeString.UTF8String;
            NSUInteger size, align;
            NSGetSizeAndAlignment(argumentType, &size, &align);
            [sizes addObject:@(size)];
            
            int offset = [offsetStr intValue];
            [layouts addObject:@(offset)];
            [layouts addObject:sizes[index]];
            index++;
        }
        _layoutLength = (NSUInteger)length;
        _layoutIndexes = [layouts copy];
        //            NSLog(@"%s", (*md).types);
        //        struct objc_method_description * md = method_getDescription(method);
        //            @"v16@0:8"
        _returnType = _getTypeStringFromEncoding([NSString stringWithCString:argumentType encoding:NSUTF8StringEncoding]);
        _arguments = array;
        //        _method = method;
        _name = mName;
    }
    return self;
}


//- (instancetype)init {
//    return [self initWithMethod:nil];
//}

- (NSString *)prototype {
    if (!_prototype) {
        NSMutableString * str;
        if (_isMeta) {
            str = [@"+" mutableCopy];
        }
        else {
            str = [@"-" mutableCopy];
        }
        NSString * returnStr = _getTypeStringFromEncoding(_returnType);
        [str appendFormat:@" (%@)%@", returnStr, _name];
        
        for (int i = 2; i < _arguments.count; i++) {
            NSString * argu = _arguments[i];
            NSString * argType = _getTypeStringFromEncoding(argu);
            [str appendFormat:@"(%@)arg%d ", argType, i - 2];
        }
        [str appendString:@";"];
        _prototype = [str copy];
    }
    return _prototype;
}

@end

