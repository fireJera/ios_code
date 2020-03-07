////
////  LETADCameraViewController.h
////  LetDate
////
////  Created by Jeremy on 2019/1/21.
////  Copyright © 2019 JersiZhu. All rights reserved.
////
//
//#import <UIKit/UIKit.h>
//
//
//@class LETADCameraViewController;
//
//@protocol LETADCameraDelegate <NSObject>
//
//@optional
//
///**
// 上传中
//
// @param controller 当前页面
// @param source uiimage or nsstring
// @param isSuccess 是否成功
// */
//
////type video & all 上传代理 目前图片上传没有走代理
//- (void)letad_cameraUpload:(LETADCameraViewController *)controller source:(id)source success:(BOOL)isSuccess result:(id)result;
//
////裁剪上传代理
//- (void)letad_imageUploadFromCamera:(UIImage *)originImage
//                          clipImage:(UIImage *)clipImage
//                            success:(BOOL)isSuccess
//                             result:(id)result
//                         originPath:(NSString *)originPath
//                           clipPath:(NSString *)clipPath;
//
//- (void)cancelCamera;
//
//@end
//
//@class LETADCameraViewmodel;
//
//NS_ASSUME_NONNULL_BEGIN
//
//@interface LETADCameraViewController : UIViewController
//
//@property (nonatomic, weak) id<LETADCameraDelegate> delegate;
//@property (nonatomic, strong) LETADCameraViewmodel * viewmodel;
//
//
//@end
//
//NS_ASSUME_NONNULL_END
