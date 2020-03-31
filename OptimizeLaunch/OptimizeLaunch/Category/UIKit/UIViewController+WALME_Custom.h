//
//  UIViewController+WALME_Custom.h
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CodeFrameDefineCode.h"

NS_ASSUME_NONNULL_BEGIN

@class WALMEBlankView;
@protocol WALMEViewControllerInfoDataSource;

@interface UIViewController (WALME_Custom)

@property (nonatomic, assign) CGFloat navBarBgAlpha;
@property (nonatomic, strong) UIColor * navBarTintColor;
@property (nonatomic, strong) UIColor * navBarTitleColor;

@property (nonatomic, strong) WALMEBlankView * blankView;

- (instancetype)initFromNib;
- (instancetype)initWithDataSource:(id<WALMEViewControllerInfoDataSource>)dataSource;

- (void)walme_setNavView;
- (void)walme_close;

@end

@class MBProgressHUD;

extern NSString * _Nonnull const WALMEAlertCancelTitle;
extern NSString * _Nonnull const WALMEAlertSureTitle;

@interface UIViewController (WALME_Alert)

#pragma mark - alert

/**
 只有确定的alert 无点击效果 无 alert - message
 
 @param title title
 @param message alert message
 */
- (void)showSureActionAlert:(nullable NSString *)title message:(nullable NSString *)message;

/**
 只有确定的alert 有点击效果 无 alert - message
 
 @param title title
 @param handler 点击
 */
- (void)showSureActionAlert:(nullable NSString *)title handler:(nullable void(^)(void))handler;

/**
 只有确定的alert 无点击效果 有 alert - message no handleer
 
 @param title title
 @param message alert message
 @param button button title
 */
- (void)showSureActionAlert:(nullable NSString *)title message:(nullable NSString *)message button:(nullable NSString *)button;

/**
 一个按钮的alert
 
 @param title title
 @param buttonTitle button title
 @param handler button点击
 */
- (void)showOneActionAlert:(nullable NSString *)title buttonTitle:(nullable NSString *)buttonTitle handler:(nullable void(^)(void))handler;

/**
 左边默认关闭(无点击) 右边可自定义 不可设置alert message
 
 @param title title
 @param ackTitle ackTitle
 @param handler button 点击
 */
- (void)showAlertWithCancel:(nullable NSString *)title
                   ackTitle:(nullable NSString *)ackTitle
                 ackHandler:(nullable void(^)(void))handler;

/**
 左边默认关闭(无点击) 右边可自定义
 
 @param title title
 @param message alert message
 @param ackTitle ackTitle
 @param handler 点击
 */
- (void)showAlertWithCancel:(nullable NSString *)title
                    message:(nullable NSString *)message
                   ackTitle:(nullable NSString *)ackTitle
                 ackHandler:(nullable void(^)(void))handler;


/**
 只能设置两个button 无alert message
 
 @param title title
 @param buttons NSArray<NSString *>*
 @param handler 第一个点击
 @param otherhandler 第二个点击
 */
- (void)showAlert:(nullable NSString *)title
          buttons:(nullable NSArray<NSString *> *)buttons
          handler:(nullable void(^)(void))handler
     otherhandler:(nullable void(^)(void))otherhandler;

/**
 只能设置两个button
 
 @param title title
 @param message alert message
 @param buttons NSArray<NSString *>*
 @param handler 第一个点击
 @param otherhandler 第二个点击
 */
- (void)showAlert:(nullable NSString *)title
          message:(nullable NSString *)message
          buttons:(nullable NSArray<NSString *> *)buttons
          handler:(nullable void(^)(void))handler
     otherhandler:(nullable void(^)(void))otherhandler;


/**
 多按钮alert
 
 @param title title
 @param message message
 @param buttons NSArray
 @param handlers NSArray<block>
 */
- (void)showAlert:(nullable NSString *)title
          message:(nullable NSString *)message
          buttons:(nullable NSArray<NSString *> *)buttons
         handlers:(nullable NSArray<WALMEVoidBlock> *)handlers;

- (void)showInputAlert:(nullable NSString *)title
               message:(nullable NSString *)message
           placeholder:(nullable NSString *)placeholder
                button:(nullable NSString *)button
              selector:(nullable SEL)method
               handler:(nullable void(^)(NSString * _Nullable text))handler;

- (void)showInputAlert:(nullable NSString *)title
               message:(nullable NSString *)message
             fieldText:(nullable NSString *)text
           placeholder:(nullable NSString *)placeholder
                button:(nullable NSString *)button
              selector:(SEL)method
               handler:(nullable void(^)(NSString * text))handler;

- (void)showInputAlert:(nullable NSString *)title
               message:(nullable NSString *)message
             fieldText:(nullable NSString *)text
           placeholder:(nullable NSString *)placeholder
                button:(nullable NSString *)button
              selector:(nullable SEL)method
                target:(nullable id)target
               handler:(nullable void(^)(NSString * _Nullable text))handler;

#pragma mark - actionsheet
- (void)showActionSheet:(nullable NSString *)title handler:(nullable void(^)(void))handler;

- (void)showActionSheet:(nullable NSArray<NSString *> *)titles
                handler:(nullable void(^)(void))handler
           otherhandler:(nullable void(^)(void))otherhandler;

- (void)showThreeActionSheet:(nullable NSArray<NSString *> *)titles
                     handler:(nullable void(^)(void))handler
               secondhandler:(nullable void(^)(void))secondhandler
                thirdhandler:(nullable void(^)(void))thirdhandler;
@end

@interface UIViewController (WALME_ScreenShot)

- (nonnull UIImage *)screenShot;

@end

@interface UIViewController (WALME_UploadProgress)

- (void)hideNavShadowLine;

@end

@interface UIViewController (WALME_nav)

@property (nonatomic, strong, readonly) UIViewController * lastViewControllerInNav;
@property (nonatomic, strong, readonly) UIViewController * rootViewControllerInNav;

@end
NS_ASSUME_NONNULL_END

