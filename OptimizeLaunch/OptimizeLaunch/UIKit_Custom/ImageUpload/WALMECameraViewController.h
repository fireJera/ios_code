//
//  WALMECameraViewController.h
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol WALMECameraDelegate, WALMECameraDataSource;

@interface WALMECameraViewController : UIViewController

@property (nonatomic, weak) id<WALMECameraDelegate> delegate;
@property (nonatomic, strong) id<WALMECameraDataSource> dataSource;

@end

@protocol WALMECameraDelegate <NSObject>

@optional

/**
 上传中
 @param controller 当前页面
 @param videoPath videoPath
 @param gifUrl gifUrl
 @param coverImage coverImage
 @param error error
 @param result result
 */
- (void)walme_videoUploadFromeCamera:(WALMECameraViewController *)controller
                           videoPath:(NSString *)videoPath
                              gifUrl:(nullable NSString *)gifUrl
                          videoCover:(nullable UIImage *)coverImage
                               error:(NSError *)error
                              result:(id)result;

//裁剪上传代理
- (void)walme_imageUploadFromCamera:(WALMECameraViewController *)viewcontroller
                        originImage:(UIImage *)originImage
                          clipImage:(nullable UIImage *)clipImage
                         originPath:(nullable NSString *)originPath
                           clipPath:(nullable NSString *)clipPath
                         originName:(nullable NSString *)originName
                           clipName:(nullable NSString *)clipName
                       originResult:(id)originResult
                         clipResult:(id _Nullable)clipResult
                              error:(NSError *)error;

- (void)cancelCamera;

@end

NS_ASSUME_NONNULL_END
