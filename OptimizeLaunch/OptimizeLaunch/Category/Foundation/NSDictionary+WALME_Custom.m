//
//  NSDictionary+WALME_Custom.m
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import "NSDictionary+WALME_Custom.h"

@implementation NSDictionary (WALME_Custom)

- (NSString *)convertToJSONStr {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    NSString *jsonString = @"";
    
    if (jsonData)
    {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    return jsonString;
}

@end
