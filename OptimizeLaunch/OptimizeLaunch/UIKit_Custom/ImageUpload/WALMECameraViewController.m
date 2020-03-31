//
//  WALMECameraViewController.m
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import "WALMECameraViewController.h"
#import "WALMECameraDataSource.h"
#import "WALMEImageClipViewController.h"
#import "WALMEImageClipViewmodel.h"
#import "WALMEControllerHeader.h"
//#import "AppDelegate.h"
#import "WALMECameraView.h"

static const int kRoundWidth = 80;
static const int kLittleRoundWidth = 60;
static const int kLeftInterval = 40;

//拍照按钮的中间
#define kRecordCenter CGPointMake(self.view.width / 2, self.view.height - kLeftInterval - (kRoundWidth / 2))
//录像存储路径
#define RMDefaultVideoPath [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"movie.mov"]

@interface WALMECameraViewController () <CAAnimationDelegate, WALMEImageClipDelegate, WALMECameraViewDelegate> {
    UIImage *_tempImg;
    BOOL _shouldCapture;
}

//******** UIKit Property *************
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *cameraSwitch;
@property (nonatomic, strong) UIButton *recordButton;
@property (nonatomic, strong) UIButton *recaptureButton;
@property (nonatomic, strong) UIButton *commitButton;
//
@property (nonatomic, strong) WALMECameraView *cameraView;
//@property (nonatomic, strong) UILabel * noteLabel;

//******** Animation Property **********
@property (nonatomic, strong) CAShapeLayer * progressLayer;
@property (nonatomic, strong) UIView * roundFace;
@property (nonatomic, strong) UIView * littleRoundFace;
@property (nonatomic, strong) CALayer * focusLayer;

//******** Media Property **************
@property (nonatomic, copy) NSString *moviePath;

@end

@implementation WALMECameraViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self p_walme_setupUI];
//    _shouldCapture = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    if (_shouldCapture) {
//        [_cameraView walme_initCapture];
//        _shouldCapture = NO;
//    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.cameraView.frame = self.view.bounds;
//    self.noteLabel.frame = CGRectMake((self.view.width - 160) / 2, 0 - 190, 160, 20);
    
    self.recordButton.bounds = CGRectMake(0, 0, kRoundWidth, kRoundWidth);
    self.recordButton.center = kRecordCenter;
    
    const CGFloat width = 48;
    self.backButton.frame = CGRectMake(0, 0, width, width);
    self.backButton.center = CGPointMake(kLeftInterval + width / 2, kRecordCenter.y);
    
    self.cameraSwitch.frame = CGRectMake(0, 0, width, width);
    self.cameraSwitch.center = CGPointMake(self.view.width - width / 2 - kLeftInterval, kRecordCenter.y);
}

#pragma mark - Private Method

- (void)p_walme_setupUI {
    self.cameraView = ({
        WALMECameraView * cameraView = [[WALMECameraView alloc] init];
        cameraView.delegate = self;
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [cameraView walme_initCapture];
//        });
        [self.view addSubview:cameraView];
        cameraView;
    });
    
    self.backButton = ({
        UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
        [b setImage:[UIImage imageNamed:@"walme_camera_2"] forState:UIControlStateNormal];
        [b addTarget:self action:@selector(p_walme_cancelRecord:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:b];
        b;
    });
    
    if (_dataSource.isSwitchCamera) {
        [self.view addSubview:self.cameraSwitch];
    }
    
    _roundFace = ({
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(kRecordCenter.x - (kRoundWidth / 2), kRecordCenter.y - (kRoundWidth / 2), kRoundWidth, kRoundWidth)];
        view.backgroundColor = [UIColor walme_colorWithRGB:0xd9d9d9];
        view.layer.cornerRadius = kRoundWidth / 2;
        [self.view addSubview:view];
        view;
    });
    
    _littleRoundFace = ({
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(kRecordCenter.x - (kLittleRoundWidth / 2), kRecordCenter.y - (kLittleRoundWidth / 2), kLittleRoundWidth, kLittleRoundWidth)];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.cornerRadius = kLittleRoundWidth / 2;
        [self.view addSubview:view];
        view;
    });
    
    self.recordButton = ({
        UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:b];
        b;
    });
    
//    self.noteLabel = ({
//        UILabel * l = [[UILabel alloc] init];
//        l.text = _dataSource.takeNote;
//        l.textAlignment = NSTextAlignmentCenter;
//        l.textColor = [UIColor whiteColor];
//        l.font = [UIFont systemFontOfSize:15];
//        [self.view addSubview:l];
//        l;
//    });
    
    if (_dataSource.useFilter) {
        _cameraView.addBeautyFilter = YES;
    }
    
    if ([_dataSource.uploadType isEqualToString:@"photo"]) {
        [_recordButton addTarget:self action:@selector(p_walme_takePhoto:) forControlEvents:UIControlEventTouchDown];
    } else if ([_dataSource.uploadType isEqualToString:@"video"]) {
        [_recordButton addTarget:self action:@selector(p_walme_beginRecord:) forControlEvents:UIControlEventTouchDown];
        [_recordButton addTarget:self action:@selector(p_walme_endRecord:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    } else if ([_dataSource.uploadType isEqualToString:@"all"]) {
        [_recordButton addTarget:self action:@selector(p_walme_beginAllTypeRecord:) forControlEvents:UIControlEventTouchDown];
        [_recordButton addTarget:self action:@selector(p_walme_endAllTypeRecord:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    }
}

#pragma mark - Logic Method

- (void)p_walme_takePhoto:(UIButton *)sender {
    sender.enabled = NO;
    [UIView animateWithDuration:0.4 animations:^{
        CGFloat width = kRoundWidth + 20;
        _roundFace.frame = CGRectMake(kRecordCenter.x - (width / 2), kRecordCenter.y - (width / 2), width, width);
        _roundFace.layer.cornerRadius = width / 2;
        width = kLittleRoundWidth - 20;
        _littleRoundFace.frame = CGRectMake(kRecordCenter.x - (width / 2), kRecordCenter.y - (width / 2), width, width);
        _littleRoundFace.layer.cornerRadius = width / 2;
    }];
    
    sender.selected = YES;
    [sender setTitle:@"" forState:UIControlStateNormal];
    __weak typeof(self) weakSelf = self;
    [_cameraView walme_takePhoto:^(UIImage * _Nonnull image, NSError * _Nonnull error) {
        [weakSelf p_walme_finishTakePhotoWithImage:image];
    }];
}

- (void)p_walme_finishTakePhotoWithImage:(UIImage *)image {
    _tempImg = image;
    if (_dataSource.userEdit) {
        [self p_walme_pushEdit:image];
    } else {
        [self p_walme_showPhoto];
    }
}

- (void)p_walme_beginRecord:(UIButton *)sender {
    [UIView animateWithDuration:0.4 animations:^{
        CGFloat width = kRoundWidth + 20;
        _roundFace.frame = CGRectMake(kRecordCenter.x - (width / 2), kRecordCenter.y - (width / 2), width, width);
        _roundFace.layer.cornerRadius = width / 2;
        width = kLittleRoundWidth - 20;
        _littleRoundFace.frame = CGRectMake(kRecordCenter.x - (width / 2), kRecordCenter.y - (width / 2), width, width);
        _littleRoundFace.layer.cornerRadius = width / 2;
    }];
    
    [self.view.layer addSublayer:self.progressLayer];
    sender.selected = YES;
    [_cameraView walme_startRecordVideo];
}

- (void)p_walme_endRecord:(UIButton *)sender {
    sender.selected = NO;
    sender.enabled = NO;
    [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1.5 options:UIViewAnimationOptionTransitionCurlUp animations:^{
        self.recaptureButton.alpha = 1.0;
        self.commitButton.alpha = 1.0;
    } completion:^(BOOL finished) {
        
    }];
    if (_cameraView.recordDuration < _dataSource.minTime) {
        NSString * msg = [NSString stringWithFormat:@"视频最短为%d秒", (int)_dataSource.minTime];
//        [self.view showTextHUD:msg];
        [_cameraView walme_recapture];
        _progressLayer.path = nil;
        sender.enabled = YES;
        return;
    }
    __weak typeof(self) weakSelf = self;
    [_cameraView walme_endRecordVideo:^(NSString * _Nonnull videoPath) {
        [weakSelf p_walme_showPlayer];
    }];
}

- (void)p_walme_beginAllTypeRecord:(UIButton *)sender {
    [self p_walme_beginRecord:sender];
}

- (void)p_walme_endAllTypeRecord:(UIButton *)sender {
    [_cameraView walme_endReocrd:^(id  _Nonnull result, NSError * _Nullable error) {
        if ([result isKindOfClass:UIImage.class]) {
            [self p_walme_finishTakePhotoWithImage:(UIImage *)result];
        } else if ([result isKindOfClass:NSString.class]) {
            [self p_walme_showPlayer];
        }
    }];
}

- (void)p_walme_cancelRecord:(UIButton *)sender {
    [_focusLayer removeAllAnimations];
//    [self.videoCamera stopCameraCapture];
    [self dismissViewControllerAnimated:true completion:nil];
    if ([_delegate respondsToSelector:@selector(cancelCamera)]) {
        [_delegate cancelCamera];
    }
}

#pragma mark - WALMECameraViewDelegate

- (void)walme_cameraViewRecordTime:(float)time {
    [self updateProgress:time / _dataSource.maxTime playing:NO];
}

- (void)p_walme_showCameraView {
    [self p_walme_showInitView];
    
    CGFloat width = kRoundWidth;
    _roundFace.frame = CGRectMake(kRecordCenter.x - (width / 2), kRecordCenter.y - (width / 2), width, width);
    _roundFace.layer.cornerRadius = width / 2;
    width = kLittleRoundWidth;
    _littleRoundFace.frame = CGRectMake(kRecordCenter.x - (width / 2), kRecordCenter.y - (width / 2), width, width);
    _littleRoundFace.layer.cornerRadius = width / 2;
}

- (void)p_walme_showPhoto {
    [self p_walme_hideInitView];
    
    [self.recaptureButton removeFromSuperview];
    [self.commitButton removeFromSuperview];
    [self.view addSubview:_recaptureButton];
    [self.view addSubview:_commitButton];
}

- (void)p_walme_showPlayer {
    [self p_walme_hideInitView];
    
    [self.recaptureButton removeFromSuperview];
    [self.commitButton removeFromSuperview];
    [self.view addSubview:_recaptureButton];
    [self.view addSubview:_commitButton];
}

- (void)p_walme_hideInitView {
    _recordButton.enabled = NO;
    _recordButton.hidden = YES;
    _roundFace.hidden = YES;
    _littleRoundFace.hidden = YES;
    _backButton.hidden = YES;
    _cameraSwitch.hidden = YES;
    [_progressLayer removeFromSuperlayer];
    _progressLayer.path = nil;
}

- (void)p_walme_showInitView {
    _recordButton.enabled = YES;
    _recordButton.hidden = NO;
    _roundFace.hidden = NO;
    _littleRoundFace.hidden = NO;
    _backButton.hidden = NO;
    _cameraSwitch.hidden = !_dataSource.isSwitchCamera;
    [self.recaptureButton removeFromSuperview];
    [self.commitButton removeFromSuperview];
}

#pragma mark - User Action

- (void)p_walme_commitAction:(UIButton *)sender {
//    MBProgressHUD * hud = [self.view customProgressHUDTitle:@"0%"];
    __weak typeof(self) weakSelf = self;
    id waitUpload;
    sender.enabled = NO;
    if ([_dataSource.uploadType isEqualToString:@"photo"]) {
        waitUpload = _tempImg;
    } else if ([_dataSource.uploadType isEqualToString:@"video"]) {
        waitUpload = RMDefaultVideoPath;
    } else if ([_dataSource.uploadType isEqualToString:@"all"]) {
        if (_tempImg) {
            waitUpload = _tempImg;
        } else {
             waitUpload = RMDefaultVideoPath;
        }
    }
    if ([waitUpload isKindOfClass:[UIImage class]]) {
        sender.enabled = NO;
        [_dataSource walme_uploadImage:_tempImg progress:^(float progressValue) {
//            hud.detailsLabel.text = [NSString stringWithFormat:@"%.2f%%", progressValue];
        } result:^(NSError * _Nullable error, id  _Nonnull result) {
            sender.enabled = YES;
//            [hud hideAnimated:YES];
            if (!error) {
                NSString * path = result[@"aliOSS"][@"data"][@"photo_url"];
                NSString * name = result[@"objectKey"];
                if ([weakSelf.delegate respondsToSelector:@selector(walme_imageUploadFromCamera:originImage:clipImage:originPath:clipPath:originName:clipName:originResult:clipResult:error:)]) {
                    [weakSelf.delegate walme_imageUploadFromCamera:weakSelf originImage:waitUpload clipImage:nil originPath:path clipPath:nil originName:name clipName:nil originResult:result clipResult:nil error:error];
                }
            } else {
//                [self.view showTextHUD:error.localizedDescription];
            }
        }];
    } else {
        //            [_avplayer.player pause];
        __weak typeof(self) weakSelf = self;
        sender.enabled = NO;
        [_dataSource walme_uploadVideo:RMDefaultVideoPath progress:^(float progressValue) {
//            hud.detailsLabel.text = [NSString stringWithFormat:@"%.2f%%", progressValue];
        } result:^(NSError * _Nullable error, id  _Nonnull result) {
            sender.enabled = YES;
//            [hud hideAnimated:YES];
            if (!error) {
                if ([weakSelf.delegate respondsToSelector:@selector(walme_videoUploadFromeCamera:videoPath:gifUrl:videoCover:error:result:)]) {
                    [weakSelf.delegate walme_videoUploadFromeCamera:weakSelf videoPath:RMDefaultVideoPath gifUrl:nil videoCover:nil error:error result:result];
                }
            } else {
//                [self.view showTextHUD:error.localizedDescription];
            }
        }];
    }
}

- (void)p_walme_recaptureAction {
    [self p_walme_showCameraView];
    [_cameraView walme_recapture];
//    [_cameraView walme_showCameraView];
    _tempImg = nil;
    [[NSFileManager defaultManager] removeItemAtPath:RMDefaultVideoPath error:nil];
}

- (void)p_walme_turnAction:(id)sender {
    [_cameraView walme_switchCamera];
}

- (void)p_walme_pushEdit:(UIImage *)image {
    WALMEImageClipViewController * clip = [[WALMEImageClipViewController alloc] init];
    WALMEImageClipViewmodel * viewmodel = [[WALMEImageClipViewmodel alloc] initWithNSDictionary:_dataSource.aliDic];
    clip.viewmodel = viewmodel;
    clip.delegate = self;
    clip.image = image;
    clip.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:clip animated:YES completion:nil];
}

#pragma mark - WALMEImageClipDelegate
- (void)imageUploadFromClip:(UIImage *)originImage
                  clipImage:(UIImage *)clipImage
                 originPath:(NSString *)originPath
                   clipPath:(NSString *)clipPath
                 originName:(NSString *)originName
                   clipName:(NSString *)clipName
               originResult:(id)originResult
                 clipResult:(id)clipResult
                      error:(NSError *)error {
    if ([_delegate respondsToSelector:@selector(walme_imageUploadFromCamera:originImage:clipImage:originPath:clipPath:originName:
                                                clipName:originResult:clipResult:error:)]) {
        [_delegate walme_imageUploadFromCamera:self originImage:originImage clipImage:clipImage originPath:originPath clipPath:clipPath originName:originName clipName:clipName originResult:originResult clipResult:clipResult error:error];
    }
}

- (void)walme_clipCancle {
    [self p_walme_recaptureAction];
}

/**
 更新进度条
 
 @param value 进度
 @param playing 是否是播放
 */
- (void)updateProgress:(CGFloat)value playing:(BOOL)playing {
    if (value > 1.0) {
        [self p_walme_endRecord:self.recordButton];
    } else {
        NSLog(@"%f", value);
        UIBezierPath * path = [UIBezierPath bezierPathWithArcCenter:kRecordCenter radius:(kRoundWidth - 10) / 2 + 16 startAngle:- M_PI_2 endAngle:2 * M_PI * (value) - M_PI_2 clockwise:YES];
        self.progressLayer.path = path.CGPath;
    }
}

- (NSString *)moviePath {
    if (!_moviePath) {
        _moviePath = RMDefaultVideoPath;
        NSLog(@"maru: %@",_moviePath);
    }
    return _moviePath;
}

#pragma mark - lazy UIView property

- (UIButton *)commitButton {
    if (!_commitButton) {
        _commitButton = ({
            UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
            [b addTarget:self action:@selector(p_walme_commitAction:) forControlEvents:UIControlEventTouchUpInside];
            [b setImage:[UIImage imageNamed:@"walme_camera_3"] forState:UIControlStateNormal];
            b.frame = CGRectMake(0, 0, kRoundWidth, kRoundWidth);
            b.right = self.view.width - kLeftInterval;
            b.bottom = self.view.height - kLeftInterval;
            b;
        });
    }
    return _commitButton;
}


- (UIButton *)recaptureButton {
    if (!_recaptureButton) {
        _recaptureButton = ({
            UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
            [b setImage:[UIImage imageNamed:@"walme_camera_2"] forState:UIControlStateNormal];
            [b addTarget:self action:@selector(p_walme_recaptureAction) forControlEvents:UIControlEventTouchUpInside];
            b.bounds = CGRectMake(0, 0, kRoundWidth, kRoundWidth);
            b.left = kLeftInterval;
            b.bottom = self.view.height - kLeftInterval;
            b;
        });
    }
    return _recaptureButton;
}

- (CAShapeLayer *)progressLayer {
    if (!_progressLayer) {
        _progressLayer = ({
            CAShapeLayer *l = [CAShapeLayer layer];
            l.lineWidth = 5.0f;
            l.fillColor = nil;
            l.strokeColor = [UIColor whiteColor].CGColor;
            l.lineCap = kCALineCapRound;
            l;
        });
    }
    return _progressLayer;
}

- (UIButton *)cameraSwitch {
    if (!_cameraSwitch) {
        _cameraSwitch = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:[UIImage imageNamed:@"walme_camera_1"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(p_walme_turnAction:) forControlEvents:UIControlEventTouchUpInside];
            button.hidden = !_dataSource.isSwitchCamera;
            button;
        });
    }
    return _cameraSwitch;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (void)dealloc {
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"🤩🤩🤩WALMECameraViewController deallc🤩🤩🤩");
}

@end
