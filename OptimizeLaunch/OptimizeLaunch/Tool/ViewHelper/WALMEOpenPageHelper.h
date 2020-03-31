//
//  WALMEOpenPageHelper.h
//  CodeFrame
//
//  Created by Jeremy on 2019/5/10.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN


@interface WALMEOpenAlertAction : NSObject

@property (nonatomic, assign) UIAlertActionStyle actionStyle;
@property (nonatomic, copy) void(^actionHandler)(UIAlertAction * _Nonnull action);
//@property (nonatomic, copy) void(^block)(void);

- (WALMEOpenAlertAction *(^)(UIAlertActionStyle actionStyle))style;
- (WALMEOpenAlertAction *(^)(void))defaultStyle;
- (WALMEOpenAlertAction *(^)(void))cancelStyle;
- (WALMEOpenAlertAction *(^)(void))destructiveStyle;

- (UIAlertAction *)walme_actionWithTitle:(NSString *)title style:(UIAlertActionStyle)style handler:(void (^ _Nullable )(UIAlertAction * _Nonnull))handler;

@end

@interface WALMEOpenAlert : NSObject

- (WALMEOpenAlertAction *(^)(NSString * _Nullable actionTitle))title;
- (WALMEOpenAlertAction *(^)(void))sureTitle;
- (WALMEOpenAlertAction *(^)(void))canceltitle;

//- (void)show;

@end


@interface WALMEOpenPageHelper : NSObject

#pragma mark - open

+ (void)p_openViewController:(UIViewController *)viewController;
+ (void)p_openViewController:(UIViewController *)viewController animated:(BOOL)animated;

+ (void)p_presentViewController:(UIViewController *)viewController animated:(BOOL)animated;

+ (void)p_showView:(UIView *)popView animated:(BOOL)animated;

+ (void)walme_close;

#pragma mark - photobrowse
// photos nsarray<NSString *> nsarray<WALMEAlbum *>
+ (void)showPhotoBrowserView:(UIView *)fromView
                      toView:(nullable UIView *)toView
                    showEdit:(BOOL)showEdit
                  thumbViews:(NSArray<UIView *> *)thumbViews
                      photos:(NSArray *)photos;

#pragma mark - custom alert

+ (void)walme_showCustomAlertWithTitle:(nullable NSString *)title
                               message:(nullable NSString *)message
                            alertStyle:(UIAlertControllerStyle)alertStyle
                                 block:(void(^)(WALMEOpenAlert * alert))block;

+ (void)walme_showCustomAlertWithTitle:(nullable NSString *)title
                                 block:(void(^)(WALMEOpenAlert * alert))block;

+ (void)walme_showCustomActionSheetWithTitle:(nullable NSString *)title
                                       block:(void(^)(WALMEOpenAlert * alert))block;

+ (void)walme_openNetAlert;

#pragma mark - system alert

/**
 只有确定的alert 无点击效果 无 alert - message
 
 @param title title
 @param message alert message
 */
+ (void)showSystemSureAlert:(nullable NSString *)title message:(nullable NSString *)message;

/**
 只有确定的alert 有点击效果 无 alert - message
 
 @param title title
 @param handler 点击
 */
+ (void)showSystemSureAlert:(nullable NSString *)title handler:(nullable void(^)(void))handler;

/**
 只有确定的alert 无点击效果 有 alert - message no handleer
 
 @param title title
 @param message alert message
 @param button button title
 */
+ (void)showSystemSureAlert:(nullable NSString *)title message:(nullable NSString *)message button:(nullable NSString *)button;

/**
 一个按钮的alert
 
 @param title title
 @param buttonTitle button title
 @param handler button点击
 */
+ (void)showSystemOneActionAlert:(nullable NSString *)title buttonTitle:(nullable NSString *)buttonTitle handler:(nullable void(^)(void))handler;

/**
 左边默认关闭(无点击) 右边可自定义 不可设置alert message
 
 @param title title
 @param ackTitle ackTitle
 @param handler button 点击
 */
+ (void)showSystemAlertWithCancel:(nullable NSString *)title
                         ackTitle:(nullable NSString *)ackTitle
                       ackHandler:(nullable void(^)(void))handler;

/**
 左边默认关闭(无点击) 右边可自定义
 
 @param title title
 @param message alert message
 @param ackTitle ackTitle
 @param handler 点击
 */
+ (void)showSystemAlertWithCancel:(nullable NSString *)title
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
+ (void)showSystemAlert:(nullable NSString *)title
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
+ (void)showSystemAlert:(nullable NSString *)title
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
+ (void)showSystemAlert:(nullable NSString *)title
                message:(nullable NSString *)message
                buttons:(nullable NSArray<NSString *> *)buttons;
//               handlers:(nullable NSArray<WALMEVoidBlock> *)handlers;

+ (void)showSystemInputAlert:(nullable NSString *)title
                     message:(nullable NSString *)message
                 placeholder:(nullable NSString *)placeholder
                      button:(nullable NSString *)button
                    selector:(nullable SEL)method
                     handler:(nullable void(^)(NSString * _Nullable text))handler;

+ (void)showSystemInputAlert:(nullable NSString *)title
                     message:(nullable NSString *)message
                   fieldText:(nullable NSString *)text
                 placeholder:(nullable NSString *)placeholder
                      button:(nullable NSString *)button
                    selector:(SEL)method
                     handler:(nullable void(^)(NSString * text))handler;

+ (void)showSystemInputAlert:(nullable NSString *)title
                     message:(nullable NSString *)message
                   fieldText:(nullable NSString *)text
                 placeholder:(nullable NSString *)placeholder
                      button:(nullable NSString *)button
                    selector:(nullable SEL)method
                      target:(nullable id)target
                     handler:(nullable void(^)(NSString * _Nullable text))handler;

#pragma mark - system action sheet
+ (void)showSystemActionSheet:(nullable NSString *)title handler:(nullable void(^)(void))handler;

+ (void)showSystemActionSheet:(nullable NSArray<NSString *> *)titles
                      handler:(nullable void(^)(void))handler
                 otherhandler:(nullable void(^)(void))otherhandler;

+ (void)showSystemThreeActionSheet:(nullable NSArray<NSString *> *)titles
                           handler:(nullable void(^)(void))handler
                     secondhandler:(nullable void(^)(void))secondhandler
                      thirdhandler:(nullable void(^)(void))thirdhandler;

@end

NS_ASSUME_NONNULL_END
