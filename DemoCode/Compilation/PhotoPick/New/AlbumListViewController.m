//
//  AlbumListViewController.m
//  PhotoPick
//
//  Created by Jeremy on 2019/3/21.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import "AlbumListViewController.h"
#import "AlbumListViewmodel.h"
#import "UIView+LETAD_Frame.h"
#import "AlbumTool.h"
#import "AlbumListCell.h"
#import "AlbumListView.h"
#import "CustomNavigationBar.h"
#import "AlbumListTitleButton.h"
#import "AlbumModel.h"
#import "PhotoModel.h"
#import "MediaPreviewViewController.h"

static NSString * const kAlbumListCell = @"albumListCell";

@interface AlbumListViewController () <UICollectionViewDelegate, UICollectionViewDataSource,
AlbumListViewDelegate, AlbumListCellDelegate,
CAAnimationDelegate, MediaPreviewViewControllerDelegate>

@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout * flowLayout;
@property (strong, nonatomic) UIButton *rightBtn;                                       //右边下一步
//@property (strong, nonatomic) UIButton *leftBtn;                                        //左边取消
//@property (strong, nonatomic) UIActivityIndicatorView *indica;                          //系统自带菊花view
@property (strong, nonatomic) UILabel *authorizationLb;                                 //
@property (nonatomic, strong) UINavigationItem * navItem;
@property (nonatomic, strong) UIView * albumListBgView;                                 //展开相册列表时的黑色背景
@property (nonatomic, strong) AlbumListView * albumListView;
@property (strong, nonatomic) CustomNavigationBar *navBar;
@property (weak, nonatomic) AlbumListTitleButton *titleBtn;
@property (strong, nonatomic) NSTimer *timer;

@property (copy, nonatomic) NSArray<AlbumModel *> *albums;
@property (strong, nonatomic) AlbumModel *selectedAlbum;
@property (assign, nonatomic) NSInteger currentSelectCount;
@property (strong, nonatomic) NSIndexPath *currentIndexPath;

@property (nonatomic, weak) id<UIViewControllerPreviewing> previewingContext;           // 3DTouch

@end

@implementation AlbumListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setViewmodel];
    [self setView];
    [self p_getAllAlbums];
    // 获取当前应用对照片的访问授权状态
    if ([PHPhotoLibrary authorizationStatus] != PHAuthorizationStatusAuthorized) {
        [self.view addSubview:self.authorizationLb];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(observeAuthrizationStatusChange:) userInfo:nil repeats:YES];
    } else {
//        [self goCameraVC];
    }
    __weak typeof(self) weakSelf = self;
    [self.viewmodel setPhotoLibraryDidChangeWithPhotoViewController:^(NSArray * _Nonnull collectionChanges) {
        [weakSelf photoLibraryDidChange:collectionChanges];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

#pragma mark - set view

- (void)setView {
    [self setNavBarView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat width = self.view.width;
    CGFloat height = self.view.height;
    
    CGFloat spacing = 0.5;
    CGFloat CVwidth = (width - spacing * self.viewmodel.columnCount - 1 ) / self.viewmodel.columnCount;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(CVwidth, CVwidth);
    flowLayout.minimumInteritemSpacing = spacing;
    flowLayout.minimumLineSpacing = spacing;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, width, height - kBottomMargin) collectionViewLayout:flowLayout];
    self.collectionView.scrollIndicatorInsets = self.collectionView.contentInset;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[AlbumListCell class] forCellWithReuseIdentifier:kAlbumListCell];
    [self.view addSubview:self.collectionView];
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
        self.automaticallyAdjustsScrollViewInsets = NO;
#pragma clang diagnostic pop
    }
    if (!self.viewmodel.singleSelected) {
        self.collectionView.contentInset = UIEdgeInsetsMake(spacing + kNavigationBarHeight, 0, spacing + 50, 0);
        if (self.viewmodel.selectionType == AlbumListSelectionTypeVideo) {
            self.collectionView.contentInset = UIEdgeInsetsMake(spacing + kNavigationBarHeight, 0,  spacing, 0);
            self.collectionView.scrollIndicatorInsets = self.collectionView.contentInset;
        }
    } else {
        self.collectionView.contentInset = UIEdgeInsetsMake(spacing + kNavigationBarHeight, 0,  spacing, 0);
    }
    self.collectionView.scrollIndicatorInsets = self.collectionView.contentInset;
    
    [self.view addSubview:self.albumListBgView];
    AlbumListView *albumListView = [[AlbumListView alloc] initWithFrame:CGRectMake(0, -340, width, 340) viewmodel:_viewmodel];
    albumListView.delegate = self;
    [self.view addSubview:albumListView];
    self.albumListView = albumListView;
    
    [self.view addSubview:self.navBar];
}

- (void)setNavBarView {
    if (!self.viewmodel.singleSelected) {
        self.navItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];
        if (self.viewmodel.selectedList.count > 0) {
            self.navItem.rightBarButtonItem.enabled = YES;
            [self.rightBtn setTitle:[NSString stringWithFormat:@"%@(%ld)", @"下一步", self.viewmodel.selectedList.count] forState:UIControlStateNormal];
            UIColor * color = [UIColor colorWithRed:253/255.0 green:142/255.0 blue:36/255.0 alpha:1];
            [self.rightBtn setBackgroundColor:color];
            self.rightBtn.layer.borderWidth = 0;
            CGFloat rightBtnH = self.rightBtn.frame.size.height;
            CGFloat rightBtnW = [AlbumTool getTextWidth:self.rightBtn.currentTitle height:rightBtnH fontSize:14];
            self.rightBtn.frame = CGRectMake(0, 0, rightBtnW + 20, rightBtnH);
        } else {
            self.navItem.rightBarButtonItem.enabled = NO;
            [self.rightBtn setTitle:@"下一步" forState:UIControlStateNormal];
            [self.rightBtn setBackgroundColor:[UIColor whiteColor]];
            self.rightBtn.frame = CGRectMake(0, 0, 60, 25);
            self.rightBtn.layer.borderWidth = 0.5;
        }
    }
//    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftBtn];
}

- (void)setViewmodel {
    if (!_viewmodel) {
        _viewmodel = [[AlbumListViewmodel alloc] init];
    }
    _viewmodel.selecting = YES;
    [_viewmodel getCellIcons];
}

#pragma mark - touch event

- (void)goSetup {
    NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if (@available(iOS 10.0, *)) {
        //        NSDictionary * options = @{UIApplicationOpenURLOptionUniversalLinksOnly : @YES}
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
#pragma clang diagnostic pop
    }
}

/**
 点击取消按钮 清空所有操作
 */
- (void)cancelClick:(UIButton *)sender {
    self.viewmodel.selecting = NO;
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    [self.viewmodel.selectedList removeAllObjects];
    [self.viewmodel.selectedPhotos removeAllObjects];
    [self.viewmodel.selectedVideos removeAllObjects];
    if ([self.delegate respondsToSelector:@selector(albumListViewControllerDidCancel:)]) {
        [self.delegate albumListViewControllerDidCancel:self];
    }
//    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 展开/收起 相册列表
 
 @param button 按钮
 */
- (void)pushAlbumList:(UIButton *)button {
    button.selected = !button.selected;
    button.userInteractionEnabled = NO;
    if (button.selected) {
        if (self.viewmodel.selectedList.count > 0) {
            for (AlbumModel *album in self.albums) {
                album.selectCount = 0;
            }
            for (PhotoModel *photoModel in self.viewmodel.selectedList) {
                for (AlbumModel *innerAlbum in self.albums) {
                    if ([innerAlbum.result containsObject:photoModel.asset]) {
                        innerAlbum.selectCount++;
                    }
                }
            }
        } else {
            for (AlbumModel *album in self.albums) {
                album.selectCount = 0;
            }
        }
        self.albumListView.albumList = self.albums;
        self.currentSelectCount = self.selectedAlbum.selectCount;
        
        self.albumListBgView.hidden = NO;
        [UIView animateWithDuration:0.2 animations:^{
            self.albumListView.frame = CGRectMake(0, kNavigationBarHeight, self.view.frame.size.width, 340);
            self.albumListView.tableView.frame = CGRectMake(0, 15, self.view.frame.size.width, 340);
            button.imageView.transform = CGAffineTransformMakeRotation(M_PI);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.25 animations:^{
                self.albumListView.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, 340);
            } completion:^(BOOL finished) {
                button.userInteractionEnabled = YES;
            }];
        }];
        [UIView animateWithDuration:0.45 animations:^{
            self.albumListBgView.alpha = 1;
        }];
    } else {
        [UIView animateWithDuration:0.45 animations:^{
            self.albumListBgView.alpha = 0;
        } completion:^(BOOL finished) {
            self.albumListBgView.hidden = YES;
            button.userInteractionEnabled = YES;
        }];
        [UIView animateWithDuration:0.25 animations:^{
            self.albumListView.tableView.frame = CGRectMake(0, 15, self.view.frame.size.width, 340);
            button.imageView.transform = CGAffineTransformMakeRotation(M_PI * 2);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                self.albumListView.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, 340);
                self.albumListView.frame = CGRectMake(0, -340, self.view.frame.size.width, 340);
            }];
        }];
    }
}

- (void)didNextClick:(UIButton *)button {
    [self cleanSelectedList];
    self.viewmodel.selecting = NO;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didAlbumsBgViewClick {
    [self pushAlbumList:self.titleBtn];
}

#pragma mark - public func 

#pragma mark - private func

- (void)p_getAllAlbums {
    [self.view showLoadingHUDText:@"加载中"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __weak typeof(self) weakSelf = self;
        [self.viewmodel fetchAllAlbum:^(NSArray<AlbumModel *> * _Nonnull albums) {
            weakSelf.albums = albums;
            [weakSelf p_getAlbumPhotos];
        }];
    });
}

- (void)p_getAlbumPhotos {
    AlbumModel *model = self.albums.firstObject;
    self.currentSelectCount = model.selectCount;
    self.selectedAlbum = model;
    __weak typeof(self) weakSelf = self;
    [self.viewmodel fetchPhotoForPHResult:model.result index:model.index result:^(NSArray<PhotoModel *> * _Nonnull photos, NSArray<PhotoModel *> * _Nonnull videos, NSArray<PhotoModel *> * _Nonnull objs) {
        weakSelf.photos = [NSMutableArray arrayWithArray:photos];
        weakSelf.videos = [NSMutableArray arrayWithArray:videos];
        weakSelf.objs = [NSMutableArray arrayWithArray:objs];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.view handleLoading];
            weakSelf.albumListView.albumList = weakSelf.albums;
            if (model.albumName.length == 0) {
                model.albumName = @"相机胶卷";
            }
            [weakSelf.titleBtn setTitle:model.albumName forState:UIControlStateNormal];
            weakSelf.title = model.albumName;
            CATransition *transition = [CATransition animation];
            transition.type = kCATransitionPush;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.fillMode = kCAFillModeForwards;
            transition.duration = 0.05;
            transition.subtype = kCATransitionFade;
            [[weakSelf.collectionView layer] addAnimation:transition forKey:@""];
            [weakSelf.collectionView reloadData];
            [weakSelf.view handleLoading];
        });
    }];
}

/**
 改变 预览、原图 按钮的状态
 
 @param model 选中的模型
 */
- (void)changeButtonClick:(PhotoModel *)model isPreview:(BOOL)isPreview {
    if (self.viewmodel.selectedList.count > 0) { // 选中数组已经有值时
        if (self.viewmodel.selectionType != AlbumListSelectionTypeVideo) {
            BOOL isVideo = NO, isPhoto = NO;
            for (PhotoModel *model in self.viewmodel.selectedList) {
                // 循环判断选中的数组中有没有视频或者图片
                if (model.type == PhotoModelMediaTypePhoto ||
                    (model.type == PhotoModelMediaTypeGif || model.type == PhotoModelMediaTypeLive)) {
                    isPhoto = YES;
                }
                else if (model.type == PhotoModelMediaTypeVideo) {
                    isVideo = YES;
                }
//                else if (model.type == PhotoModelMediaTypeCameraPhoto) {
//                    isPhoto = YES;
//                }
//                else if (model.type == PhotoModelMediaTypeCameraVideo) {
//                    isVideo = YES;
//                }
            }
        }
        self.navItem.rightBarButtonItem.enabled = YES;
        [self.rightBtn setTitle:[NSString stringWithFormat:@"%@(%ld)", @"下一步", self.viewmodel.selectedList.count] forState:UIControlStateNormal];
        UIColor * color = [UIColor colorWithRed:253/255.0 green:142/255.0 blue:36/255.0 alpha:1];
        [self.rightBtn setBackgroundColor:color];
        self.rightBtn.layer.borderWidth = 0;
        CGFloat rightBtnH = self.rightBtn.frame.size.height;
        CGFloat rightBtnW = [AlbumTool getTextWidth:self.rightBtn.currentTitle height:rightBtnH fontSize:14];
        self.rightBtn.width = rightBtnW + 20;
#ifdef __IPHONE_11_0
        if (@available(iOS 11.0, *)) {
            if (isPreview) {
                self.navItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];
            }
        }
#endif
    } else { // 没有选中时 全部恢复成初始状态
        self.navItem.rightBarButtonItem.enabled = NO;
        [self.rightBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [self.rightBtn setBackgroundColor:[UIColor whiteColor]];
        self.rightBtn.frame = CGRectMake(0, 0, 60, 25);
        self.rightBtn.layer.borderWidth = 0.5;
    }
}

- (void)p_goCameraVC {
    NSAssert(NO, @"暂不支持打开相机，自己集成");
    if (!self.viewmodel.showCamera) {
        return;
    }
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self.view showImageHUDText:@"无法使用相机!"];
        return;
    }
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"无法使用相机" message:@"请在设置-隐私-相机中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
//        [alert show];
        return;
    }
}

- (void)p_goCameraViewController {
    NSAssert(NO, @"暂不支持打开相机，自己集成");
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self.view showImageHUDText:@"无法使用相机!"];
        return;
    }
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"无法使用相机" message:@"请在设置-隐私-相机中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
//        [alert show];
        return;
    }
//    HXCameraType type = 0;
    if (self.viewmodel.selectionType == AlbumListSelectionTypeAll) {
//        if (self.photos.count > 0 && self.videos.count > 0) {
//            type = HXCameraTypePhotoAndVideo;
//        }
//        else if (self.videos.count > 0) {
//            type = HXCameraTypeVideo;
//        }
//        else {
//            type = HXCameraTypePhotoAndVideo;
//        }
    }
    else if (self.viewmodel.selectionType == AlbumListSelectionTypePhoto) {
//        type = HXCameraTypePhoto;
    }
    else if (self.viewmodel.selectionType == AlbumListSelectionTypeVideo) {
//        type = HXCameraTypeVideo;
    }
}

#pragma mark - timer
- (void)observeAuthrizationStatusChange:(NSTimer *)timer {
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized) {
        [timer invalidate];
        [self.timer invalidate];
        self.timer = nil;
        [self.authorizationLb removeFromSuperview];
//        [self goCameraVC];
        if (self.viewmodel.albums.count > 0) {
            [self p_getAllAlbums];
        }else {
            [self p_getAllAlbums];
        }
    }
}

- (void)photoLibraryDidChange:(NSArray *)list {
    for (int i = 0; i < list.count ; i++) {
        NSDictionary *dic = list[i];
        PHFetchResultChangeDetails *collectionChanges = dic[@"collectionChanges"];
        AlbumModel *albumModel = dic[@"model"];
        if (collectionChanges) {
            if ([collectionChanges hasIncrementalChanges]) {
                PHFetchResult *result = collectionChanges.fetchResultAfterChanges;
                if (collectionChanges.insertedObjects.count > 0) {
                    albumModel.asset = nil;
                    albumModel.result = result;
                    albumModel.photoCount = result.count;
                    if (self.selectedAlbum.index == albumModel.index) {
                        [self collectionChangeWithInseterData:collectionChanges.insertedObjects];
                    }
                }
                if (collectionChanges.removedObjects.count > 0) {
                    albumModel.asset = nil;
                    albumModel.result = result;
                    albumModel.photoCount = result.count;
                    
                    BOOL select = NO;
                    NSMutableArray *indexPathList = [NSMutableArray array];
                    for (PHAsset *asset in collectionChanges.removedObjects) {
                        NSString *property = @"asset";
                        NSPredicate *pred = [NSPredicate predicateWithFormat:@"%K = %@", property, asset];
                        if (i == 0) {
                            NSArray *newArray = [self.viewmodel.selectedList filteredArrayUsingPredicate:pred];
                            if (newArray.count > 0) {
                                select = YES;
                                PhotoModel *photoModel = newArray.firstObject;
                                photoModel.selected = NO;
                                if ((photoModel.type == PhotoModelMediaTypePhoto ||
                                     photoModel.type == PhotoModelMediaTypeGif) ||
                                    photoModel.type == PhotoModelMediaTypeLive) {
                                    [self.viewmodel.selectedPhotos removeObject:photoModel];
                                } else {
                                    [self.viewmodel.selectedVideos removeObject:photoModel];
                                }
                                [self.viewmodel.selectedList removeObject:photoModel];
                            }
                        }
                        if (self.selectedAlbum.index == albumModel.index) {
                            PhotoModel *photoModel;
                            if (asset.mediaType == PHAssetMediaTypeImage) {
                                NSArray *photoArray = [self.photos filteredArrayUsingPredicate:pred];
                                photoModel = photoArray.firstObject;
                                [self.photos removeObject:photoModel];
                            } else if (asset.mediaType == PHAssetMediaTypeVideo) {
                                NSArray *videoArray = [self.videos filteredArrayUsingPredicate:pred];
                                photoModel = videoArray.firstObject;
                                [self.videos removeObject:photoModel];
                            }
                            [indexPathList addObject:[NSIndexPath indexPathForItem:[self.objs indexOfObject:photoModel] inSection:0]];
                            [self.objs removeObject:photoModel];
                        }
                    }
                    if (select) {
                        [self changeButtonClick:self.viewmodel.selectedList.lastObject isPreview:NO];
                    }
                    if (indexPathList.count > 0) {
                        [self.collectionView deleteItemsAtIndexPaths:indexPathList];
                    }
                    
                }
            }
        }
    }
    self.albumListView.albumList = self.albums;
}

- (void)collectionChangeWithInseterData:(NSArray *)array {
    NSInteger insertedCount = array.count;
    NSInteger cameraIndex = self.viewmodel.showCamera ? 1 : 0;
    NSMutableArray *indexPathList = [NSMutableArray array];
    for (int i = 0; i < insertedCount; i++) {
        PHAsset *asset = array[i];
        PhotoModel *photoModel = [[PhotoModel alloc] init];
        photoModel.asset = asset;
        if (asset.mediaType == PHAssetMediaTypeImage) {
            photoModel.subType = PhotoModelMediaSubTypePhoto;
            if ([[asset valueForKey:@"filename"] hasSuffix:@"GIF"]) {
                if (self.viewmodel.singleSelected && self.viewmodel.singleSelectedClip) {
                    photoModel.type = PhotoModelMediaTypePhoto;
                }else {
                    photoModel.type = self.viewmodel.showGif ? PhotoModelMediaTypeGif : PhotoModelMediaTypePhoto;
                }
            } else {
                photoModel.type = PhotoModelMediaTypePhoto;
                if (iOS9_1_Later && [AlbumTool platform]) {
                    if (asset.mediaSubtypes == PHAssetMediaSubtypePhotoLive) {
                        if (!self.viewmodel.singleSelected) {
                            photoModel.type = self.viewmodel.showLive ? PhotoModelMediaTypeLive : PhotoModelMediaTypePhoto;
                        }
                    }
                }
            }
            [self.photos insertObject:photoModel atIndex:0];
        } else if (asset.mediaType == PHAssetMediaTypeVideo) {
            photoModel.subType = PhotoModelMediaSubTypeVideo;
            photoModel.type = PhotoModelMediaTypeVideo;
            [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:nil resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
                photoModel.avAsset = asset;
            }];
            NSString *timeLength = [NSString stringWithFormat:@"%0.0f",asset.duration];
            photoModel.videoTime = [AlbumTool getNewTimeFromDurationSecond:timeLength.integerValue];
            [self.videos insertObject:photoModel atIndex:0];
        }
        photoModel.currentAlbumIndex = self.selectedAlbum.index;
        [self.objs insertObject:photoModel atIndex:cameraIndex];
        [indexPathList addObject:[NSIndexPath indexPathForItem:i + cameraIndex inSection:0]];
    }
    [self.collectionView insertItemsAtIndexPaths:indexPathList];
}

- (void)sortSelectList {
    int i = 0, j = 0, k = 0;
    for (PhotoModel * model in self.viewmodel.selectedList) {
        if ((model.type == PhotoModelMediaTypePhoto || model.type == PhotoModelMediaTypeGif) ||
            model.type == PhotoModelMediaTypeLive) {
//            (model.type == HXPhotoModelMediaTypeCameraPhoto || model.type == HXPhotoModelMediaTypeLivePhoto)) {
            model.endIndex = i++;
        }
        else if (model.type == PhotoModelMediaTypeVideo) {
//        else if (model.type == PhotoModelMediaTypeVideo || model.type == HXPhotoModelMediaTypeCameraVideo) {
            model.videoIndex = j++;
        }
        model.endCollectionIndex = k++;
    }
}

- (void)cleanSelectedList {
    [self sortSelectList];
    
    if (!self.viewmodel.singleSelected) {
        // 记录这次操作的数据
        if ([self.delegate respondsToSelector:@selector(albumListViewControllerDidFinish:)]) {
            [self.delegate albumListViewControllerDidFinish:self];
        }
    }
    else {
        if ([self.delegate respondsToSelector:@selector(albumListViewControllerDidCancel:)]) {
            [self.delegate albumListViewControllerDidCancel:self];
        }
    }
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _objs.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AlbumListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kAlbumListCell forIndexPath:indexPath];
    if (!self.viewmodel.singleSelected) {
        cell.iconDic = self.viewmodel.albumListCellIcon;
    }
    PhotoModel *model = self.objs[indexPath.item];
    model.rowCount = self.viewmodel.columnCount;
    cell.delegate = self;
    cell.model = model;
    cell.singleSelected = self.viewmodel.singleSelected;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.navigationController.topViewController != self) {
        return;
    }
    AlbumListCell *cell = (AlbumListCell *)[_collectionView cellForItemAtIndexPath:indexPath];
    self.currentIndexPath = indexPath;
    PhotoModel *model = self.objs[indexPath.item];
    if (self.viewmodel.singleSelected) {
        if (model.type == PhotoModelMediaTypeCamera) {
            [self p_goCameraViewController];
        }
        else if (model.type == PhotoModelMediaTypeVideo) {
//            HXVideoPreviewViewController *vc = [[HXVideoPreviewViewController alloc] init];
//            vc.coverImage = cell.imageView.image;
//            vc.manager = self.viewmodel;
//            vc.delegate = self;
//            vc.model = model;
//            self.navigationController.delegate = vc;
//            [self.navigationController pushViewController:vc animated:YES];
        }
//        else if (model.type == PhotoModelMediaTypeCameraVideo) {
//            HXVideoPreviewViewController *vc = [[HXVideoPreviewViewController alloc] init];
//            vc.coverImage = cell.imageView.image;
//            vc.manager = self.viewmodel;
//            vc.delegate = self;
//            vc.model = model;
//            vc.isCamera = YES;
//            self.navigationController.delegate = vc;
//            [self.navigationController pushViewController:vc animated:YES];
//        }
        else {
//            HXPhotoEditViewController *vc = [[HXPhotoEditViewController alloc] init];
//            vc.model = model;
//            vc.delegate = self;
//            vc.coverImage = cell.imageView.image;
//            vc.photoManager = self.viewmodel;
//            [self.navigationController pushViewController:vc animated:YES];
        }
        return;
    }
//    if (model.type == PhotoModelMediaTypePhoto ||
//        (model.type == PhotoModelMediaTypeGif || model.type == PhotoModelMediaTypeLive)) {
////        HXPhotoPreviewViewController *vc = [[HXPhotoPreviewViewController alloc] init];
////        vc.modelList = self.photos;
////        vc.index = [self.photos indexOfObject:model];
////        vc.delegate = self;
////        vc.manager = self.viewmodel;
////        self.navigationController.delegate = vc;
////        [self.navigationController pushViewController:vc animated:YES];
//    }
//    else if (model.type == PhotoModelMediaTypeVideo){
////        HXVideoPreviewViewController *vc = [[HXVideoPreviewViewController alloc] init];
////        vc.coverImage = cell.imageView.image;
////        vc.manager = self.viewmodel;
////        vc.delegate = self;
////        vc.model = model;
////        self.navigationController.delegate = vc;
////        [self.navigationController pushViewController:vc animated:YES];
//    }
    else if (model.type == PhotoModelMediaTypeCamera) {
        [self p_goCameraViewController];
    }
    else {
        MediaPreviewViewController *previewVC = [[MediaPreviewViewController alloc] init];
        previewVC.delegate = self;
        previewVC.modelArray = _objs;
        previewVC.viewmodel = self.viewmodel;
        previewVC.currentModelIndex = indexPath.row;
//        self.navigationController.delegate = previewVC;
        [self.navigationController pushViewController:previewVC animated:YES];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    AlbumListCell *myCell = (AlbumListCell *)cell;
    [myCell cancelRequest];
    if (!myCell.model.selected && myCell.model.thumbPhoto) {
        if (myCell.model.type != PhotoModelMediaTypeCamera
//            && myCell.model.type != PhotoModelMediaTypeCameraPhoto
//            && myCell.model.type != PhotoModelMediaTypeCameraVideo
            ) {
            myCell.model.thumbPhoto = nil;
        }
    }
}

#pragma mark - AlbumListCellDelegate

- (void)albumListCellChangeLivePhotoState:(PhotoModel *)model {
    PhotoModel *modelInList = [self.viewmodel.selectedList objectAtIndex:[self.viewmodel.selectedList indexOfObject:model]];
    modelInList.isCloseLivePhoto = model.isCloseLivePhoto;
    
    PhotoModel *modelInPhotos = [self.viewmodel.selectedPhotos objectAtIndex:[self.viewmodel.selectedPhotos indexOfObject:model]];
    modelInPhotos.isCloseLivePhoto = model.isCloseLivePhoto;
}

- (void)albumListCellDidSelectedBtnClick:(AlbumListCell *)cell model:(PhotoModel *)model {
    if (!cell.selectBtn.selected) { // 弹簧果冻动画效果
        NSString *str = [AlbumTool maximumOfJudgment:model viewmodel:_viewmodel];
        if (str) {
            [self.view showImageHUDText:str];
            return;
        }
        [cell.maskView.layer removeAllAnimations];
        cell.maskView.hidden = NO;
        cell.maskView.alpha = 0;
        [UIView animateWithDuration:0.15 animations:^{
            cell.maskView.alpha = 1;
        }];
        CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        anim.duration = 0.25;
        anim.values = @[@(1.2),@(0.8),@(1.1),@(0.9),@(1.0)];
        [cell.selectBtn.layer addAnimation:anim forKey:@""];
    }else {
        cell.maskView.hidden = YES;
    }
    cell.selectBtn.selected = !cell.selectBtn.selected;
    cell.model.selected = cell.selectBtn.selected;
    BOOL selected = cell.selectBtn.selected;
    
    if (selected) { // 选中之后需要做的
//        if (model.type != PhotoModelMediaTypeCameraVideo && model.type != PhotoModelMediaTypeCameraPhoto) {
//            model.thumbPhoto = cell.imageView.image;
//        }
        if (model.type == PhotoModelMediaTypeLive) {
            [cell startLivePhoto];
        }
        if (model.type == PhotoModelMediaTypePhoto || (model.type == PhotoModelMediaTypeGif || model.type == PhotoModelMediaTypeLive)) { // 为图片时
            [self.viewmodel.selectedPhotos addObject:model];
        }
        else if (model.type == PhotoModelMediaTypeVideo) { // 为视频时
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
        self.selectedAlbum.selectCount++;
    } else { // 取消选中之后的
//        if (model.type != PhotoModelMediaTypeCameraVideo && model.type != PhotoModelMediaTypeCameraPhoto) {
//            model.thumbPhoto = nil;
//            model.previewPhoto = nil;
//        }
        if (model.type == PhotoModelMediaTypeLive) {
            [cell stopLivePhoto];
        }
        if ((model.type == PhotoModelMediaTypePhoto || model.type == PhotoModelMediaTypeGif) ||
            (model.type == PhotoModelMediaTypeVideo || model.type == PhotoModelMediaTypeLive)) {
            if (model.type == PhotoModelMediaTypePhoto ||
                model.type == PhotoModelMediaTypeGif ||
                model.type == PhotoModelMediaTypeLive) {
                [self.viewmodel.selectedPhotos removeObject:model];
            }
            else if (model.type == PhotoModelMediaTypeVideo) {
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
        self.selectedAlbum.selectCount--;
        [self.viewmodel.selectedList removeObject:model];
    }
}

#pragma mark - AlbumListViewDelegate
- (void)albumListViewCellClick:(AlbumModel *)model animated:(BOOL)animated {
    if (animated) {
        [self pushAlbumList:self.titleBtn];
    }
    if ([self.selectedAlbum.result isEqual:model.result]) {
        return;
    }
    // 当前相册选中的个数
    self.currentSelectCount = model.selectCount;
    self.selectedAlbum = model;
    self.title = model.albumName;
    [self.titleBtn setTitle:model.albumName forState:UIControlStateNormal];
    __weak typeof(self) weakSelf = self;
    // 获取指定相册的所有图片
    [self.viewmodel fetchPhotoForPHResult:model.result index:model.index result:^(NSArray<PhotoModel *> * _Nonnull photos, NSArray<PhotoModel *> * _Nonnull videos, NSArray<PhotoModel *> * _Nonnull objs) {
        weakSelf.photos = [NSMutableArray arrayWithArray:photos];
        weakSelf.videos = [NSMutableArray arrayWithArray:videos];
        weakSelf.objs = [NSMutableArray arrayWithArray:objs];
        CATransition *transition = [CATransition animation];
        transition.type = kCATransitionPush;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.fillMode = kCAFillModeForwards;
        transition.duration = 0.2;
        transition.delegate = weakSelf;
        transition.subtype = kCATransitionFade;
        [[weakSelf.collectionView layer] addAnimation:transition forKey:@""];
        [weakSelf.collectionView reloadData];
        [weakSelf.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
    }];
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag) {
        [self.collectionView.layer removeAllAnimations];
    }
}

//#pragma mark - previewDelegate
///**
// 查看图片时 选中或取消选中时的代理
//
// @param model 当前操作的模型
// @param state 状态
// */
//- (void)didSelectedClick:(HXPhotoModel *)model AddOrDelete:(BOOL)state {
//    if (state) { // 选中
//        self.albumModel.selectedCount++;
//    }else { // 取消选中
//        self.albumModel.selectedCount--;
//    }
//    model.selected = state;
//    [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:[self.objs indexOfObject:model] inSection:0]]];
//}
///**
// 查看视频时点击下一步按钮的代理
// */
//- (void)previewVideoDidNextClick {
//    [self didNextClick:self.rightBtn];
//}
/**
 查看视频时 选中/取消选中 的代理
 
 @param model 模型
 */
//- (void)previewVideoDidSelectedClick:(HXPhotoModel *)model
//{
//    [self.collectionView reloadData];
//    // 改变 预览、原图 按钮的状态
//    [self changeButtonClick:model isPreview:YES];
//}
///**
// 查看图片时点击下一步按钮的代理
// */
//- (void)previewDidNextClick
//{
//    [self didNextClick:self.rightBtn];
//}
//#pragma mark - < HXPhotoEditViewControllerDelegate >
//- (void)editViewControllerDidNextClick:(HXPhotoModel *)model {
//    [self.manager.selectedCameraList addObject:model];
//    [self.manager.selectedCameraPhotos addObject:model];
//    [self.manager.selectedPhotos addObject:model];
//    [self.manager.selectedList addObject:model];
//    [self didNextClick:self.rightBtn];
//}


#pragma mark - lazy property
- (UILabel *)authorizationLb {
    if (!_authorizationLb) {
        _authorizationLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 100)];
        _authorizationLb.text = @"无法访问照片\n请点击这里前往设置中允许访问照片";
        _authorizationLb.textAlignment = NSTextAlignmentCenter;
        _authorizationLb.numberOfLines = 0;
        _authorizationLb.textColor = [UIColor blackColor];
        _authorizationLb.font = [UIFont systemFontOfSize:15];
        _authorizationLb.userInteractionEnabled = YES;
        [_authorizationLb addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goSetup)]];
    }
    return _authorizationLb;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _collectionView.alwaysBounceVertical = YES;
        //        [_collectionView registerClass:[HXAlbumListQuadrateViewCell class] forCellWithReuseIdentifier:@"cellId"];
        
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            //#ifdef __IPHONE_11_0
            //
            //#else
            //            self.automaticallyAdjustsScrollViewInsets = NO;
            //#endif
        }
        //        if (self.viewmodel.open3DTouchPreview) {
        //            if ([self respondsToSelector:@selector(traitCollection)]) {
        //                if ([self.traitCollection respondsToSelector:@selector(forceTouchCapability)]) {
        //                    if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
        //                        self.previewingContext = [self registerForPreviewingWithDelegate:self sourceView:_collectionView];
        //                    }
        //                }
        //            }
        //        }
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        //        CGFloat itemWidth = (self.view.hx_w - 45) / 2;
        //        CGFloat itemHeight = itemWidth + 6 + 14 + 4 + 14;
        //        _flowLayout.itemSize = CGSizeMake(itemWidth, itemHeight);
        _flowLayout.minimumLineSpacing = 15;
        _flowLayout.minimumInteritemSpacing = 15;
        _flowLayout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
    }
    return _flowLayout;
}

- (UINavigationItem *)navItem {
    if (!_navItem) {
        _navItem = [[UINavigationItem alloc] init];
        _navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelClick:)];
        
        AlbumListTitleButton *titleBtn = [AlbumListTitleButton buttonWithType:UIButtonTypeCustom];
        [titleBtn setTitleColor:[UIColor blackTextColor] forState:UIControlStateNormal];
        [titleBtn setImage:[AlbumTool imageNamed:@"headlines_icon_arrow@2x.png"] forState:UIControlStateNormal];
        titleBtn.frame = CGRectMake(0, 0, 150, 30);
        [titleBtn setTitle:@"相机胶卷" forState:UIControlStateNormal];
        [titleBtn addTarget:self action:@selector(pushAlbumList:) forControlEvents:UIControlEventTouchUpInside];
        self.titleBtn = titleBtn;
        _navItem.title = @"相机胶卷";
        _navItem.titleView = self.titleBtn;
    }
    return _navItem;
}

- (UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rightBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        [_rightBtn setTitleColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
        _rightBtn.layer.masksToBounds = YES;
        _rightBtn.layer.cornerRadius = 2;
        _rightBtn.layer.borderWidth = 0.5;
        _rightBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [_rightBtn setBackgroundColor:[UIColor whiteColor]];
        [_rightBtn addTarget:self action:@selector(didNextClick:) forControlEvents:UIControlEventTouchUpInside];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _rightBtn.frame = CGRectMake(0, 0, 60, 25);
    }
    return _rightBtn;
}

//- (UIButton *)leftBtn {
//    if (!_leftBtn) {
//        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_leftBtn setTitle:@"取消" forState:UIControlStateNormal];
//        [_leftBtn setTitleColor:[UIColor blackTextColor] forState:UIControlStateNormal];
//        [_leftBtn setBackgroundColor:[UIColor whiteColor]];
//        [_leftBtn addTarget:self action:@selector(cancelPick:) forControlEvents:UIControlEventTouchUpInside];
//        _leftBtn.titleLabel.font = [UIFont letad_PingFangMedium16]
//        _leftBtn.frame = CGRectMake(0, 0, 60, 25);
//    }
//    return _rightBtn;
//}

- (UIView *)albumListBgView {
    if (!_albumListBgView) {
        _albumListBgView = [[UIView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, self.view.frame.size.width, self.view.frame.size.height - kNavigationBarHeight)];
        _albumListBgView.hidden = YES;
        _albumListBgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        _albumListBgView.alpha = 0;
        [_albumListBgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didAlbumsBgViewClick)]];
    }
    return _albumListBgView;
}

- (void)dealloc {
    self.viewmodel.selecting = NO;
    //    if (self.viewmodel.open3DTouchPreview) {
    //        if (self.previewingContext) {
    //            [self unregisterForPreviewingWithContext:self.previewingContext];
    //        }
    //    }
    NSSLog(@"dealloc");
}

@end
