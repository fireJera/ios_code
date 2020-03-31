//
//  NSAttributedString+WALME_Custom.h
//  CodeFrame
//
//  Created by Jeremy on 2019/4/20.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSAttributedString (WALME_Custom)

+ (nullable instancetype)attributedStringWithStringsAndAttriutes:(NSString *)firstString, ... NS_REQUIRES_NIL_TERMINATION;

+ (nullable instancetype)attributedStringWithStrings:(NSArray<NSString *> *)strings AndAttriutes:(NSArray<NSDictionary *> *)attributes;

@end

NS_ASSUME_NONNULL_END
