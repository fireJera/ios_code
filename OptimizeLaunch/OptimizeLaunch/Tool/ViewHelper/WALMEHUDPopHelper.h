//
//  WALMEHUDPopHelper.h
//  CodeFrame
//
//  Created by Jeremy on 2019/5/6.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class MBProgressHUD;

@interface WALMEHUDPopHelper : NSObject

+ (void)showTextHUD:(NSString *)text;

+ (void)showTextHUD:(NSString *)text delaySecond:(NSInteger)second;

+ (MBProgressHUD *)customProgressHUDTitle:(nullable NSString *)title;


+ (void)showHelloViewWithStrings:(NSArray<NSString *> *)strings;


@end

NS_ASSUME_NONNULL_END
