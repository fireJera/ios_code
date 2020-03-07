//
//  MediaPreviewViewController.m
//  PhotoPick
//
//  Created by Jeremy on 2019/3/23.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import "MediaPreviewViewController.h"
#import "CustomNavigationBar.h"
#import "CircleProgressView.h"
#import "PhotoModel.h"
#import "AlbumTool.h"
//#import "MediaPreviewInteractiveTransition.h"
//#import "MediaPreviewPresentTransition.h"
//#import "MediaPreviewTransition.h"

@interface MediaPreviewCell : UICollectionViewCell <UIScrollViewDelegate,PHLivePhotoViewDelegate>

@property (strong, nonatomic) PhotoModel *model;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIImage * gifImage;
@property (assign, nonatomic) BOOL dragging;
@property (nonatomic, copy) void (^cellTapClick)(void);
@property (nonatomic, copy) void (^cellDidPlayVideoBtn)(BOOL play);

@property (strong, nonatomic) UIScrollView *scrollView;
@property (assign, nonatomic) CGPoint imageCenter;
@property (strong, nonatomic) UIImage *gifFirstFrame;
@property (assign, nonatomic) PHImageRequestID requestID;
@property (strong, nonatomic) PHLivePhotoView *livePhotoView;
@property (assign, nonatomic) BOOL livePhotoAnimating;
@property (strong, nonatomic) AVPlayerLayer *playerLayer;
@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) UIButton *videoPlayBtn;
@property (strong, nonatomic) CircleProgressView *progressView;             // 进度圈

- (void)resetScale;
- (void)requestHDImage;
- (void)cancelRequest;

@end

@implementation MediaPreviewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.requestID = -1;
        [self setup];
    }
    return self;
}

#pragma mark - set view

- (void)setup {
    [self.contentView addSubview:self.scrollView];
    [self.scrollView addSubview:self.imageView];
    [self.contentView.layer addSublayer:self.playerLayer];
    [self.contentView addSubview:self.videoPlayBtn];
    [self.contentView addSubview:self.progressView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.scrollView.frame = self.bounds;
    self.playerLayer.frame = self.bounds;
    self.scrollView.contentSize = CGSizeMake(self.width, self.height);
    self.progressView.center = CGPointMake(self.width / 2, self.height / 2);
}

#pragma mark - setter
- (void)setModel:(PhotoModel *)model {
    _model = model;
    [self cancelRequest];
    self.playerLayer.player = nil;
    self.player = nil;
    self.progressView.hidden = YES;
    self.progressView.progress = 0;
    self.videoPlayBtn.userInteractionEnabled = YES;
    
    [self resetScale];
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    CGFloat imgWidth = self.model.imageSize.width;
    CGFloat imgHeight = self.model.imageSize.height;
    CGFloat w;
    CGFloat h;
    
    imgHeight = width / imgWidth * imgHeight;
    if (imgHeight > height) {
        w = height / self.model.imageSize.height * imgWidth;
        h = height;
        self.scrollView.maximumZoomScale = width / w + 0.5;
    }else {
        w = width;
        h = imgHeight;
        self.scrollView.maximumZoomScale = 2.5;
    }
    self.imageView.frame = CGRectMake(0, 0, w, h);
    self.imageView.center = CGPointMake(width / 2, height / 2);
    
    self.imageView.hidden = NO;
    __weak typeof(self) weakSelf = self;
    
    //    if (model.type == PhotoModelMediaTypeCameraPhoto || model.type == PhotoModelMediaTypeCameraVideo) {
    //        self.imageView.image = model.thumbPhoto;
    //        model.tempImage = nil;
    //    }
    //    else {
    if (model.type == PhotoModelMediaTypeLive) {
        if (model.tempImage) {
            self.imageView.image = model.tempImage;
            model.tempImage = nil;
        } else {
            self.requestID = [AlbumTool getPhotoForPHAsset:model.asset
                                                      size:CGSizeMake(self.width * 0.5, self.height * 0.5)
                                                completion:^(UIImage * _Nonnull image, NSDictionary * _Nonnull info) {
                                                    weakSelf.imageView.image = image;
                                                }];
        }
    } else {
        if (model.previewPhoto) {
            self.imageView.image = model.previewPhoto;
            model.tempImage = nil;
        } else {
            if (model.tempImage) {
                self.imageView.image = model.tempImage;
                model.tempImage = nil;
            } else {
                PHImageRequestID requestID;
                if (imgHeight > imgWidth / 9 * 17) {
                    requestID = [AlbumTool getPhotoForPHAsset:model.asset
                                                         size:CGSizeMake(self.width * 0.6, self.height * 0.6)
                                                   completion:^(UIImage * _Nonnull image, NSDictionary * _Nonnull info) {
                                                       weakSelf.imageView.image = image;
                                                   }];
                } else {
                    requestID = [AlbumTool getPhotoForPHAsset:model.asset size:CGSizeMake(model.endImageSize.width * 0.8, model.endImageSize.height * 0.8) completion:^(UIImage *image, NSDictionary *info) {
                        weakSelf.imageView.image = image;
                    }];
                }
                self.requestID = requestID;
            }
        }
    }
    //    }
    if (model.subType == PhotoModelMediaSubTypeVideo) {
        self.playerLayer.hidden = NO;
        self.videoPlayBtn.hidden = NO;
    } else {
        self.playerLayer.hidden = YES;
        self.videoPlayBtn.hidden = YES;
    }
}

#pragma mark - public func

- (void)resetScale {
    [self.scrollView setZoomScale:1.0 animated:NO];
}

- (void)cancelRequest {
    if (self.requestID) {
        [[PHImageManager defaultManager] cancelImageRequest:self.requestID];
        self.requestID = -1;
    }
    self.progressView.hidden = YES;
    self.progressView.progress = 0;
    self.videoPlayBtn.userInteractionEnabled = YES;
    if (self.model.type == PhotoModelMediaTypeLive) {
        if (_livePhotoView.livePhoto) {
            self.livePhotoView.livePhoto = nil;
            [self.livePhotoView removeFromSuperview];
            self.imageView.hidden = NO;
            [self stopLivePhoto];
        }
    }else if (self.model.type == PhotoModelMediaTypePhoto) {
        
    }else if (self.model.type == PhotoModelMediaTypePhoto) {
        self.imageView.image = nil;
        self.gifImage = nil;
        self.imageView.image = self.gifFirstFrame;
    }
    if (self.model.subType == PhotoModelMediaSubTypeVideo) {
        if (self.player != nil) {
            [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
            [self.player pause];
            self.videoPlayBtn.selected = NO;
            [self.player seekToTime:kCMTimeZero];
            self.playerLayer.player = nil;
            self.player = nil;
        }
    }
}

- (void)requestHDImage {
    if (self.requestID) {
        [[PHImageManager defaultManager] cancelImageRequest:self.requestID];
        self.requestID = -1;
    }
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    CGFloat imgWidth = self.model.imageSize.width;
    CGFloat imgHeight = self.model.imageSize.height;
    CGSize size;
    __weak typeof(self) weakSelf = self;
    if (imgHeight > imgWidth / 9 * 17) {
        size = CGSizeMake(width, height);
    }else {
        size = CGSizeMake(_model.endImageSize.width * 2.0, _model.endImageSize.height * 2.0);
    }
    if (self.model.type == PhotoModelMediaTypeLive) {
        if (_livePhotoView.livePhoto) {
            [self.livePhotoView stopPlayback];
            [self.livePhotoView startPlaybackWithStyle:PHLivePhotoViewPlaybackStyleFull];
            return;
        }
        self.requestID = [AlbumTool fetchLivePhotoForPHAsset:self.model.asset size:self.model.endImageSize completion:^(PHLivePhoto * _Nonnull livePhoto, NSDictionary * _Nonnull info) {
            weakSelf.livePhotoView.frame = weakSelf.imageView.frame;
            [weakSelf.scrollView addSubview:weakSelf.livePhotoView];
            weakSelf.imageView.hidden = YES;
            weakSelf.livePhotoView.livePhoto = livePhoto;
            [weakSelf.livePhotoView startPlaybackWithStyle:PHLivePhotoViewPlaybackStyleFull];
        }];
    } else if (self.model.type == PhotoModelMediaTypePhoto) {
        self.requestID = [AlbumTool getHighQualityFormatPhoto:_model.asset size:size startRequestIcloud:^(PHImageRequestID cloudRequestId) {
            weakSelf.progressView.hidden = NO;
            weakSelf.requestID = cloudRequestId;
        } progressHandler:^(double progress) {
            weakSelf.progressView.hidden = NO;
            weakSelf.progressView.progress = progress;
        } completion:^(UIImage * _Nonnull image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.progressView.hidden = YES;
                weakSelf.imageView.image = image;
            });
        } failed:^(NSDictionary * _Nonnull info) {
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.progressView.hidden = YES;
            });
        }];
    } else if (self.model.type == PhotoModelMediaTypePhoto) {
        if (self.gifImage) {
            self.imageView.image = self.gifImage;
        } else {
            self.requestID = [AlbumTool getImageData:_model.asset startRequestIcloud:^(PHImageRequestID cloudRequestId) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.progressView.hidden = NO;
                    weakSelf.requestID = cloudRequestId;
                });
            } progressHandler:^(double progress) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.progressView.hidden = NO;
                    weakSelf.progressView.progress = progress;
                });
            } completion:^(NSData * _Nonnull imageData, UIImageOrientation orientation) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIImage *gifImage = [UIImage animatedGIFWithData:imageData];
                    if (gifImage.images.count == 0) {
                        weakSelf.gifFirstFrame = gifImage;
                        //                        weakSelf.imageView.image = gifImage;
                    }else {
                        weakSelf.gifFirstFrame = gifImage.images.firstObject;
                        //                        weakSelf.imageView.image = weakSelf.gifFirstFrame;
                    }
                    weakSelf.model.tempImage = nil;
                    weakSelf.imageView.image = gifImage;
                    weakSelf.gifImage = gifImage;
                });
            } failed:^(NSDictionary * _Nonnull info) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.progressView.hidden = YES;
                });
            }];
        }
    }
    if (self.player != nil) return;
    if (self.model.type == PhotoModelMediaTypeVideo) {
        self.requestID = [AlbumTool getPlayerItemWithPHAsset:_model.asset startRequestIcloud:^(PHImageRequestID cloudRequestId) {
            weakSelf.progressView.hidden = NO;
            weakSelf.requestID = cloudRequestId;
            weakSelf.videoPlayBtn.userInteractionEnabled = NO;
        } progressHandler:^(double progress) {
            weakSelf.progressView.hidden = NO;
            weakSelf.progressView.progress = progress;
        } completion:^(AVPlayerItem * _Nonnull playerItem) {
            weakSelf.videoPlayBtn.userInteractionEnabled = YES;
            weakSelf.player = [AVPlayer playerWithPlayerItem:playerItem];
            weakSelf.playerLayer.player = weakSelf.player;
            [[NSNotificationCenter defaultCenter] addObserver:weakSelf selector:@selector(pausePlayerAndShowNaviBar) name:AVPlayerItemDidPlayToEndTimeNotification object:weakSelf.player.currentItem];
        } failed:^(NSDictionary * _Nonnull info) {
            weakSelf.videoPlayBtn.userInteractionEnabled = YES;
            weakSelf.progressView.hidden = YES;
        }];
    }
    //    else if (self.model.type == PhotoModelMediaTypeCameraVideo ) {
    //        self.player = [AVPlayer playerWithPlayerItem:[AVPlayerItem playerItemWithURL:self.model.videoURL]];
    //        self.playerLayer.player = self.player;
    //        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pausePlayerAndShowNaviBar) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
    //    }
}

#pragma mark - private func

- (void)pausePlayerAndShowNaviBar {
    [self.player pause];
    self.videoPlayBtn.selected = NO;
    if (@available(iOS 11.0, *)) {
        [self.player.currentItem seekToTime:CMTimeMake(0, 1) completionHandler:nil];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
        [self.player.currentItem seekToTime:CMTimeMake(0, 1)];
#pragma clang diagnostic pop
    }
}

#pragma mark - touch event

- (void)didPlayBtnClick:(UIButton *)button {
    button.selected = !button.selected;
    if (button.selected) {
        [self.player play];
    } else {
        [self.player pause];
    }
    if (self.cellDidPlayVideoBtn) {
        self.cellDidPlayVideoBtn(button.selected);
    }
}

- (void)singleTap:(UITapGestureRecognizer *)tap {
    if (self.cellTapClick) {
        self.cellTapClick();
    }
}

- (void)doubleTap:(UITapGestureRecognizer *)tap {
    if (_scrollView.zoomScale > 1.0) {
        [_scrollView setZoomScale:1.0 animated:YES];
    } else {
        CGFloat width = self.frame.size.width;
        CGFloat height = self.frame.size.height;
        CGPoint touchPoint;
        if (self.model.type == PhotoModelMediaTypeLive) {
            touchPoint = [tap locationInView:self.livePhotoView];
        } else {
            touchPoint = [tap locationInView:self.imageView];
        }
        CGFloat newZoomScale = self.scrollView.maximumZoomScale;
        CGFloat xsize = width / newZoomScale;
        CGFloat ysize = height / newZoomScale;
        [self.scrollView zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
    }
}

#pragma mark - PHLivePhotoViewDelegate
- (void)livePhotoView:(PHLivePhotoView *)livePhotoView willBeginPlaybackWithStyle:(PHLivePhotoViewPlaybackStyle)playbackStyle {
    self.livePhotoAnimating = YES;
}
- (void)livePhotoView:(PHLivePhotoView *)livePhotoView didEndPlaybackWithStyle:(PHLivePhotoViewPlaybackStyle)playbackStyle {
    [self stopLivePhoto];
}
- (void)stopLivePhoto {
    self.livePhotoAnimating = NO;
    [self.livePhotoView stopPlayback];
}

#pragma mark - UIScrollViewDelegate
- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    if (self.model.type == PhotoModelMediaTypeLive) {
        return self.livePhotoView;
    }else {
        return self.imageView;
    }
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat offsetX = (scrollView.frame.size.width > scrollView.contentSize.width) ? (scrollView.frame.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.frame.size.height > scrollView.contentSize.height) ? (scrollView.frame.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    
    if (self.model.type == PhotoModelMediaTypeLive) {
        self.livePhotoView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
    }else {
        self.imageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
    }
}

#pragma mark - lazy property

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.bouncesZoom = YES;
        _scrollView.minimumZoomScale = 1;
        _scrollView.multipleTouchEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.scrollsToTop = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _scrollView.delaysContentTouches = NO;
        _scrollView.canCancelContentTouches = YES;
        _scrollView.alwaysBounceVertical = NO;
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        [_scrollView addGestureRecognizer:tap1];
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
        tap2.numberOfTapsRequired = 2;
        [tap1 requireGestureRecognizerToFail:tap2];
        [_scrollView addGestureRecognizer:tap2];
    }
    return _scrollView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

- (PHLivePhotoView *)livePhotoView {
    if (!_livePhotoView) {
        _livePhotoView = [[PHLivePhotoView alloc] init];
        _livePhotoView.clipsToBounds = YES;
        _livePhotoView.contentMode = UIViewContentModeScaleAspectFill;
        _livePhotoView.delegate = self;
    }
    return _livePhotoView;
}

- (UIButton *)videoPlayBtn {
    if (!_videoPlayBtn) {
        _videoPlayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_videoPlayBtn setImage:[AlbumTool imageNamed:@"multimedia_videocard_play@2x.png"] forState:UIControlStateNormal];
        [_videoPlayBtn setImage:[[UIImage alloc] init] forState:UIControlStateSelected];
        [_videoPlayBtn addTarget:self action:@selector(didPlayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _videoPlayBtn.frame = self.bounds;
        _videoPlayBtn.hidden = YES;
    }
    return _videoPlayBtn;
}

- (CircleProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[CircleProgressView alloc] init];
        _progressView.hidden = YES;
    }
    return _progressView;
}

- (AVPlayerLayer *)playerLayer {
    if (!_playerLayer) {
        _playerLayer = [[AVPlayerLayer alloc] init];
        _playerLayer.hidden = YES;
    }
    return _playerLayer;
}

- (void)dealloc {
    [self cancelRequest];
}

@end

@interface MediaPreviewViewController () <UICollectionViewDataSource,UICollectionViewDelegate
//,UIViewControllerTransitioningDelegate
>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UICollectionViewFlowLayout *flowLayout;
@property (strong, nonatomic) PhotoModel *currentModel;
@property (strong, nonatomic) UIView *customTitleView;
@property (strong, nonatomic) UILabel *titleLb;
@property (strong, nonatomic) UILabel *subTitleLb;
@property (strong, nonatomic) MediaPreviewCell *tempCell;
@property (strong, nonatomic) UIButton *selectBtn;
@property (assign, nonatomic) BOOL orientationDidChange;
@property (assign, nonatomic) NSInteger beforeOrientationIndex;
//@property (strong, nonatomic) MediaPreviewInteractiveTransition *interactiveTransition;
@property (strong, nonatomic) CustomNavigationBar *navBar;
@property (strong, nonatomic) UINavigationItem *navItem;

@end

@implementation MediaPreviewViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        //        self.transitioningDelegate = self;
        self.modalPresentationStyle = UIModalPresentationCustom;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationChanged:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationWillChanged:) name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
    
    //    if (!self.outside) {
    //        //初始化手势过渡的代理
    //        self.interactiveTransition = [[MediaPreviewInteractiveTransition alloc] init];
    //        //给当前控制器的视图添加手势
    //        [self.interactiveTransition addPanGestureForViewController:self];
    //    }
}

//#pragma mark -  UIViewControllerTransitioningDelegate
//- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
//    if (operation == UINavigationControllerOperationPush) {
//        return [MediaPreviewTransition transitionWithType:MediaPreviewTransitionTypePush];
//    } else {
//        if (![fromVC isKindOfClass:[self class]]) {
//            return nil;
//        }
//        return [MediaPreviewTransition transitionWithType:MediaPreviewTransitionTypePop];
//    }
//}
//
//- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController{
//    return self.interactiveTransition.interation ? self.interactiveTransition : nil;
//}
//
//- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
//    return [MediaPreviewPresentTransition transitionWithTransitionType:MediaPreviewPresentTransitionTypePresent photoView:self.photoView];
//}
//
//- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
//    return [MediaPreviewPresentTransition transitionWithTransitionType:MediaPreviewPresentTransitionTypeDismiss photoView:self.photoView];
//}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    PhotoModel *model = self.modelArray[self.currentModelIndex];
    self.currentModel = model;
    MediaPreviewCell *cell = (MediaPreviewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentModelIndex inSection:0]];
    if (!cell) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            MediaPreviewCell *tempCell = (MediaPreviewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentModelIndex inSection:0]];
            self.tempCell = tempCell;
            [tempCell requestHDImage];
        });
    }else {
        self.tempCell = cell;
        [cell requestHDImage];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    MediaPreviewCell *cell = (MediaPreviewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentModelIndex inSection:0]];
    [cell cancelRequest];
}

#pragma mark - set view

- (void)setupUI {
    self.navigationItem.titleView = self.customTitleView;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    self.beforeOrientationIndex = self.currentModelIndex;
    [self changeSubviewFrame];
    PhotoModel *model = self.modelArray[self.currentModelIndex];
    if (!self.outside) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.selectBtn];
        self.selectBtn.selected = model.selected;
        [self.selectBtn setTitle:model.selectIndexStr forState:UIControlStateSelected];
        self.selectBtn.backgroundColor = self.selectBtn.selected ? self.view.tintColor : nil;
        //        if ([self.viewmodel.selectedList containsObject:model]) {
        //            self.bottomView.currentIndex = [self.viewmodel.selectedList indexOfObject:model];
        //        } else {
        //            [self.bottomView deselected];
        //        }
    } else {
        //        self.bottomView.selectCount = self.viewmodel.endSelectedList.count;
        //        if ([self.viewmodel.endSelectedList containsObject:model]) {
        //            self.bottomView.currentIndex = [self.viewmodel.endSelectedList indexOfObject:model];
        //        }else {
        //            [self.bottomView deselected];
        //        }
        [self.view addSubview:self.navBar];
    }
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (self.orientationDidChange) {
        self.orientationDidChange = NO;
        [self changeSubviewFrame];
    }
}

- (void)changeSubviewFrame {
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    PhotoModel *model = self.modelArray[self.currentModelIndex];
    if (orientation == UIInterfaceOrientationPortrait || UIInterfaceOrientationPortrait == UIInterfaceOrientationPortraitUpsideDown) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
        self.titleLb.hidden = NO;
        self.customTitleView.frame = CGRectMake(0, 0, 150, 44);
        self.titleLb.frame = CGRectMake(0, 9, 150, 14);
        self.subTitleLb.frame = CGRectMake(0, CGRectGetMaxY(self.titleLb.frame) + 4, 150, 12);
        self.titleLb.text = model.barTitle;
        self.subTitleLb.text = model.barSubTitle;
    } else if (orientation == UIInterfaceOrientationLandscapeRight || orientation == UIInterfaceOrientationLandscapeLeft){
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
        self.customTitleView.frame = CGRectMake(0, 0, 200, 30);
        self.titleLb.hidden = YES;
        self.subTitleLb.frame = CGRectMake(0, 0, 200, 30);
        self.subTitleLb.text = [NSString stringWithFormat:@"%@  %@",model.barTitle,model.barSubTitle];
    }
    CGFloat bottomMargin = kBottomMargin;
    //    CGFloat leftMargin = 0;
    //    CGFloat rightMargin = 0;
    CGFloat width = self.view.width;
    CGFloat itemMargin = 20;
    if (kDevice_Is_iPhoneX && (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight)) {
        bottomMargin = 21;
        //        leftMargin = 35;
        //        rightMargin = 35;
        //        width = self.view.width - 70;
    }
    self.flowLayout.itemSize = CGSizeMake(width, self.view.height - kTopMargin - bottomMargin);
    self.flowLayout.minimumLineSpacing = itemMargin;
    
    [self.collectionView setCollectionViewLayout:self.flowLayout];
    
    //    self.collectionView.contentInset = UIEdgeInsetsMake(0, leftMargin, 0, rightMargin);
    if (self.outside) {
        self.navBar.frame = CGRectMake(0, 0, self.view.width, kNavigationBarHeight);
    }
    self.collectionView.frame = CGRectMake(-(itemMargin / 2), kTopMargin,self.view.width + itemMargin, self.view.height - kTopMargin - bottomMargin);
    self.collectionView.contentSize = CGSizeMake(self.modelArray.count * (self.view.width + itemMargin), 0);
    
    [self.collectionView setContentOffset:CGPointMake(self.beforeOrientationIndex * (self.view.width + itemMargin), 0)];
    
    [UIView performWithoutAnimation:^{
        [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:self.beforeOrientationIndex inSection:0]]];
    }];
    
    //    self.bottomView.frame = CGRectMake(0, self.view.height - 50 - bottomMargin, self.view.width, 50 + bottomMargin);
}

#pragma mark - notification

- (void)deviceOrientationChanged:(NSNotification *)notify {
    self.orientationDidChange = YES;
}

- (void)deviceOrientationWillChanged:(NSNotification *)notify {
    self.beforeOrientationIndex = self.currentModelIndex;
}

#pragma mark - touch event

- (void)didSelectClick:(UIButton *)button {
    if (self.modelArray.count <= 0 || self.outside) {
        [self.view showImageHUDText:@"没有照片可选!"];
        return;
    }
    PhotoModel *model = self.modelArray[self.currentModelIndex];
    if (button.selected) {
        button.selected = NO;
        //        if (model.type != PhotoModelMediaTypeCameraVideo && model.type != PhotoModelMediaTypeCameraPhoto) {
        //            model.thumbPhoto = nil;
        //            model.previewPhoto = nil;
        //        }
        if ((model.type == PhotoModelMediaTypePhoto || model.type == PhotoModelMediaTypePhoto) ||
            (model.type == PhotoModelMediaTypeVideo || model.type == PhotoModelMediaTypeLive)) {
            if (model.type == PhotoModelMediaTypePhoto || model.type == PhotoModelMediaTypePhoto || model.type == PhotoModelMediaTypeLive) {
                [self.viewmodel.selectedPhotos removeObject:model];
            }else if (model.type == PhotoModelMediaTypeVideo) {
                [self.viewmodel.selectedVideos removeObject:model];
            }
        }
        //        else if (model.type == PhotoModelMediaTypeCameraPhoto || model.type == PhotoModelMediaTypeCameraVideo) {
        //            if (model.type == PhotoModelMediaTypeCameraPhoto) {
        //                [self.viewmodel.selectedPhotos removeObject:model];
        //                [self.viewmodel.selectedCameraPhotos removeObject:model];
        //            }else if (model.type == PhotoModelMediaTypeCameraVideo) {
        //                [self.viewmodel.selectedVideos removeObject:model];
        //                [self.viewmodel.selectedCameraVideos removeObject:model];
        //            }
        //            [self.viewmodel.selectedCameraList removeObject:model];
        //        }
        [self.viewmodel.selectedList removeObject:model];
        model.selectIndexStr = @"";
    } else {
        NSString *str = [AlbumTool maximumOfJudgment:model viewmodel:self.viewmodel];
        if (str) {
            [self.view showImageHUDText:str];
            return;
        }
        MediaPreviewCell *cell = (MediaPreviewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentModelIndex inSection:0]];
        if (model.type == PhotoModelMediaTypePhoto) {
            if (cell.imageView.image.images.count > 0) {
                model.thumbPhoto = cell.imageView.image.images.firstObject;
                model.previewPhoto = cell.imageView.image.images.firstObject;
            }else {
                model.thumbPhoto = cell.imageView.image;
                model.previewPhoto = cell.imageView.image;
            }
        }else {
            model.thumbPhoto = cell.imageView.image;
            model.previewPhoto = cell.imageView.image;
        }
        if (model.type == PhotoModelMediaTypePhoto || (model.type == PhotoModelMediaTypePhoto || model.type == PhotoModelMediaTypeLive)) { // 为图片时
            [self.viewmodel.selectedPhotos addObject:model];
        } else if (model.type == PhotoModelMediaTypeVideo) { // 为视频时
            [self.viewmodel.selectedVideos addObject:model];
        }
        //        else if (model.type == PhotoModelMediaTypeCameraPhoto) {
        //            // 为相机拍的照片时
        //            [self.viewmodel.selectedPhotos addObject:model];
        //            [self.viewmodel.selectedCameraPhotos addObject:model];
        //            [self.viewmodel.selectedCameraList addObject:model];
        //        }
        //        else if (model.type == PhotoModelMediaTypeCameraVideo) {
        //            // 为相机录的视频时
        //            [self.viewmodel.selectedVideos addObject:model];
        //            [self.viewmodel.selectedCameraVideos addObject:model];
        //            [self.viewmodel.selectedCameraList addObject:model];
        //        }
        [self.viewmodel.selectedList addObject:model];
        button.selected = YES;
        model.selectIndexStr = [NSString stringWithFormat:@"%ld",[self.viewmodel.selectedList indexOfObject:model] + 1];
        [button setTitle:model.selectIndexStr forState:UIControlStateSelected];
        CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        anim.duration = 0.25;
        anim.values = @[@(1.2),@(0.8),@(1.1),@(0.9),@(1.0)];
        [button.layer addAnimation:anim forKey:@""];
    }
    model.selected = button.selected;
    button.backgroundColor = button.selected ? self.view.tintColor : nil;
    //    if ([self.delegate respondsToSelector:@selector(datePhotoPreviewControllerDidSelect:model:)]) {
    //        [self.delegate datePhotoPreviewControllerDidSelect:self model:model];
    //    }
    //    self.bottomView.selectCount = self.viewmodel.selectedList.count;
    //    if (button.selected) {
    //        [self.bottomView insertModel:model];
    //    }else {
    //        [self.bottomView deleteModel:model];
    //    }
//    if (self.selectPreview) {
//        
//    }
}

#pragma mark - private

- (MediaPreviewCell *)currentPreviewCell:(PhotoModel *)model {
    if (!model) {
        return nil;
    }
    return (MediaPreviewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentModelIndex inSection:0]];
}

- (void)setSubviewAlphaAnimate:(BOOL)animete {
    BOOL hide = NO;
    //    if (self.bottomView.alpha == 1) {
    //        hide = YES;
    //    }
    if (!hide) {
        [self.navigationController setNavigationBarHidden:hide animated:NO];
    }
    //    self.bottomView.userInteractionEnabled = !hide;
    if (animete) {
        [[UIApplication sharedApplication] setStatusBarHidden:hide withAnimation:UIStatusBarAnimationFade];
        [UIView animateWithDuration:0.15 animations:^{
            self.navigationController.navigationBar.alpha = hide ? 0 : 1;
            if (self.outside) {
                self.navBar.alpha = hide ? 0 : 1;
            }
            self.view.backgroundColor = hide ? [UIColor blackColor] : [UIColor whiteColor];
            self.collectionView.backgroundColor = hide ? [UIColor blackColor] : [UIColor whiteColor];
        } completion:^(BOOL finished) {
            if (hide) {
                [self.navigationController setNavigationBarHidden:hide animated:NO];
            }
        }];
    } else {
        [[UIApplication sharedApplication] setStatusBarHidden:hide];
        self.navigationController.navigationBar.alpha = hide ? 0 : 1;
        if (self.outside) {
            self.navBar.alpha = hide ? 0 : 1;
        }
        self.view.backgroundColor = hide ? [UIColor blackColor] : [UIColor whiteColor];
        self.collectionView.backgroundColor = hide ? [UIColor blackColor] : [UIColor whiteColor];
        if (hide) {
            [self.navigationController setNavigationBarHidden:hide];
        }
    }
}


#pragma mark - < UICollectionViewDataSource >
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.modelArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MediaPreviewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DatePreviewCellId" forIndexPath:indexPath];
    PhotoModel *model = self.modelArray[indexPath.item];
    cell.model = model;
    __weak typeof(self) weakSelf = self;
    [cell setCellDidPlayVideoBtn:^(BOOL play) {
//        if (play) {
//            if (weakSelf.bottomView.userInteractionEnabled) {
//                [weakSelf setSubviewAlphaAnimate:YES];
//            }
//        } else {
//            if (!weakSelf.bottomView.userInteractionEnabled) {
//                [weakSelf setSubviewAlphaAnimate:YES];
//            }
//        }
    }];
    [cell setCellTapClick:^{
        [weakSelf setSubviewAlphaAnimate:YES];
    }];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    [(MediaPreviewCell *)cell resetScale];
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    [(MediaPreviewCell *)cell cancelRequest];
}

#pragma mark - UICollectionViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //    if (!self.tempCell.dragging) {
    //        [self.tempCell cancelRequest];
    //        self.tempCell.dragging = YES;
    //    }
    if (scrollView != self.collectionView) {
        return;
    }
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat offsetx = self.collectionView.contentOffset.x;
    NSInteger currentIndex = (offsetx + (width + 20) * 0.5) / (width + 20);
    if (currentIndex > self.modelArray.count - 1) {
        currentIndex = self.modelArray.count - 1;
    }
    if (currentIndex < 0) {
        currentIndex = 0;
    }
    if (self.modelArray.count > 0) {
        PhotoModel *model = self.modelArray[currentIndex];
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (orientation == UIInterfaceOrientationPortrait || UIInterfaceOrientationPortrait == UIInterfaceOrientationPortraitUpsideDown) {
            self.titleLb.text = model.barTitle;
            self.subTitleLb.text = model.barSubTitle;
        }else if (orientation == UIInterfaceOrientationLandscapeRight || orientation == UIInterfaceOrientationLandscapeLeft){
            self.subTitleLb.text = [NSString stringWithFormat:@"%@  %@",model.barTitle,model.barSubTitle];
        }
        self.selectBtn.selected = model.selected;
        [self.selectBtn setTitle:model.selectIndexStr forState:UIControlStateSelected];
        self.selectBtn.backgroundColor = self.selectBtn.selected ? self.view.tintColor : nil;
        if (self.outside) {
//            if ([self.viewmodel.endSelectedList containsObject:model]) {
//                self.bottomView.currentIndex = [self.viewmodel.endSelectedList indexOfObject:model];
//            } else {
//                [self.bottomView deselected];
//            }
        } else {
//            if ([self.viewmodel.selectedList containsObject:model]) {
//                self.bottomView.currentIndex = [self.viewmodel.selectedList indexOfObject:model];
//            } else {
//                [self.bottomView deselected];
//            }
        }
    }
    self.currentModelIndex = currentIndex;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.modelArray.count > 0) {
        MediaPreviewCell *cell = (MediaPreviewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentModelIndex inSection:0]];
        PhotoModel *model = self.modelArray[self.currentModelIndex];
        self.currentModel = model;
        [cell requestHDImage];
    }
}
//
//- (void)datePhotoPreviewBottomViewDidItem:(PhotoModel *)model currentIndex:(NSInteger)currentIndex beforeIndex:(NSInteger)beforeIndex {
//    if ([self.modelArray containsObject:model]) {
//        NSInteger index = [self.modelArray indexOfObject:model];
//        if (self.currentModelIndex == index) {
//            return;
//        }
//        self.currentModelIndex = index;
//        [self.collectionView setContentOffset:CGPointMake(self.currentModelIndex * (self.view.width + 20), 0) animated:NO];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self scrollViewDidEndDecelerating:self.collectionView];
//        });
//    } else {
//        if (beforeIndex == -1) {
//            [self.bottomView deselectedWithIndex:currentIndex];
//        }
//        self.bottomView.currentIndex = beforeIndex;
//    }
//}

//- (void)datePhotoPreviewBottomViewDidDone:(HXDatePhotoPreviewBottomView *)bottomView {
//    if (self.outside) {
//        [self dismissViewControllerAnimated:YES completion:nil];
//        return;
//    }
//    if (self.modelArray.count == 0) {
//        [self.view showImageHUDText:@"没有照片可选!"];
//        return;
//    }
//    PhotoModel *model = self.modelArray[self.currentModelIndex];
//    BOOL max = NO;
//    if (self.viewmodel.selectedList.count == self.viewmodel.maxNum) {
//        // 已经达到最大选择数
//        max = YES;
//    }
//    if (self.viewmodel.type == HXPhotoManagerSelectedTypePhotoAndVideo) {
//        if ((model.type == PhotoModelMediaTypePhoto || model.type == PhotoModelMediaTypePhoto) || (model.type == PhotoModelMediaTypeCameraPhoto || model.type == PhotoModelMediaTypeLive)) {
//            if (self.viewmodel.videoMaxNum > 0) {
//                if (!self.viewmodel.selectTogether) { // 是否支持图片视频同时选择
//                    if (self.viewmodel.selectedVideos.count > 0 ) {
//                        // 已经选择了视频,不能再选图片
//                        max = YES;
//                    }
//                }
//            }
//            if (self.viewmodel.selectedPhotos.count == self.viewmodel.photoMaxNum) {
//                max = YES;
//                // 已经达到图片最大选择数
//            }
//        }
//    } else if (self.viewmodel.type == HXPhotoManagerSelectedTypePhoto) {
//        if (self.viewmodel.selectedPhotos.count == self.viewmodel.photoMaxNum) {
//            // 已经达到图片最大选择数
//            max = YES;
//        }
//    }
//    if (self.viewmodel.selectedList.count == 0) {
//        if (!self.selectBtn.selected && !max && self.modelArray.count > 0) {
//            model.selected = YES;
//            MediaPreviewCell *cell = (MediaPreviewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentModelIndex inSection:0]];
//            if (model.type == PhotoModelMediaTypePhoto) {
//                if (cell.imageView.image.images.count > 0) {
//                    model.thumbPhoto = cell.imageView.image.images.firstObject;
//                    model.previewPhoto = cell.imageView.image.images.firstObject;
//                }else {
//                    model.thumbPhoto = cell.imageView.image;
//                    model.previewPhoto = cell.imageView.image;
//                }
//            }else {
//                model.thumbPhoto = cell.imageView.image;
//                model.previewPhoto = cell.imageView.image;
//            }
//            if (model.type == PhotoModelMediaTypePhoto || (model.type == PhotoModelMediaTypePhoto || model.type == PhotoModelMediaTypeLive)) { // 为图片时
//                [self.viewmodel.selectedPhotos addObject:model];
//            }else if (model.type == PhotoModelMediaTypeVideo) { // 为视频时
//                [self.viewmodel.selectedVideos addObject:model];
//            }else if (model.type == PhotoModelMediaTypeCameraPhoto) {
//                // 为相机拍的照片时
//                [self.viewmodel.selectedPhotos addObject:model];
//                [self.viewmodel.selectedCameraPhotos addObject:model];
//                [self.viewmodel.selectedCameraList addObject:model];
//            }else if (model.type == PhotoModelMediaTypeCameraVideo) {
//                // 为相机录的视频时
//                [self.viewmodel.selectedVideos addObject:model];
//                [self.viewmodel.selectedCameraVideos addObject:model];
//                [self.viewmodel.selectedCameraList addObject:model];
//            }
//            [self.viewmodel.selectedList addObject:model];
//            model.selectIndexStr = [NSString stringWithFormat:@"%ld",[self.viewmodel.selectedList indexOfObject:model] + 1];
//        }
//    }
//    if ([self.delegate respondsToSelector:@selector(datePhotoPreviewControllerDidDone:)]) {
//        [self.delegate datePhotoPreviewControllerDidDone:self];
//    }
//}

#pragma mark - lazy
- (CustomNavigationBar *)navBar {
    if (!_navBar) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        _navBar = [[CustomNavigationBar alloc] initWithFrame:CGRectMake(0, 0, width, kNavigationBarHeight)];
        _navBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [_navBar pushNavigationItem:self.navItem animated:NO];
    }
    return _navBar;
}

- (UINavigationItem *)navItem {
    if (!_navItem) {
        _navItem = [[UINavigationItem alloc] init];
        //
        //        _navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[NSBundle hx_localizedStringForKey:@"取消"] style:UIBarButtonItemStylePlain target:self action:@selector(dismissClick)];
        _navItem.titleView = self.customTitleView;
    }
    return _navItem;
}

- (UIView *)customTitleView {
    if (!_customTitleView) {
        _customTitleView = [[UIView alloc] init];
        [_customTitleView addSubview:self.titleLb];
        [_customTitleView addSubview:self.subTitleLb];
    }
    return _customTitleView;
}

- (UILabel *)titleLb {
    if (!_titleLb) {
        _titleLb = [[UILabel alloc] init];
        _titleLb.textAlignment = NSTextAlignmentCenter;
        if (iOS8_2Later) {
            _titleLb.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        }else {
            _titleLb.font = [UIFont systemFontOfSize:14];
        }
        _titleLb.textColor = [UIColor blackColor];
    }
    return _titleLb;
}

- (UILabel *)subTitleLb {
    if (!_subTitleLb) {
        _subTitleLb = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleLb.frame) + 4, 150, 12)];
        _subTitleLb.textAlignment = NSTextAlignmentCenter;
        if (iOS8_2Later) {
            _subTitleLb.font = [UIFont systemFontOfSize:11 weight:UIFontWeightRegular];
        }else {
            _subTitleLb.font = [UIFont systemFontOfSize:11];
        }
        _subTitleLb.textColor = [UIColor blackColor];
    }
    return _subTitleLb;
}

- (UIButton *)selectBtn {
    if (!_selectBtn) {
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectBtn setBackgroundImage:[AlbumTool imageNamed:@"compose_guide_check_box_default111@2x.png"] forState:UIControlStateNormal];
        [_selectBtn setBackgroundImage:[[UIImage alloc] init] forState:UIControlStateSelected];
        [_selectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        _selectBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _selectBtn.adjustsImageWhenDisabled = YES;
        [_selectBtn addTarget:self action:@selector(didSelectClick:) forControlEvents:UIControlEventTouchUpInside];
        _selectBtn.size = CGSizeMake(24, 24);
        [_selectBtn setEnlargeEdgeWithTop:0 right:0 bottom:20 left:20];
        _selectBtn.layer.cornerRadius = 12;
    }
    return _selectBtn;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(-10, kTopMargin,self.view.width + 20, self.view.height - kTopMargin - kBottomMargin) collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        //        _collectionView.contentSize = CGSizeMake(self.modelArray.count * (self.view.width + 20), 0);
        [_collectionView registerClass:[MediaPreviewCell class] forCellWithReuseIdentifier:@"DatePreviewCellId"];
        //        [_collectionView setContentOffset:CGPointMake(self.currentModelIndex * (self.view.width + 20), 0) animated:NO];
#ifdef __IPHONE_11_0
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
#else
        self.automaticallyAdjustsScrollViewInsets = NO;
#endif
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        //        _flowLayout.itemSize = CGSizeMake(self.view.width, self.view.height - kTopMargin - kBottomMargin);
        _flowLayout.minimumInteritemSpacing = 0;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        if (self.outside) {
            _flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
        } else {
            _flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
        }
    }
    return _flowLayout;
}

- (NSMutableArray *)modelArray {
    if (!_modelArray) {
        _modelArray = [NSMutableArray array];
    }
    return _modelArray;
}

- (void)dealloc {
    MediaPreviewCell *cell = (MediaPreviewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentModelIndex inSection:0]];
    [cell cancelRequest];
    if ([UIApplication sharedApplication].statusBarHidden) {
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
    NSSLog(@"dealloc");
}

@end
