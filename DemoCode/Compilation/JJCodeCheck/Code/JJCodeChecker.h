//
//  JJCodeChecker.h
//  JJCodeCheck
//
//  Created by Jeremy on 2019/7/8.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXTERN const int kJJMenuBtnTag;

@interface JJCodeChecker : NSObject

@property(class, nonatomic) BOOL showMenuBtn;

@property(class, nonatomic, readonly) NSArray<NSString *> *images;

+ (void)addSomeImageClassName:(NSString *)clsName;

+ (void)check;

@end

NS_ASSUME_NONNULL_END
