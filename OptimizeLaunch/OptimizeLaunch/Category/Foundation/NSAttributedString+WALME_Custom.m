//
//  NSAttributedString+WALME_Custom.m
//  CodeFrame
//
//  Created by Jeremy on 2019/4/20.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import "NSAttributedString+WALME_Custom.h"

@implementation NSAttributedString (WALME_Custom)

+ (instancetype)attributedStringWithStringsAndAttriutes:(NSString *)firstString, ... {
    va_list args;
    NSMutableArray * strings = [NSMutableArray array];
    NSMutableArray * attributes = [NSMutableArray array];
    va_start(args, firstString);
//    id firstStr = va_arg(args, id);
    if ([firstString isKindOfClass:[NSString class]]) {
        [strings addObject:firstString];
    } else if ([firstString isKindOfClass:[NSDictionary class]]) {
        [attributes addObject:firstString];
    }
    id firstStr;
    while ((firstStr = va_arg(args, id)) != nil) {
        if ([firstStr isKindOfClass:[NSString class]]) {
            [strings addObject:firstStr];
        } else if ([firstStr isKindOfClass:[NSDictionary class]]) {
            [attributes addObject:firstStr];
        }
    }
    
    va_end(args);
    
    return [self attributedStringWithStrings:strings AndAttriutes:attributes];
}

+ (instancetype)attributedStringWithStrings:(NSArray<NSString *> *)strings AndAttriutes:(nonnull NSArray<NSDictionary *> *)attributes {
    NSMutableAttributedString * result;
    if (strings.count > 0 && attributes.count > 0) {
        NSAttributedString * attributeString = [[NSAttributedString alloc] initWithString:strings.firstObject attributes: attributes.firstObject];
        result = [[NSMutableAttributedString alloc] initWithAttributedString:attributeString];
        for (int i = 1; i < strings.count; i++) {
            NSDictionary * dic;
            if (i < attributes.count) {
                dic = attributes[i];
            } else {
                dic = attributes.firstObject;
            }
            attributeString = [[NSAttributedString alloc] initWithString:strings[i] attributes:dic];
            [result appendAttributedString:attributeString];
        }
        return result;
    }
    return [[NSAttributedString alloc] initWithString:@""];
}

@end
