//
//  WALMEAuthorityHelper.m
//  CodeFrame
//
//  Created by Jeremy on 2019/4/17.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import "WALMEAuthorityHelper.h"
#import <AVFoundation/AVFoundation.h>
#import <UserNotifications/UserNotifications.h>
#import <UIKit/UIKit.h>

@implementation WALMEAuthorityHelper

//+ (void)checkCameraAuthorityDenied:(WALMEVoidBlock)deniedBlock
//                     notDetermined:(WALMEVoidBlock)notDeterminedBlock
//                         authBlock:(WALMEVoidBlock)authBlock
//                        restricted:(WALMEVoidBlock)restrictedBlock {
//    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
//        
//    }];
//
//    AVAuthorizationStatus AVstatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];//相机权限
//    switch (AVstatus) {
//        case AVAuthorizationStatusDenied: {
//            if (deniedBlock) {
//                deniedBlock();
//            }
////                [self showAlertWithCancel:@"无法使用相机" message:@"请在IPhone的“设置-nico-相机”中允许访问相机" button:@"去设置" handler:^{
////                    [self walme_clickOpenAuthorization];
////                }];
//        }
//            break;
//        case AVAuthorizationStatusNotDetermined: {
//            [AVCaptureDevice requestAccessForMediaType:
//             AVMediaTypeVideo completionHandler:^(BOOL granted) {
//                 dispatch_async(dispatch_get_main_queue(), ^{
//                     if (granted) {
//                         if (authBlock) {
//                             authBlock();
//                         }
//                     } else {
//                         if (notDeterminedBlock) {
//                             notDeterminedBlock();
//                         }
//                     }
//                 });
//             }];
//        }
//            break;
//        case AVAuthorizationStatusAuthorized:{
//            if (authBlock) {
//                authBlock();
//            }
//        }
//            break;
//        case AVAuthorizationStatusRestricted: {
//            [AVCaptureDevice requestAccessForMediaType:
//             AVMediaTypeVideo completionHandler:^(BOOL granted) {
//                 dispatch_async(dispatch_get_main_queue(), ^{
//                     if (restrictedBlock) {
//                         restrictedBlock();
//                     }
//                 });
//             }];
//        }
//            break;
//        default:
//            break;
//    }
//}
//
//+ (void)requestMicroAuthroity {
//    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
//        
//    }];
//}
//
////+ (void)checkMicroAuthroityDenied:(WALMEVoidBlock)deniedBlock
////                    notDetermined:(WALMEVoidBlock)notDeterminedBlock
////                        authBlock:(WALMEVoidBlock)authBlock
////                       restricted:(WALMEVoidBlock)restrictedBlock {
////    AVAuthorizationStatus AVstatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
////    //相机权限
////    if (AVstatus == AVAuthorizationStatusDenied) {
//////        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"无法使用相机" message:@"请在IPhone的“设置-nico-相机”中允许访问相机" preferredStyle:UIAlertControllerStyleAlert];
//////        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
//////        [alert addAction:[UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//////            [WALMEINSTANCE_Application openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
//////        }]];
//////        [topVC presentViewController:alert animated:YES completion:nil];
////    }
////    else if (AVstatus == AVAuthorizationStatusNotDetermined) {
////        [AVCaptureDevice requestAccessForMediaType:
////         AVMediaTypeVideo completionHandler:^(BOOL granted) {
//////             if (granted) {
//////                 [self p_presentViewController:camera animated:YES];
//////             } else{
//////                 NSLog(@"Denied or Restricted");
//////             }
////         }];
////    }
////    else if (AVstatus == AVAuthorizationStatusAuthorized) {
////
////    }
////    else if (AVstatus == AVAuthorizationStatusRestricted) {
////        [AVCaptureDevice requestAccessForMediaType:
////         AVMediaTypeAudio completionHandler:^(BOOL granted) {
////             
////         }];
////    }
////}
//
//+ (void)hasPushAuthority:(void (^)(BOOL))block {
//    if (@available(iOS 10.0, *)) {
//        __block BOOL hasAuthority = NO;
//        [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
//            if (settings.authorizationStatus == UNAuthorizationStatusDenied) {
//                hasAuthority = NO;
//            }
//            else {
//              hasAuthority = YES;
//            }
//            if (block) {
//                block(hasAuthority);
//            }
//        }];
//    }
////    else if (@available(iOS 8.0, *)) {
////        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
////        if (setting.types == UIUserNotificationTypeNone) {
////            if (block) {
////                block(NO);
////            }
////        }
////        if (block) {
////            block(YES);
////        }
////    } else {
////        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
////        if (type == UIUserNotificationTypeNone) {
////            if (block) {
////                block(NO);
////            }
////        }
////        if (block) {
////            block(YES);
////        }
////    }
//}
//
//+ (void)openPushAuthoritySetting {
//    NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        if ([[UIApplication sharedApplication] canOpenURL:url]) {
//            [[UIApplication sharedApplication] openURL:url];
//        }
//    });
//}

@end
