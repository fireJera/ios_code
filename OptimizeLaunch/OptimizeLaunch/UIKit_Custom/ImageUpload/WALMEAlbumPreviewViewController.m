//
//  WALMEAlbumPreviewViewController.m
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import "WALMEAlbumPreviewViewController.h"
#import "HXPhotoPreviewViewCell.h"
#import "HXTransition.h"
#import "UIView+HXExtension.h"
#import "UIButton+HXExtension.h"
//#import "HXPresentTransition.h"
#import "HXPhotoCustomNavigationBar.h"
#import "WALMEAlbumListViewmodel.h"
#import "WALMEControllerHeader.h"
#import "WALMEVideoCompressHelper.h"
#import "HXPhotoUIManager.h"
#import "HXPhotoTools.h"

@interface WALMEAlbumPreviewViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UILabel *titleLb;
@property (strong, nonatomic) UIButton *rightBtn;
@property (strong, nonatomic) UIButton *leftBtn;
@property (strong, nonatomic) HXPhotoPreviewViewCell *livePhotoCell;
@property (assign, nonatomic) BOOL firstWillDisplayCell;
@property (strong, nonatomic) HXPhotoCustomNavigationBar *navBar;
@property (strong, nonatomic) UINavigationItem *navItem;
@property (assign, nonatomic) BOOL firstOn;

@end

@implementation WALMEAlbumPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self walme_setup];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (HXPhotoCustomNavigationBar *)navBar {
    if (!_navBar) {
        
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        _navBar = [[HXPhotoCustomNavigationBar alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
        _navBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.view addSubview:_navBar];
        [_navBar pushNavigationItem:self.navItem animated:NO];
//        _navBar.tintColor = self.manager.UIManager.navLeftBtnTitleColor;
//        if (self.manager.UIManager.navBackgroundImageName) {
//            [_navBar setBackgroundImage:[HXPhotoTools hx_imageNamed:self.manager.UIManager.navBackgroundImageName] forBarMetrics:UIBarMetricsDefault];
//        }
//        else if (self.manager.UIManager.navBackgroundColor) {
//            [_navBar setBackgroundColor:self.manager.UIManager.navBackgroundColor];
//        }
    }
    return _navBar;
}

- (UINavigationItem *)navItem {
    if (!_navItem) {
        _navItem = [[UINavigationItem alloc] init];
        _navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftBtn];
        _navItem.titleView = self.titleLb;
    }
    return _navItem;
}

- (void)walme_setup {
    if (self.isPreview) {
        // 防错,,,,,如果出现问题麻烦及时告诉我..... qq294005139
        for (HXPhotoModel *model in self.modelList) {
            model.selected = YES;
        }
    }
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];
    
    [self setupNavRightBtn];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(width, height - 0);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 20;
    if (@available(iOS 11.0, *)) {
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    } else {
        flowLayout.sectionInset = UIEdgeInsetsMake(-20, 10, 0, 10);
        
    }
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(-10, 0, width + 20, height - 0) collectionViewLayout:flowLayout];
    collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.pagingEnabled = YES;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.contentSize = CGSizeMake(self.modelList.count * (width + 20), 0);
    
    [collectionView registerClass:[HXPhotoPreviewViewCell class] forCellWithReuseIdentifier:@"cellId"];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    [collectionView setContentOffset:CGPointMake(self.index * (width + 20), 0) animated:NO];
    [self.view addSubview:self.selectedBtn];
    HXPhotoModel *model = self.modelList[self.index];
    self.selectedBtn.selected = model.selected;
    
    [self.selectedBtn setBackgroundImage:[UIImage imageNamed:model.selected ? @"checkbox_act" : @"checkbox_def"] forState:UIControlStateNormal];
    [self.selectedBtn setImage:nil forState:UIControlStateNormal];
    [self.selectedBtn setTitle:model.selected ? [NSString stringWithFormat:@"%d", model.selectedPhotosIndex + 1] : @"" forState:UIControlStateNormal];
    
    __weak typeof(self) weakSelf = self;
    [self.manager setPhotoLibraryDidChangeWithPhotoPreviewViewController:^(NSArray *collectionChanges){
        [weakSelf systemPhotoDidChange:collectionChanges];
    }];
    [self.view addSubview:self.navBar];
//    if (self.manager.UIManager.navBar) {
//        self.manager.UIManager.navBar(self.navBar);
//    }
//    if (self.manager.UIManager.navItem) {
//        self.manager.UIManager.navItem(self.navItem);
//    }
//    if (self.manager.UIManager.navRightBtn) {
//        self.manager.UIManager.navRightBtn(self.rightBtn);
//    }
    _selectedBtn.hidden = _viewmodel.maxNum == 1;
}


- (void)setupNavRightBtn {
    if (self.manager.selectedList.count > 0) {
        self.navItem.rightBarButtonItem.enabled = YES;
        [self.rightBtn setBackgroundColor:[UIColor blueColor]];
    } else {
        [self.rightBtn setTitle:[NSBundle hx_localizedStringForKey:@"下一步"] forState:UIControlStateNormal];
        [self.rightBtn setBackgroundColor:[UIColor blueColor]];
    }
}

- (void)systemPhotoDidChange:(NSArray *)list {
    if (list.count > 0) {
        NSDictionary *dic = list.firstObject;
        PHFetchResultChangeDetails *collectionChanges = dic[@"collectionChanges"];
        if (collectionChanges) {
            if ([collectionChanges hasIncrementalChanges]) {
                
                if (collectionChanges.insertedObjects.count > 0) {
                    [self.collectionView reloadData];
                    [self setupNavRightBtn];
                    [self scrollViewDidScroll:self.collectionView];
                }
                
                if (collectionChanges.removedObjects.count > 0) {
                    [self.collectionView reloadData];
                    [self setupNavRightBtn];
                    [self scrollViewDidScroll:self.collectionView];
                    if (self.modelList.count == 0) {
                        self.selectedBtn.selected = NO;
                    }
                }
            }
        }
    }
}

- (void)dismissClick {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.modelList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HXPhotoPreviewViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    cell.model = self.modelList[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    HXPhotoPreviewViewCell *myCell = (HXPhotoPreviewViewCell *)cell;
    if (myCell.requestID) {
        [[PHImageManager defaultManager] cancelImageRequest:myCell.requestID];
    }
    if (myCell.longRequestId) {
        [[PHImageManager defaultManager] cancelImageRequest:myCell.longRequestId];
    }
    if (myCell.liveRequestID) {
        [[PHImageManager defaultManager] cancelImageRequest:myCell.liveRequestID];
    }
    if (myCell.model.type == WALMEPhotoModelMediaTypeGif) {
        [myCell stopGifImage];
    }else if (myCell.model.type == WALMEPhotoModelMediaTypeLive) {
        [myCell stopLivePhoto];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat offsetx = scrollView.contentOffset.x;
    NSInteger currentIndex = (offsetx + (width + 20) * 0.5) / (width + 20);
    if (currentIndex > self.modelList.count - 1) {
        currentIndex = self.modelList.count - 1;
    }
    if (currentIndex < 0) {
        currentIndex = 0;
    }
    if (self.modelList.count == 0) {
        self.titleLb.text = @"0/0";
    }else {
        self.titleLb.text = [NSString stringWithFormat:@"%d/%d", (int)(currentIndex + 1), (int)self.modelList.count];
    }
    if (self.modelList.count > 0) {
        HXPhotoModel *model = self.modelList[currentIndex];
        
        self.selectedBtn.selected = model.selected;
        [self.selectedBtn setBackgroundImage:[UIImage imageNamed:model.selected ? @"checkbox_act" : @"checkbox_def"] forState:UIControlStateNormal];
        NSString * str = model.selected ? [NSString stringWithFormat:@"%d", model.selectedPhotosIndex + 1] : @"";
        NSLog(@"%@", str);
        [self.selectedBtn setTitle:model.selected ? [NSString stringWithFormat:@"%d", model.selectedPhotosIndex + 1] : @"" forState:UIControlStateNormal];
        
    }
    self.index = currentIndex;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    HXPhotoModel *model = self.modelList[self.index];
    self.currentModel = model;
    if (model.isCloseLivePhoto) {
        return;
    }
    
    HXPhotoPreviewViewCell *cell = (HXPhotoPreviewViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.index inSection:0]];
    if (model.type == WALMEPhotoModelMediaTypeLive) {
        [cell startLivePhoto];
        self.livePhotoCell = cell;
    } else if (model.type == WALMEPhotoModelMediaTypeGif) {
        [cell startGifImage];
    } else {
        if (!model.previewPhoto) {
            [cell fetchLongPhoto];
        }
    }
}


- (UILabel *)titleLb {
    if (!_titleLb) {
        _titleLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        _titleLb.textColor = [UIColor walme_colorWithRGB:0x212121];
        _titleLb.font = [UIFont walme_PingFangMedium15];
        _titleLb.textAlignment = NSTextAlignmentCenter;
        _titleLb.text = [NSString stringWithFormat:@"%d/%d", (int)self.index + 1, (int)self.modelList.count];
    }
    return _titleLb;
}

- (UIButton *)selectedBtn {
    if (!_selectedBtn) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        _selectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectedBtn setTitleColor:[UIColor walme_colorWithRGB:0x212121] forState:UIControlStateNormal];
        [_selectedBtn setTitleColor:[UIColor walme_colorWithRGB:0x212121] forState:UIControlStateSelected];
        _selectedBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        
        CGFloat selectedBtnW = 32;//image.size.width;
        CGFloat selectedBtnH = 32;//image.size.height;
        _selectedBtn.frame = CGRectMake(width - 30 - selectedBtnW, 0 + 20, selectedBtnW, selectedBtnH);
        
        [_selectedBtn addTarget:self action:@selector(didSelectedClick:) forControlEvents:UIControlEventTouchUpInside];
        [_selectedBtn setEnlargeEdgeWithTop:20 right:20 bottom:20 left:20];
    }
    return _selectedBtn;
}

- (void)selectClick {
    HXPhotoModel *model = self.modelList[self.index];
    if (!self.selectedBtn.selected && !model.selected) {
        [self didSelectedClick:self.selectedBtn];
    }
}


- (void)didSelectedClick:(UIButton *)button {
    if (self.modelList.count == 0) {
        [self.view showImageHUDText:[NSBundle hx_localizedStringForKey:@"没有照片可选!"]];
        return;
    }
    HXPhotoModel *model = self.modelList[self.index];
    if (!button.selected) {
        NSString *str = [HXPhotoTools maximumOfJudgment:model manager:self.manager];
        if (str) {
            [self.view showImageHUDText:str];
            return;
        }
//        if (model.type != WALMEPhotoModelMediaTypeCameraVideo && model.type != WALMEPhotoModelMediaTypeCameraPhoto) {
            HXPhotoPreviewViewCell *cell = (HXPhotoPreviewViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.index inSection:0]];
            if (cell) {
                if (model.type == WALMEPhotoModelMediaTypeGif) {
                    if (cell.imageView.image.images.count > 0) {
                        model.thumbPhoto = cell.imageView.image.images.firstObject;
                        model.previewPhoto = cell.imageView.image.images.firstObject;
                    } else {
                        model.thumbPhoto = cell.imageView.image;
                        model.previewPhoto = cell.imageView.image;
                    }
                } else {
                    model.thumbPhoto = cell.imageView.image;
                    model.previewPhoto = cell.imageView.image;
                }
            } else {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    HXPhotoPreviewViewCell *cell_1 = (HXPhotoPreviewViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.index inSection:0]];
                    if (model.type == WALMEPhotoModelMediaTypeGif) {
                        model.thumbPhoto = cell_1.firstImage;
                        model.previewPhoto = cell_1.firstImage;
                    } else {
                        model.thumbPhoto = cell_1.imageView.image;
                        model.previewPhoto = cell_1.imageView.image;
                    }
                });
            }
//        }
        if (model.type == WALMEPhotoModelMediaTypePhoto || (model.type == WALMEPhotoModelMediaTypeGif || model.type == WALMEPhotoModelMediaTypeLive)) {
            [self.manager.selectedPhotos addObject:model];
        } else if (model.type == WALMEPhotoModelMediaTypeVideo) {
            [self.manager.selectedVideos addObject:model];
        }
//        else if (model.type == WALMEPhotoModelMediaTypeCameraPhoto) {
//            [self.manager.selectedPhotos addObject:model];
//            [self.manager.selectedCameraPhotos addObject:model];
//            [self.manager.selectedCameraList addObject:model];
//        }
//        else if (model.type == WALMEPhotoModelMediaTypeCameraVideo) {
//            [self.manager.selectedVideos addObject:model];
//            [self.manager.selectedCameraVideos addObject:model];
//            [self.manager.selectedCameraList addObject:model];
//        }
        [self.manager.selectedList addObject:model];
        CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        anim.duration = 0.25;
        anim.values = @[@(1.2),@(0.8),@(1.1),@(0.9),@(1.0)];
        [button.layer addAnimation:anim forKey:@""];
    } else {
//        if (model.type != WALMEPhotoModelMediaTypeCameraVideo && model.type != WALMEPhotoModelMediaTypeCameraPhoto) {
            model.thumbPhoto = nil;
            model.previewPhoto = nil;
//        }
        if ((model.type == WALMEPhotoModelMediaTypePhoto || model.type == WALMEPhotoModelMediaTypeGif) || (model.type == WALMEPhotoModelMediaTypeVideo || model.type == WALMEPhotoModelMediaTypeLive)) {
            if (model.type == WALMEPhotoModelMediaTypePhoto || model.type == WALMEPhotoModelMediaTypeGif || model.type == WALMEPhotoModelMediaTypeLive) {
                [self.manager.selectedPhotos removeObject:model];
            } else if (model.type == WALMEPhotoModelMediaTypeVideo) {
                [self.manager.selectedVideos removeObject:model];
            }
        }
//        else if (model.type == WALMEPhotoModelMediaTypeCameraPhoto) {
//            [self.manager.selectedPhotos removeObject:model];
//            [self.manager.selectedCameraPhotos removeObject:model];
//            [self.manager.selectedCameraList removeObject:model];
//        }
        [self.manager.selectedList removeObject:model];
    }
    button.selected = !button.selected;
    model.selected = button.selected;
    
    for (int i = 0; i < self.manager.selectedPhotos.count; i++) {
        HXPhotoModel * model = [self.manager.selectedPhotos objectAtIndex:i];
        model.selectedPhotosIndex = i;
    }
    
    if (model.selected) {
        [button setTitle:[NSString stringWithFormat:@"%d", model.selectedPhotosIndex + 1] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"checkbox_act"] forState:UIControlStateNormal];
    }
    else {
        [button setTitle:@"" forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"checkbox_def"] forState:UIControlStateNormal];
    }
    
    if (self.manager.selectedList.count > 0) {
        self.navItem.rightBarButtonItem.enabled = YES;
    }
    if ([self.delegate respondsToSelector:@selector(didSelectedClick:AddOrDelete:)]) {
        [self.delegate didSelectedClick:model AddOrDelete:button.selected];
    }
}

- (UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setTitle:[NSBundle hx_localizedStringForKey:@"下一步"] forState:UIControlStateNormal];
        [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rightBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
//        [_rightBtn setTitleColor:self.manager.UIManager.navRightBtnNormalTitleColor forState:UIControlStateNormal];
//        [_rightBtn setTitleColor:self.manager.UIManager.navRightBtnDisabledTitleColor forState:UIControlStateDisabled];
        [_rightBtn setTitleColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
        _rightBtn.layer.masksToBounds = YES;
        _rightBtn.layer.cornerRadius = 4;
        [self.rightBtn setBackgroundColor:[UIColor blueColor]];
        
        [_rightBtn addTarget:self action:@selector(didNextClick:) forControlEvents:UIControlEventTouchUpInside];
        _rightBtn.titleLabel.font = [UIFont walme_PingFangMedium11];
        _rightBtn.frame = CGRectMake(0, 0, 60, 25);
    }
    return _rightBtn;
}

- (UIButton *)leftBtn {
    if (!_leftBtn) {
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftBtn setTitle:@"取消" forState:UIControlStateNormal];
        _leftBtn.titleLabel.font = [UIFont walme_PingFangMedium15];
        [_leftBtn setTitleColor:[UIColor walme_colorWithRGB:0x212121] forState:UIControlStateNormal];
        [_leftBtn addTarget:self action:@selector(dismissClick) forControlEvents:UIControlEventTouchUpInside];
        _leftBtn.frame = CGRectMake(0, 0, 60, 25);
    }
    return _leftBtn;
}

#pragma mark - 点击下一步

- (void)didNextClick:(UIButton *)button {
    if (self.modelList.count == 0) {
        [self.view showImageHUDText:@"没有照片可选!"];
        return;
    }
    HXPhotoModel *model = self.modelList[self.index];
    BOOL max = NO;
    if (self.manager.selectedList.count == self.manager.maxNum) {
        // 已经达到最大选择数
        max = YES;
    }
    if (self.manager.selectionType == WALMEAlbumListSelectionTypeAll) {
        if (model.type == WALMEPhotoModelMediaTypePhoto ||
            model.type == WALMEPhotoModelMediaTypeGif ||
            model.type == WALMEPhotoModelMediaTypeLive) {
            if (self.manager.maxVideoNum > 0) {
//                if (!self.manager.selectTogether) { // 是否支持图片视频同时选择
                    if (self.manager.selectedVideos.count > 0 ) {
                        // 已经选择了视频,不能再选图片
                        max = YES;
                    }
//                }
            }
            if (self.manager.selectedPhotos.count == self.manager.maxPhotoNum) {
                max = YES;
                // 已经达到图片最大选择数
            }
        }
    }
    else if (self.manager.selectionType == WALMEAlbumListSelectionTypePhoto) {
        if (self.manager.selectedPhotos.count == self.manager.maxPhotoNum) {
            // 已经达到图片最大选择数
            max = YES;
        }
    }
    if (self.manager.selectedList.count == 0) {
        if (!self.selectedBtn.selected && !max && self.modelList.count > 0) {
            model.selected = YES;
            HXPhotoPreviewViewCell *cell = (HXPhotoPreviewViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.index inSection:0]];
            model.thumbPhoto = cell.imageView.image;
            model.previewPhoto = cell.imageView.image;
            [self didSelectedClick:self.selectedBtn];
        }
    }
    
    __weak typeof(self) weakSelf = self;
    int totalCount = (int)(_manager.selectedPhotos.count);
    NSString * str = [NSString stringWithFormat:@"0/%d", totalCount];
//    MBProgressHUD * hud = [self.view customProgressHUDTitle:str];
    button.enabled = NO;
    
    [_viewmodel walme_uploadImages:_manager.selectedPhotos progress:^(float singleProgress, float totalProgress) {
        NSString * proStr = [NSString stringWithFormat:@"%.2f", totalProgress];
//        hud.detailsLabel.text = proStr;
    } result:^(int sendCount, int failCount, NSArray * _Nonnull sendResults, NSArray<HXPhotoModel *> * _Nonnull failModels, NSArray<UIImage *> * _Nullable successImages, NSArray<NSString *> * _Nullable photoPaths) {
        if (totalCount == sendCount) {
            button.enabled = YES;
//            [hud hideAnimated:YES];
            weakSelf.viewmodel.selectedImages = successImages;
            weakSelf.viewmodel.uploadedResults = sendResults;
            weakSelf.viewmodel.uploadedPaths = photoPaths;
            if (_viewmodel.maxNum == 1) {
                if (failCount == 1) {
                    if ([weakSelf.delegate respondsToSelector:@selector(imageUploadFromPhoto:clipImage:success:result:)]) {
                        [weakSelf.delegate imageUploadFromPhoto:[successImages objectOrNilAtIndex:0] clipImage:nil success:NO result:[sendResults objectOrNilAtIndex:0]];
                    }
                } else {
                    if ([weakSelf.delegate respondsToSelector:@selector(imageUploadFromPhoto:clipImage:success:result:)]) {
                        [weakSelf.delegate imageUploadFromPhoto:[successImages objectOrNilAtIndex:0] clipImage:nil success:YES result:[sendResults objectOrNilAtIndex:0]];
                    }
                }
            } else {
                if ([weakSelf.delegate respondsToSelector:@selector(previewUpload:sendCount:failCount:sendResults:)]) {
                    [weakSelf.delegate previewUpload:weakSelf sendCount:sendCount failCount:failCount sendResults:sendResults];
                }
            }
//            [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    HXPhotoModel *model = self.modelList[self.index];
    self.currentModel = model;
    if (model.isCloseLivePhoto) {
        return;
    }
    HXPhotoPreviewViewCell *cell = (HXPhotoPreviewViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.index inSection:0]];
    
    if (!cell) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            HXPhotoPreviewViewCell *cell_1 = (HXPhotoPreviewViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.index inSection:0]];
            if (model.type == WALMEPhotoModelMediaTypeLive) {
                [cell_1 startLivePhoto];
                self.livePhotoCell = cell_1;
            } else if (model.type == WALMEPhotoModelMediaTypeGif) {
                [cell_1 startGifImage];
            } else {
                [cell_1 fetchLongPhoto];
            }
        });
    }else {
        if (model.type == WALMEPhotoModelMediaTypeLive) {
            [cell startLivePhoto];
            self.livePhotoCell = cell;
        } else if (model.type == WALMEPhotoModelMediaTypeGif) {
            [cell startGifImage];
        } else {
            [cell fetchLongPhoto];
        }
    }
}

- (void)dealloc {
    NSSLog(@"dealloc");
}


@end

