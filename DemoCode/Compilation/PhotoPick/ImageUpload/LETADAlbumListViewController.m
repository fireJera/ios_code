//
//  LETADAlbumListViewController.m
//  LetDate
//
//  Created by Jeremy on 2019/1/21.
//  Copyright © 2019 JersiZhu. All rights reserved.
//

#import "LETADAlbumListViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <MediaPlayer/MediaPlayer.h>
#import "HXPhotoViewCell.h"
#import "HXAlbumListView.h"
#import "HXAlbumTitleButton.h"
#import "UIView+HXExtension.h"
//#import "HXPhotoEditViewController.h"
#import "UIImage+HXExtension.h"
#import "HXPhotoCustomNavigationBar.h"
//#import "HXPhoto3DTouchViewController.h"
//#import "LETADCHeader.h"
#import "LETADVideoPreviewViewController.h"
#import "LETADPhotoPerviewViewController.h"
#import "LETADClipImageViewController.h"
//#import "LETADClipImageViewmodel.h"
//#import "LETADVideoCompressHelper.h"
#import "UIView+LETAD_Frame.h"
#import "UIImage+LETAD_Custom.h"
#import "UIColor+LETAD_Hex.h"
#import "UIFont+LETAD_Common.h"

static NSString *PhotoViewCellId = @"PhotoViewCellId";

@interface LETADAlbumListViewController () <UICollectionViewDataSource,UICollectionViewDelegate,
CAAnimationDelegate,
//UIViewControllerPreviewingDelegate,
HXAlbumListViewDelegate,LETADPhotoPerviewViewControllerDelegate,
HXPhotoViewCellDelegate,
UICollectionViewDataSourcePrefetching,
LETADVideoPreviewViewControllerDelegate,
LETADNewClipImageDelegate> {
    CGRect _originalFrame;
}

@property (copy, nonatomic) NSArray *albums;                                            //
@property (weak, nonatomic) HXAlbumListView *albumView;                                 //相册列表view
@property (weak, nonatomic) HXAlbumTitleButton *titleBtn;                               //展开相册按钮
@property (strong, nonatomic) UIButton *rightBtn;                                       //右边下一步
@property (strong, nonatomic) UIButton *leftBtn;                                        //左边取消
@property (strong, nonatomic) UIView *albumsBgFace;                                     //因该是相册列表灰色背景
@property (strong, nonatomic) UIActivityIndicatorView *indica;                          //系统自带菊花view
@property (assign, nonatomic) BOOL isSelectedChange;                                    //
@property (strong, nonatomic) HXAlbumModel *albumModel;
@property (assign, nonatomic) NSInteger currentSelectCount;                             //
@property (strong, nonatomic) NSIndexPath *currentIndexPath;                            //
@property (strong, nonatomic) NSTimer *timer;                                           //开启一个计时器来监听权限的改变
@property (strong, nonatomic) UILabel *authorizationLb;                                 //
@property (weak, nonatomic) id<UIViewControllerPreviewing> previewingContext;           //
@property (assign, nonatomic) BOOL responseTraitCollection;                             //
@property (assign, nonatomic) BOOL responseForceTouchCapability;                        //
@property (assign, nonatomic) BOOL isCapabilityAvailable;                               //
@property (assign, nonatomic) BOOL selectOtherAlbum;                                    //
@property (strong, nonatomic) HXPhotoCustomNavigationBar *navBar;                       //
@property (strong, nonatomic) UINavigationItem *navItem;                                //

@end

@implementation LETADAlbumListViewController
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

- (void)goSetup {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}

//- (void)setViewmodel:(LETADAlbumListViewmodel *)viewmodel {
//    _viewmodel = viewmodel;
//
//    HXPhotoManagerSelectedType type;
//    if ([_viewmodel.uploadType isEqualToString:@"photo"]) {
//        type = HXPhotoManagerSelectedTypePhoto;
//    } else if ([_viewmodel.uploadType isEqualToString:@"video"]) {
//        type = HXPhotoManagerSelectedTypeVideo;
//    } else if ([_viewmodel.uploadType isEqualToString:@"all"]) {
//        type = HXPhotoManagerSelectedTypePhotoAndVideo;
//    } else {
//        type = HXPhotoManagerSelectedTypePhoto;
//    }
//    _manager = [[HXPhotoManager alloc] initWithType:type];
//    switch (type) {
//        case HXPhotoManagerSelectedTypePhoto:
//            _manager.photoMaxNum = _viewmodel.maxNumer;
//            _manager.maxNum = _viewmodel.maxNumer;
//            _manager.singleSelected = _viewmodel.maxNumer == 1;
//            break;
//        case HXPhotoManagerSelectedTypeVideo:
//            _manager.videoMaxNum = _viewmodel.maxNumer;
//            _manager.singleSelected = _viewmodel.maxNumer == 1;
//            _manager.videoMaxDuration = _viewmodel.maxTime;
//            _manager.videoMinDuration = _viewmodel.minTime;
//            break;
//        case HXPhotoManagerSelectedTypePhotoAndVideo:
//            _manager.singleSelected = _viewmodel.maxNumer == 1;;
//            _manager.maxNum = _viewmodel.maxNumer;
//            _manager.photoMaxNum = _viewmodel.maxNumer;
//            _manager.videoMaxNum = _viewmodel.maxNumer;
//            _manager.videoMaxDuration = _viewmodel.maxTime;
//            _manager.videoMinDuration = _viewmodel.minTime;
//            break;
//    }
//    _manager.selectTogether = YES;
//    _manager.goCamera = NO;
//    _manager.showDateHeaderSection = YES;
//    _manager.reverseDate = NO;
//
//    _manager.cacheAlbum = NO;
//    _manager.openCamera = NO;
//    _manager.rowCount = 3;
//    _manager.style = HXPhotoAlbumStylesWeibo;
//    _manager.deleteTemporaryPhoto = NO;
//    _manager.lookLivePhoto = YES;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.manager getImage];
    self.view.backgroundColor = [UIColor whiteColor];
    self.manager.selectPhoto = YES;
    [self.view layoutIfNeeded];
    [self p_letad_setup];
    if (self.manager.albums.count > 0) {
        if (self.manager.cacheAlbum) {
            [self.view showLoadingHUDText:nil];
            self.albums = self.manager.albums.mutableCopy;
            [self getAlbumPhotos];
        } else {
            [self getObjs];
        }
    }else {
        [self getObjs];
    }
    // 获取当前应用对照片的访问授权状态
    if ([PHPhotoLibrary authorizationStatus] != PHAuthorizationStatusAuthorized) {
        if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusNotDetermined) {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                
            }];
        } else {
            
        }
        [self.view addSubview:self.authorizationLb];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(observeAuthrizationStatusChange:) userInfo:nil repeats:YES];
    }
    __weak typeof(self) weakSelf = self;
    [self.manager setPhotoLibraryDidChangeWithPhotoViewController:^(NSArray *collectionChanges){
        [weakSelf photoLibraryDidChange:collectionChanges];
    }];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeModel:) name:LETADImageEditRemoveImageNotification object:nil];
}
- (void)getAlbumPhotos {
    HXAlbumModel *model = self.albums.firstObject;
    self.currentSelectCount = model.selectedCount;
    self.albumModel = model;
    __weak typeof(self) weakSelf = self;
    [self.manager FetchAllPhotoForPHFetchResult:model.result Index:model.index FetchResult:^(NSArray *photos, NSArray *videos, NSArray *Objs) {
        weakSelf.photos = [NSMutableArray arrayWithArray:photos];
        weakSelf.videos = [NSMutableArray arrayWithArray:videos];
        weakSelf.objs = [NSMutableArray arrayWithArray:Objs];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.view handleLoading];
            weakSelf.albumView.list = weakSelf.albums;
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

- (void)photoLibraryDidChange:(NSArray *)list {
    for (int i = 0; i < list.count ; i++) {
        NSDictionary *dic = list[i];
        PHFetchResultChangeDetails *collectionChanges = dic[@"collectionChanges"];
        HXAlbumModel *albumModel = dic[@"model"];
        if (collectionChanges) {
            if ([collectionChanges hasIncrementalChanges]) {
                PHFetchResult *result = collectionChanges.fetchResultAfterChanges;
                
                if (collectionChanges.insertedObjects.count > 0) {
                    albumModel.asset = nil;
                    albumModel.result = result;
                    albumModel.count = result.count;
                    if (self.albumModel.index == albumModel.index) {
                        [self collectionChangeWithInseterData:collectionChanges.insertedObjects];
                    }
                }
                if (collectionChanges.removedObjects.count > 0) {
                    albumModel.asset = nil;
                    albumModel.result = result;
                    albumModel.count = result.count;
                    
                    BOOL select = NO;
                    NSMutableArray *indexPathList = [NSMutableArray array];
                    for (PHAsset *asset in collectionChanges.removedObjects) {
                        NSString *property = @"asset";
                        NSPredicate *pred = [NSPredicate predicateWithFormat:@"%K = %@", property, asset];
                        if (i == 0) {
                            NSArray *newArray = [self.manager.selectedList filteredArrayUsingPredicate:pred];
                            if (newArray.count > 0) {
                                select = YES;
                                HXPhotoModel *photoModel = newArray.firstObject;
                                photoModel.selected = NO;
                                if ((photoModel.type == HXPhotoModelMediaTypePhoto || photoModel.type == HXPhotoModelMediaTypePhotoGif) || photoModel.type == HXPhotoModelMediaTypePhotoLivePhoto) {
                                    [self.manager.selectedPhotos removeObject:photoModel];
                                }else {
                                    [self.manager.selectedVideos removeObject:photoModel];
                                }
                                [self.manager.selectedList removeObject:photoModel];
                            }
                        }
                        if (self.albumModel.index == albumModel.index) {
                            HXPhotoModel *photoModel;
                            if (asset.mediaType == PHAssetMediaTypeImage) {
                                NSArray *photoArray = [self.photos filteredArrayUsingPredicate:pred];
                                photoModel = photoArray.firstObject;
                                [self.photos removeObject:photoModel];
                            }else if (asset.mediaType == PHAssetMediaTypeVideo) {
                                NSArray *videoArray = [self.videos filteredArrayUsingPredicate:pred];
                                photoModel = videoArray.firstObject;
                                [self.videos removeObject:photoModel];
                            }
                            [indexPathList addObject:[NSIndexPath indexPathForItem:[self.objs indexOfObject:photoModel] inSection:0]];
                            [self.objs removeObject:photoModel];
                        }
                    }
                    if (select) {
                        [self changeButtonClick:self.manager.selectedList.lastObject isPreview:NO];
                    }
                    if (indexPathList.count > 0) {
                        [self.collectionView deleteItemsAtIndexPaths:indexPathList];
                    }
                }
                if (collectionChanges.changedObjects.count > 0) {
                    
                }
                if ([collectionChanges hasMoves]) {
                    
                }
            }
        }
    }
    self.albumView.list = self.albums;
}

- (void)collectionChangeWithInseterData:(NSArray *)array {
    NSInteger insertedCount = array.count;
    NSInteger cameraIndex = self.manager.openCamera ? 1 : 0;
    NSMutableArray *indexPathList = [NSMutableArray array];
    for (int i = 0; i < insertedCount; i++) {
        PHAsset *asset = array[i];
        HXPhotoModel *photoModel = [[HXPhotoModel alloc] init];
        photoModel.asset = asset;
        if (asset.mediaType == PHAssetMediaTypeImage) {
            photoModel.subType = HXPhotoModelMediaSubTypePhoto;
            if ([[asset valueForKey:@"filename"] hasSuffix:@"GIF"]) {
                if (self.manager.singleSelected && self.manager.singleSelecteClip) {
                    photoModel.type = HXPhotoModelMediaTypePhoto;
                }else {
                    photoModel.type = self.manager.lookGifPhoto ? HXPhotoModelMediaTypePhotoGif : HXPhotoModelMediaTypePhoto;
                }
            } else {
//                if (IOS9_OR_LATER && [HXPhotoTools platform]) {
                    if (@available(iOS 9.1, *)) {
                        if (asset.mediaSubtypes == PHAssetMediaSubtypePhotoLive) {
                            if (!self.manager.singleSelected) {
                                photoModel.type = self.manager.lookLivePhoto ? HXPhotoModelMediaTypePhotoLivePhoto : HXPhotoModelMediaTypePhoto;
                            }else {
                                photoModel.type = HXPhotoModelMediaTypePhoto;
                            }
                        }else {
                            photoModel.type = HXPhotoModelMediaTypePhoto;
                        }
                    } else {
                        // Fallback on earlier versions
                    }
//                }else {
//                    photoModel.type = HXPhotoModelMediaTypePhoto;
//                }
            }
            [self.photos insertObject:photoModel atIndex:0];
        }else if (asset.mediaType == PHAssetMediaTypeVideo) {
            photoModel.subType = HXPhotoModelMediaSubTypeVideo;
            photoModel.type = HXPhotoModelMediaTypePhotoVideo;
            [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:nil resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
                photoModel.avAsset = asset;
            }];
            NSString *timeLength = [NSString stringWithFormat:@"%0.0f",asset.duration];
            photoModel.videoTime = [HXPhotoTools getNewTimeFromDurationSecond:timeLength.integerValue];
            [self.videos insertObject:photoModel atIndex:0];
        }
        photoModel.currentAlbumIndex = self.albumModel.index;
        
        [self.objs insertObject:photoModel atIndex:cameraIndex];
        [indexPathList addObject:[NSIndexPath indexPathForItem:i + cameraIndex inSection:0]];
    }
    [self.collectionView insertItemsAtIndexPaths:indexPathList];
}

- (void)observeAuthrizationStatusChange:(NSTimer *)timer {
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized) {
        [timer invalidate];
        [self.timer invalidate];
        self.timer = nil;
        [self.authorizationLb removeFromSuperview];
        
        if (self.manager.albums.count > 0) {
            if (self.manager.cacheAlbum) {
                self.albums = self.manager.albums.mutableCopy;
                [self getAlbumPhotos];
            }else {
                [self getObjs];
            }
        }else {
            [self getObjs];
        }
    }
}

/**
 获取所有相册 图片
 */
- (void)getObjs {
    [self.view showLoadingHUDText:@"加载中"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __weak typeof(self) weakSelf = self;
        BOOL isShow = self.manager.selectedList.count;
        [self.manager FetchAllAlbum:^(NSArray *albums) {
            weakSelf.albums = albums;
            [weakSelf getAlbumPhotos];
        } IsShowSelectTag:isShow];
    });
}

/**
 展开/收起 相册列表
 
 @param button 按钮
 */
- (void)pushAlbumList:(UIButton *)button {
    button.selected = !button.selected;
    button.userInteractionEnabled = NO;
    if (button.selected) {
        if (self.manager.selectedList.count > 0) {
            for (HXAlbumModel *albumMd in self.albums) {
                albumMd.selectedCount = 0;
            }
            for (HXPhotoModel *photoModel in self.manager.selectedList) {
                for (HXAlbumModel *albumMd in self.albums) {
                    if ([albumMd.result containsObject:photoModel.asset]) {
                        albumMd.selectedCount++;
                    }
                }
            }
            if (self.manager.selectedCameraList.count > 0) {
                HXAlbumModel *albumMd = self.albums.firstObject;
                albumMd.selectedCount = self.manager.selectedCameraList.count;
            }
            
        }else {
            for (HXAlbumModel *albumMd in self.albums) {
                albumMd.selectedCount = 0;
            }
        }
        self.albumView.list = self.albums;
        self.currentSelectCount = self.albumModel.selectedCount;
        
        self.albumsBgFace.hidden = NO;
        [UIView animateWithDuration:0.2 animations:^{
            self.albumView.frame = CGRectMake(0, kNavigationBarHeight, self.view.frame.size.width, 340);
            self.albumView.tableView.frame = CGRectMake(0, 15, self.view.frame.size.width, 340);
            button.imageView.transform = CGAffineTransformMakeRotation(M_PI);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.25 animations:^{
                self.albumView.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, 340);
            } completion:^(BOOL finished) {
                button.userInteractionEnabled = YES;
            }];
        }];
        [UIView animateWithDuration:0.45 animations:^{
            self.albumsBgFace.alpha = 1;
        }];
    } else {
        [UIView animateWithDuration:0.45 animations:^{
            self.albumsBgFace.alpha = 0;
        } completion:^(BOOL finished) {
            self.albumsBgFace.hidden = YES;
            button.userInteractionEnabled = YES;
        }];
        [UIView animateWithDuration:0.25 animations:^{
            self.albumView.tableView.frame = CGRectMake(0, 15, self.view.frame.size.width, 340);
            button.imageView.transform = CGAffineTransformMakeRotation(M_PI * 2);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                self.albumView.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, 340);
                self.albumView.frame = CGRectMake(0, -340, self.view.frame.size.width, 340);
            }];
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (HXPhotoCustomNavigationBar *)navBar {
    if (!_navBar) {
        _navBar = [[HXPhotoCustomNavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.hx_w, kNavigationBarHeight)];
        [_navBar pushNavigationItem:self.navItem animated:NO];
        _navBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _navBar.tintColor = [UIColor whiteColor];
        [_navBar setBackgroundColor:[UIColor whiteColor]];
    }
    return _navBar;
}

- (UINavigationItem *)navItem {
    if (!_navItem) {
        _navItem = [[UINavigationItem alloc] init];
        _navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftBtn];
        
        HXAlbumTitleButton *titleBtn = [HXAlbumTitleButton buttonWithType:UIButtonTypeCustom];
        [titleBtn setTitleColor:self.manager.UIManager.navTitleColor forState:UIControlStateNormal];
        [titleBtn setImage:[UIImage imageNamed:@"letad_forall_8"] forState:UIControlStateNormal];
        titleBtn.frame = CGRectMake(0, 0, 150, 30);
        [titleBtn setTitle:@"相机胶卷" forState:UIControlStateNormal];
        [titleBtn addTarget:self action:@selector(pushAlbumList:) forControlEvents:UIControlEventTouchUpInside];
        [titleBtn setTitleColor:[UIColor blackTextColor] forState:UIControlStateNormal];
        titleBtn.titleLabel.font = [UIFont letad_PingFangMedium15];
        self.titleBtn = titleBtn;
        _navItem.title = @"相机胶卷";
        _navItem.titleView = self.titleBtn;
    }
    return _navItem;
}

- (void)p_letad_setup {
    self.responseTraitCollection = [self respondsToSelector:@selector(traitCollection)];
    self.responseForceTouchCapability = [self.traitCollection respondsToSelector:@selector(forceTouchCapability)];
    if (self.responseTraitCollection && self.responseForceTouchCapability) {
        self.isCapabilityAvailable = self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable;
    }
    
    if (self.manager.type == HXPhotoManagerSelectedTypePhoto) {
        if (self.manager.networkPhotoUrls.count == 0) {
            self.manager.maxNum = self.manager.photoMaxNum;
        }
        if (self.manager.endCameraVideos.count > 0) {
            [self.manager.endCameraList removeObjectsInArray:self.manager.endCameraVideos];
            [self.manager.endCameraVideos removeAllObjects];
        }
    } else if (self.manager.type == HXPhotoManagerSelectedTypeVideo) {
        if (self.manager.networkPhotoUrls.count == 0) {
            self.manager.maxNum = self.manager.videoMaxNum;
        }
        if (self.manager.endCameraPhotos.count > 0) {
            [self.manager.endCameraList removeObjectsInArray:self.manager.endCameraPhotos];
            [self.manager.endCameraPhotos removeAllObjects];
        }
    }
    // 上次选择的所有记录
    self.manager.selectedList = [NSMutableArray arrayWithArray:self.manager.endSelectedList];
    self.manager.selectedPhotos = [NSMutableArray arrayWithArray:self.manager.endSelectedPhotos];
    self.manager.selectedVideos = [NSMutableArray arrayWithArray:self.manager.endSelectedVideos];
    self.manager.cameraList = [NSMutableArray arrayWithArray:self.manager.endCameraList];
    self.manager.cameraPhotos = [NSMutableArray arrayWithArray:self.manager.endCameraPhotos];
    self.manager.cameraVideos = [NSMutableArray arrayWithArray:self.manager.endCameraVideos];
    self.manager.selectedCameraList = [NSMutableArray arrayWithArray:self.manager.endSelectedCameraList];
    self.manager.selectedCameraPhotos = [NSMutableArray arrayWithArray:self.manager.endSelectedCameraPhotos];
    self.manager.selectedCameraVideos = [NSMutableArray arrayWithArray:self.manager.endSelectedCameraVideos];
    self.manager.isOriginal = self.manager.endIsOriginal;
    self.manager.photosTotalBtyes = self.manager.endPhotosTotalBtyes;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
#pragma mark - navigationButton
    if (!self.manager.singleSelected) {
        self.navItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];
        if (self.manager.selectedList.count > 0) {
            self.navItem.rightBarButtonItem.enabled = YES;
            [self.rightBtn setBackgroundColor:[UIColor femaleBlueColor]];
            CGFloat rightBtnH = self.rightBtn.frame.size.height;
            CGFloat rightBtnW = [HXPhotoTools getTextWidth:self.rightBtn.currentTitle height:rightBtnH fontSize:13];
            self.rightBtn.frame = CGRectMake(0, 0, rightBtnW + 20, rightBtnH);
        } else {
            self.navItem.rightBarButtonItem.enabled = NO;
            [self.rightBtn setTitle:@"下一步" forState:UIControlStateNormal];
            [self.rightBtn setBackgroundColor:[UIColor seperatorLineColor]];
            self.rightBtn.frame = CGRectMake(0, 0, 60, 25);
        }
    }
    
    CGFloat spacing = 0.5;
    CGFloat CVwidth = (width - spacing * self.manager.rowCount - 1 ) / self.manager.rowCount;
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
    [self.collectionView registerClass:[HXPhotoViewCell class] forCellWithReuseIdentifier:PhotoViewCellId];
    [self.view addSubview:self.collectionView];
#ifdef __IPHONE_11_0
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
#else
    if ((NO)) {
    }
#endif
    else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    if (!self.manager.singleSelected) {
        self.collectionView.contentInset = UIEdgeInsetsMake(spacing + kNavigationBarHeight, 0, spacing + 50, 0);
    } else {
        self.collectionView.contentInset = UIEdgeInsetsMake(spacing + kNavigationBarHeight, 0,  spacing, 0);
    }
    self.collectionView.scrollIndicatorInsets = self.collectionView.contentInset;
    
    [self.view addSubview:self.albumsBgFace];
    HXAlbumListView *albumView = [[HXAlbumListView alloc] initWithFrame:CGRectMake(0, -340, width, 340) manager:self.manager];
    albumView.delegate = self;
    [self.view addSubview:albumView];
    self.albumView = albumView;
    
    [self.view addSubview:self.navBar];
    if (self.manager.UIManager.navBar) {
        self.manager.UIManager.navBar(self.navBar);
    }
    if (self.manager.UIManager.navItem) {
        self.manager.UIManager.navItem(self.navItem);
    }
    if (self.manager.UIManager.navRightBtn) {
        self.manager.UIManager.navRightBtn(self.rightBtn);
    }
    //    if (self.manager.open3DTouchPreview) {
    //        if (self.responseTraitCollection) {
    //            if (self.responseForceTouchCapability) {
    //                if (self.isCapabilityAvailable) {
    //                    self.previewingContext = [self registerForPreviewingWithDelegate:self sourceView:self.collectionView];
    //                }
    //            }
    //        }
    //    }
}

/**
 点击取消按钮 清空所有操作
 */

- (void)cancelClick {
    self.manager.selectPhoto = NO;
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    [self.manager.selectedList removeAllObjects];
    [self.manager.selectedPhotos removeAllObjects];
    [self.manager.selectedVideos removeAllObjects];
    self.manager.isOriginal = NO;
    self.manager.photosTotalBtyes = nil;
    [self.manager.selectedCameraList removeAllObjects];
    [self.manager.selectedCameraVideos removeAllObjects];
    [self.manager.selectedCameraPhotos removeAllObjects];
    [self.manager.cameraPhotos removeAllObjects];
    [self.manager.cameraList removeAllObjects];
    [self.manager.cameraVideos removeAllObjects];
    if ([self.delegate respondsToSelector:@selector(photoViewControllerDidCancel)]) {
        [self.delegate photoViewControllerDidCancel];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - < UICollectionViewDataSource >

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.objs.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HXPhotoViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PhotoViewCellId forIndexPath:indexPath];
    if (!self.manager.singleSelected) {
        cell.iconDic = self.manager.photoViewCellIconDic;
    }
    HXPhotoModel *model = self.objs[indexPath.item];
    model.rowCount = self.manager.rowCount;
    cell.maxTime = _manager.videoMaxDuration;
    cell.minTime = _manager.videoMinDuration;
    cell.delegate = self;
    cell.model = model;
    cell.singleSelected = self.manager.singleSelected;
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    HXPhotoViewCell *myCell = (HXPhotoViewCell *)cell;
    [myCell cancelRequest];
    if (!myCell.model.selected && myCell.model.thumbPhoto) {
        if (myCell.model.type != HXPhotoModelMediaTypePhotoCamera && myCell.model.type != HXPhotoModelMediaTypePhotoCameraPhoto && myCell.model.type != HXPhotoModelMediaTypePhotoCameraVideo) {
            myCell.model.thumbPhoto = nil;
        }
    }
}

//- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
//    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:location];
//    if (!indexPath) {
//        return nil;
//    }
//    HXPhotoViewCell *cell = (HXPhotoViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
//    if (!cell || cell.model.type == HXPhotoModelMediaTypePhotoCamera || cell.model.isIcloud) {
//        return nil;
//    }
//    //    previewingContext.sourceRect = [self.collectionView cellForItemAtIndexPath:indexPath].frame;
//    //    HXPhotoModel *model = self.objs[indexPath.item];
//    //    HXPhoto3DTouchViewController *vc = [[HXPhoto3DTouchViewController alloc] init];
//    //    vc.model = model;
//    //    vc.indexPath = indexPath;
//    //    vc.image = cell.imageView.image;
//    //    vc.preferredContentSize = model.endImageSize;
//    //    return vc;
//    return nil;
//}
//
//
//- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
////    HXPhoto3DTouchViewController *viewController = (HXPhoto3DTouchViewController *)viewControllerToCommit;
////    self.currentIndexPath = viewController.indexPath;
////    HXPhotoModel *model = viewController.model;
////    if (!self.manager.singleSelected) {
////        if (model.type == HXPhotoModelMediaTypePhotoVideo || model.type == HXPhotoModelMediaTypePhotoCameraVideo) {
////
////        } else {
////            LETADPhotoPerviewViewController *vc = [[LETADPhotoPerviewViewController alloc]  init];
////            vc.modelList = self.photos;
////            model.tempImage = viewController.imageView.image;
////            vc.index = [self.photos indexOfObject:model];
////            vc.manager = self.manager;
////            vc.delegate = self;
////            self.navigationController.delegate = vc;
////            [self showViewController:vc sender:self];
////            [vc selectClick];
////        }
////    } else {
////        if (model.type == HXPhotoModelMediaTypePhotoVideo || model.type == HXPhotoModelMediaTypePhotoCameraVideo) {
////
////        } else {
////            LETADPhotoPerviewViewController *vc = [[LETADPhotoPerviewViewController alloc] init];
////            vc.modelList = self.photos;
////            vc.index = [self.photos indexOfObject:model];
////            vc.delegate = self;
////            vc.manager = self.manager;
////            vc.viewmodel = _viewmodel;
////            self.navigationController.delegate = vc;
////            [self.navigationController pushViewController:vc animated:YES];
////        }
////    }
//}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.navigationController.topViewController != self) {
        return;
    }
    HXPhotoViewCell *cell = (HXPhotoViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    self.currentIndexPath = indexPath;
    HXPhotoModel *model = self.objs[indexPath.item];
    //单选
    if (self.manager.singleSelected) {
        //视频
        if (model.type == HXPhotoModelMediaTypePhotoVideo) {
//            if (model.videoSecond > _viewmodel.maxTime) {
//                NSString * msg = [NSString stringWithFormat:@"最长%d秒", _viewmodel.maxTime];
//                [self showTextHUD:msg toView:self.view];
//                return;
//            } else if (model.videoSecond < _viewmodel.minTime) {
//                NSString * msg = [NSString stringWithFormat:@"最短%d秒", _viewmodel.minTime];
//                [self showTextHUD:msg toView:self.view];
//                return;
//            }
            if (cell.model.isIcloud) {
                [self.view showImageHUDText:@"尚未从iCloud上下载，请至相册下载完毕后选择"];
                return;
            }
            LETADVideoPreviewViewController *previewVC = [[LETADVideoPreviewViewController alloc] init];
            previewVC.delegate = self;
            previewVC.modelArray = self.objs;
            previewVC.manager = self.manager;
            previewVC.currentModelIndex = self.currentIndexPath.row;
//            previewVC.listViewmodel = _viewmodel;
            [self.navigationController pushViewController:previewVC animated:NO];
        } else if (model.type == HXPhotoModelMediaTypePhotoCameraVideo) {
//            if (model.videoSecond > _viewmodel.maxTime) {
//                return;
//            }
            LETADVideoPreviewViewController *previewVC = [[LETADVideoPreviewViewController alloc] init];
            previewVC.delegate = self;
            previewVC.modelArray = self.objs;
            previewVC.manager = self.manager;
            previewVC.currentModelIndex = self.currentIndexPath.row;
//            previewVC.listViewmodel = _viewmodel;
            [self.navigationController pushViewController:previewVC animated:NO];
        } else {
//            if ([_viewmodel.uploadType isEqualToString:@"photo"]) {
//                if (_viewmodel.userEdit) {
//                    [LETADVideoCompressHelper fetchImage:model.asset image:^(UIImage *images) {
//                        if (images.size.width < _viewmodel.minWidth || images.size.height < _viewmodel.minHeight) {
//                            [self showTextHUD:@"图片太小" toView:self.view];
//                            return ;
//                        }
//                        if (images) {
//                            [self pushEdit:images];
//                        }
//                    }];
//                    return;
//                }
//            }
//            if ([_viewmodel.uploadType isEqualToString:@"photo"]) {
//                LETADPhotoPerviewViewController *vc = [[LETADPhotoPerviewViewController alloc] init];
//                vc.modelList = self.photos;
//                vc.index = [self.photos indexOfObject:model];
//                vc.delegate = self;
//                vc.manager = self.manager;
//                vc.viewmodel = _viewmodel;
//                self.navigationController.delegate = vc;
//                [self.navigationController pushViewController:vc animated:YES];
//                return;
//            }
            LETADVideoPreviewViewController *previewVC = [[LETADVideoPreviewViewController alloc] init];
            previewVC.delegate = self;
            previewVC.modelArray = self.objs;
            previewVC.manager = self.manager;
            previewVC.currentModelIndex = self.currentIndexPath.row;
//            previewVC.listViewmodel = _viewmodel;
            [self.navigationController pushViewController:previewVC animated:NO];
        }
        return;
    }
//    if ([_viewmodel.uploadType isEqualToString:@"all"]) {
//        if (model.type == HXPhotoModelMediaTypePhotoCameraVideo || model.type == HXPhotoModelMediaTypePhotoVideo) {
//            if (model.videoSecond > _viewmodel.maxTime) {
//                return;
//            }
//            if (model.videoSecond < _viewmodel.minTime) {
//                return;
//            }
//        }
//        LETADVideoPreviewViewController *previewVC = [[LETADVideoPreviewViewController alloc] init];
//        previewVC.delegate = self;
//        previewVC.modelArray = self.objs;
//        previewVC.manager = self.manager;
//        previewVC.currentModelIndex = self.currentIndexPath.row;
//        previewVC.listViewmodel = _viewmodel;
//        [self.navigationController pushViewController:previewVC animated:NO];
//        return;
//    }
    if (model.type == HXPhotoModelMediaTypePhoto || (model.type == HXPhotoModelMediaTypePhotoGif || model.type == HXPhotoModelMediaTypePhotoLivePhoto)) {
        LETADPhotoPerviewViewController *vc = [[LETADPhotoPerviewViewController alloc] init];
        vc.modelList = self.photos;
        vc.index = [self.photos indexOfObject:model];
        vc.delegate = self;
        vc.manager = self.manager;
//        vc.viewmodel = _viewmodel;
        self.navigationController.delegate = vc;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (model.type == HXPhotoModelMediaTypePhotoCameraPhoto){
        LETADPhotoPerviewViewController *vc = [[LETADPhotoPerviewViewController alloc] init];
        vc.modelList = self.photos;
        vc.index = [self.photos indexOfObject:model];
        vc.delegate = self;
        vc.manager = self.manager;
//        vc.viewmodel = _viewmodel;
        self.navigationController.delegate = vc;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    HXPhotoModel *model = [[HXPhotoModel alloc] init];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        if (image.imageOrientation != UIImageOrientationUp) {
            image = [image normalizedImage];
        }
        model.type = HXPhotoModelMediaTypePhotoCameraPhoto;
        model.subType = HXPhotoModelMediaSubTypePhoto;
        model.thumbPhoto = image;
        model.imageSize = image.size;
        model.previewPhoto = image;
        model.cameraIdentifier = [self videoOutFutFileName];
    } else  if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]) {
        NSURL *url = info[UIImagePickerControllerMediaURL];
        model.type = HXPhotoModelMediaTypePhotoCameraVideo;
        UIImage  *image = [UIImage imageInVideoUrl:url];//[player thumbnailImageAtTime:1.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
        NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
                                                         forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
        AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:url options:opts];
        float second = 0;
        second = urlAsset.duration.value/urlAsset.duration.timescale;
        NSString *videoTime = [HXPhotoTools getNewTimeFromDurationSecond:second];
        model.videoURL = url;
        model.videoTime = videoTime;
        model.thumbPhoto = image;
        model.imageSize = image.size;
        model.previewPhoto = image;
        model.cameraIdentifier = [self videoOutFutFileName];
    }
    [self cameraDidNextClick:model];
}

- (NSString *)videoOutFutFileName {
    NSString *fileName = @"";
    NSDate *nowDate = [NSDate date];
    NSString *dateStr = [NSString stringWithFormat:@"%ld", (long)[nowDate timeIntervalSince1970]];
    NSString *numStr = [NSString stringWithFormat:@"%d",arc4random()%10000];
    fileName = [fileName stringByAppendingString:dateStr];
    fileName = [fileName stringByAppendingString:numStr];
    return fileName;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}
/**
 通过相机拍照的图片或视频
 
 @param model 图片/视频 模型
 */
- (void)fullScreenCameraDidNextClick:(HXPhotoModel *)model {
    [self cameraDidNextClick:model];
}

- (void)cameraDidNextClick:(HXPhotoModel *)model {
    if (self.manager.saveSystemAblum) {
        if ([PHPhotoLibrary authorizationStatus] != PHAuthorizationStatusAuthorized) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.view showImageHUDText:@"保存失败，无法访问照片\n请前往设置中允许访问照片"];
            });
            return;
        }
        if (self.albumModel.index != 0) {
            [self didTableViewCellClick:self.albums.firstObject animate:NO];
            self.albumView.currentIndex = 0;
            self.albumView.list = self.albums;
        }
        __weak typeof(self) weakSelf = self;
        if (model.type == HXPhotoModelMediaTypePhotoCameraPhoto) {
            [HXPhotoTools saveImageToAlbum:model.previewPhoto completion:^{
                NSSLog(@"保存成功");
            } error:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf.view showImageHUDText:@"照片保存失败!"];
                });
            }];
        }else {
            [HXPhotoTools saveVideoToAlbum:model.videoURL completion:^{
                NSSLog(@"保存成功");
            } error:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf.view showImageHUDText:@"视频保存失败!"];
                });
            }];
        }
        return;
    }
    if (self.manager.singleSelected && model.type == HXPhotoModelMediaTypePhotoCameraPhoto) {
        [self.manager.selectedCameraList addObject:model];
        [self.manager.selectedCameraPhotos addObject:model];
        [self.manager.selectedPhotos addObject:model];
        [self.manager.selectedList addObject:model];
        [self didNextClick:self.rightBtn];
        return;
    }
    if (self.albumModel.index != 0) {
        [self didTableViewCellClick:self.albums.firstObject animate:NO];
        self.albumView.currentIndex = 0;
        self.albumView.list = self.albums;
    }
    // 判断类型
    if (model.type == HXPhotoModelMediaTypePhotoCameraPhoto) {
        [self.manager.cameraPhotos addObject:model];
        [self.photos insertObject:model atIndex:0];
        
        if (self.manager.selectedPhotos.count != self.manager.photoMaxNum) {
            if (!self.manager.selectTogether) {
                if (self.manager.selectedList.count > 0) {
                    HXPhotoModel *phMd = self.manager.selectedList.firstObject;
                    if ((phMd.type == HXPhotoModelMediaTypePhoto || phMd.type == HXPhotoModelMediaTypePhotoLivePhoto) || (phMd.type == HXPhotoModelMediaTypePhotoGif || phMd.type == HXPhotoModelMediaTypePhotoCameraPhoto)) {
                        [self.manager.selectedCameraPhotos insertObject:model atIndex:0];
                        [self.manager.selectedPhotos addObject:model];
                        [self.manager.selectedList addObject:model];
                        [self.manager.selectedCameraList addObject:model];
                        self.isSelectedChange = YES;
                        model.selected = YES;
                        self.albumModel.selectedCount++;
                    }
                }else {
                    [self.manager.selectedCameraPhotos insertObject:model atIndex:0];
                    [self.manager.selectedPhotos addObject:model];
                    [self.manager.selectedList addObject:model];
                    [self.manager.selectedCameraList addObject:model];
                    self.isSelectedChange = YES;
                    model.selected = YES;
                    self.albumModel.selectedCount++;
                }
            }else {
                [self.manager.selectedCameraPhotos insertObject:model atIndex:0];
                [self.manager.selectedPhotos addObject:model];
                [self.manager.selectedList addObject:model];
                [self.manager.selectedCameraList addObject:model];
                self.isSelectedChange = YES;
                model.selected = YES;
                self.albumModel.selectedCount++;
            }
        }
    }else if (model.type == HXPhotoModelMediaTypePhotoCameraVideo) {
        [self.manager.cameraVideos addObject:model];
        [self.videos insertObject:model atIndex:0];
        // 当选中视频个数没有达到最大个数时就添加到选中数组中
        if (self.manager.selectedVideos.count != self.manager.videoMaxNum) {
            if (!self.manager.selectTogether) {
                if (self.manager.selectedList.count > 0) {
                    HXPhotoModel *phMd = self.manager.selectedList.firstObject;
                    if (phMd.type == HXPhotoModelMediaTypePhotoVideo || phMd.type == HXPhotoModelMediaTypePhotoCameraVideo) {
                        [self.manager.selectedCameraVideos insertObject:model atIndex:0];
                        [self.manager.selectedVideos addObject:model];
                        [self.manager.selectedList addObject:model];
                        [self.manager.selectedCameraList addObject:model];
                        self.isSelectedChange = YES;
                        model.selected = YES;
                        self.albumModel.selectedCount++;
                    }
                }else {
                    
                    [self.manager.selectedCameraVideos insertObject:model atIndex:0];
                    [self.manager.selectedVideos addObject:model];
                    [self.manager.selectedList addObject:model];
                    [self.manager.selectedCameraList addObject:model];
                    self.isSelectedChange = YES;
                    model.selected = YES;
                    self.albumModel.selectedCount++;
                }
            }else {
                [self.manager.selectedCameraVideos insertObject:model atIndex:0];
                [self.manager.selectedVideos addObject:model];
                [self.manager.selectedList addObject:model];
                [self.manager.selectedCameraList addObject:model];
                self.isSelectedChange = YES;
                model.selected = YES;
                self.albumModel.selectedCount++;
            }
        }
    }
    [self.manager.cameraList addObject:model];
    NSInteger cameraIndex = self.manager.openCamera ? 1 : 0;
    [self.objs insertObject:model atIndex:cameraIndex];
    [self.collectionView reloadData];
    [self changeButtonClick:model isPreview:NO];
}

/**
 点击相册列表的代理
 
 @param model 点击的相册模型
 @param anim 是否需要展开动画
 */
- (void)didTableViewCellClick:(HXAlbumModel *)model animate:(BOOL)anim {
    if (anim) {
        [self pushAlbumList:self.titleBtn];
    }
    if ([self.albumModel.result isEqual:model.result]) {
        return;
    }
    // 当前相册选中的个数
    self.currentSelectCount = model.selectedCount;
    self.albumModel = model;
    self.title = model.albumName;
    [self.titleBtn setTitle:model.albumName forState:UIControlStateNormal];
    __weak typeof(self) weakSelf = self;
    // 获取指定相册的所有图片
    [self.manager FetchAllPhotoForPHFetchResult:model.result Index:model.index FetchResult:^(NSArray *photos, NSArray *videos, NSArray *Objs) {
        weakSelf.photos = [NSMutableArray arrayWithArray:photos];
        weakSelf.videos = [NSMutableArray arrayWithArray:videos];
        weakSelf.objs = [NSMutableArray arrayWithArray:Objs];
        CATransition *transition = [CATransition animation];
        transition.type = kCATransitionPush;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.fillMode = kCAFillModeForwards;
        transition.duration = 0.2;
        transition.delegate = weakSelf;
        transition.subtype = kCATransitionFade;
        [[weakSelf.collectionView layer] addAnimation:transition forKey:@""];
        weakSelf.selectOtherAlbum = YES;
        [weakSelf.collectionView reloadData];
        [weakSelf.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
    }];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag) {
        
        [self.collectionView.layer removeAllAnimations];
    }
}

/**
 查看图片时 选中或取消选中时的代理
 
 @param model 当前操作的模型
 @param state 状态
 */
- (void)didSelectedClick:(HXPhotoModel *)model AddOrDelete:(BOOL)state {
    if (state) { // 选中
        self.albumModel.selectedCount++;
    }else { // 取消选中
        self.albumModel.selectedCount--;
    }
    model.selected = state;
    [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:[self.objs indexOfObject:model] inSection:0]]];
    // 改变 预览、原图 按钮的状态
    [self changeButtonClick:model isPreview:YES];
    
    for (int i = 0; i < self.manager.selectedPhotos.count; i++) {
        HXPhotoModel * model = [self.manager.selectedPhotos objectAtIndex:i];
        model.selectedPhotosIndex = i;
        NSIndexPath * indexpath = [NSIndexPath indexPathForItem:[self.objs indexOfObject:model] inSection:0];
        HXPhotoViewCell * cell = (HXPhotoViewCell *)[self.collectionView cellForItemAtIndexPath:indexpath];
        [cell.selectBtn setTitle:[NSString stringWithFormat:@"%d", model.selectedPhotosIndex + 1] forState:UIControlStateNormal];
        [cell.selectBtn setBackgroundImage:[UIImage imageNamed:@"letad_album_1"] forState:UIControlStateNormal];
    }
}

/**
 查看图片时 选中或取消选中时的代理
 
 @param model 当前操作的模型
 @param state 状态
 */
- (void)allPreviewdidSelectedClick:(HXPhotoModel *)model AddOrDelete:(BOOL)state {
    if (state) { // 选中
        self.albumModel.selectedCount++;
    }else { // 取消选中
        self.albumModel.selectedCount--;
    }
    model.selected = state;
    [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:[self.objs indexOfObject:model] inSection:0]]];
    // 改变 预览、原图 按钮的状态
    [self changeButtonClick:model isPreview:YES];
    
    for (int i = 0; i < self.manager.selectedList.count; i++) {
        HXPhotoModel * model = [self.manager.selectedList objectAtIndex:i];
        model.selectedPhotosIndex = i;
        NSIndexPath * indexpath = [NSIndexPath indexPathForItem:[self.objs indexOfObject:model] inSection:0];
        HXPhotoViewCell * cell = (HXPhotoViewCell *)[self.collectionView cellForItemAtIndexPath:indexpath];
        [cell.selectBtn setTitle:[NSString stringWithFormat:@"%d", model.selectedPhotosIndex + 1] forState:UIControlStateNormal];
        [cell.selectBtn setBackgroundImage:[UIImage imageNamed:@"letad_album_1"] forState:UIControlStateNormal];
    }
}

#pragma mark - cell delegate 右上角选择方框
/**
 cell选中代理
 */

- (void)cellDidSelectedBtnClick:(HXPhotoViewCell *)cell Model:(HXPhotoModel *)model {
    if (!cell.selectBtn.selected) { // 弹簧果冻动画效果
        NSString *str = [HXPhotoTools maximumOfJudgment:model manager:self.manager];
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
    } else {
        cell.maskView.hidden = YES;
    }
    cell.selectBtn.selected = !cell.selectBtn.selected;
    cell.model.selected = cell.selectBtn.selected;
    BOOL selected = cell.selectBtn.selected;
    
    if (selected) { // 选中之后需要做的
        if (model.type != HXPhotoModelMediaTypePhotoCameraVideo && model.type != HXPhotoModelMediaTypePhotoCameraPhoto) {
            model.thumbPhoto = cell.imageView.image;
        }
        if (model.type == HXPhotoModelMediaTypePhotoLivePhoto) {
            [cell startLivePhoto];
        }
        if (model.type == HXPhotoModelMediaTypePhoto || (model.type == HXPhotoModelMediaTypePhotoGif || model.type == HXPhotoModelMediaTypePhotoLivePhoto)) { // 为图片时
            [self.manager.selectedPhotos addObject:model];
        } else if (model.type == HXPhotoModelMediaTypePhotoVideo) { // 为视频时
            [self.manager.selectedVideos addObject:model];
        } else if (model.type == HXPhotoModelMediaTypePhotoCameraPhoto) {
            // 为相机拍的照片时
            [self.manager.selectedPhotos addObject:model];
            [self.manager.selectedCameraPhotos addObject:model];
            [self.manager.selectedCameraList addObject:model];
        } else if (model.type == HXPhotoModelMediaTypePhotoCameraVideo) {
            // 为相机录的视频时
            [self.manager.selectedVideos addObject:model];
            [self.manager.selectedCameraVideos addObject:model];
            [self.manager.selectedCameraList addObject:model];
        }
        [self.manager.selectedList addObject:model];
        self.albumModel.selectedCount++;
    } else { // 取消选中之后的
        model.selectedPhotosIndex = 0;
        if (model.type != HXPhotoModelMediaTypePhotoCameraVideo && model.type != HXPhotoModelMediaTypePhotoCameraPhoto) {
            model.thumbPhoto = nil;
            model.previewPhoto = nil;
        }
        if (model.type == HXPhotoModelMediaTypePhotoLivePhoto) {
            [cell stopLivePhoto];
        }
        if ((model.type == HXPhotoModelMediaTypePhoto || model.type == HXPhotoModelMediaTypePhotoGif) || (model.type == HXPhotoModelMediaTypePhotoVideo || model.type == HXPhotoModelMediaTypePhotoLivePhoto)) {
            if (model.type == HXPhotoModelMediaTypePhoto || model.type == HXPhotoModelMediaTypePhotoGif || model.type == HXPhotoModelMediaTypePhotoLivePhoto) {
                [self.manager.selectedPhotos removeObject:model];
            }else if (model.type == HXPhotoModelMediaTypePhotoVideo) {
                [self.manager.selectedVideos removeObject:model];
            }
        }else if (model.type == HXPhotoModelMediaTypePhotoCameraPhoto || model.type == HXPhotoModelMediaTypePhotoCameraVideo) {
            if (model.type == HXPhotoModelMediaTypePhotoCameraPhoto) {
                [self.manager.selectedPhotos removeObject:model];
                [self.manager.selectedCameraPhotos removeObject:model];
            }else if (model.type == HXPhotoModelMediaTypePhotoCameraVideo) {
                [self.manager.selectedVideos removeObject:model];
                [self.manager.selectedCameraVideos removeObject:model];
            }
            [self.manager.selectedCameraList removeObject:model];
        }
        self.albumModel.selectedCount--;
        [self.manager.selectedList removeObject:model];
    }
    // 改变 预览、原图 按钮的状态
    [self changeButtonClick:model isPreview:NO];
    //    NSMutableArray * models = [NSMutableArray arrayWithCapacity:self.manager.selectedPhotos.count];
    
    for (int i = 0; i < self.manager.selectedList.count; i++) {
        HXPhotoModel * model = [self.manager.selectedList objectAtIndex:i];
        model.selectedPhotosIndex = i;
        NSIndexPath * indexpath = [NSIndexPath indexPathForItem:[self.objs indexOfObject:model] inSection:0];
        HXPhotoViewCell * cell = (HXPhotoViewCell *)[self.collectionView cellForItemAtIndexPath:indexpath];
        [cell.selectBtn setTitle:[NSString stringWithFormat:@"%d", model.selectedPhotosIndex + 1] forState:UIControlStateNormal];
    }
    
    if (model.selected) {
        [cell.selectBtn setBackgroundImage:[UIImage imageNamed:@"letad_album_1"] forState:UIControlStateSelected];
    } else {
        [cell.selectBtn setTitle:@"" forState:UIControlStateNormal];
        [cell.selectBtn setBackgroundImage:[UIImage imageNamed:@"letad_album_2"] forState:UIControlStateSelected];
    }
}

/**
 cell改变livephoto的状态
 
 @param model 模型
 */
- (void)cellChangeLivePhotoState:(HXPhotoModel *)model {
    HXPhotoModel *PHModel = [self.manager.selectedList objectAtIndex:[self.manager.selectedList indexOfObject:model]];
    PHModel.isCloseLivePhoto = model.isCloseLivePhoto;
    
    HXPhotoModel *PHModel1 = [self.manager.selectedPhotos objectAtIndex:[self.manager.selectedPhotos indexOfObject:model]];
    PHModel1.isCloseLivePhoto = model.isCloseLivePhoto;
}

/**
 改变 预览、原图 按钮的状态
 
 @param model 选中的模型
 */
- (void)changeButtonClick:(HXPhotoModel *)model isPreview:(BOOL)isPreview {
    self.isSelectedChange = YES; // 记录在当前相册是否操作过
    if (self.manager.selectedList.count > 0) { // 选中数组已经有值时
        if (self.manager.type != HXPhotoManagerSelectedTypeVideo) {
            BOOL isVideo = NO, isPhoto = NO;
            for (HXPhotoModel *model in self.manager.selectedList) {
                // 循环判断选中的数组中有没有视频或者图片
                if (model.type == HXPhotoModelMediaTypePhoto || (model.type == HXPhotoModelMediaTypePhotoGif || model.type == HXPhotoModelMediaTypePhotoLivePhoto)) {
                    isPhoto = YES;
                }else if (model.type == HXPhotoModelMediaTypePhotoVideo) {
                    isVideo = YES;
                }else if (model.type == HXPhotoModelMediaTypePhotoCameraPhoto) {
                    isPhoto = YES;
                }else if (model.type == HXPhotoModelMediaTypePhotoCameraVideo) {
                    isVideo = YES;
                }
            }
            if (self.manager.isOriginal) { // 原图按钮已经选中
                // 改变原图按钮的状态和计算图片原图的大小
                [self changeOriginalState:YES IsChange:YES];
            }
            // 当数组中有图片时 原图按钮变为可操作状态
            if ((isPhoto && isVideo) || isPhoto) {
                
            } else { // 否则回复成初始状态
                [self changeOriginalState:NO IsChange:NO];
                self.manager.isOriginal = NO;
            }
        }
        
        self.navItem.rightBarButtonItem.enabled = YES;
        [self.rightBtn setBackgroundColor:[UIColor femaleBlueColor]];
        CGFloat rightBtnH = self.rightBtn.frame.size.height;
        CGFloat rightBtnW = [HXPhotoTools getTextWidth:self.rightBtn.currentTitle height:rightBtnH fontSize:14];
        self.rightBtn.hx_w = rightBtnW + 20;
#ifdef __IPHONE_11_0
        if (@available(iOS 11.0, *)) {
            if (isPreview) {
                self.navItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];
            }
        }
#endif
    } else { // 没有选中时 全部恢复成初始状态
        [self changeOriginalState:NO IsChange:NO];
        self.manager.isOriginal = NO;
        self.navItem.rightBarButtonItem.enabled = NO;
        [self.rightBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [self.rightBtn setBackgroundColor:[UIColor seperatorLineColor]];
        self.rightBtn.frame = CGRectMake(0, 0, 60, 25);
    }
}

#pragma mark - LETADPhotoPerviewViewControllerDelegate
/**
 查看视频时点击下一步按钮的代理
 */
- (void)previewVideoDidNextClick {
    [self didNextClick:self.rightBtn];
}

/**
 查看视频时 选中/取消选中 的代理
 
 @param model 模型
 */

- (void)previewVideoDidSelectedClick:(HXPhotoModel *)model
{
    [self.collectionView reloadData];
    // 改变 预览、原图 按钮的状态
    [self changeButtonClick:model isPreview:YES];
}

- (void)imageUploadFromPhoto:(UIImage *)originImage
                   clipImage:(UIImage *)clipImage
                     success:(BOOL)isSuccess
                      result:(id)result {
    if ([_delegate respondsToSelector:@selector(letad_imageUploadFromList:clipImage:success:result:originPath:clipPath:)]) {
        [_delegate letad_imageUploadFromList:originImage
                                   clipImage:clipImage
                                     success:isSuccess
                                      result:result
                                  originPath:nil
                                    clipPath:nil];
    }
}

- (void)previewUpload:(LETADPhotoPerviewViewController *)controller source:(id)albums success:(BOOL)isSuccess result:(id)result {
    if (isSuccess) {
        if ([self.delegate respondsToSelector:@selector(letad_albumUpload:source:success:result:)]) {
            [self.delegate letad_albumUpload:self source:albums success:isSuccess result:result];
        }
    }
}

#pragma mark - LETADVideoPreviewViewControllerDelegate
- (void)videoPreviewUpload:(LETADVideoPreviewViewController *)previewController success:(BOOL)isSuccess {
    if (isSuccess) {
        if ([self.delegate respondsToSelector:@selector(letad_albumUpload:source:success:result:)]) {
            [self.delegate letad_albumUpload:self source:nil success:isSuccess result:nil];
        }
    }
}

- (void)imageUploadFromVideo:(UIImage *)originImage clipImage:(UIImage *)clipImage success:(BOOL)isSuccess {
    if ([_delegate respondsToSelector:@selector(letad_imageUploadFromList:clipImage:success:result:originPath:clipPath:)]) {
        [_delegate letad_imageUploadFromList:originImage
                                   clipImage:clipImage
                                     success:isSuccess
                                      result:nil
                                  originPath:nil
                                    clipPath:nil];
    }
}

- (void)mixUploadFromAlbumPreview:(LETADVideoPreviewViewController *)previewController
                           source:(id)albums
                          success:(BOOL)isSuccess
                           result:(id)result {
    if (isSuccess) {
        if ([self.delegate respondsToSelector:@selector(letad_albumUpload:source:success:result:)]) {
            [self.delegate letad_albumUpload:self
                                      source:albums
                                     success:isSuccess
                                      result:result];
        }
    }
}

#pragma mark - --------
/**
 改变原图按钮的状态信息
 
 @param selected 是否选中
 @param isChange 是否改变成初始状态
 */
- (void)changeOriginalState:(BOOL)selected IsChange:(BOOL)isChange {
    if (selected) { // 选中时
        if (isChange) {
            
        }
        [self.indica startAnimating];
        self.indica.hidden = NO;
        
        __weak typeof(self) weakSelf = self;
        // 获取一组图片的大小
        [HXPhotoTools FetchPhotosBytes:self.manager.selectedPhotos completion:^(NSString *totalBytes) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (!weakSelf.manager.isOriginal) {
                    return;
                }
                weakSelf.manager.photosTotalBtyes = totalBytes;
                [weakSelf.indica stopAnimating];
                weakSelf.indica.hidden = YES;
            });
        }];
    } else {// 取消选中 恢复成初始状态
        [self.indica stopAnimating];
        self.indica.hidden = YES;
        self.manager.photosTotalBtyes = nil;
    }
}

/**
 查看图片时点击下一步按钮的代理
 */
- (void)previewDidNextClick
{
    [self didNextClick:self.rightBtn];
}

//#pragma mark - < HXPhotoEditViewControllerDelegate >
//- (void)editViewControllerDidNextClick:(HXPhotoModel *)model {
//    [self.manager.selectedCameraList addObject:model];
//    [self.manager.selectedCameraPhotos addObject:model];
//    [self.manager.selectedPhotos addObject:model];
//    [self.manager.selectedList addObject:model];
//    [self didNextClick:self.rightBtn];
//}

- (void)pushEdit:(UIImage *)image {
    LETADClipImageViewController * clip = [[LETADClipImageViewController alloc] init];
    clip.image = image;
//    clip.delegate = self;
//    LETADClipImageViewmodel * viewmodel = [[LETADClipImageViewmodel alloc] initWithNSDictionary:_viewmodel.aliDic];
//    clip.viewmodel = viewmodel;
    [self presentViewController:clip animated:YES completion:nil];
}

#pragma mark - LETADNewClipImageDelegate
- (void)imageUploadFromClip:(UIImage *)originImage
                  clipImage:(UIImage *)clipImage
                    success:(BOOL)isSuccess
                     result:(id)result
                 originPath:(NSString *)originPath
                   clipPath:(NSString *)clipPath {
    if (isSuccess) {
        if ([_delegate respondsToSelector:@selector(letad_imageUploadFromList:clipImage:success:result:originPath:clipPath:)]) {
            [_delegate letad_imageUploadFromList:originImage
                                       clipImage:clipImage
                                         success:YES
                                          result:result
                                      originPath:originPath
                                        clipPath:clipPath];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        });
    }
}

/**
 点击下一步执行的方法
 
 @param button 下一步按钮
 */
#pragma mark - 下一步
- (void)didNextClick:(UIButton *)button {
//    self.manager.selectPhoto = NO;
//    if (self.navigationController.topViewController != self) {
//        return;
//    }
//    __weak typeof(self) weakSelf = self;
//    int totalCount = (int)(_manager.selectedList.count);
//    NSString * str = [NSString stringWithFormat:@"0/%d", totalCount];
//    MBProgressHUD * hud = [self customProgressHUDTitle:str];
//    button.enabled = NO;
//    [_viewmodel letad_uploadImages:_manager.selectedList progress:^(float progressValue) {
//        NSString * proStr = [NSString stringWithFormat:@"%d/%d", (int)progressValue, totalCount];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            hud.detailsLabel.text = proStr;
//        });
//    } result:^(BOOL isSuccess, id result, NSString *msg) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [hud hideAnimated:YES];
//            button.enabled = YES;
//            if (isSuccess) {
//                if ([msg isEqualToString:@"end"]) {
//                    [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
//                } else {
//                    [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
//                }
//            } else {
//                if (msg.length > 0) {
//                    [weakSelf showTextHUD:msg toView:weakSelf.view];
//                }
//            }
//            if ([weakSelf.delegate respondsToSelector:@selector(letad_albumUpload:source:success:result:)]) {
//                [weakSelf.delegate letad_albumUpload:weakSelf source:weakSelf.viewmodel.albums success:isSuccess result:result];
//            }
//        });
//    }];
}

- (void)sortSelectList {
    int i = 0, j = 0, k = 0;
    for (HXPhotoModel *model in self.manager.selectedList) {
        if ((model.type == HXPhotoModelMediaTypePhoto || model.type == HXPhotoModelMediaTypePhotoGif) || (model.type == HXPhotoModelMediaTypePhotoCameraPhoto || model.type == HXPhotoModelMediaTypePhotoLivePhoto)) {
            model.endIndex = i++;
        }else if (model.type == HXPhotoModelMediaTypePhotoVideo || model.type == HXPhotoModelMediaTypePhotoCameraVideo) {
            model.videoIndex = j++;
        }
        model.endCollectionIndex = k++;
    }
}

- (void)cleanSelectedList {
    [self sortSelectList];
    // 如果通过相机拍的数组为空 则清空所有关于相机的数组
    if (self.manager.deleteTemporaryPhoto) {
        if (self.manager.selectedCameraList.count == 0) {
            [self.manager.cameraList removeAllObjects];
            [self.manager.cameraVideos removeAllObjects];
            [self.manager.cameraPhotos removeAllObjects];
        }
    }
    if (!self.manager.singleSelected) {
        // 记录这次操作的数据
        self.manager.endSelectedList = [NSMutableArray arrayWithArray:self.manager.selectedList];
        self.manager.endSelectedPhotos = [NSMutableArray arrayWithArray:self.manager.selectedPhotos];
        self.manager.endSelectedVideos = [NSMutableArray arrayWithArray:self.manager.selectedVideos];
        self.manager.endCameraList = [NSMutableArray arrayWithArray:self.manager.cameraList];
        self.manager.endCameraPhotos = [NSMutableArray arrayWithArray:self.manager.cameraPhotos];
        self.manager.endCameraVideos = [NSMutableArray arrayWithArray:self.manager.cameraVideos];
        self.manager.endSelectedCameraList = [NSMutableArray arrayWithArray:self.manager.selectedCameraList];
        self.manager.endSelectedCameraPhotos = [NSMutableArray arrayWithArray:self.manager.selectedCameraPhotos];
        self.manager.endSelectedCameraVideos = [NSMutableArray arrayWithArray:self.manager.selectedCameraVideos];
        self.manager.endIsOriginal = self.manager.isOriginal;
        self.manager.endPhotosTotalBtyes = self.manager.photosTotalBtyes;
        
        if ([self.delegate respondsToSelector:@selector(photoViewControllerDidNext:Photos:Videos:Original:)]) {
            [self.delegate photoViewControllerDidNext:self.manager.endSelectedList.mutableCopy Photos:self.manager.endSelectedPhotos.mutableCopy Videos:self.manager.endSelectedVideos.mutableCopy Original:self.manager.endIsOriginal];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(photoViewControllerDidNext:Photos:Videos:Original:)]) {
            [self.delegate photoViewControllerDidNext:self.manager.selectedList.mutableCopy Photos:self.manager.selectedPhotos.mutableCopy Videos:self.manager.selectedVideos.mutableCopy Original:self.manager.isOriginal];
        }
    }
}

/**
 小菊花
 
 @return 小菊花
 */
- (UIActivityIndicatorView *)indica {
    if (!_indica) {
        _indica = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    return _indica;
}

/**
 下一步按钮
 
 @return 按钮
 */
- (UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rightBtn setTitleColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
        _rightBtn.layer.masksToBounds = YES;
        _rightBtn.layer.cornerRadius = 4;
        _rightBtn.backgroundColor = [UIColor seperatorLineColor];
        [_rightBtn addTarget:self action:@selector(didNextClick:) forControlEvents:UIControlEventTouchUpInside];
        _rightBtn.titleLabel.font = [UIFont letad_PingFangMedium11];
        _rightBtn.frame = CGRectMake(0, 0, 60, 25);
    }
    return _rightBtn;
}

- (UIButton *)leftBtn {
    if (!_leftBtn) {
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_leftBtn setTitleColor:[UIColor blackTextColor] forState:UIControlStateNormal];
        _leftBtn.titleLabel.font = [UIFont letad_PingFangMedium15];
        [_leftBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        _leftBtn.frame = CGRectMake(0, 0, 60, 25);
    }
    return _leftBtn;
}

/**
 展开相册列表时的黑色背景
 @return 视图
 */
- (UIView *)albumsBgFace {
    if (!_albumsBgFace) {
        _albumsBgFace = [[UIView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, self.view.frame.size.width, self.view.frame.size.height - kNavigationBarHeight)];
        _albumsBgFace.hidden = YES;
        _albumsBgFace.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        _albumsBgFace.alpha = 0;
        [_albumsBgFace addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didalbumsBgFaceClick)]];
    }
    return _albumsBgFace;
}

- (NSMutableArray *)objs {
    if (!_objs) {
        _objs = [NSMutableArray array];
    }
    return _objs;
}

- (NSMutableArray *)photos {
    if (!_photos) {
        _photos = [NSMutableArray array];
    }
    return _photos;
}

- (NSMutableArray *)videos {
    if (!_videos) {
        _videos = [NSMutableArray array];
    }
    return _videos;
}

/**
 点击背景时
 */
- (void)didalbumsBgFaceClick {
    [self pushAlbumList:self.titleBtn];
}

- (void)removeModel:(NSNotification *) notification {
    NSDictionary * dic = notification.userInfo;
    int index = [[dic valueForKey:@"index"] intValue];
    
    if (index >= self.manager.selectedPhotos.count) {
        return;
    }
    HXPhotoModel * model = self.manager.selectedPhotos[index];
    model.selected = NO;
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
    }else if (model.type == HXPhotoModelMediaTypePhotoCameraPhoto || model.type == HXPhotoModelMediaTypePhotoCameraVideo) {
        if (model.type == HXPhotoModelMediaTypePhotoCameraPhoto) {
            [self.manager.selectedPhotos removeObject:model];
            [self.manager.selectedCameraPhotos removeObject:model];
        }else if (model.type == HXPhotoModelMediaTypePhotoCameraVideo) {
            [self.manager.selectedVideos removeObject:model];
            [self.manager.selectedCameraVideos removeObject:model];
        }
        [self.manager.selectedCameraList removeObject:model];
    }
    self.albumModel.selectedCount--;
    [self.manager.selectedList removeObject:model];
    
    for (int i = 0; i < self.manager.selectedPhotos.count; i++) {
        HXPhotoModel * model = [self.manager.selectedPhotos objectAtIndex:i];
        model.selectedPhotosIndex = i;
        NSIndexPath * indexpath = [NSIndexPath indexPathForItem:[self.objs indexOfObject:model] inSection:0];
        HXPhotoViewCell * cell = (HXPhotoViewCell *)[self.collectionView cellForItemAtIndexPath:indexpath];
        [cell.selectBtn setTitle:[NSString stringWithFormat:@"%d", model.selectedPhotosIndex + 1] forState:UIControlStateNormal];
    }
    [self.collectionView reloadData];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.manager.selectPhoto = NO;
    //    if (self.manager.open3DTouchPreview) {
    //        if (self.previewingContext) {
    //            [self unregisterForPreviewingWithContext:self.previewingContext];
    //        }
    //    }
    //    NSLog(@"🤩🤩🤩LETADAlbumListViewController deallc🤩🤩🤩");
}
@end
