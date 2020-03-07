
//
//  LETADVideoPreviewViewController.m
//  LetDate
//
//  Created by Jeremy on 2019/1/21.
//  Copyright © 2019 JersiZhu. All rights reserved.
//

#import "LETADVideoPreviewViewController.h"
//#import "HXDatePhotoPreviewBottomView.h"
#import "UIButton+HXExtension.h"
#import "HXPhotoCustomNavigationBar.h"
#import "HXCircleProgressView.h"
#import "HXDatePhotoPreviewViewController.h"
//#import "LETADAlbumListViewmodel.h"
//#import "LETADVideoCompressHelper.h"
//#import "LETADCHeader.h"
#import "UIView+LETAD_Frame.h"
#import "UIImage+LETAD_Custom.h"
#import "UIColor+LETAD_Hex.h"

@interface LETADVideoPreviewViewController () <UICollectionViewDataSource,UICollectionViewDelegate> {
    BOOL _showBar;
}

@property (strong, nonatomic) UICollectionViewFlowLayout *flowLayout;
@property (strong, nonatomic) HXPhotoModel *currentModel;
@property (strong, nonatomic) UIView *customTitleView;
@property (strong, nonatomic) UILabel *titleLb;
@property (strong, nonatomic) UILabel *subTitleLb;
@property (strong, nonatomic) HXDatePhotoPreviewViewCell *tempCell;
@property (strong, nonatomic) UIButton *selectBtn;
@property (nonatomic, strong) UIButton * selectedBtn;
@property (assign, nonatomic) BOOL orientationDidChange;
@property (assign, nonatomic) NSInteger beforeOrientationIndex;
@property (strong, nonatomic) HXPhotoCustomNavigationBar *navBar;
@property (strong, nonatomic) UINavigationItem *navItem;
@end

@implementation LETADVideoPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _showBar = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationChanged:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationWillChanged:) name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
    [self setSubviewAlphaAnimate:YES];
    [self p_letad_setupUI];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (self.orientationDidChange) {
        self.orientationDidChange = NO;
        
        [self p_letad_changeSubviewFrame];
    }
}

- (void)deviceOrientationChanged:(NSNotification *)notify {
    self.orientationDidChange = YES;
}

- (void)deviceOrientationWillChanged:(NSNotification *)notify {
    
    
    self.beforeOrientationIndex = self.currentModelIndex;
}

- (HXDatePhotoPreviewViewCell *)currentPreviewCell:(HXPhotoModel *)model {
    
    if (!model) {
        return nil;
    }
    return (HXDatePhotoPreviewViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentModelIndex inSection:0]];
}


- (void)p_letad_changeSubviewFrame {
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    HXPhotoModel *model = self.modelArray[self.currentModelIndex];
    if (orientation == UIInterfaceOrientationPortrait || UIInterfaceOrientationPortrait == UIInterfaceOrientationPortraitUpsideDown) {
        self.titleLb.hidden = NO;
        self.customTitleView.frame = CGRectMake(0, 0, 150, 44);
        self.titleLb.frame = CGRectMake(0, 9, 150, 14);
        self.subTitleLb.frame = CGRectMake(0, CGRectGetMaxY(self.titleLb.frame) + 4, 150, 12);
        self.titleLb.text = model.barTitle;
        self.subTitleLb.text = model.barSubTitle;
    } else if (orientation == UIInterfaceOrientationLandscapeRight || orientation == UIInterfaceOrientationLandscapeLeft){
        self.customTitleView.frame = CGRectMake(0, 0, 200, 30);
        self.titleLb.hidden = YES;
        self.subTitleLb.frame = CGRectMake(0, 0, 200, 30);
        self.subTitleLb.text = [NSString stringWithFormat:@"%@  %@",model.barTitle,model.barSubTitle];
    }
    CGFloat bottomMargin = kBottomMargin;
    CGFloat width = self.view.hx_w;
    CGFloat itemMargin = 20;
    if (kDevice_Is_iPhoneX && (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight)) {
        bottomMargin = 21;
    }
    self.flowLayout.itemSize = CGSizeMake(width, self.view.hx_h - kTopMargin - bottomMargin);
    self.flowLayout.minimumLineSpacing = itemMargin;
    
    [self.collectionView setCollectionViewLayout:self.flowLayout];
    self.navBar.frame = CGRectMake(0, 0, self.view.hx_w, kNavigationBarHeight);
    self.collectionView.frame = CGRectMake(-(itemMargin / 2), kTopMargin, self.view.hx_w + itemMargin, self.view.hx_h - kTopMargin - bottomMargin);
    self.collectionView.contentSize = CGSizeMake(self.modelArray.count * (self.view.hx_w + itemMargin), 0);
    
    [self.collectionView setContentOffset:CGPointMake(self.beforeOrientationIndex * (self.view.hx_w + itemMargin), 0)];
    
    [UIView performWithoutAnimation:^{
        [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:self.beforeOrientationIndex inSection:0]]];
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    HXPhotoModel *model = self.modelArray[self.currentModelIndex];
    self.currentModel = model;
    HXDatePhotoPreviewViewCell *cell = (HXDatePhotoPreviewViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentModelIndex inSection:0]];
    if (!cell) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            HXDatePhotoPreviewViewCell *tempCell = (HXDatePhotoPreviewViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentModelIndex inSection:0]];
            self.tempCell = tempCell;
            [tempCell requestHDImage];
        });
    }else {
        self.tempCell = cell;
        [cell requestHDImage];
    }
}


- (void)viewWillDisappear:(BOOL)animated {
    HXDatePhotoPreviewViewCell *cell = (HXDatePhotoPreviewViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentModelIndex inSection:0]];
    [cell cancelRequest];
}



- (void)p_letad_setupUI {
    self.navigationItem.titleView = self.customTitleView;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    
    self.beforeOrientationIndex = self.currentModelIndex;
    [self p_letad_changeSubviewFrame];
    HXPhotoModel *model = self.modelArray[self.currentModelIndex];
    
    if (!self.outside) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.selectBtn];
        self.selectBtn.selected = model.selected;
        [self.selectBtn setTitle:model.selectIndexStr forState:UIControlStateSelected];
    }
    if (_manager.singleSelected || _manager.maxNum == 1) {
        return;
    }

    [self.view addSubview:self.selectedBtn];
    
    if (model.type == HXPhotoModelMediaTypePhotoVideo || model.type == HXPhotoModelMediaTypePhotoCameraVideo) {
        BOOL canSelect = model.videoSecond <= _manager.videoMaxDuration && model.videoSecond >= _manager.videoMinDuration;
        self.selectBtn.enabled = canSelect;
        self.selectBtn.backgroundColor = canSelect ? [UIColor femaleBlueColor] : [UIColor grayTextColor];
    } else {
        self.selectBtn.enabled = YES;
        self.selectBtn.backgroundColor = [UIColor femaleBlueColor];
    }
}

- (void)didSelectClick:(UIButton *)button {
    if (self.modelArray.count <= 0 || self.outside) {
        [self.view showImageHUDText:@"没有照片可选!"];
        return;
    }
//    if ([_listViewmodel.uploadType isEqualToString:@"all"]) {
//        if (_manager.selectedList.count) {
//            [self commitAllModels];
//        } else {
//            HXPhotoModel *model = self.modelArray[self.currentModelIndex];
//            model.selected = button.selected;
//            [self p_letad_commitVideo:model];
//        }
//
//        return;
//    }
    HXPhotoModel *model = self.modelArray[self.currentModelIndex];
    model.selected = button.selected;
    [self p_letad_commitVideo:model];
}

#pragma mark - right checkbox
- (void)selectClick:(UIButton *)sender {
    if (self.modelArray.count == 0) {
        [self.view showImageHUDText:@"没有照片可选!"];
        return;
    }
    HXPhotoModel *model = self.modelArray[self.currentModelIndex];
    if (!sender.selected) {
        NSString *str = [HXPhotoTools maximumOfJudgment:model manager:self.manager];
        if (str) {
            [self.view showImageHUDText:str];
            return;
        }
        if (model.type != HXPhotoModelMediaTypePhotoCameraVideo && model.type != HXPhotoModelMediaTypePhotoCameraPhoto) {
            HXDatePhotoPreviewViewCell *cell = (HXDatePhotoPreviewViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentModelIndex inSection:0]];
            if (cell) {
                if (model.type == HXPhotoModelMediaTypePhotoGif) {
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
            }else {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    HXDatePhotoPreviewViewCell *cell_1 = (HXDatePhotoPreviewViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentModelIndex inSection:0]];
                    if (model.type == HXPhotoModelMediaTypePhotoGif) {
                        //                        model.thumbPhoto = cell_1.firstImage;
                        //                        model.previewPhoto = cell_1.firstImage;
                    }else {
                        model.thumbPhoto = cell_1.imageView.image;
                        model.previewPhoto = cell_1.imageView.image;
                    }
                });
            }
        }
        if (model.type == HXPhotoModelMediaTypePhoto || (model.type == HXPhotoModelMediaTypePhotoGif || model.type == HXPhotoModelMediaTypePhotoLivePhoto)) {
            [self.manager.selectedPhotos addObject:model];
        } else if (model.type == HXPhotoModelMediaTypePhotoVideo) {
            [self.manager.selectedVideos addObject:model];
        } else if (model.type == HXPhotoModelMediaTypePhotoCameraPhoto) {
            [self.manager.selectedPhotos addObject:model];
            [self.manager.selectedCameraPhotos addObject:model];
            [self.manager.selectedCameraList addObject:model];
        } else if (model.type == HXPhotoModelMediaTypePhotoCameraVideo) {
            [self.manager.selectedVideos addObject:model];
            [self.manager.selectedCameraVideos addObject:model];
            [self.manager.selectedCameraList addObject:model];
        }
        [self.manager.selectedList addObject:model];
        CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        anim.duration = 0.25;
        anim.values = @[@(1.2),@(0.8),@(1.1),@(0.9),@(1.0)];
        [sender.layer addAnimation:anim forKey:@""];
    } else {
        if (model.type != HXPhotoModelMediaTypePhotoCameraVideo && model.type != HXPhotoModelMediaTypePhotoCameraPhoto) {
            model.thumbPhoto = nil;
            model.previewPhoto = nil;
        }
        if ((model.type == HXPhotoModelMediaTypePhoto || model.type == HXPhotoModelMediaTypePhotoGif) || (model.type == HXPhotoModelMediaTypePhotoVideo || model.type == HXPhotoModelMediaTypePhotoLivePhoto)) {
            if (model.type == HXPhotoModelMediaTypePhoto || model.type == HXPhotoModelMediaTypePhotoGif || model.type == HXPhotoModelMediaTypePhotoLivePhoto) {
                [self.manager.selectedPhotos removeObject:model];
            }else if (model.type == HXPhotoModelMediaTypePhotoVideo) {
                [self.manager.selectedVideos removeObject:model];
            }
        } else if (model.type == HXPhotoModelMediaTypePhotoCameraPhoto || model.type == HXPhotoModelMediaTypePhotoCameraVideo) {
            if (model.type == HXPhotoModelMediaTypePhotoCameraPhoto) {
                [self.manager.selectedPhotos removeObject:model];
                [self.manager.selectedCameraPhotos removeObject:model];
                
            }else if (model.type == HXPhotoModelMediaTypePhotoCameraVideo) {
                [self.manager.selectedVideos removeObject:model];
                [self.manager.selectedCameraVideos removeObject:model];
            }
            [self.manager.selectedCameraList removeObject:model];
        }
        [self.manager.selectedList removeObject:model];
    }
    sender.selected = !sender.selected;
    model.selected = sender.selected;
    
    for (int i = 0; i < self.manager.selectedList.count; i++) {
        HXPhotoModel * model = [self.manager.selectedList objectAtIndex:i];
        model.selectedPhotosIndex = i;
    }
    
    if (model.selected) {
        [sender setTitle:[NSString stringWithFormat:@"%d", model.selectedPhotosIndex + 1] forState:UIControlStateNormal];
        [sender setBackgroundImage:[UIImage imageNamed:@"letad_album_1"] forState:UIControlStateNormal];
    } else {
        [sender setTitle:@"" forState:UIControlStateNormal];
        [sender setBackgroundImage:[UIImage imageNamed:@"letad_album_2"] forState:UIControlStateNormal];
    }
    
    if ([self.delegate respondsToSelector:@selector(allPreviewdidSelectedClick:AddOrDelete:)]) {
        
        [self.delegate allPreviewdidSelectedClick:model AddOrDelete:sender.selected];
    }
}

- (void)p_letad_commitVideo:(HXPhotoModel *)model {
//    __weak typeof(self) weakSelf = self;
//    if (_listViewmodel) {
//        MBProgressHUD * hud = [self customProgressHUDTitle:@"0%"];
//        if ([_listViewmodel.uploadType isEqualToString:@"all"]) {
//            [_listViewmodel letad_uploadUnKnown:model progress:^(float progressValue) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    hud.detailsLabel.text = [NSString stringWithFormat:@"%.2f", progressValue];
//                });
//            } result:^(BOOL isSuccess, id result, NSString *msg) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [hud hideAnimated:YES];
//                    if (isSuccess) {
//                        if ([msg isEqualToString:@"end"]) {
//                            [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
//                            if ([weakSelf.delegate respondsToSelector:@selector(videoPreviewUpload:success:)]) {
//                                [weakSelf.delegate videoPreviewUpload:self success:isSuccess];
//                            }
//                        } else {
//                            [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
//                            if ([weakSelf.delegate respondsToSelector:@selector(videoPreviewUpload:success:)]) {
//                                [weakSelf.delegate videoPreviewUpload:self success:isSuccess];
//                            }
//                        }
//                    } else {
//                        if (msg.length > 0) {
//                            [weakSelf showTextHUD:msg toView:self.view];
//                        }
//                    }
//                });
//            }];
//        } else {
//            [_listViewmodel letad_uploadVideo:model progress:^(float progressValue) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    hud.detailsLabel.text = [NSString stringWithFormat:@"%.2f", progressValue];
//                });
//            } result:^(BOOL isSuccess, id result, NSString *msg) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [hud hideAnimated:YES];
//                    if (isSuccess) {
//                        if ([msg isEqualToString:@"end"]) {
//                            [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
//                            if ([weakSelf.delegate respondsToSelector:@selector(videoPreviewUpload:success:)]) {
//                                [weakSelf.delegate videoPreviewUpload:self success:isSuccess];
//                            }
//                        }
//                    } else {
//                        if (msg.length > 0) {
//                            [weakSelf showTextHUD:msg toView:self.view];
//                        }
//                    }
//                });
//            }];
//            return;
//        }
//    }
//}
//
//- (void)commitAllModels {
//    __weak typeof(self) weakSelf = self;
//    int totalCount = (int)(_manager.selectedList.count);
//    NSString * str = [NSString stringWithFormat:@"0/%d", totalCount];
//    MBProgressHUD * hud = [self customProgressHUDTitle:str];
//
//    [_listViewmodel letad_uploadImages:_manager.selectedList progress:^(float progressValue) {
//        NSString * proStr = [NSString stringWithFormat:@"%d/%d", (int)progressValue, totalCount];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            hud.detailsLabel.text = proStr;
//        });
//    } result:^(BOOL isSuccess, id result, NSString *msg) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [hud hideAnimated:YES];
//            if (isSuccess) {
//                if ([msg isEqualToString:@"end"]) {
//                    [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
//                } else {
//                    [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
//                }
//                if ([weakSelf.delegate respondsToSelector:@selector(mixUploadFromAlbumPreview:source:success:result:)]) {
//                    [weakSelf.delegate mixUploadFromAlbumPreview:weakSelf
//                                                          source:weakSelf.listViewmodel.albums
//                                                         success:YES
//                                                          result:result];
//                }
//            } else {
//                if (msg.length > 0) {
//                    [weakSelf showTextHUD:msg toView:weakSelf.view];
//                }
//                if ([weakSelf.delegate respondsToSelector:@selector(mixUploadFromAlbumPreview:source:success:result:)]) {
//                    [weakSelf.delegate mixUploadFromAlbumPreview:weakSelf
//                                                          source:weakSelf.listViewmodel.albums
//                                                         success:NO
//                                                          result:result];
//                }
//            }
//        });
//    }];
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.modelArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HXDatePhotoPreviewViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DatePreviewCellId" forIndexPath:indexPath];
    HXPhotoModel *model = self.modelArray[indexPath.item];
    cell.model = model;
    __weak typeof(self) weakSelf = self;
    [cell setCellDidPlayVideoBtn:^(BOOL play) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf->_showBar = !play;
        [weakSelf setSubviewAlphaAnimate:YES];
    }];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    HXPhotoModel *model = self.modelArray[indexPath.item];
    if (model.type != HXPhotoModelMediaTypePhotoVideo || model.type != HXPhotoModelMediaTypePhotoCameraVideo) {
        [self setSubviewAlphaAnimate:YES];
    }
}

- (void)setSubviewAlphaAnimate:(BOOL)animate {
    BOOL hide = NO;
    hide = !_showBar;
    if (!hide) {
        [self.navigationController setNavigationBarHidden:hide animated:NO];
    }
    
    if (animate) {
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

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    [(HXDatePhotoPreviewViewCell *)cell resetScale];
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    [(HXDatePhotoPreviewViewCell *)cell cancelRequest];
}

#pragma mark - < UICollectionViewDelegate >

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
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
        HXPhotoModel *model = self.modelArray[currentIndex];
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (orientation == UIInterfaceOrientationPortrait || UIInterfaceOrientationPortrait == UIInterfaceOrientationPortraitUpsideDown) {
            self.titleLb.text = model.barTitle;
            self.subTitleLb.text = model.barSubTitle;
        } else if (orientation == UIInterfaceOrientationLandscapeRight || orientation == UIInterfaceOrientationLandscapeLeft){
            self.subTitleLb.text = [NSString stringWithFormat:@"%@  %@", model.barTitle, model.barSubTitle];
        }
        self.selectBtn.selected = model.selected;
        [self.selectBtn setTitle:model.selectIndexStr forState:UIControlStateSelected];
    }
    self.currentModelIndex = currentIndex;
    HXPhotoModel *model = self.modelArray[currentIndex];
    
    if (model.type == HXPhotoModelMediaTypePhotoVideo || model.type == HXPhotoModelMediaTypePhotoCameraVideo) {
        BOOL canSelect = model.videoSecond <= _manager.videoMaxDuration && model.videoSecond >= _manager.videoMinDuration;
        self.selectBtn.enabled = canSelect;
        self.selectBtn.backgroundColor = canSelect ? [UIColor femaleBlueColor] : [UIColor grayTextColor];
    } else {
        self.selectBtn.enabled = YES;
        self.selectBtn.backgroundColor = [UIColor femaleBlueColor];
    }
    
    self.selectedBtn.selected = model.selected;
    [self.selectedBtn setBackgroundImage:[UIImage imageNamed:model.selected ? @"letad_album_1" : @"letad_album_2"] forState:UIControlStateNormal];
    NSString * str = model.selected ? [NSString stringWithFormat:@"%d", model.selectedPhotosIndex + 1] : @"";
    [self.selectedBtn setTitle:str forState:UIControlStateNormal];
    if (!_showBar) {
        _showBar = YES;
        [self setSubviewAlphaAnimate:YES];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.modelArray.count > 0) {
        HXDatePhotoPreviewViewCell *cell = (HXDatePhotoPreviewViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentModelIndex inSection:0]];
        HXPhotoModel *model = self.modelArray[self.currentModelIndex];
        self.currentModel = model;
        [cell requestHDImage];
    }
}

- (void)datePhotoPreviewBottomViewDidItem:(HXPhotoModel *)model currentIndex:(NSInteger)currentIndex beforeIndex:(NSInteger)beforeIndex {
    if ([self.modelArray containsObject:model]) {
        NSInteger index = [self.modelArray indexOfObject:model];
        if (self.currentModelIndex == index) {
            return;
        }
        self.currentModelIndex = index;
        [self.collectionView setContentOffset:CGPointMake(self.currentModelIndex * (self.view.hx_w + 20), 0) animated:NO];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self scrollViewDidEndDecelerating:self.collectionView];
        });
    }
}

//- (void)datePhotoPreviewBottomViewDidDone:(HXDatePhotoPreviewBottomView *)bottomView {
//    if (self.outside) {
//        [self dismissViewControllerAnimated:YES completion:nil];
//        return;
//    }
//    if (self.modelArray.count == 0) {
//        [self.view showImageHUDText:@"没有照片可选!"];
//        return;
//    }
//    HXPhotoModel *model = self.modelArray[self.currentModelIndex];
//    BOOL max = NO;
//    if (self.manager.selectedList.count == self.manager.maxNum) {
//        // 已经达到最大选择数
//        max = YES;
//    }
//    if (self.manager.type == HXPhotoManagerSelectedTypePhotoAndVideo) {
//        if ((model.type == HXPhotoModelMediaTypePhoto || model.type == HXPhotoModelMediaTypePhotoGif) || (model.type == HXPhotoModelMediaTypePhotoCameraPhoto || model.type == HXPhotoModelMediaTypePhotoLivePhoto)) {
//            if (self.manager.videoMaxNum > 0) {
//                if (!self.manager.selectTogether) { // 是否支持图片视频同时选择
//                    if (self.manager.selectedVideos.count > 0 ) {
//                        // 已经选择了视频,不能再选图片
//                        max = YES;
//                    }
//                }
//            }
//            if (self.manager.selectedPhotos.count == self.manager.photoMaxNum) {
//                max = YES;
//                // 已经达到图片最大选择数
//            }
//        }
//    }else if (self.manager.type == HXPhotoManagerSelectedTypePhoto) {
//        if (self.manager.selectedPhotos.count == self.manager.photoMaxNum) {
//            // 已经达到图片最大选择数
//            max = YES;
//
//        }
//    }
//    if (self.manager.selectedList.count == 0) {
//        if (!self.selectBtn.selected && !max && self.modelArray.count > 0) {
//            model.selected = YES;
//            HXDatePhotoPreviewViewCell *cell = (HXDatePhotoPreviewViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentModelIndex inSection:0]];
//            if (model.type == HXPhotoModelMediaTypePhotoGif) {
//                if (cell.imageView.image.images.count > 0) {
//                    model.thumbPhoto = cell.imageView.image.images.firstObject;
//                    model.previewPhoto = cell.imageView.image.images.firstObject;
//                } else {
//                    model.thumbPhoto = cell.imageView.image;
//                    model.previewPhoto = cell.imageView.image;
//                }
//            } else {
//                model.thumbPhoto = cell.imageView.image;
//                model.previewPhoto = cell.imageView.image;
//            }
//            if (model.type == HXPhotoModelMediaTypePhoto || (model.type == HXPhotoModelMediaTypePhotoGif || model.type == HXPhotoModelMediaTypePhotoLivePhoto)) { // 为图片时
//                [self.manager.selectedPhotos addObject:model];
//            } else if (model.type == HXPhotoModelMediaTypePhotoVideo) { // 为视频时
//                [self.manager.selectedVideos addObject:model];
//            } else if (model.type == HXPhotoModelMediaTypePhotoCameraPhoto) {
//                // 为相机拍的照片时
//                [self.manager.selectedPhotos addObject:model];
//                [self.manager.selectedCameraPhotos addObject:model];
//                [self.manager.selectedCameraList addObject:model];
//            } else if (model.type == HXPhotoModelMediaTypePhotoCameraVideo) {
//                // 为相机录的视频时
//                [self.manager.selectedVideos addObject:model];
//                [self.manager.selectedCameraVideos addObject:model];
//                [self.manager.selectedCameraList addObject:model];
//            }
//            [self.manager.selectedList addObject:model];
//            model.selectIndexStr = [NSString stringWithFormat:@"%ld",[self.manager.selectedList indexOfObject:model] + 1];
//        }
//    }
//    if ([self.delegate respondsToSelector:@selector(datePhotoPreviewControllerDidDone:)]) {
//        [self.delegate previewControllerDidDone:self];
//    }
//}

#pragma mark - < 懒加载 >
- (HXPhotoCustomNavigationBar *)navBar {
    if (!_navBar) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        _navBar = [[HXPhotoCustomNavigationBar alloc] initWithFrame:CGRectMake(0, 0, width, kNavigationBarHeight)];
        _navBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [_navBar pushNavigationItem:self.navItem animated:NO];
    }
    return _navBar;
}

- (UINavigationItem *)navItem {
    if (!_navItem) {
        _navItem = [[UINavigationItem alloc] init];
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
        [_selectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _selectBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_selectBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_selectBtn setBackgroundColor:[UIColor femaleBlueColor]];
        [_selectBtn addTarget:self action:@selector(didSelectClick:) forControlEvents:UIControlEventTouchUpInside];
        _selectBtn.hx_size = CGSizeMake(60, 24);
        _selectBtn.layer.cornerRadius = 4;
    }
    return _selectBtn;
}

- (UIButton *)selectedBtn {
    if (!_selectedBtn) {
        _selectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectedBtn setTitleColor:[UIColor blackTextColor] forState:UIControlStateNormal];
        [_selectedBtn setBackgroundImage:[UIImage imageNamed:@"letad_album_2"] forState:UIControlStateNormal];
        [_selectedBtn addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
        _selectedBtn.frame = CGRectMake(self.view.width - 40, 80, 30, 30);
        [_selectedBtn setEnlargeEdgeWithTop:0 right:0 bottom:20 left:20];
    }
    return _selectedBtn;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(-10, kTopMargin,self.view.hx_w + 20, self.view.hx_h - kTopMargin - kBottomMargin) collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[HXDatePhotoPreviewViewCell class] forCellWithReuseIdentifier:@"DatePreviewCellId"];
#ifdef __IPHONE_11_0
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
#else
            if ((NO)) {
#endif
            } else {
                self.automaticallyAdjustsScrollViewInsets = NO;
                
            }
        }
        return _collectionView;
    }
    
    - (UICollectionViewFlowLayout *)flowLayout {
        if (!_flowLayout) {
            _flowLayout = [[UICollectionViewFlowLayout alloc] init];
            _flowLayout.minimumInteritemSpacing = 0;
            _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            
            if (self.outside) {
                _flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
            } else {
#ifdef __IPHONE_11_0
                if (@available(iOS 11.0, *)) {
#else
                    if ((NO)) {
#endif
                        _flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
                    } else {
                        _flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
                    }
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
            HXDatePhotoPreviewViewCell *cell = (HXDatePhotoPreviewViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentModelIndex inSection:0]];
            [cell cancelRequest];
            if ([UIApplication sharedApplication].statusBarHidden) {
                [self.navigationController setNavigationBarHidden:NO animated:NO];
            }
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
            //    NSSLog(@"dealloc");
        }
@end
