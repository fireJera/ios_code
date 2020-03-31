//
//  WALMEOpenPageHelper.m
//  CodeFrame
//
//  Created by Jeremy on 2019/5/10.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import "WALMEOpenPageHelper.h"
#import "UIViewController+WALME_Custom.h"
#import "UIColor+WALME_Hex.h"
#import "WALMEControllerFinder.h"
#import "WALMENetCallback.h"
#import "NSArray+WALME_Custom.h"
#import "WALMEAlbum.h"

@interface WALMEOpenAlertAction ()

@property (nonatomic, copy) NSString * title;
@property (nonatomic, strong) UIAlertAction * action;

@end

@implementation WALMEOpenAlertAction

- (WALMEOpenAlertAction * _Nonnull (^)(UIAlertActionStyle))style {
    return ^(UIAlertActionStyle style) {
        _actionStyle = style;
        return self;
    };
}

- (WALMEOpenAlertAction * _Nonnull (^)(void))cancelStyle {
    return ^(void) {
        _actionStyle = UIAlertActionStyleCancel;
        return self;
    };
}

- (WALMEOpenAlertAction * _Nonnull (^)(void))destructiveStyle {
    return ^(void) {
        _actionStyle = UIAlertActionStyleDestructive;
        return self;
    };
}

- (WALMEOpenAlertAction * _Nonnull (^)(void))defaultStyle {
    return ^(void) {
        _actionStyle = UIAlertActionStyleDefault;
        return self;
    };
}

- (void)setActionHandler:(void (^)(UIAlertAction * _Nonnull))actionHandler {
    _action = [self walme_actionWithTitle:_title style:_actionStyle handler:actionHandler];
}

- (UIAlertAction *)action {
    if (!_action) {
        _action = [self walme_actionWithTitle:_title style:_actionStyle handler:nil];
    }
    return _action;
}

- (UIAlertAction *)walme_actionWithTitle:(NSString *)title style:(UIAlertActionStyle)style handler:(void (^)(UIAlertAction * _Nonnull))handler {
    if (!IsStringWithAnyText(title)) {
        title = style == UIAlertActionStyleCancel ? WALMEAlertCancelTitle : WALMEAlertSureTitle;
    }
    UIAlertAction *action = [UIAlertAction actionWithTitle:title style:style handler:handler];
    
    /* titleTextColor是iOS8.3之后才有的属性  */
//    if (WALMEIOSFLoatSystemVersion >= 8.3) {
//        if (style == UIAlertActionStyleDestructive) {
//            // 蓝色 - 1
//            [action setValue:[UIColor walme_colorWithRGB:0x8358d0] forKey:@"titleTextColor"];
//        }
//        else if(style == UIAlertActionStyleDefault) {
//            // 黑色 - 0
//            [action setValue:[UIColor walme_colorWithRGB:0x8358d0] forKey:@"titleTextColor"];
//        }
//        else if(style == UIAlertActionStyleCancel){
//            // 灰色 - 2
//            [action setValue:[UIColor walme_colorWithRGB:0xb1b1b1] forKey:@"titleTextColor"];
//        }
//    }
    return action;
}

@end

@interface WALMEOpenAlert ()

@property (nonatomic, strong) NSMutableArray<WALMEOpenAlertAction *> *actions;

@end

@implementation WALMEOpenAlert

- (WALMEOpenAlertAction * _Nonnull (^)(NSString * _Nullable))title {
    return ^(NSString * title) {
        WALMEOpenAlertAction * action = [[WALMEOpenAlertAction alloc] init];
        action.title = title;
        [_actions addObject:action];
        return action;
    };
}

- (WALMEOpenAlertAction * _Nonnull (^)(void))sureTitle {
    return ^() {
        WALMEOpenAlertAction * action = [[WALMEOpenAlertAction alloc] init];
        action.title = WALMEAlertSureTitle;
        [_actions addObject:action];
        return action;
    };
}

- (WALMEOpenAlertAction * _Nonnull (^)(void))canceltitle {
    return ^() {
        WALMEOpenAlertAction * action = [[WALMEOpenAlertAction alloc] init];
        action.title = WALMEAlertCancelTitle;
        [_actions addObject:action];
        return action;
    };
}

- (void)show:(UIAlertController *)alert {
    for (WALMEOpenAlertAction * action in _actions) {
        [alert addAction:action.action];
    }
    [WALMEOpenPageHelper p_presentViewController:alert animated:YES];
}

////适配iPad Sheet
//- (void)adaptivePadAlertControllerWithController:(UIViewController *)alertController {
//    self.modalPresentationStyle = UIModalPresentationPopover;
//    self.modalTransitionStyle   = UIModalTransitionStyleFlipHorizontal;
//    self.preferredContentSize = CGSizeMake(300, 150);
//    if(!_sendView) {
//        self.popoverPresentationController.sourceView = WALMEINSTANCE_KEYWINDOW;
//        self.popoverPresentationController.sourceRect = CGRectMake(0 / 2, 0 / 2, 0, 0);
//        self.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
//    } else {
//        self.popoverPresentationController.sourceView = _sendView;
//        self.popoverPresentationController.sourceRect = _sendView.bounds;
//        self.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
//    }
//    [alertController presentViewController:self animated:YES completion:nil];
//}

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    _actions = [NSMutableArray array];
    return self;
}

@end

static dispatch_semaphore_t kOpenLock = NULL;
#define Lock() dispatch_semaphore_wait(kOpenLock, DISPATCH_TIME_FOREVER);
#define UnLock() dispatch_semaphore_signal(kOpenLock);

@implementation WALMEOpenPageHelper

+ (void)initialize {
    if (self == [WALMEOpenPageHelper class]) {
        kOpenLock = dispatch_semaphore_create(1);
        WALMENetCallback.openCls = [self class];
    }
}

+ (void)p_openViewController:(UIViewController *)viewController {
    [self p_openViewController:viewController animated:YES];
}

+ (void)p_openViewController:(UIViewController *)viewController animated:(BOOL)animated {
    viewController.modalPresentationStyle = UIModalPresentationFullScreen;
    dispatch_async(dispatch_get_main_queue(), ^{
        Lock()
        UIViewController * topVC = [WALMEControllerFinder topViewController];
        if (topVC.navigationController) {
            [topVC.navigationController pushViewController:viewController animated:animated];
        } else {
            [topVC presentViewController:viewController animated:animated completion:nil];
        }
        UnLock()
    });
}

+ (void)p_presentViewController:(UIViewController *)viewController animated:(BOOL)animated {
    viewController.modalPresentationStyle = UIModalPresentationFullScreen;
    dispatch_async(dispatch_get_main_queue(), ^{
        Lock()
        UIViewController * topVC = [WALMEControllerFinder topViewController];
        if (topVC) {
            [topVC presentViewController:viewController animated:animated completion:nil];
        }
        UnLock()
    });
}

+ (void)p_showView:(UIView *)popView animated:(BOOL)animated {
    dispatch_async(dispatch_get_main_queue(), ^{
        Lock()
        UIViewController * topVC = [WALMEControllerFinder rootControlerInWindow];
        if (topVC) {
            [topVC.view addSubview:popView];
            [topVC.view bringSubviewToFront:popView];
        }
        UnLock()
    });
}


+ (void)walme_close {
    dispatch_async(dispatch_get_main_queue(), ^{
        Lock()
        UIViewController * topVC = [WALMEControllerFinder topViewController];
        if (topVC.navigationController && topVC.navigationController.viewControllers.count > 1) {
            [topVC.navigationController popViewControllerAnimated:YES];
        } else if (topVC.presentingViewController) {
            [topVC dismissViewControllerAnimated:YES completion:nil];
        }
        UnLock()
    });
}

#pragma mark - photo browser

+ (void)showPhotoBrowserView:(UIView *)fromView toView:(UIView *)toView showEdit:(BOOL)showEdit thumbViews:(NSArray<UIView *> *)thumbViews photos:(nonnull NSArray *)photos {
//    if (!IsArrayWithItems(thumbViews)) return;
    
    NSMutableArray *items = [NSMutableArray array];
//    [thumbViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        YYPhotoGroupItem *item = [YYPhotoGroupItem new];
//        item.thumbView = obj;
//        id photo = [photos objectOrNilAtIndex:idx];
//        NSString * path;
//        if ([photo isKindOfClass:[NSString class]]) {
//            path = (NSString *)photo;
//        }
//        else if ([photo isKindOfClass:[WALMEAlbum class]]) {
//            path = ((WALMEAlbum *)photo).link;
////            item.isBtnBg = ((WALMEAlbum *)photo).isVideo;
//            item.album = (WALMEAlbum *)photo;
//        }
//        item.largeImageURL = path ? [NSURL URLWithString:path] : nil;
//        [items addObject:item];
//    }];
//    
//    YYPhotoBrowseView *groupView = [[YYPhotoBrowseView alloc]initWithGroupItems:items];
//    groupView.delegate = (id<YYPhotoBrowseFuncDelegate>)[WALMEControllerFinder topViewController];
//    groupView.showEdit = showEdit;
//    groupView.blurEffectBackground = NO;
//    if (!toView) {
//        toView = [WALMEControllerFinder rootControlerInWindow].view;
//    }
//    [groupView walme_presentFromImageView:fromView toContainer:toView animated:YES completion:nil];
}

#pragma mark - alert

+ (void)walme_showCustomAlertWithTitle:(nullable NSString *)title
                               message:(nullable NSString *)message
                            alertStyle:(UIAlertControllerStyle)alertStyle
                                 block:(void (^)(WALMEOpenAlert * _Nonnull))block {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:alertStyle];
    WALMEOpenAlert * alert = [WALMEOpenAlert new];
    if (block) {
        block(alert);
    }
    [alert show:alertController];
}

+ (void)walme_showCustomAlertWithTitle:(NSString *)title
                                 block:(void(^)(WALMEOpenAlert * alert))block {
    [self walme_showCustomAlertWithTitle:title message:nil alertStyle:UIAlertControllerStyleAlert block:block];
}

+ (void)walme_showCustomActionSheetWithTitle:(NSString *)title
                                       block:(void(^)(WALMEOpenAlert * alert))block {
    [self walme_showCustomAlertWithTitle:title message:nil alertStyle:UIAlertControllerStyleActionSheet block:block];
}

+ (void)walme_openNetAlert {
    [self showSystemAlertWithCancel:@"当前无网络请求权限，是否去设置中打开？" ackTitle:WALMEAlertSureTitle ackHandler:^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }];
}

#pragma mark - system Alert

+ (void)showSystemSureAlert:(nullable NSString *)title message:(nullable NSString *)message {
    [self showSystemAlert:title buttons:@[WALMEAlertSureTitle] handler:nil otherhandler:nil];
}

+ (void)showSystemSureAlert:(nullable NSString *)title handler:(nullable void(^)(void))handler {
    [self showSystemAlert:title message:nil buttons:@[WALMEAlertSureTitle] handler:handler otherhandler:nil];
}

+ (void)showSystemSureAlert:(nullable NSString *)title message:(nullable NSString *)message button:(nullable NSString *)button {
    [self showSystemAlert:title message:nil buttons:button ? @[button] : @[WALMEAlertSureTitle] handler:nil otherhandler:nil];
}

+ (void)showSystemOneActionAlert:(nullable NSString *)title buttonTitle:(nullable NSString *)buttonTitle handler:(nullable void(^)(void))handler {
    [self showSystemAlert:title message:nil buttons:buttonTitle ? @[buttonTitle] : @[WALMEAlertSureTitle] handler:nil otherhandler:nil];
}

+ (void)showSystemAlertWithCancel:(nullable NSString *)title
                         ackTitle:(nullable NSString *)ackTitle
                       ackHandler:(nullable void(^)(void))handler {
    [self showSystemAlert:title message:nil buttons:ackTitle ? @[WALMEAlertCancelTitle, ackTitle] : @[WALMEAlertCancelTitle, WALMEAlertSureTitle] handler:nil otherhandler:handler];
}

+ (void)showSystemAlertWithCancel:(nullable NSString *)title
                          message:(nullable NSString *)message
                         ackTitle:(nullable NSString *)ackTitle
                       ackHandler:(nullable void(^)(void))handler {
    [self showSystemAlert:title message:message buttons:ackTitle ? @[WALMEAlertCancelTitle, ackTitle] : @[WALMEAlertCancelTitle, WALMEAlertSureTitle] handler:nil otherhandler:handler];
}

+ (void)showSystemAlert:(nullable NSString *)title
                buttons:(nullable NSArray<NSString *> *)buttons
                handler:(nullable void(^)(void))handler
           otherhandler:(nullable void(^)(void))otherhandler {
    [self showSystemAlert:title message:nil buttons:buttons handler:handler otherhandler:otherhandler];
}

+ (void)showSystemAlert:(nullable NSString *)title
                message:(nullable NSString *)message
                buttons:(nullable NSArray<NSString *> *)buttons
                handler:(nullable void(^)(void))handler
           otherhandler:(nullable void(^)(void))otherhandler {
    if (!buttons || buttons.count == 0) return;
    UIAlertController * _Nonnull alert =  [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:buttons.firstObject style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (handler) {
            handler();
        }
    }]];
    if (buttons.count > 1) {
        [alert addAction:[UIAlertAction actionWithTitle:buttons[1] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (otherhandler) {
                otherhandler();
            }
        }]];
    }
    //    if (WALME_IS_IPAD) {
    //        UIPopoverPresentationController * popPresenter = [alert popoverPresentationController];
    //        popPresenter.sourceView = WALMEINSTANCE_KEYWINDOW;
    //        popPresenter.sourceRect = CGRectMake(0 / 2, 0 / 2, 0, 0);
    //        popPresenter.permittedArrowDirections = UIPopoverArrowDirectionUp;
    //        [self presentViewController:alert animated:YES completion:nil];
    //    } else {
    [self p_presentViewController:alert animated:YES];
    //}
}

+ (void)showSystemAlert:(nullable NSString *)title
                message:(nullable NSString *)message
                buttons:(nullable NSArray<NSString *> *)buttons {
//               handlers:(nullable NSArray<WALMEVoidBlock> *)handlers {
    if (buttons.count == 0 || !buttons) return;
    UIAlertController * _Nonnull alert =  [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [buttons enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [alert addAction:[UIAlertAction actionWithTitle:obj style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            WALMEVoidBlock handler = handlers[idx];
//            if (handler) {
//                handler();
//            }
        }]];
    }];
    
    //    if (WALME_IS_IPAD) {
    //        UIPopoverPresentationController * popPresenter = [alert popoverPresentationController];
    //        popPresenter.sourceView = WALMEINSTANCE_KEYWINDOW;
    //        popPresenter.sourceRect = CGRectMake(0 / 2, 0 / 2, 0, 0);
    //        popPresenter.permittedArrowDirections = UIPopoverArrowDirectionUp;
    //        [self presentViewController:alert animated:YES completion:nil];
    //    } else {
    [self p_presentViewController:alert animated:YES];
    //    }
}


+ (void)showSystemInputAlert:(nullable NSString *)title
                     message:(nullable NSString *)message
                 placeholder:(nullable NSString *)placeholder
                      button:(nullable NSString *)button
                    selector:(nullable SEL)method
                     handler:(nullable void(^)(NSString * _Nullable text))handler {
    [self showSystemInputAlert:title
                       message:message
                     fieldText:nil
                   placeholder:placeholder
                        button:button
                      selector:method
                        target:self
                       handler:handler];
}


+ (void)showSystemInputAlert:(nullable NSString *)title
                     message:(nullable NSString *)message
                   fieldText:(nullable NSString *)text
                 placeholder:(nullable NSString *)placeholder
                      button:(nullable NSString *)button
                    selector:(SEL)method
                     handler:(nullable void(^)(NSString * text))handler {
    [self showSystemInputAlert:title
                       message:message
                     fieldText:text
                   placeholder:placeholder
                        button:button
                      selector:method
                        target:self
                       handler:handler];
}


+ (void)showSystemInputAlert:(nullable NSString *)title
                     message:(nullable NSString *)message
                   fieldText:(nullable NSString *)text
                 placeholder:(nullable NSString *)placeholder
                      button:(nullable NSString *)button
                    selector:(nullable SEL)method
                      target:(nullable id)target
                     handler:(nullable void(^)(NSString * _Nullable text))handler {
    UIAlertController * _Nonnull alert =  [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField){
        NSLayoutConstraint*  heightConstraint = [NSLayoutConstraint constraintWithItem:textField attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant: 24];
        [textField addConstraint:heightConstraint];
        textField.placeholder = placeholder;
        if (text) {
            textField.text = text;
        }
        if (target && method) {
            [[NSNotificationCenter defaultCenter] addObserver:target selector:method name:UITextFieldTextDidChangeNotification object:textField];
        }
    }];
    
    [alert addAction:[UIAlertAction actionWithTitle:WALMEAlertCancelTitle style:UIAlertActionStyleDefault handler:nil]];
    
    if (button) {
        [alert addAction:[UIAlertAction actionWithTitle:button style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField *textfield = alert.textFields.firstObject;
            if (handler) {
                handler(textfield.text);
            }
        }]];
    }
    [self p_presentViewController:alert animated:YES];
}


#pragma mark - actionsheet
+ (void)showSystemActionSheet:(nullable NSString *)title handler:(nullable void(^)(void))handler {
    if (title) [self showSystemActionSheet:@[title] handler:handler otherhandler:nil];
}


+ (void)showSystemActionSheet:(nullable NSArray<NSString *> *)titles
                      handler:(nullable void(^)(void))handler
                 otherhandler:(nullable void(^)(void))otherhandler {
    UIAlertController * alert =  [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    if (!titles || titles.count == 0) return;
    [alert addAction:[UIAlertAction actionWithTitle:titles.firstObject style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (handler) {
            handler();
        }
    }]];
    if (titles.count > 1) {
        [alert addAction:[UIAlertAction actionWithTitle:titles[1] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (otherhandler) {
                otherhandler();
            }
        }]];
    }
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    //    if (WALME_IS_IPAD) {
    //        UIPopoverPresentationController * popPresenter = [alert popoverPresentationController];
    //        popPresenter.sourceView = WALMEINSTANCE_KEYWINDOW;
    //        popPresenter.sourceRect = CGRectMake(0 / 2, 0 / 2, 0, 0);
    //        popPresenter.permittedArrowDirections = UIPopoverArrowDirectionUp;
    //        [self presentViewController:alert animated:YES completion:nil];
    //    } else {
    [self p_presentViewController:alert animated:YES];
    //    }
}

+ (void)showSystemThreeActionSheet:(nullable NSArray<NSString *> *)titles
                           handler:(nullable void(^)(void))handler
                     secondhandler:(nullable void(^)(void))secondhandler
                      thirdhandler:(nullable void(^)(void))thirdhandler {
    UIAlertController * alert =  [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    if (!titles || titles.count == 0) return;
    [alert addAction:[UIAlertAction actionWithTitle:titles.firstObject style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (handler) {
            handler();
        }
    }]];
    if (titles.count > 1) {
        [alert addAction:[UIAlertAction actionWithTitle:titles[1] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (secondhandler) {
                secondhandler();
            }
        }]];
    }
    
    if (titles.count > 2) {
        [alert addAction:[UIAlertAction actionWithTitle:titles[2] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (thirdhandler) {
                thirdhandler();
            }
        }]];
    }
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    //    if (WALME_IS_IPAD) {
    //        UIPopoverPresentationController * popPresenter = [alert popoverPresentationController];
    //        popPresenter.sourceView = WALMEINSTANCE_KEYWINDOW;
    //        popPresenter.sourceRect = CGRectMake(0 / 2, 0 / 2, 0, 0);
    //        popPresenter.permittedArrowDirections = UIPopoverArrowDirectionUp;
    //        [self presentViewController:alert animated:YES completion:nil];
    //    } else {
    [self p_presentViewController:alert animated:YES];
    //    }
}

@end
