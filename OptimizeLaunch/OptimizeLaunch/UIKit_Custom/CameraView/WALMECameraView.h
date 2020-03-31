//
//  WALMECameraView.h
//  CodeFrame
//
//  Created by Jeremy on 2019/4/17.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@class GPUImageView, WALMEBeautySlider, GPUImageStillCamera, GPUImageFilterGroup, GPUImageMovieWriter, WALMEGPUImageBeautyFilter;

@protocol WALMECameraViewDelegate;

@interface WALMECameraView : UIView

/**
 default is NO
 */
@property (nonatomic, assign) BOOL showBeautySlider;

/**
 default is YES
 */
@property (nonatomic, assign) BOOL addBeautyFilter;

/**
 default AVCaptureDevicePositionFront
 */
@property (nonatomic, assign) AVCaptureDevicePosition cameraPosition;

/**
 0-1
 */
@property (nonatomic, assign) float beautyValue;

/**
 defaul 3s
 */
@property (nonatomic, assign) NSUInteger minReocrdTime;
/**
 defaul 10s
 */
@property (nonatomic, assign) NSUInteger maxReocrdTime;

/**
 defaul NO
 */
@property (nonatomic, assign) BOOL detectFace;

/**
 default UIInterfaceOrientationPortrait
 */
@property (nonatomic, assign) UIInterfaceOrientation outputImageOrientation;

/**
 是否正在录制
 */
@property (nonatomic, assign, readonly) BOOL recording;

@property (nonatomic, strong) GPUImageView *cameraView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) WALMEBeautySlider *beautySlider;
@property (nonatomic, strong) CALayer * focusLayer;

//******** Media Property **************
@property (nonatomic, assign, readonly) float recordDuration;
@property (nonatomic, copy) NSString *moviePath;
@property (nonatomic, copy) NSString *compressdMoviePath;
@property (nonatomic, strong) NSDictionary *audioSettings;
@property (nonatomic, strong) NSDictionary *videoSettings;

//******** GPUImage Property ***********
@property (nonatomic, strong) GPUImageStillCamera *videoCamera;
@property (nonatomic, strong) GPUImageFilterGroup *normalFilter;
@property (nonatomic, strong) GPUImageMovieWriter * _Nullable movieWriter;
@property (nonatomic, strong) WALMEGPUImageBeautyFilter *leveBeautyFilter;
@property (nonatomic, weak) id<WALMECameraViewDelegate> delegate;

- (void)walme_showCameraView;
- (void)walme_switchCamera;

/**
 拍照完成后 或录制完成后 要调用此方法
 */
- (void)walme_recapture;

- (void)walme_initCapture;

- (void)walme_startRecordVideo;
- (void)walme_endReocrd:(void(^)(id result, NSError * _Nullable error))block;

// 这两种方法是在确定调用是拍照还是录制时直接调用
- (void)walme_takePhoto:(void(^)(UIImage *image, NSError * _Nullable error))block;
- (void)walme_endRecordVideo:(void(^)(NSString *videoPath))block;

- (void)walme_play:(NSString *)path;
- (void)walme_pausePlay;

- (void)walme_dismiss;

- (void)startCameraCapture;
- (void)stopCameraCapture;
- (void)pauseCameraCapture;
- (void)resumeCameraCapture;
- (void)stopDetectFace;
- (void)startDetectFace;

@end

@protocol WALMECameraViewDelegate <NSObject>

@optional

- (void)walme_cameraViewRecordTime:(float)time;
- (void)walme_cameraViewDetectFaceResult:(NSArray<AVMetadataFaceObject *> *)metadataObjects;

@end

NS_ASSUME_NONNULL_END
