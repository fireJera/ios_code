//
//  WALMENetCallback.m
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import "WALMENetCallback.h"
#import "WALMEControllerHeader.h"
#import "WALMEViewmodelHeader.h"
//#import "AppDelegate.h"
#import "WALMECameraViewmodel.h"
#import "WALMECameraViewController.h"
#import "WALMEAlbumListViewController.h"
#import "WALMEAlbumListViewmodel.h"
#import "WALMEUploadExampleView.h"
#import "WALMEHUDPopHelper.h"
#import "WALMEOpenPageHelper.h"
#import "WALMEControllerFinder.h"
#import "WALMEBottomSheet.h"
#import <objc/message.h>
#import "WALMEPlayerViewController.h"
//#import "WALMEDateMessage.h"
//#import "WALMEDateListViewController.h"
//#import "WALMEDateListViewmodel.h"

static Class _openCls = nil;

@implementation WALMENetCallback

#pragma mark - 处理callback

- (WALMENetCallback * _Nonnull (^)(NSDictionary * _Nullable))walme_deal {
    return ^(NSDictionary * json) {
        [self walme_dealCallbackWithJson:json];
        return self;
    };
}

- (instancetype)walme_dealCallbackWithJson:(NSDictionary *)json {
    if ([json isKindOfClass:[NSDictionary class]]) {
        NSString *funcName = SAFESTRING(json[@"funcName"]);
        if (IsStringWithAnyText(funcName)) {
            SEL callbackFunc = NSSelectorFromString(funcName);
            if ([self respondsToSelector:callbackFunc]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                _funcData = json[@"funcData"];
                [self performSelector:callbackFunc];
#pragma clang diagnostic pop
            }
        }
    }
    return self;
}

+ (void)setOpenCls:(Class)openCls {
    _openCls = openCls;
}

+ (Class)openCls {
    return _openCls;
}

#pragma mark - new methods
- (void)showTips {
    NSString *msg = SAFESTRING(_funcData[@"msg"]);
    NSInteger second = [_funcData[@"waitTime"] integerValue];
    [WALMEHUDPopHelper showTextHUD:msg delaySecond:second];
}

- (void)ajaxRequest {
    if (IsDictionaryWithItems(_funcData)) {
        NSMutableDictionary * parameters;
//        if (IsArrayWithItems(_funcData[@"postData"])) {
//            NSArray *array = _funcData[@"postData"];
//            parameters = [NSMutableDictionary dictionaryWithCapacity:array.count];
//            for (NSDictionary * keyDic in array) {
//                NSString * key = SAFESTRING(keyDic[@"key"]);
//                NSString * value = SAFESTRING(keyDic[@"value"]);
//                [parameters setValue:value forKey:key];
//            }
//        }
        MBProgressHUD * hud = [WALMEHUDPopHelper customProgressHUDTitle:nil];
        NSString * url = SAFESTRING(_funcData[@"postUrl"]);
        //        NSString * urlString = [NSString stringWithFormat:@"%@?token=%@", url, WALMEINSTANCE_USER.token];
        [WALMENetWorkManager walme_post:url withParameters:parameters success:^(id result) {
            dispatch_async(dispatch_get_main_queue(), ^{
//                [hud hideAnimated:YES];
//                if (_resultBlock) {
//                    _resultBlock(YES, result);
//                }
                NSString * msg = result[@"msg"];
                [WALMEHUDPopHelper showTextHUD:msg];
            });
        } failed:^(BOOL netReachable, NSString *msg, id result) {
            dispatch_async(dispatch_get_main_queue(), ^{
//                [hud hideAnimated:YES];
                [WALMEHUDPopHelper showTextHUD:msg];
//                if (_resultBlock) {
//                    _resultBlock(NO, result);
//                }
            });
        }];
    }
}

- (void)asyncAjaxRequest {
    NSMutableDictionary * parameters;
//    if (IsArrayWithItems(_funcData[@"postData"])) {
//        NSArray *array = _funcData[@"postData"];
//        parameters = [NSMutableDictionary dictionaryWithCapacity:array.count];
//        for (NSDictionary * keyDic in array) {
//            NSString * key = SAFESTRING(keyDic[@"key"]);
//            NSString * value = SAFESTRING(keyDic[@"value"]);
//            [parameters setValue:value forKey:key];
//        }
//    }
    
    NSString * url = SAFESTRING(_funcData[@"postUrl"]);
    
    [WALMENetWorkManager walme_post:url withParameters:parameters success:^(id result) {
        if (result[@"msg"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
//                if (_resultBlock) {
//                    _resultBlock(YES, result);
//                }
                [WALMEHUDPopHelper showTextHUD:result[@"msg"]];
            });
        }
    } failed:^(BOOL netReachable, NSString *msg, id result) {
        [WALMEHUDPopHelper showTextHUD:msg];
    }];
}

#pragma mark - callback数组

- (void)multipleCallBack {
    NSArray * array = (NSArray *)_funcData;
//    if (IsArrayWithItems(array)) {
//        for (NSDictionary * dic in array) {
//            [self walme_dealCallbackWithJson:dic];
//        }
//    }
}

#pragma mark - open
- (void)open {
//    if (IsDictionaryWithItems(_funcData)) {
//        BOOL shouldClose = [_funcData[@"closeWin"] intValue];
//#if DEBUG
//        shouldClose = NO;
//#endif
//        if (shouldClose) {
//            [WALMEOpenPageHelper walme_close];
////            ((void(*)(id, SEL))(void *)objc_msgSend)(_openCls, NSSelectorFromString(@"walme_close"));
//        }
//        Class cls = [self class].openCls;
//        SEL callbackFunc = NSSelectorFromString(@"walme_dealCallbackWithJson:");
//        if ([cls respondsToSelector:callbackFunc]) {
//            IMP imp = [cls methodForSelector:callbackFunc];
//            void (*func)(id, SEL, id) = (void *)imp;
//            func(cls, callbackFunc, _funcData);
//        }
//    }
}

- (void)showConfirm {
    // enter
    NSDictionary *enterDic = _funcData[@"enter"];
    NSString *enterText = SAFESTRING(enterDic[@"label"]);
    if (!IsStringWithAnyText(enterText)) {
        enterText = @"确定";
    }
    NSString *msg = SAFESTRING(_funcData[@"msg"]);
    
    // cancel
    NSDictionary *cancelDic = _funcData[@"cancel"];
    NSString *cancel_text;
    if (IsDictionaryWithItems(cancelDic)) {
        cancel_text = SAFESTRING(cancelDic[@"label"]);
    }
    if (!IsStringWithAnyText(cancel_text)) {
        cancel_text = @"取消";
    }
    
    [WALMEOpenPageHelper walme_showCustomAlertWithTitle:msg block:^(WALMEOpenAlert * _Nonnull alert) {
        alert.title(enterText).destructiveStyle().actionHandler = ^(UIAlertAction * _Nonnull action) {
            [self walme_dealCallbackWithJson:enterDic];
        };
        alert.title(cancel_text).cancelStyle().actionHandler = ^(UIAlertAction * _Nonnull action) {
            [self walme_dealCallbackWithJson:cancelDic];
            if ([[WALMEControllerFinder topViewController] isKindOfClass:[WALMEPlayerViewController class]]) {
                [[WALMEControllerFinder topViewController].navigationController popViewControllerAnimated:YES];
            }
        };
    }];
    
//    WALMEAlertController *alert = [WALMEAlertController alertControllerWithTitle:msg message:nil preferredStyle:UIAlertControllerStyleAlert];
//    [alert walme_addActionWithTitle:enterText style:UIAlertActionStyleDestructive handler:^{
//        if (IsDictionaryWithItems(enterDic)) {
//            [self walme_dealCallbackWithJson:enterDic];
//        }
//    }];
//
//    [alert walme_addActionWithTitle:cancel_text style:UIAlertActionStyleCancel handler:^{
//        if (IsDictionaryWithItems(cancelDic)) {
//            [self walme_dealCallbackWithJson:cancelDic];
//        }
//    }];
//    [alert walme_showWithController:WALMEINSTANCE_KEYWINDOW.rootViewController];
}

#pragma mark - showAlert
- (void)showAlert {
    NSDictionary *enterDic = _funcData[@"enter"];
    NSString *enterText = SAFESTRING(enterDic[@"label"]);
    if (!IsStringWithAnyText(enterText)) {
        enterText = @"确定";
    }
    NSString *title = SAFESTRING(_funcData[@"title"]);
    NSString *msg = SAFESTRING(_funcData[@"msg"]);
    
    [WALMEOpenPageHelper walme_showCustomAlertWithTitle:title message:msg alertStyle:UIAlertControllerStyleAlert block:^(WALMEOpenAlert * _Nonnull alert) {
        alert.title(enterText).destructiveStyle().actionHandler = ^(UIAlertAction * action) {
            if (IsDictionaryWithItems(enterDic)) {
                [self walme_dealCallbackWithJson:enterDic];
            }
        };
    }];
    
//    WALMEAlertController *alert = [WALMEAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
//    [alert walme_addActionWithTitle:enterText style:UIAlertActionStyleDestructive handler:^{
//        if (IsDictionaryWithItems(enterDic)) {
//            [self walme_dealCallbackWithJson:enterDic];
//        }
//    }];
//    [alert walme_showWithController:WALMEINSTANCE_KEYWINDOW.rootViewController];
}

- (void)showMultiple {
    NSString *msg = SAFESTRING(_funcData[@"msg"]);
    [WALMEOpenPageHelper walme_showCustomAlertWithTitle:nil message:msg alertStyle:UIAlertControllerStyleAlert block:^(WALMEOpenAlert * _Nonnull alert) {
        NSArray * btns = _funcData[@"button"];
//        if (IsArrayWithItems(btns)) {
//            for (NSDictionary * btnDic in btns) {
//                if (IsDictionaryWithItems(btnDic)) {
//                    NSString * text = SAFESTRING(btnDic[@"label"]);
//                    int styleNum = [btnDic[@"style"] intValue];
//                    if (!IsStringWithAnyText(text)) {
//                        text = @"确定";
//                    }
//                    UIAlertActionStyle style = UIAlertActionStyleDefault;
//                    //                if (styleNum == 0) {
//                    //                    style = UIAlertActionStyleDefault;
//                    //                }
//                    //                else
//                    if (styleNum == 1) {
//                        style = UIAlertActionStyleDestructive;
//                    }
//                    else if (styleNum == 2) {
//                        style = UIAlertActionStyleCancel;
//                    }
//                    alert.title(text).style(style).actionHandler = ^(UIAlertAction * _Nonnull action) {
//                        [self walme_dealCallbackWithJson:btnDic[@"callback"]];
//                    };
////                    [alert walme_addActionWithTitle:text style:style handler:^{
////                        [self walme_dealCallbackWithJson:btnDic[@"callback"]];
////                    }];
//                }
//            }
//        }
    }];
}

#pragma mark - sendMessage
- (void)sendMultipleChatMsg {
    NSArray * array = _funcData[@"messages"];
//    if (IsArrayWithItems(array)) {
//        for (NSDictionary * dic in array) {
//            if (IsDictionaryWithItems(dic)) {
//                [self walme_dealCallbackWithJson:dic];
//            }
//        }
//    }
    id openChat = _funcData[@"openChat"];
    if (IsDictionaryWithItems(openChat) && openChat) {
        [self walme_dealCallbackWithJson:(NSDictionary *)openChat];
    }
}

- (void)sendChatMsg {
    //    NSString * msgType = _funcData[@"msgType"];
    //    if ([msgType isEqualToString:RCTextMessageTypeIdentifier]) {
    //        [self p_walme_sendTextMessage];
    //    }
    //    else if ([msgType isEqualToString:WALMEDateMessageTypeIdentifier]) {
    //        [self p_walme_sendDateMessage];
    //    }
    //
    //    id openChat = _funcData[@"openChat"];
    //    if (IsDictionaryWithItems(openChat) && openChat) {
    //        [self walme_dealCallbackWithJson:(NSDictionary *)openChat];
    //    }
}

- (void)p_walme_sendTextMessage {
    //    NSString * content = _funcData[@"content"];
    //    if (content) {
    //        NSString * extra = _funcData[@"extra"];
    //
    //        RCTextMessage *textMessage = [RCTextMessage messageWithContent:content];
    //        if (extra) {
    //            textMessage.extra = extra;
    //        }
    //        NSString * targetId = SAFESTRING(_funcData[@"to_userid"]);
    //        NSString * pushData = _funcData[@"pushData"];
    //        NSString * pushContent = _funcData[@"pushContent"];
    //        [[RCIM sharedRCIM] sendMessage:ConversationType_PRIVATE
    //                              targetId:targetId
    //                               content:textMessage
    //                           pushContent:pushContent
    //                              pushData:pushData
    //                               success:^(long messageId) {
    //
    //                               } error:^(RCErrorCode nErrorCode, long messageId) {
    //                                   //NSLog(@"发送失败。消息ID：%@， 错误码：%d", messageId, nErrorCode);
    //                               }];
    //    }
}

- (void)p_walme_sendDateMessage {
    //    NSString * content = _funcData[@"content"];
    //    WALMEDateMessage * dateMessage = [[WALMEDateMessage alloc] init];
    //    dateMessage.showContent = content;
    //    NSString * extraString = _funcData[@"extra"];
    //    NSDictionary * tempDic = [extraString convertToObject];
    //    NSDictionary * extraDic = tempDic[@"dating"];
    //    NSString * targetId = SAFESTRING(_funcData[@"to_userid"]);
    //    NSString * dateUid = SAFESTRING(extraDic[@"userid"]);
    //    if (IsDictionaryWithItems(extraDic)) {
    //        NSString * dateTitle = extraDic[@"title"];
    //        NSString * dateid = SAFESTRING(extraDic[@"dating_id"]);
    //        NSString * sendNote = extraDic[@"intro_author"];
    //        NSString * receiveNote = extraDic[@"intro_join"];
    //        NSString * dateIcon = extraDic[@"icon"];
    //        NSString * chatTitle = extraDic[@"chat_title"];
    //        NSString * joineruid = SAFESTRING(extraDic[@"join_uid"]);
    //        NSString * dateType = SAFESTRING(extraDic[@"dating_type"]);
    //        dateMessage.dateTitle = dateTitle;
    //        dateMessage.dateIcon = dateIcon;
    //        dateMessage.dateid = dateid;
    //        dateMessage.sendNote = sendNote;
    //        dateMessage.receiveNote = receiveNote;
    //        dateMessage.chatTitle = chatTitle;
    //        dateMessage.joineruid = joineruid;
    //        dateMessage.dateuid = dateUid;
    //        dateMessage.dateType = dateType;
    //    }
    //
    //    NSString * pushData = _funcData[@"pushData"];
    //    NSString * pushContent = _funcData[@"pushContent"];
    //    [[RCIMClient sharedRCIMClient] sendMessage:ConversationType_PRIVATE
    //                                      targetId:targetId
    //                                       content:dateMessage
    //                                   pushContent:pushContent
    //                                      pushData:pushData
    //                                       success:^(long messageId) {
    //                                           NSLog(@"date send success");
    //                                       } error:^(RCErrorCode nErrorCode, long messageId) {
    //                                           NSLog(@"date error");
    //                                       }];
}

#pragma mark - showPick
- (void)showPick {
    NSArray * array = _funcData[@"pick"];
    NSMutableArray * titles = [NSMutableArray array];
    NSMutableArray * dics = [NSMutableArray array];
//    if (IsArrayWithItems(array)) {
//        for (NSDictionary * enterDic in array) {
//            if (IsDictionaryWithItems(enterDic)) {
//                NSString * title = SAFESTRING(enterDic[@"label"]);
//                if (title.length == 0) {
//                    title = @"ok";
//                }
//                [titles addObject:title];
//                [dics addObject:enterDic];
//            }
//        }
//    }
    WALMEBottomSheet *sheet = [WALMEBottomSheet walme_bottomSheetWithTitleArray:titles block:^(NSInteger index) {
        [self walme_dealCallbackWithJson:[dics objectOrNilAtIndex:index]];
    }];
    [sheet walme_show];
    
//    [WALMEOpenPageHelper walme_showCustomActionSheetWithTitle:nil block:^(WALMEOpenAlert * _Nonnull alert) {
//        NSArray * array = _funcData[@"pick"];
//        if (IsArrayWithItems(array)) {
//            for (NSDictionary * enterDic in array) {
//                if (IsDictionaryWithItems(enterDic)) {
//                    NSString * title = SAFESTRING(enterDic[@"label"]);
//                    if (title.length == 0) {
//                        title = @"ok";
//                    }
//                    alert.title(title).style(UIAlertActionStyleDefault).actionHandler = ^(UIAlertAction * _Nonnull action) {
//                        [self walme_dealCallbackWithJson:enterDic];
//                    };
////                    UIAlertAction * action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
////                        [self walme_dealCallbackWithJson:enterDic];
////                    }];
////                    [sheet addAction:action];
//                }
//            }
//        }
//        alert.title(@"取消").style(UIAlertActionStyleCancel);
//    }];
//    UIAlertController * sheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//    NSArray * array = _funcData[@"pick"];
//    if (IsArrayWithItems(array)) {
//        for (NSDictionary * enterDic in array) {
//            if (IsDictionaryWithItems(enterDic)) {
//                NSString * title = SAFESTRING(enterDic[@"label"]);
//                if (title.length == 0) {
//                    title = @"ok";
//                }
//                UIAlertAction * action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                    [self walme_dealCallbackWithJson:enterDic];
//                }];
//                [sheet addAction:action];
//            }
//        }
//    }
//
//    UIAlertAction * action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//    }];
//    [sheet addAction:action];
//    UIViewController *topVC = [self topViewController];
//    [topVC presentViewController:sheet animated:YES completion:nil];
}

#pragma mark - uploadComponent
- (void)uploadComponent {
    NSArray * uploads = _funcData[@"uploadWay"];
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
    [uploads enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString * str = (NSString *)obj;
        if ([str isEqualToString:@"camera"]) {
            [array addObject:@"拍摄"];
        } else if ([str isEqualToString:@"choose"]) {
            [array addObject:@"从相册选取"];
        }
    }];

    if (uploads.count == 1) {
        [self p_walme_openUploadPage:uploads.firstObject];
    } else if (uploads.count > 1) {
        if (_funcData[@"example"]) {
            UIViewController * tabbar = [WALMEControllerFinder rootControlerInWindow];
            WALMEUploadExampleView * upload = [[WALMEUploadExampleView alloc] initWithFrame:tabbar.view.bounds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [upload configWithBtns:uploads dictionary:_funcData[@"example"] leftHandler:^{
                    [self p_walme_openUploadPage:uploads.firstObject];
                } rightHandler:^{
                    [self p_walme_openUploadPage:uploads[1]];
                }];
                [tabbar.view addSubview:upload];
            });
        } else {
            WALMEBottomSheet *sheet = [WALMEBottomSheet walme_bottomSheetWithTitleArray:array block:^(NSInteger index) {
                [self p_walme_openUploadPage:[uploads objectOrNilAtIndex:index]];
            }];
            [sheet walme_show];
//            UIViewController *topVC = [WALMEControllerFinder topViewController];
//            [topVC showActionSheet:array handler:^{
//                [self p_walme_openUploadPage:uploads.firstObject];
//            } otherhandler:^{
//                [self p_walme_openUploadPage:uploads[1]];
//            }];
        }
    }
}

- (void)p_walme_openUploadPage:(NSString *)pageStr {
    if ([pageStr isEqualToString:@"choose"]) {
        [self p_walme_openAlbumList];
    } else if ([pageStr isEqualToString:@"camera"]) {
        [self p_walme_openCamera];
    }
}

- (void)p_walme_openCamera {
    Class cls = [self class].openCls;
    SEL callbackFunc = NSSelectorFromString(@"openCameraWithDictionary:");
    if ([cls respondsToSelector:callbackFunc]) {
        IMP imp = [cls methodForSelector:callbackFunc];
        void (*func)(id, SEL, id) = (void *)imp;
        func(cls, callbackFunc, _funcData);
    }
}

- (void)p_walme_openAlbumList {
    Class cls = [self class].openCls;
    SEL callbackFunc = NSSelectorFromString(@"openAlbumWithDictionary:");
    if ([cls respondsToSelector:callbackFunc]) {
        IMP imp = [cls methodForSelector:callbackFunc];
        void (*func)(id, SEL, id) = (void *)imp;
        func(cls, callbackFunc, _funcData);
    }
}

#pragma mark - walme_openNetAlert

//- (void)walme_openNetAlert {
//    UIViewController * topVC = [self topViewController];
//    if ([topVC isKindOfClass:[UIAlertController class]]) {
//        return;
//    }
//    [topVC showAlertWithCancel:@"当前无网络请求权限，是否去设置中打开？" ackTitle:@"确定" ackHandler:^{
//        [WALMEINSTANCE_Application openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
//    }];
//}

- (void)showPublichDating {
    //    UITabBarController * rootTab = (UITabBarController *)WALMEINSTANCE_Application.keyWindow.rootViewController;
    //    NSString *forceDateType = _funcData[@"publishType"];
    //    BOOL canClose = [_funcData[@"isClosePublish"] intValue];
    //
    //    UINavigationController * nav = rootTab.viewControllers.firstObject;
    //    UIViewController * rootDate = nav.viewControllers.firstObject;
    //    WALMEDateListViewController * allList = rootDate.childViewControllers.firstObject;
    //    NSArray<WALMEDateTypeModel *> *dateTypes;
    //    if ([allList isKindOfClass:[WALMEDateListViewController class]]) {
    //        WALMEDateListViewmodel * viewmodel = ((WALMEDateListViewController *)allList).viewmodel;
    //        dateTypes = viewmodel.dateTypes;
    //    }
    //    if ([rootTab isKindOfClass:[UITabBarController class]]) {
    //        [rootTab WALME_showForceDateViewWithType:forceDateType
    //                                        canClose:canClose
    //                                       dateTypes:dateTypes];
    //    }
}

#pragma mark - close
- (void)close {
//    ((void(*)(id, SEL))(void *)objc_msgSend)(_openCls, NSSelectorFromString(@"walme_close"));
    [WALMEOpenPageHelper walme_close];
}

//- (UIViewController *)topViewController {
//    UIViewController *resultVC;
//    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
//    while (resultVC.presentedViewController) {
//        resultVC = [self _topViewController:resultVC.presentedViewController];
//    }
//    return resultVC;
//}
//
//- (UIViewController *)_topViewController:(UIViewController *)vc {
//    if ([vc isKindOfClass:[UITabBarController class]]) {
//        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
//    }
//    else if ([vc isKindOfClass:[UINavigationController class]]) {
//        return [self _topViewController:[(UINavigationController *)vc topViewController]];
//    } else {
//        return vc;
//    }
//    return nil;
//}

#pragma mark - call
- (void)copyText {
    NSString * text = SAFESTRING(_funcData[@"text"]);
    [UIPasteboard generalPasteboard].string = text;
    [WALMEHUDPopHelper showTextHUD:@"复制成功"];
}

- (void)upgrade {
    NSString *title = _funcData[@"title"];
    NSString *content = _funcData[@"content"];
    NSString *downloadUrl = _funcData[@"download"];
    NSString *leftTitle = _funcData[@"leftBtn"];
    NSString *rightTitle = _funcData[@"rightBtn"];
    
    [WALMEOpenPageHelper walme_showCustomAlertWithTitle:title message:content alertStyle:UIAlertControllerStyleAlert block:^(WALMEOpenAlert * _Nonnull alert) {
//        if (IsStringLengthGreaterThanZero(leftTitle)) {
//            alert.title(leftTitle).defaultStyle();
//        }
//        if (IsStringLengthGreaterThanZero(rightTitle)) {
//            alert.title(rightTitle).defaultStyle().actionHandler = ^(UIAlertAction * _Nonnull action) {
//                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:downloadUrl]];
//            };
//        }
    }];
}

@end
