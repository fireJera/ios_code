//
//  WALMECameraView.m
//  CodeFrame
//
//  Created by Jeremy on 2019/4/17.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import "WALMECameraView.h"
#import "WALMEBeautySlider.h"
#import "NSTimer+WALME_Block.h"
#import "UIView+WALME_Frame.h"

static const int kCameraWidth = 540;
static const int kCameraHeight = 960;

//录像存储路径
#define WALMEVideoPath [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"movie.mov"]

#define WALMECompressedVideoPath [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"compressMovie.mov"]

@interface WALMECameraView () <CAAnimationDelegate, AVCaptureMetadataOutputObjectsDelegate> {
    CGFloat _allTime;
    AVPlayerLayer *_avplayer;
    
    struct {
        unsigned int recordTime : 1;
        unsigned int detectFace : 1;
    } _delegateFlags;
}

@property (nonatomic, strong) CADisplayLink * timer;
@property (nonatomic, strong) AVCaptureMetadataOutput * metaDataOutput;
@property (nonatomic, assign, readwrite) BOOL recording;

@end

@implementation WALMECameraView

- (void)layoutSubviews {
    [super layoutSubviews];
}

#pragma mark - AnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self performSelector:@selector(focusLayerNormal) withObject:self afterDelay:1.0f];
}

#pragma mark - capture delegate

- (void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if (_delegateFlags.detectFace) {
        [_delegate walme_cameraViewDetectFaceResult:metadataObjects];
    }
}

#pragma mark 聚焦
- (void)focusTap:(UITapGestureRecognizer *)tap {
//    self.cameraView.userInteractionEnabled = NO;
//    CGPoint touchPoint = [tap locationInView:tap.view];
//
//    if (touchPoint.y > 0) {
//        return;
//    }
//    [self layerAnimationWithPoint:touchPoint];
//    touchPoint = CGPointMake(touchPoint.x / tap.view.bounds.size.width, touchPoint.y / tap.view.bounds.size.height);
//    if ([self.videoCamera.inputCamera isFocusPointOfInterestSupported] && [self.videoCamera.inputCamera isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
//        NSError *error;
//        if ([self.videoCamera.inputCamera lockForConfiguration:&error]) {
//            [self.videoCamera.inputCamera setFocusPointOfInterest:touchPoint];
//            [self.videoCamera.inputCamera setFocusMode:AVCaptureFocusModeAutoFocus];
//            if([self.videoCamera.inputCamera isExposurePointOfInterestSupported] && [self.videoCamera.inputCamera isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure])
//            {
//                [self.videoCamera.inputCamera setExposurePointOfInterest:touchPoint];
//                [self.videoCamera.inputCamera setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
//            }
//            [self.videoCamera.inputCamera unlockForConfiguration];
//        } else {
//            NSLog(@"ERROR = %@", error);
//        }
//    }
//
}

#pragma mark - Animation
- (void)p_walme_animationCamera {
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = .5f;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = @"oglFlip";
    animation.subtype = kCATransitionFromRight;
//    [self.cameraView.layer addAnimation:animation forKey:nil];
}

- (void)focusLayerNormal {
//    self.cameraView.userInteractionEnabled = YES;
    _focusLayer.hidden = YES;
}

- (void)layerAnimationWithPoint:(CGPoint)point {
    [_focusLayer removeAllAnimations];
    if (_focusLayer) {
        CALayer *focusLayer = _focusLayer;
        focusLayer.hidden = NO;
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        [focusLayer setPosition:point];
        focusLayer.transform = CATransform3DMakeScale(2.0f,2.0f,1.0f);
        [CATransaction commit];
        
        CABasicAnimation *animation = [ CABasicAnimation animationWithKeyPath: @"transform" ];
        animation.toValue = [ NSValue valueWithCATransform3D: CATransform3DMakeScale(1.0f,1.0f,1.0f)];
        animation.delegate = self;
        animation.duration = 0.3f;
        animation.repeatCount = 1;
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        [focusLayer addAnimation: animation forKey:@"animation"];
    }
}

#pragma mark - touch event

- (void)p_walme_beautyValueChanged:(UISlider *)slider {
    _beautyValue = slider.value / 100;
//    self.leveBeautyFilter.beautyLevel = _beautyValue;
//    if (_beautyValue == 0) {
//        [self.videoCamera removeAllTargets];
//        [self.videoCamera addTarget:self.normalFilter];
//        [self.normalFilter addTarget:self.cameraView];
//    } else {
//        [self.videoCamera removeAllTargets];
//        [self.videoCamera addTarget:self.leveBeautyFilter];
//        [self.leveBeautyFilter addTarget:self.cameraView];
//    }
}

#pragma mark - notifcation

- (void)p_walme_applicationWillResignActive:(NSNotification *)notification {
    if (_avplayer) {
        [_avplayer.player pause];
    }
}

- (void)p_walme_applicationDidBecomeActive:(NSNotification *)notification {
    if (_avplayer) {
        [_avplayer.player play];
    }
}

//播放结束
- (void)p_walme_moviePlayDidEnd:(NSNotification *)notification {
    [_avplayer.player seekToTime:kCMTimeZero];
    [_avplayer.player play];
}

#pragma mark - public method
- (void)walme_switchCamera {
//    [_videoCamera pauseCameraCapture];
//
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        [self.videoCamera rotateCamera];
//        [self.videoCamera resumeCameraCapture];
//    });
    [self performSelector:@selector(p_walme_animationCamera) withObject:self afterDelay:0.2f];
}

- (void)walme_recapture {
//    if (_timer) {
//        [_timer invalidate];
//        _timer = nil;
//    }
//
//    [_movieWriter cancelRecording];
//    [_movieWriter finishRecording];
//    [_videoCamera removeAllTargets];
//    id<GPUImageInput> target = (_addBeautyFilter && _beautyValue > 0) ? self.leveBeautyFilter : self.normalFilter;
//
//    [_videoCamera addTarget:target];
//    [(GPUImageOutput *)target addTarget:self.cameraView];
//
//    [self p_walme_createNewWritter];
//    [self walme_showCameraView];
//    [_videoCamera resumeCameraCapture];
//    _avplayer = nil;
//    if (_detectFace) {
//        [self p_walme_detecFace];
//    }
//    [[NSFileManager defaultManager] removeItemAtPath:WALMEVideoPath error:nil];
}

- (void)walme_startRecordVideo {
//    _recording = YES;
//    unlink([self.moviePath UTF8String]);
//    id<GPUImageInput> target = (_addBeautyFilter && _beautyValue > 0) ? self.leveBeautyFilter : self.normalFilter;
//    [(GPUImageOutput *)target addTarget:self.movieWriter];
//    [self.movieWriter startRecording];
//
//    __weak typeof(self) weakSelf = self;
//    _timer = [CADisplayLink displayLinkWithExecuteBlock:^(CADisplayLink *displayLink) {
//        [weakSelf p_walme_timerupdating];
//    }];
//    _timer.frameInterval = 3;
////    _timer.preferredFramesPerSecond = 3;
//    [_timer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
//    _allTime = 0;
}

- (void)walme_endReocrd:(void (^)(id _Nonnull, NSError * _Nullable))block {
//    if (!_timer) {
//        return;
//    }
//
//    [_timer invalidate];
//    _timer = nil;
//
//    if (_allTime < 0.3) {
//        [self p_walme_finishTakePhoto:block];
//        return;
//    }
//
//    [self p_walme_hideSlider];
//    id<GPUImageInput> target = (_addBeautyFilter && _beautyValue > 0) ? self.leveBeautyFilter : self.normalFilter;
//    [(GPUImageOutput *)target removeTarget:self.movieWriter];
//
//    if (_allTime < _minReocrdTime) {
//        NSString * msg = [NSString stringWithFormat:@"视频最短为%d秒", (int)_minReocrdTime];
//        [self showTextHUD:msg];
//        [self.movieWriter finishRecording];
//        [self p_walme_createNewWritter];
//        [self walme_recapture];
//        return;
//    }
//
//    __weak typeof(self) weakSelf = self;
//    [self.movieWriter finishRecordingWithCompletionHandler:^{
////        [weakSelf p_walme_createNewWritter];
//        [weakSelf.videoCamera pauseCameraCapture];
////        weakSelf.movieWriter = nil;
//        [weakSelf p_walme_stopDetecFace];
//        __strong typeof(weakSelf) strongSelf = weakSelf;
//        strongSelf->_recording = NO;
//        if (strongSelf->_allTime > 0.5) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [weakSelf walme_play:weakSelf.moviePath];
//                if (block) {
//                    block(weakSelf.moviePath, nil);
//                }
//            });
//        }
//    }];
}

- (void)walme_takePhoto:(void (^)(UIImage * _Nonnull, NSError * _Nonnull))block {
//    _recording = YES;
//    unlink([self.moviePath UTF8String]);
//    GPUImageOutput * target = (_addBeautyFilter && _beautyValue > 0) ? self.leveBeautyFilter : self.normalFilter;
//    [target addTarget:self.movieWriter];
//
//    [self.movieWriter startRecording];
//    [self p_walme_finishTakePhoto:block];
}

- (void)walme_endRecordVideo:(void (^)(NSString * _Nonnull))block {
//    if (!_timer) {
//        return;
//    }
//
//    [_timer invalidate];
//    _timer = nil;
//
//    [self p_walme_hideSlider];
//    id<GPUImageInput> target = (_addBeautyFilter && _beautyValue > 0) ? self.leveBeautyFilter : self.normalFilter;
//    [(GPUImageOutput *)target removeTarget:self.movieWriter];
//
//    if (_allTime < _minReocrdTime) {
//        NSString * msg = [NSString stringWithFormat:@"视频最短为%d秒", (int)_minReocrdTime];
//        [self showTextHUD:msg];
//        [self.movieWriter finishRecording];
////        [self p_walme_createNewWritter];
//        [self walme_recapture];
//        return;
//    }
//
//    __weak typeof(self) weakSelf = self;
//    [self.movieWriter finishRecordingWithCompletionHandler:^{
////        [weakSelf p_walme_createNewWritter];
//        [weakSelf.videoCamera pauseCameraCapture];
//        [weakSelf p_walme_stopDetecFace];
//        __strong typeof(weakSelf) strongSelf = weakSelf;
//        strongSelf->_recording = NO;
//        if (strongSelf->_allTime > 0.5) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [weakSelf walme_play:weakSelf.moviePath];
//                if (block) {
//                    block(weakSelf.moviePath);
//                }
//            });
//        }
//    }];
}

- (void)walme_play:(NSString *)path {
    _avplayer = [AVPlayerLayer playerLayerWithPlayer:[AVPlayer playerWithURL:[NSURL fileURLWithPath:path]]];
    _avplayer.frame = self.bounds;
//    [self.layer insertSublayer:_avplayer above:self.cameraView.layer];
    [_avplayer.player play];
//    _cameraView.hidden = YES;
}

- (void)walme_pausePlay {
    [_avplayer.player pause];
}

- (void)walme_dismiss {
    [_focusLayer removeAllAnimations];
//    [self.videoCamera stopCameraCapture];
}

- (void)startCameraCapture {
//    [_videoCamera startCameraCapture];
}

- (void)stopCameraCapture {
//    [_videoCamera stopCameraCapture];
}

- (void)pauseCameraCapture {
//    [_videoCamera pauseCameraCapture];
}

- (void)resumeCameraCapture {
//    [_videoCamera resumeCameraCapture];
}

- (void)stopDetectFace {
//    [_videoCamera.captureSession removeOutput:_metaDataOutput];
    [self pauseCameraCapture];
}

- (void)startDetectFace {
//    _metaDataOutput = [[AVCaptureMetadataOutput alloc] init];
//    if ([_videoCamera.captureSession canAddOutput:_metaDataOutput]) {
//        [_videoCamera.captureSession addOutput:_metaDataOutput];
//        NSArray* supportTypes = _metaDataOutput.availableMetadataObjectTypes;
//        if ([supportTypes containsObject:AVMetadataObjectTypeFace]) {
//            [_metaDataOutput setMetadataObjectTypes:@[AVMetadataObjectTypeFace]];
//            [_metaDataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
//        }
//    }
//    [self resumeCameraCapture];
}

- (void)walme_initCapture {
//    [_videoCamera startCameraCapture];
}

#pragma mark - private method

- (void)p_walme_finishTakePhoto:(void (^)(UIImage * _Nonnull, NSError * _Nonnull))block {
//    GPUImageOutput * target = (_addBeautyFilter && _beautyValue > 0) ? self.leveBeautyFilter : self.normalFilter;
//    [target removeTarget:self.movieWriter];
//
//    [self.movieWriter finishRecording];
//    _recording = NO;
//    __weak typeof(self) weakSelf = self;
//    [self.videoCamera capturePhotoAsImageProcessedUpToFilter:self.leveBeautyFilter withCompletionHandler:^(UIImage *processedImage, NSError *error) {
////        [self p_walme_createNewWritter];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (block) {
//                block(processedImage, error);
//            }
//            [weakSelf p_walme_showPhoto:processedImage];
//        });
//    }];
}

- (void)p_walme_timerupdating {
    _allTime += 0.05;
    //    NSLog(@"_alltime:-------%f", _allTime);
    if (_delegateFlags.recordTime) {
        [_delegate walme_cameraViewRecordTime:(_allTime)];
    }
}

- (void)walme_showCameraView {
//    _cameraView.hidden = NO;
    [_imageView removeFromSuperview];
    _beautySlider.hidden = !_showBeautySlider;
    
    [_avplayer.player pause];
    [_avplayer removeFromSuperlayer];
}

- (void)p_walme_showPhoto:(UIImage *)image {
    self.imageView.image = image;
    [self addSubview:_imageView];
}

- (void)p_walme_hideSlider {
    _beautySlider.hidden = YES;
}

- (void)p_walme_detecFace {
//    _metaDataOutput =[[AVCaptureMetadataOutput alloc] init];
//    if ([_videoCamera.captureSession canAddOutput:_metaDataOutput]) {
//        [_videoCamera.captureSession addOutput:_metaDataOutput];
//        NSArray* supportTypes = _metaDataOutput.availableMetadataObjectTypes;
//
//        //NSLog(@"supports:%@",supportTypes);
//        if ([supportTypes containsObject:AVMetadataObjectTypeFace]) {
//            [_metaDataOutput setMetadataObjectTypes:@[AVMetadataObjectTypeFace]];
//            [_metaDataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
//        }
//    }
}

- (void)p_walme_stopDetecFace {
//    [_videoCamera.captureSession removeOutput:_metaDataOutput];
}

- (void)setDelegate:(id<WALMECameraViewDelegate>)delegate {
    _delegate = delegate;
    _delegateFlags.recordTime = [_delegate respondsToSelector:@selector(walme_cameraViewRecordTime:)];
    _delegateFlags.detectFace = [_delegate respondsToSelector:@selector(walme_cameraViewDetectFaceResult:)];
}

#pragma mark - getter

- (NSString *)moviePath {
    if (!_moviePath) {
        _moviePath = WALMEVideoPath;
    }
    return _moviePath;
}

- (NSString *)compressdMoviePath {
    if (!_compressdMoviePath) {
        _compressdMoviePath = WALMECompressedVideoPath;
    }
    return _compressdMoviePath;
}

- (float)recordDuration {
    return _allTime;
}

#pragma mark - Lazy Property

//- (GPUImageFilterGroup *)normalFilter {
//    if (!_normalFilter) {
//        GPUImageFilter *filter = [[GPUImageFilter alloc] init];
//        _normalFilter = [[GPUImageFilterGroup alloc] init];
//        [(GPUImageFilterGroup *) _normalFilter setInitialFilters:[NSArray arrayWithObject:filter]];
//        [(GPUImageFilterGroup *) _normalFilter setTerminalFilter:filter];
//    }
//    return _normalFilter;
//}
//
//- (WALMEGPUImageBeautyFilter *)leveBeautyFilter {
//    if (!_leveBeautyFilter) {
//        _leveBeautyFilter = [[WALMEGPUImageBeautyFilter alloc] init];
//        _leveBeautyFilter.beautyLevel = _beautyValue;
//    }
//    return _leveBeautyFilter;
//}

- (NSDictionary *)videoSettings {
    if (!_videoSettings) {
        _videoSettings = @{
                           AVVideoCodecKey: AVVideoCodecH264,
                           AVVideoWidthKey: @(kCameraWidth),
                           AVVideoHeightKey: @(kCameraHeight),
                           };
    }
    return _videoSettings;
}

#pragma mark - lazy uiview property

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.userInteractionEnabled = YES;
    }
    return _imageView;
}

- (WALMEBeautySlider *)beautySlider {
    if (!_beautySlider) {
        _beautySlider = ({
            WALMEBeautySlider * slider = [[WALMEBeautySlider alloc] init];
            slider.minimumValue = 0;
            slider.maximumValue = 100;
            [slider setThumbImage:[UIImage imageNamed:@"walme_aremac_3"] forState:UIControlStateNormal];
            [slider addTarget:self action:@selector(p_walme_beautyValueChanged:) forControlEvents:UIControlEventValueChanged];
            slider.frame = CGRectMake(2 , 0 / 2, 0 - 6, 8);
            [slider setMinimumTrackImage:[UIImage imageNamed:@"walme_aremac_1"] forState:UIControlStateNormal];
            [slider setMaximumTrackImage:[UIImage imageNamed:@"walme_aremac_2"] forState:UIControlStateNormal];
            slider.value = 50;
            slider.frame = CGRectMake(0 / 2 - 25 , 0 / 2, 0, 8);
            slider.transform = CGAffineTransformMakeRotation(-M_PI_2);
            [self addSubview:slider];
            slider;
        });
    }
    return _beautySlider;
}

- (CALayer *)focusLayer {
    if (!_focusLayer) {
        UIImage *focusImage = [UIImage imageNamed:@"walme_aremac_7"];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, focusImage.size.width, focusImage.size.height)];
        imageView.image = focusImage;
        _focusLayer = imageView.layer;
        _focusLayer.hidden = YES;
    }
    return _focusLayer;
}

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self p_commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self p_commonInit];
    }
    return self;
}

- (void)p_commonInit {
//    self.backgroundColor = [UIColor blackColor];
//    _addBeautyFilter = YES;
//    _showBeautySlider = NO;
//    _cameraPosition = AVCaptureDevicePositionFront;
//    _outputImageOrientation = UIInterfaceOrientationPortrait;
    _beautyValue = 0.6;
    _allTime = 0;
//    _maxReocrdTime = 10;
//    _minReocrdTime = 3;
    _detectFace = NO;
    [self p_walme_setupUI];
    [self p_walme_setupNotification];
}

- (void)p_walme_setupUI {
//    _cameraView = ({
//        GPUImageView * g = [[GPUImageView alloc] init];
//        [g.layer addSublayer:self.focusLayer];
//        [g addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(focusTap:)]];
//        [g setFillMode:kGPUImageFillModePreserveAspectRatioAndFill];
//        [self addSubview:g];
//        g;
//    });
//
//    _videoCamera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPresetHigh cameraPosition:_cameraPosition];
//    _videoCamera.outputImageOrientation = _outputImageOrientation;
//    _videoCamera.horizontallyMirrorFrontFacingCamera = YES;
//    [self walme_recapture];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.26 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
//        [_videoCamera startCameraCapture];
//    });
}

- (void)p_walme_setupNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(p_walme_moviePlayDidEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(p_walme_applicationWillResignActive:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(p_walme_applicationDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
}

//- (void)p_walme_createNewWritter {
//    _movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:[NSURL fileURLWithPath:self.moviePath]
//                                                            size:CGSizeMake(kCameraWidth, kCameraHeight)
//                                                        fileType:AVFileTypeQuickTimeMovie
//                                                  outputSettings:self.videoSettings];
//    _movieWriter.hasAudioTrack = YES;
//    _movieWriter.shouldPassthroughAudio = YES;
//    /// 如果不加上这一句，会出现第一帧闪现黑屏
//    [_videoCamera addAudioInputsAndOutputs];
//    _videoCamera.audioEncodingTarget = _movieWriter;
//}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"🤩🤩🤩WALMECameraView dealloc🤩🤩🤩");
}

@end
