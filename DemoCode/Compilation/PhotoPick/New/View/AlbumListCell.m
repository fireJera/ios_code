//
//  AlbumListCell.m
//  PhotoPick
//
//  Created by Jeremy on 2019/3/22.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import "AlbumListCell.h"
#import "AlbumTool.h"
#import <PhotosUI/PhotosUI.h>
#import "PhotoModel.h"

@interface AlbumListCell ()

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *cameraBtn;
@property (nonatomic, strong) UIImageView *videoIcon;
@property (nonatomic, strong) UILabel *videoTime;
@property (nonatomic, strong) UIImageView *gifIcon;
@property (nonatomic, strong) UIImageView *liveIcon;
@property (nonatomic, strong) UIButton *liveBtn;
@property (nonatomic, strong) PHLivePhotoView *livePhotoView;
@property (nonatomic, copy)   NSString *localIdentifier;
@property (nonatomic, strong) UIImageView *previewImg;
@property (nonatomic, assign) PHImageRequestID liveRequestID;
@property (nonatomic, assign) BOOL addImageComplete;
@property (nonatomic, strong) UIButton *iCloudBtn;
@property (nonatomic, strong) UIImageView *iCloudIcon;

@end

@implementation AlbumListCell

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.requestID = 0;
        [self p_setUp];
    }
    return self;
}

- (void)p_setUp {
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.bottomView];
    [self.bottomView addSubview:self.videoIcon];
    [self.bottomView addSubview:self.videoTime];
    [self.contentView addSubview:self.gifIcon];
    [self.contentView addSubview:self.liveIcon];
    [self.contentView addSubview:self.maskView];
    [self.contentView addSubview:self.liveBtn];
    [self.contentView addSubview:self.iCloudBtn];
    [self.iCloudBtn addSubview:self.iCloudIcon];
    [self.contentView addSubview:self.selectBtn];
    [self.contentView addSubview:self.cameraBtn];
}

#pragma mark - setter
- (void)setIconDic:(NSDictionary *)iconDic {
    _iconDic = iconDic;
    if (self.addImageComplete) {
        return;
    }
    if (!self.videoIcon.image) {
        self.videoIcon.image = iconDic[@"videoIcon"];
    }
    if (!self.gifIcon.image) {
        self.gifIcon.image = iconDic[@"gifIcon"];
    }
    if (!self.liveIcon.image) {
        self.liveIcon.image = iconDic[@"liveIcon"];
    }
    if (!self.liveBtn.currentImage) {
        [self.liveBtn setImage:iconDic[@"liveBtnImageNormal"] forState:UIControlStateNormal];
        [self.liveBtn setImage:iconDic[@"liveBtnImageSelected"] forState:UIControlStateSelected];
    }
    if (!self.liveBtn.currentBackgroundImage) {
        [self.liveBtn setBackgroundImage:iconDic[@"liveBtnBackgroundImage"] forState:UIControlStateNormal];
    }
    if (!self.selectBtn.currentImage) {
        [self.selectBtn setImage:iconDic[@"selectBtnNormal"] forState:UIControlStateNormal];
        [self.selectBtn setImage:iconDic[@"selectBtnSelected"] forState:UIControlStateSelected];
    }
    if (!self.iCloudIcon.image) {
        self.iCloudIcon.image = iconDic[@"icloudIcon"];
        self.iCloudIcon.size = self.iCloudIcon.image.size;
        self.iCloudIcon.center = self.selectBtn.center;
    }
    self.addImageComplete = YES;
}

- (void)setSingleSelected:(BOOL)singleSelected {
    _singleSelected = singleSelected;
    if (singleSelected) {
        [self.maskView removeFromSuperview];
        [self.selectBtn removeFromSuperview];
    }
}

- (void)setModel:(PhotoModel *)model {
    _model = model;
    self.iCloudBtn.hidden = YES;
    self.selectBtn.hidden = NO;
    if (model.isIcloud) {
        self.iCloudBtn.hidden = NO;
        self.selectBtn.hidden = YES;
    }
    if (model.type == PhotoModelMediaTypeCamera
//        || model.type == PhotoModelMediaTypeCameraPhoto
//        || model.type == PhotoModelMediaTypeCameraVideo
        ) {
        self.imageView.image = model.thumbPhoto;
    } else {
        __weak typeof(self) weakSelf = self;
        PHImageRequestID requestId = [AlbumTool getImageWithModel:model completion:^(UIImage * _Nonnull image, PhotoModel * _Nonnull model) {
            if (weakSelf.model == model) {
                weakSelf.imageView.image = image;
            }
        }];
        self.requestID = requestId;
    }
    
    self.videoTime.text = model.videoTime;
    self.liveIcon.hidden = YES;
    self.liveBtn.hidden = YES;
    self.gifIcon.hidden = YES;
    self.cameraBtn.hidden = YES;
    if (model.type == PhotoModelMediaTypeVideo) {
        self.bottomView.hidden = NO;
    }
    else if (model.type == PhotoModelMediaTypePhoto ||
             (model.type == PhotoModelMediaTypeGif || model.type == PhotoModelMediaTypeLive)){
        self.bottomView.hidden = YES;
        if (model.type == PhotoModelMediaTypeGif) {
            self.gifIcon.hidden = NO;
        }
        else if (model.type == PhotoModelMediaTypeLive) {
            self.liveIcon.hidden = NO;
            if (model.selected) {
                self.liveIcon.hidden = YES;
                self.liveBtn.hidden = NO;
                self.liveBtn.selected = model.isCloseLivePhoto;
            }
        }
    }
    else if (model.type == PhotoModelMediaTypeCamera){
        [self.cameraBtn setImage:model.thumbPhoto forState:UIControlStateNormal];
        self.cameraBtn.hidden = NO;
    }
//    else if (model.type == PhotoModelMediaTypeCameraPhoto) {
//        self.bottomView.hidden = YES;
//    }
//    else if (model.type == PhotoModelMediaTypeCameraVideo) {
//        self.bottomView.hidden = NO;
//    }
    self.maskView.hidden = !model.selected;
    self.selectBtn.selected = model.selected;
}

#pragma mark - touch event

- (void)didICloudBtnCLick {
    [[self viewController].view showImageHUDText:@"尚未从iCloud上下载，请至相册下载完毕后选择"];
}

- (void)didLivePhotoBtnClick:(UIButton *)button {
    button.selected = !button.selected;
    self.model.isCloseLivePhoto = button.selected;
    if (button.selected) {
        [self.livePhotoView stopPlayback];
        [self.livePhotoView removeFromSuperview];
    }
    else {
        [self startLivePhoto];
    }
    if ([self.delegate respondsToSelector:@selector(albumListCellChangeLivePhotoState:)]) {
        [self.delegate albumListCellChangeLivePhotoState:self.model];
    }
}

- (void)didSelectClick:(UIButton *)button {
    if (self.model.type == PhotoModelMediaTypeCamera) {
        return;
    }
    if (self.model.isIcloud) {
        [self didICloudBtnCLick];
        return;
    }
    if ([self.delegate respondsToSelector:@selector(albumListCellDidSelectedBtnClick:model:)]) {
        [self.delegate albumListCellDidSelectedBtnClick:self model:self.model];
    }
}

#pragma mark - public func

- (void)startLivePhoto {
    self.liveIcon.hidden = YES;
    self.liveBtn.hidden = NO;
    if (self.model.isCloseLivePhoto) {
        return;
    }
    [self.contentView insertSubview:self.livePhotoView aboveSubview:self.imageView];
    CGFloat width = self.frame.size.width;
    __weak typeof(self) weakSelf = self;
    CGSize size;
    if (self.model.imageSize.width > self.model.imageSize.height / 9 * 15) {
        size = CGSizeMake(width, width * 1.5);
    }
    else if (self.model.imageSize.height > self.model.imageSize.width / 9 * 15) {
        size = CGSizeMake(width * 1.5, width);
    }
    else {
        size = CGSizeMake(width, width);
    }
    self.liveRequestID = [AlbumTool fetchLivePhotoForPHAsset:self.model.asset size:size completion:^(PHLivePhoto * _Nonnull livePhoto, NSDictionary * _Nonnull info) {
        weakSelf.livePhotoView.livePhoto = livePhoto;
        [weakSelf.livePhotoView startPlaybackWithStyle:PHLivePhotoViewPlaybackStyleHint];
    }];
}

- (void)stopLivePhoto {
    [[PHCachingImageManager defaultManager] cancelImageRequest:self.liveRequestID];
    self.liveIcon.hidden = NO;
    self.liveBtn.hidden = YES;
    [self.livePhotoView stopPlayback];
    [self.livePhotoView removeFromSuperview];
}

- (void)cancelRequest {
    if (self.requestID) {
        [[PHImageManager defaultManager] cancelImageRequest:self.requestID];
        self.requestID = -1;
    }
}

#pragma mark - lazy property

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.frame = self.bounds;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 25, self.width, 25)];
        _bottomView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        _bottomView.hidden = YES;
    }
    return _bottomView;
}

- (UIImageView *)videoIcon {
    if (!_videoIcon) {
        _videoIcon = [[UIImageView alloc] init];
        _videoIcon.frame = CGRectMake(5, 0, 17, 17);
        _videoIcon.center = CGPointMake(_videoIcon.center.x, 25 / 2);
    }
    return _videoIcon;
}

- (UILabel *)videoTime {
    if (!_videoTime) {
        _videoTime = [[UILabel alloc] init];
        _videoTime.textColor = [UIColor whiteColor];
        _videoTime.textAlignment = NSTextAlignmentRight;
        _videoTime.font = [UIFont systemFontOfSize:10];
        _videoTime.frame = CGRectMake(CGRectGetMaxX(_videoTime.frame), 0, self.width - CGRectGetMaxX(_videoTime.frame) - 5, 25);
    }
    return _videoTime;
}

- (UIImageView *)gifIcon {
    if (!_gifIcon) {
        _gifIcon = [[UIImageView alloc] init];
        _gifIcon.frame = CGRectMake(self.width - 28, self.height - 18, 28, 18);
    }
    return _gifIcon;
}

- (UIImageView *)liveIcon {
    if (!_liveIcon) {
        _liveIcon = [[UIImageView alloc] init];
        _liveIcon.frame = CGRectMake(7, 5, 18, 18);
    }
    return _liveIcon;
}

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:self.bounds];
        _maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        _maskView.hidden = YES;
    }
    return _maskView;
}

- (UIButton *)liveBtn {
    if (!_liveBtn) {
        _liveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_liveBtn setTitle:@"LIVE" forState:UIControlStateNormal];
        [_liveBtn setTitle:@"关闭" forState:UIControlStateSelected];
        [_liveBtn setTitleColor:[UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1] forState:UIControlStateNormal];
        _liveBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 4, 0, 0);
        _liveBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 2, 0, 0);
        _liveBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _liveBtn.frame = CGRectMake(5, 5, 55, 24);
        [_liveBtn addTarget:self action:@selector(didLivePhotoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _liveBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _liveBtn.hidden = YES;
    }
    return _liveBtn;
}

- (UIButton *)selectBtn {
    if (!_selectBtn) {
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectBtn addTarget:self action:@selector(didSelectClick:) forControlEvents:UIControlEventTouchUpInside];
        _selectBtn.frame = CGRectMake(self.width - 32, 0, 32, 32);
        _selectBtn.center = CGPointMake(_selectBtn.center.x, self.liveBtn.center.y);
        self.liveIcon.center = CGPointMake(self.liveIcon.center.x, self.liveBtn.center.y);
        [_selectBtn setEnlargeEdgeWithTop:0 right:0 bottom:20 left:20];
    }
    return _selectBtn;
}

- (UIButton *)cameraBtn {
    if (!_cameraBtn) {
        _cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cameraBtn setBackgroundColor:[UIColor whiteColor]];
        _cameraBtn.userInteractionEnabled = NO;
        _cameraBtn.frame = self.bounds;
    }
    return _cameraBtn;
}

- (UIButton *)iCloudBtn {
    if (!_iCloudBtn) {
        _iCloudBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_iCloudBtn setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.4]];
        [_iCloudBtn addTarget:self action:@selector(didICloudBtnCLick) forControlEvents:UIControlEventTouchUpInside];
        _iCloudBtn.frame = self.bounds;
    }
    return _iCloudBtn;
}

- (UIImageView *)iCloudIcon {
    if (!_iCloudIcon) {
        _iCloudIcon = [[UIImageView alloc] init];
    }
    return _iCloudIcon;
}

- (PHLivePhotoView *)livePhotoView {
    if (!_livePhotoView) {
        _livePhotoView = [[PHLivePhotoView alloc] init];
        _livePhotoView.clipsToBounds = YES;
        _livePhotoView.contentMode = UIViewContentModeScaleAspectFill;
        _livePhotoView.frame = self.bounds;
    }
    return _livePhotoView;
}


- (void)dealloc {
    if (self.requestID) {
        [[PHImageManager defaultManager] cancelImageRequest:self.requestID];
        self.requestID = -1;
    }
}

@end
