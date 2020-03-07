//
//  JJLeakMessenger.h
//  MemoryLeak
//
//  Created by Jeremy on 2019/6/21.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JJLeakMessenger : NSObject

+ (void)alertWithTitle:(NSString *)title message:(NSString *)message;

+ (void)alertWithTitle:(NSString *)title
               message:(NSString *)message
              delegate:(nullable id<UIAlertViewDelegate>)delegate
  addtionalButtonTitle:(nullable NSString *)addtionalButtonTitle;

@end

NS_ASSUME_NONNULL_END
