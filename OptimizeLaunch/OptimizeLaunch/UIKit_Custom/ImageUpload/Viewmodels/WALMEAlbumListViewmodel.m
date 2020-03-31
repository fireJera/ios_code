//
//  HX_PhotoManager.m
//  微博照片选择
//
//  Created by 洪欣 on 17/2/8.
//  Copyright © 2017年 洪欣. All rights reserved.
//

#import "WALMEAlbumListViewmodel.h"
#import <mach/mach_time.h>
#import "HXAlbumModel.h"
#import "HXPhotoModel.h"
#import "HXPhotoTools.h"
#import "HXPhotoUIManager.h"

#import "WALMEAlbumListModel.h"
#import "WALMEViewmodelHeader.h"
//#import "WALMEAliOSS.h"
#import "WALMEUploadOptions.h"
#import "WALMEVideoCompressHelper.h"

#define iOS9Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.1f)

@interface WALMEAlbumListViewmodel () <PHPhotoLibraryChangeObserver> {
    WALMEAliOSS * _aliOSS;
}
@property (strong, nonatomic) NSMutableArray *allPhotos;
@property (strong, nonatomic) NSMutableArray *allVideos;
@property (strong, nonatomic) NSMutableArray *allObjs;
@property (nonatomic, strong) NSMutableArray<HXAlbumModel *> * innerAlbums;
//@property (assign, nonatomic) BOOL hasLivePhoto;

@property (nonatomic, assign) BOOL supportLiveInDevice;
//@property (nonatomic, strong) WALMEAliOSS * aliOSS;

@end

@implementation WALMEAlbumListViewmodel

//- (instancetype)initWithType:(WALMEAlbumListSelectionType)type {
//    if (self = [super init]) {
//        [self p_walme_setup];
//        _selectionType = type;
//    }
//    return self;
//}

- (instancetype)init {
    if ([super init]) {
        [self p_walme_setup];
    }
    return self;
}

- (void)p_walme_setup {
    _selectionType = WALMEAlbumListSelectionTypeAll;
    _reverseDate = YES;
    _firstTop = YES;
    _showGif = YES;
    _showLive = YES;
    _shouldCompress = NO;
    _showCamera = NO;
    //    if ([UIScreen mainScreen].bounds.size.width == 320) {
    _columnCount = 3;
    //    }
    //    else {
    //        _columnCount = 4;
    //    }
    _selectedList = [NSMutableArray array];
    _selectedPhotos = [NSMutableArray array];
    _selectedVideos = [NSMutableArray array];
    _innerAlbums = [NSMutableArray array];
    _allObjs = [NSMutableArray array];
    _allVideos = [NSMutableArray array];
    _saveCameraPhotoToAlbum = YES;
    _monitorSystemAlbum = YES;
    _supportLiveInDevice = [HXPhotoTools platform];
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
}

- (void)setMonitorSystemAlbum:(BOOL)monitorSystemAlbum {
    _monitorSystemAlbum = monitorSystemAlbum;
    if (!monitorSystemAlbum) {
        [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
    }else {
        [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
    }
}
//
//- (void)setLocalImageList:(NSArray *)localImageList {
//    _localImageList = localImageList;
//    if (![localImageList.firstObject isKindOfClass:[UIImage class]]) {
//        NSSLog(@"请传入装着UIImage对象的数组");
//        return;
//    }
//    for (UIImage *image in localImageList) {
//        HXPhotoModel *photoModel = [HXPhotoModel photoModelWithImage:image];
//        photoModel.selected = YES;
//        [self.endCameraPhotos addObject:photoModel];
//        [self.endSelectedCameraPhotos addObject:photoModel];
//        [self.endCameraList addObject:photoModel];
//        [self.endSelectedCameraList addObject:photoModel];
//        [self.endSelectedPhotos addObject:photoModel];
//        [self.endSelectedList addObject:photoModel];
//    }
//}

//- (void)addLocalImage:(NSArray *)images selected:(BOOL)selected {
//    if (![images.firstObject isKindOfClass:[UIImage class]]) {
//        NSSLog(@"请传入装着UIImage对象的数组");
//        return;
//    }
//    for (UIImage *image in images) {
//        HXPhotoModel *photoModel = [HXPhotoModel photoModelWithImage:image];
//        photoModel.selected = selected;
//        if (selected) {
//            [self.endCameraPhotos addObject:photoModel];
//            [self.endSelectedCameraPhotos addObject:photoModel];
//            [self.endCameraList addObject:photoModel];
//            [self.endSelectedCameraList addObject:photoModel];
//            [self.endSelectedPhotos addObject:photoModel];
//            [self.endSelectedList addObject:photoModel];
//        }else {
//            [self.endCameraPhotos addObject:photoModel];
//            [self.endCameraList addObject:photoModel];
//        }
//    }
//}
//
//- (void)addLocalImageToAlbumWithImages:(NSArray *)images {
//    if (![images.firstObject isKindOfClass:[UIImage class]]) {
//        NSSLog(@"请传入装着UIImage对象的数组");
//        return;
//    }
//    for (UIImage *image in images) {
//        HXPhotoModel *photoModel = [HXPhotoModel photoModelWithImage:image];
//        [self.endCameraPhotos addObject:photoModel];
//        [self.endCameraList addObject:photoModel];
//    }
//}

- (void)getCellIcons {
    if (!self.singleSelected && !self.albumListCellIcon) {
        self.albumListCellIcon = @{
                                   @"videoIcon" : [HXPhotoTools hx_imageNamed:@"VideoSendIcon@2x.png"] ,
                                   @"gifIcon" : [HXPhotoTools hx_imageNamed:@"timeline_image_gif@2x.png"] ,
                                   @"liveIcon" : [HXPhotoTools hx_imageNamed:@"compose_live_photo_open_only_icon@2x.png"] ,
                                   @"liveBtnImageNormal" : [HXPhotoTools hx_imageNamed:@"compose_live_photo_open_icon@2x.png"] ,
                                   @"liveBtnImageSelected" : [HXPhotoTools hx_imageNamed:@"compose_live_photo_close_icon@2x.png"] ,
                                   @"liveBtnBackgroundImage" : [HXPhotoTools hx_imageNamed:@"compose_live_photo_background@2x.png"] ,
                                   @"selectBtnNormal" : [HXPhotoTools hx_imageNamed:@"compose_guide_check_box_default@2x.png"] ,
                                   @"selectBtnSelected" : [HXPhotoTools hx_imageNamed:@"compose_guide_check_box_right@2x.png"] ,
                                   @"icloudIcon" : [HXPhotoTools hx_imageNamed:@"icon_yunxiazai@2x.png"],
                                   };
    }
}

/**
 获取系统所有相册
 
 @param albums 相册集合
 */
- (void)getAllPhotoAlbums:(void (^)(HXAlbumModel * _Nonnull))firstModel albums:(void (^)(NSArray<HXAlbumModel *> * _Nonnull))albums isFirst:(BOOL)isFirst {
    if (self.innerAlbums.count > 0) [self.innerAlbums removeAllObjects];
    // 获取系统智能相册
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    [smartAlbums enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(PHAssetCollection *collection, NSUInteger idx, BOOL * _Nonnull stop) {
        if (isFirst) {
            if ([[HXPhotoTools transFormPhotoTitle:collection.localizedTitle] isEqualToString:@"相机胶卷"] ||
                [[HXPhotoTools transFormPhotoTitle:collection.localizedTitle] isEqualToString:@"所有照片"] ||
                [[HXPhotoTools transFormPhotoTitle:collection.localizedTitle] isEqualToString:@"最近项目"]) {
                
                // 是否按创建时间排序
                PHFetchOptions *option = [[PHFetchOptions alloc] init];
                option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
                if (self.selectionType == WALMEAlbumListSelectionTypePhoto) {
                    option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
                }else if (self.selectionType == WALMEAlbumListSelectionTypeVideo) {
                    option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeVideo];
                }
                // 获取照片集合
                PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:collection options:option];
                
                HXAlbumModel *albumModel = [[HXAlbumModel alloc] init];
                albumModel.count = result.count;
                albumModel.albumName = collection.localizedTitle;
                albumModel.result = result;
                albumModel.index = 0;
                if (firstModel) {
                    firstModel(albumModel);
                }
                *stop = YES;
            }
        }else {
            // 是否按创建时间排序
            PHFetchOptions *option = [[PHFetchOptions alloc] init];
            option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
            if (self.selectionType == WALMEAlbumListSelectionTypePhoto) {
                option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
            }else if (self.selectionType == WALMEAlbumListSelectionTypeVideo) {
                option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeVideo];
            }
            // 获取照片集合
            PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:collection options:option];
            
            // 过滤掉空相册
            if (result.count > 0 && ![[HXPhotoTools transFormPhotoTitle:collection.localizedTitle] isEqualToString:@"最近删除"]) {
                HXAlbumModel *albumModel = [[HXAlbumModel alloc] init];
                albumModel.count = result.count;
                albumModel.albumName = collection.localizedTitle;
                albumModel.result = result;
                if ([[HXPhotoTools transFormPhotoTitle:collection.localizedTitle] isEqualToString:@"相机胶卷"] ||
                    [[HXPhotoTools transFormPhotoTitle:collection.localizedTitle] isEqualToString:@"所有照片"] ||
                    [[HXPhotoTools transFormPhotoTitle:collection.localizedTitle] isEqualToString:@"最近项目"]) {
                    [self.innerAlbums insertObject:albumModel atIndex:0];
                }else {
                    [self.innerAlbums addObject:albumModel];
                }
            }
        }
    }];
    if (isFirst) {
        return;
    }
    // 获取用户相册
    PHFetchResult *userAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
    [userAlbums enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(PHAssetCollection *collection, NSUInteger idx, BOOL * _Nonnull stop) {
        // 是否按创建时间排序
        PHFetchOptions *option = [[PHFetchOptions alloc] init];
        option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
        if (self.selectionType == WALMEAlbumListSelectionTypePhoto) {
            option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
        }else if (self.selectionType == WALMEAlbumListSelectionTypeVideo) {
            option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeVideo];
        }
        // 获取照片集合
        PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:collection options:option];
        
        // 过滤掉空相册
        if (result.count > 0) {
            HXAlbumModel *albumModel = [[HXAlbumModel alloc] init];
            albumModel.count = result.count;
            albumModel.albumName = [HXPhotoTools transFormPhotoTitle:collection.localizedTitle];
            albumModel.result = result;
            [self.innerAlbums addObject:albumModel];
        }
    }];
    for (int i = 0 ; i < self.innerAlbums.count; i++) {
        HXAlbumModel *model = self.innerAlbums[i];
        model.index = i;
        //        NSPredicate *pred = [NSPredicate predicateWithFormat:@"currentAlbumIndex = %d", i];
        //        NSArray *newArray = [self.selectedList filteredArrayUsingPredicate:pred];
        //        model.selectedCount = newArray.count;
    }
    if (albums) {
        albums(self.innerAlbums);
    }
}
- (void)fetchAllAlbum:(void (^)(NSArray<HXAlbumModel *> * _Nonnull))albums IsShowSelectTag:(BOOL)isShow {
    if (self.innerAlbums.count > 0) [self.innerAlbums removeAllObjects];
    // 获取系统智能相册
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    [smartAlbums enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(PHAssetCollection *collection, NSUInteger idx, BOOL * _Nonnull stop) {
        // 是否按创建时间排序
        PHFetchOptions *option = [[PHFetchOptions alloc] init];
        option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
        if (self.selectionType == WALMEAlbumListSelectionTypePhoto) {
            option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
        }else if (self.selectionType == WALMEAlbumListSelectionTypeVideo) {
            option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeVideo];
        }
        // 获取照片集合
        PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:collection options:option];
        // 过滤掉空相册
        if (result.count > 0 && ![[HXPhotoTools transFormPhotoTitle:collection.localizedTitle] isEqualToString:@"最近删除"]) {
            HXAlbumModel *albumModel = [[HXAlbumModel alloc] init];
            albumModel.count = result.count;
            albumModel.albumName = collection.localizedTitle;
            //            albumModel.asset = result.lastObject;
            albumModel.result = result;
            if ([[HXPhotoTools transFormPhotoTitle:collection.localizedTitle] isEqualToString:@"相机胶卷"] ||
                [[HXPhotoTools transFormPhotoTitle:collection.localizedTitle] isEqualToString:@"所有照片"] ||
                [[HXPhotoTools transFormPhotoTitle:collection.localizedTitle] isEqualToString:@"最近项目"]) {
                [self.innerAlbums insertObject:albumModel atIndex:0];
            }else {
                [self.innerAlbums addObject:albumModel];
            }
            
            if (isShow) {
                if (self.selectedList.count > 0) {
                    HXPhotoModel *photoModel = self.selectedList.firstObject;
                    for (PHAsset *asset in result) {
                        if ([asset.localIdentifier isEqualToString:photoModel.asset.localIdentifier]) {
                            albumModel.selectedCount++;
                            break;
                        }
                    }
                }
            }
        }
    }];
    
    // 获取用户相册
    PHFetchResult *userAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
    [userAlbums enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(PHAssetCollection *collection, NSUInteger idx, BOOL * _Nonnull stop) {
        // 是否按创建时间排序
        PHFetchOptions *option = [[PHFetchOptions alloc] init];
        option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
        if (self.selectionType == WALMEAlbumListSelectionTypePhoto) {
            option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
        }else if (self.selectionType == WALMEAlbumListSelectionTypeVideo) {
            option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeVideo];
        }
        // 获取照片集合
        PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:collection options:option];
        
        // 过滤掉空相册
        if (result.count > 0) {
            HXAlbumModel *albumModel = [[HXAlbumModel alloc] init];
            albumModel.count = result.count;
            albumModel.albumName = [HXPhotoTools transFormPhotoTitle:collection.localizedTitle];
            //            albumModel.asset = result.lastObject;
            albumModel.result = result;
            [self.innerAlbums addObject:albumModel];
            if (isShow) {
                if (self.selectedList.count > 0) {
                    HXPhotoModel *photoModel = self.selectedList.firstObject;
                    for (PHAsset *asset in result) {
                        if ([asset.localIdentifier isEqualToString:photoModel.asset.localIdentifier]) {
                            albumModel.selectedCount++;
                            break;
                        }
                    }
                }
            }
        }
    }];
    
    for (int i = 0 ; i < self.innerAlbums.count; i++) {
        HXAlbumModel *model = self.innerAlbums[i];
        model.index = i;
        if (isShow) {
            if (i == 0) {
                //                model.selectedCount += self.selectedCameraList.count;
            }
        }
    }
    if (albums) {
        albums(self.innerAlbums);
    }
}
/**
 *  是否为同一天
 */
- (BOOL)isSameDay:(NSDate*)date1 date2:(NSDate*)date2 {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:date1];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date2];
    
    return [comp1 day]   == [comp2 day] &&
    [comp1 month] == [comp2 month] &&
    [comp1 year]  == [comp2 year];
}

- (void)getPhotoListWithAlbumModel:(HXAlbumModel *)albumModel complete:(void (^)(NSArray<HXPhotoModel *> * _Nonnull, NSArray<HXPhotoModel *> * _Nonnull, NSArray<HXPhotoModel *> * _Nonnull, NSArray<HXPhotoModel *> * _Nonnull, HXPhotoModel * _Nonnull))complete {
    NSMutableArray *allArray = [NSMutableArray array];
    NSMutableArray *previewArray = [NSMutableArray array];
    NSMutableArray *videoArray = [NSMutableArray array];
    NSMutableArray *photoArray = [NSMutableArray array];
    //    NSMutableArray *dateArray = [NSMutableArray array];
    
    //    __block NSDate *currentIndexDate;
    //    __block NSMutableArray *sameDayArray;
    //    __block HXPhotoDateModel *dateModel;
    __block HXPhotoModel *firstSelectModel;
    //    __block BOOL already = NO;
    NSMutableArray *selectList = [NSMutableArray arrayWithArray:self.selectedList];
    if (self.reverseDate) {
        [albumModel.result enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(PHAsset *asset, NSUInteger idx, BOOL * _Nonnull stop) {
            HXPhotoModel *photoModel = [[HXPhotoModel alloc] init];
            photoModel.asset = asset;
            if ([[asset valueForKey:@"isCloudPlaceholder"] boolValue]) {
                photoModel.isIcloud = YES;
            }
            if (selectList.count > 0) {
                NSString *property = @"asset";
                NSPredicate *pred = [NSPredicate predicateWithFormat:@"%K = %@", property, asset];
                NSArray *newArray = [selectList filteredArrayUsingPredicate:pred];
                if (newArray.count > 0) {
                    HXPhotoModel *model = newArray.firstObject;
                    [selectList removeObject:model];
                    photoModel.selected = YES;
                    if (model.type == WALMEPhotoModelMediaTypePhoto ||
                        model.type == WALMEPhotoModelMediaTypeGif ||
                        model.type == WALMEPhotoModelMediaTypeLive) {
                        [self.selectedPhotos replaceObjectAtIndex:[self.selectedPhotos indexOfObject:model] withObject:photoModel];
                    }
                    else {
                        [self.selectedVideos replaceObjectAtIndex:[self.selectedVideos indexOfObject:model] withObject:photoModel];
                    }
                    [self.selectedList replaceObjectAtIndex:[self.selectedList indexOfObject:model] withObject:photoModel];
                    photoModel.thumbPhoto = model.thumbPhoto;
                    photoModel.previewPhoto = model.previewPhoto;
                    photoModel.isCloseLivePhoto = model.isCloseLivePhoto;
                    photoModel.selectIndexStr = model.selectIndexStr;
                    if (!firstSelectModel) {
                        firstSelectModel = photoModel;
                    }
                }
            }
            if (asset.mediaType == PHAssetMediaTypeImage) {
                photoModel.subType = WALMEPhotoModelMediaSubTypePhoto;
                if ([[asset valueForKey:@"filename"] hasSuffix:@"GIF"]) {
                    if (self.singleSelected && self.singleSelecteClip) {
                        photoModel.type = WALMEPhotoModelMediaTypePhoto;
                    } else {
                        photoModel.type = self.showGif ? WALMEPhotoModelMediaTypeGif : WALMEPhotoModelMediaTypePhoto;
                    }
                } else {
                    photoModel.type = WALMEPhotoModelMediaTypePhoto;
                    if (self.supportLiveInDevice) {
                        if (@available(iOS 9.1, *)) {
                            if (asset.mediaSubtypes == PHAssetMediaSubtypePhotoLive) {
                                if (!self.singleSelected) {
                                    photoModel.type = self.showLive ? WALMEPhotoModelMediaTypeLive : WALMEPhotoModelMediaTypePhoto;
                                }
                            }
                        }
                    }
                }
                if (!photoModel.isIcloud) {
                    [photoArray addObject:photoModel];
                }
            } else if (asset.mediaType == PHAssetMediaTypeVideo) {
                photoModel.subType = WALMEPhotoModelMediaSubTypeVideo;
                photoModel.type = WALMEPhotoModelMediaTypeVideo;
                if (!photoModel.isIcloud) {
                    [videoArray addObject:photoModel];
                }
            }
            photoModel.currentAlbumIndex = albumModel.index;
            [allArray addObject:photoModel];
            if (!photoModel.isIcloud) {
                [previewArray addObject:photoModel];
            }
            photoModel.dateItem = allArray.count - 1;
            photoModel.dateSection = 0;
        }];
    } else {
        NSInteger index = 0;
        for (PHAsset *asset in albumModel.result) {
            HXPhotoModel *photoModel = [[HXPhotoModel alloc] init];
            photoModel.asset = asset;
            if ([[asset valueForKey:@"isCloudPlaceholder"] boolValue]) {
                photoModel.isIcloud = YES;
            }
            if (selectList.count > 0) {
                NSString *property = @"asset";
                NSPredicate *pred = [NSPredicate predicateWithFormat:@"%K = %@", property, asset];
                NSArray *newArray = [selectList filteredArrayUsingPredicate:pred];
                if (newArray.count > 0) {
                    HXPhotoModel *model = newArray.firstObject;
                    [selectList removeObject:model];
                    photoModel.selected = YES;
                    if (model.type == WALMEPhotoModelMediaTypePhoto ||
                        model.type == WALMEPhotoModelMediaTypeGif ||
                        model.type == WALMEPhotoModelMediaTypeLive) {
                        [self.selectedPhotos replaceObjectAtIndex:[self.selectedPhotos indexOfObject:model] withObject:photoModel];
                    }
                    else {
                        [self.selectedVideos replaceObjectAtIndex:[self.selectedVideos indexOfObject:model] withObject:photoModel];
                    }
                    [self.selectedList replaceObjectAtIndex:[self.selectedList indexOfObject:model] withObject:photoModel];
                    photoModel.thumbPhoto = model.thumbPhoto;
                    photoModel.previewPhoto = model.previewPhoto;
                    photoModel.isCloseLivePhoto = model.isCloseLivePhoto;
                    photoModel.selectIndexStr = model.selectIndexStr;
                    if (!firstSelectModel) {
                        firstSelectModel = photoModel;
                    }
                }
            }
            if (asset.mediaType == PHAssetMediaTypeImage) {
                photoModel.subType = WALMEPhotoModelMediaSubTypePhoto;
                if ([[asset valueForKey:@"filename"] hasSuffix:@"GIF"]) {
                    if (self.singleSelected && self.singleSelecteClip) {
                        photoModel.type = WALMEPhotoModelMediaTypePhoto;
                    } else {
                        photoModel.type = self.showGif ? WALMEPhotoModelMediaTypeGif : WALMEPhotoModelMediaTypePhoto;
                    }
                } else {
                    if (iOS9Later && self.supportLiveInDevice) {
                        if (@available(iOS 9.1, *)) {
                            if (asset.mediaSubtypes == PHAssetMediaSubtypePhotoLive) {
                                if (!self.singleSelected) {
                                    photoModel.type = self.showLive ? WALMEPhotoModelMediaTypeLive : WALMEPhotoModelMediaTypePhoto;
                                }else {
                                    photoModel.type = WALMEPhotoModelMediaTypePhoto;
                                }
                            }else {
                                photoModel.type = WALMEPhotoModelMediaTypePhoto;
                            }
                        } else {
                            // Fallback on earlier versions
                        }
                    }else {
                        photoModel.type = WALMEPhotoModelMediaTypePhoto;
                    }
                }
                if (!photoModel.isIcloud) {
                    [photoArray addObject:photoModel];
                }
            } else if (asset.mediaType == PHAssetMediaTypeVideo) {
                photoModel.subType = WALMEPhotoModelMediaSubTypeVideo;
                photoModel.type = WALMEPhotoModelMediaTypeVideo;
                if (!photoModel.isIcloud) {
                    [videoArray addObject:photoModel];
                }
            }
            photoModel.currentAlbumIndex = albumModel.index;
            [allArray addObject:photoModel];
            
            if (!photoModel.isIcloud) {
                [previewArray addObject:photoModel];
            }
            photoModel.dateItem = allArray.count - 1;
            photoModel.dateSection = 0;
            index++;
        }
    }
    //    NSInteger cameraIndex = self.showCamera ? 1 : 0;
    //    if (self.showCamera) {
    //        HXPhotoModel *model = [[HXPhotoModel alloc] init];
    //        model.type = WALMEPhotoModelMediaTypeCamera;
    //        if (photoArray.count == 0 && videoArray.count != 0) {
    //            model.thumbPhoto = [HXPhotoTools hx_imageNamed:@""]; //self.UIManager.cellCameraVideoImageName
    //        }else if (photoArray.count == 0) {
    //            model.thumbPhoto = [HXPhotoTools hx_imageNamed:@""]; //self.UIManager.cellCameraPhotoImageName
    //        }else {
    //            model.thumbPhoto = [HXPhotoTools hx_imageNamed:@""]; //self.UIManager.cellCameraPhotoImageName
    //        }
    //        if (!self.reverseDate) {
    //            model.dateSection = 0;
    //            model.dateItem = allArray.count;
    //            [allArray addObject:model];
    //        }
    //        else {
    //            model.dateSection = 0;
    //            model.dateItem = 0;
    //            [allArray insertObject:model atIndex:0];
    //        }
    //    }
    if (complete) {
        complete(allArray, previewArray, photoArray, videoArray, firstSelectModel);
    }
}

/**
 根据PHFetchResult获取某个相册里面的所有图片和视频
 
 @param result PHFetchResult对象
 @param index 相册下标
 @param list 照片和视频的集合
 */
- (void)fetchAllPhotoForPHFetchResult:(PHFetchResult *)result Index:(NSInteger)index fetchResult:(void (^)(NSArray<HXPhotoModel *> * _Nonnull, NSArray<HXPhotoModel *> * _Nonnull, NSArray<HXPhotoModel *> * _Nonnull))list {
    NSMutableArray *photoAy = [NSMutableArray array];
    NSMutableArray *videoAy = [NSMutableArray array];
    NSMutableArray *objAy = [NSMutableArray array];
    //    __block NSInteger cameraIndex = self.showCamera ? 1 : 0;
    //    uint64_t start = mach_absolute_time();
    [result enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(PHAsset *asset, NSUInteger idx, BOOL * _Nonnull stop) {
        HXPhotoModel *photoModel = [[HXPhotoModel alloc] init];
        photoModel.asset = asset;
        if ([[asset valueForKey:@"isCloudPlaceholder"] boolValue]) {
            photoModel.isIcloud = YES;
        }
        if (self.selectedList.count > 0) {
            NSMutableArray *selectedList = [NSMutableArray arrayWithArray:self.selectedList];
            for (HXPhotoModel *model in selectedList) {
                if ([model.asset.localIdentifier isEqualToString:photoModel.asset.localIdentifier]) {
                    photoModel.selected = YES;
                    //                    if (model.currentAlbumIndex == index) {
                    if (model.type == WALMEPhotoModelMediaTypePhoto ||
                        model.type == WALMEPhotoModelMediaTypeGif ||
                        model.type == WALMEPhotoModelMediaTypeLive) {
                        [self.selectedPhotos replaceObjectAtIndex:[self.selectedPhotos indexOfObject:model] withObject:photoModel];
                    }
                    else {
                        [self.selectedVideos replaceObjectAtIndex:[self.selectedVideos indexOfObject:model] withObject:photoModel];
                    }
                    [self.selectedList replaceObjectAtIndex:[self.selectedList indexOfObject:model] withObject:photoModel];
                    //                    }
                    photoModel.thumbPhoto = model.thumbPhoto;
                    photoModel.previewPhoto = model.previewPhoto;
                    photoModel.isCloseLivePhoto = model.isCloseLivePhoto;
                }
            }
        }
        if (asset.mediaType == PHAssetMediaTypeImage) {
            photoModel.subType = WALMEPhotoModelMediaSubTypePhoto;
            if ([[asset valueForKey:@"filename"] hasSuffix:@"GIF"]) {
                if (self.singleSelected && self.singleSelecteClip) {
                    photoModel.type = WALMEPhotoModelMediaTypePhoto;
                }else {
                    photoModel.type = self.showGif ? WALMEPhotoModelMediaTypeGif : WALMEPhotoModelMediaTypePhoto;
                }
            } else {
                photoModel.type = WALMEPhotoModelMediaTypePhoto;
                if (iOS9Later && [HXPhotoTools platform]) {
                    if (@available(iOS 9.1, *)) {
                        if (asset.mediaSubtypes == PHAssetMediaSubtypePhotoLive) {
                            if (!self.singleSelected) {
                                photoModel.type = self.showLive ? WALMEPhotoModelMediaTypeLive : WALMEPhotoModelMediaTypePhoto;
                            }
                        }
                    }
                }
            }
            if (!photoModel.isIcloud) {
                [photoAy addObject:photoModel];
            }
        } else if (asset.mediaType == PHAssetMediaTypeVideo) {
            photoModel.subType = WALMEPhotoModelMediaSubTypeVideo;
            photoModel.type = WALMEPhotoModelMediaTypeVideo;
            [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:nil resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
                photoModel.avAsset = asset;
            }];
            NSString *timeLength = [NSString stringWithFormat:@"%0.0f",asset.duration];
            photoModel.videoTime = [HXPhotoTools getNewTimeFromDurationSecond:timeLength.integerValue];
            if (!photoModel.isIcloud) {
                [videoAy addObject:photoModel];
            }
        }
        photoModel.currentAlbumIndex = index;
        [objAy addObject:photoModel];
    }];
    if (self.showCamera) {
        HXPhotoModel *model = [[HXPhotoModel alloc] init];
        model.type = WALMEPhotoModelMediaTypeCamera;
        if (photoAy.count == 0 && videoAy.count != 0) {
            model.thumbPhoto = [HXPhotoTools hx_imageNamed:@""]; //self.UIManager.cellCameraVideoImageName
        }else if (videoAy.count == 0) {
            model.thumbPhoto = [HXPhotoTools hx_imageNamed:@""]; //self.UIManager.cellCameraPhotoImageName
        }else {
            model.thumbPhoto = [HXPhotoTools hx_imageNamed:@""]; //self.UIManager.cellCameraPhotoImageName
        }
        [objAy insertObject:model atIndex:0];
    }
    //    if (index == 0) {
    //        if (self.cameraList.count > 0) {
    //            for (int i = 0; i < self.cameraList.count; i++) {
    //                HXPhotoModel *phMD = self.cameraList[i];
    //                [objAy insertObject:phMD atIndex:cameraIndex];
    //            }
    //            for (int i = 0; i < self.cameraPhotos.count; i++) {
    //                HXPhotoModel *phMD = self.cameraPhotos[i];
    //                [photoAy insertObject:phMD atIndex:0];
    //            }
    //            for (int i = 0; i < self.cameraVideos.count; i++) {
    //                HXPhotoModel *phMD = self.cameraVideos[i];
    //                [videoAy insertObject:phMD atIndex:0];
    //            }
    //        }
    //    }
    //    uint64_t stop = mach_absolute_time();
    //    NSSLog(@"%f",subtractTimes(stop, start));
    if (list) {
        list(photoAy,videoAy,objAy);
    }
}
double subtractTimes( uint64_t endTime, uint64_t startTime ) {
    uint64_t difference = endTime - startTime;
    static double conversion = 0.0;
    if( conversion == 0.0 )
    {
        mach_timebase_info_data_t info;
        kern_return_t err =mach_timebase_info( &info );
        //Convert the timebase into seconds
        if( err == 0  )
            conversion= 1e-9 * (double) info.numer / (double) info.denom;
    }
    return conversion * (double)difference;
}

- (void)clearSelectedList {
    
    [self.selectedList removeAllObjects];
    [self.selectedPhotos removeAllObjects];
    [self.selectedVideos removeAllObjects];
    [self.selectedPhotos removeAllObjects];
    [self.selectedVideos removeAllObjects];
}

- (void)getMaxAlbum {
    if ([PHPhotoLibrary authorizationStatus] != PHAuthorizationStatusAuthorized) {
        [[UIApplication sharedApplication].keyWindow showImageHUDText:[NSBundle hx_localizedStringForKey:@"无法访问照片，请前往设置中允许\n访问照片"]];
        return;
    }
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection *collection in smartAlbums) {
        if ([[HXPhotoTools transFormPhotoTitle:collection.localizedTitle] isEqualToString:@"相机胶卷"] ||
            [[HXPhotoTools transFormPhotoTitle:collection.localizedTitle] isEqualToString:@"所有照片"] ||
            [[HXPhotoTools transFormPhotoTitle:collection.localizedTitle] isEqualToString:@"最近项目"]) {
            PHFetchOptions *option = [[PHFetchOptions alloc] init];
            option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
            if (self.selectionType == WALMEAlbumListSelectionTypePhoto) {
                option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
            }else if (self.selectionType == WALMEAlbumListSelectionTypeVideo) {
                option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeVideo];
            }
            PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:collection options:option];
            HXAlbumModel *albumModel = [[HXAlbumModel alloc] init];
            albumModel.count = result.count;
            albumModel.albumName = collection.localizedTitle;
            albumModel.result = result;
            self.albumModel = albumModel;
            break;
        }
    }
}

- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    NSMutableArray *array = [NSMutableArray array];
    for (HXAlbumModel *albumModel in self.innerAlbums) {
        PHFetchResultChangeDetails *collectionChanges = [changeInstance changeDetailsForFetchResult:albumModel.result];
        if (collectionChanges) {
            [array addObject:@{@"collectionChanges" : collectionChanges ,@"model" : albumModel}];
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.selecting) {
            if (self.photoLibraryDidChangeWithPhotoViewController) {
                self.photoLibraryDidChangeWithPhotoViewController(array);
            }
        }
        if (self.photoLibraryDidChangeWithPhotoPreviewViewController) {
            self.photoLibraryDidChangeWithPhotoPreviewViewController(array);
        }
        if (self.photoLibraryDidChangeWithVideoViewController) {
            self.photoLibraryDidChangeWithVideoViewController(array);
        }
        if (array.count == 0 && self.saveCameraPhotoToAlbum) {
            PHFetchResultChangeDetails *collectionChanges = [changeInstance changeDetailsForFetchResult:self.albumModel.result];
            if (collectionChanges) {
                [array addObject:@{@"collectionChanges" : collectionChanges ,@"model" : self.albumModel}];
            }
        }
        if (array.count > 0) {
            if (self.photoLibraryDidChangeWithPhotoView) {
                self.photoLibraryDidChangeWithPhotoView(array,self.selecting);
            }
        }
    });
}
- (void)dealloc {
    NSSLog(@"dealloc");
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

@end


@implementation WALMEAlbumListViewmodel (Bussiness)

#pragma mark - init
- (instancetype)initWithNSDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        [self p_walme_setup];
        NSDictionary * conditions = dictionary[@"choose"];
//        _model = [WALMEAlbumListModel yy_modelWithJSON:conditions];
        NSDictionary * options = dictionary[@"options"];
//        _option = [WALMEUploadOptions yy_modelWithJSON:options];
        _aliDic = dictionary;
        if ([self.uploadType isEqualToString:@"photo"]) {
            _selectionType = WALMEAlbumListSelectionTypePhoto;
        } else if ([self.uploadType isEqualToString:@"video"]) {
            _selectionType = WALMEAlbumListSelectionTypeVideo;
        } else if ([self.uploadType isEqualToString:@"all"]) {
            _selectionType = WALMEAlbumListSelectionTypeAll;
        } else {
            _selectionType = WALMEAlbumListSelectionTypePhoto;
        }
    }
    return self;
}

#pragma mark - upload
- (void)walme_uploadImage:(HXPhotoModel *)model
//                 progress:(WALMENetProgressBlock)progressBlock
                   result:(WALMEAliOSSImageResultBlock)resultBlock {
    if (model) {
        [self walme_uploadImages:@[model] progress:^(float singleProgress, float totalProgress) {
//            if (progressBlock) {
//                progressBlock(singleProgress);
//            }
        } result:^(int sendCount, int failCount, NSArray * _Nonnull sendResults, NSArray<HXPhotoModel *> * _Nonnull failModels, NSArray<UIImage *> * _Nullable successImages, NSArray<NSString *> * _Nullable photoPaths) {
            NSError *error;
            if (failCount == 1) {
                NSString *domain = @"com.CodeFrame.WALMEChatAliOSS.ErrorDomain";
                NSString *desc = @"上传失败";
                NSDictionary *userInfo = @{NSLocalizedDescriptionKey : desc };
                error = [NSError errorWithDomain:domain
                                            code:-1111
                                        userInfo:userInfo];
            }
//            if (failCount != 1) {
//
//            }
            if (resultBlock) {
                resultBlock(error, failCount == 1 ? failModels : [sendResults objectOrNilAtIndex:0]);
            }
        }];
    }
}

- (void)walme_uploadImages:(NSArray<HXPhotoModel *> *)models
//                  progress:(WALMEAlbumUploadProgress)progressBlock
                    result:(WALMEAlbumUploadResult)resultBlock {
    int totalCount = (int)models.count;
    __weak typeof(self) weakSelf = self;
    [self.aliOSS stsRequest:^(NSError * _Nullable error, id  _Nullable results) {
        __block NSMutableArray * resultArr = [NSMutableArray arrayWithCapacity:0];
        __block NSMutableArray * failArr = [NSMutableArray arrayWithCapacity:0];
        __block NSMutableArray * images = [NSMutableArray arrayWithCapacity:0];
        __block NSMutableArray * paths = [NSMutableArray arrayWithCapacity:0];
        __block int sendCount = 0;
        __block int failCount = 0;
        
        [models enumerateObjectsUsingBlock:^(HXPhotoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            _albums = [NSMutableArray arrayWithCapacity:models.count];
            if (obj.type == WALMEPhotoModelMediaTypePhoto || obj.type == WALMEPhotoModelMediaTypeGif || obj.type == WALMEPhotoModelMediaTypeLive) {
//                [WALMEVideoCompressHelper fetchImage:obj.asset image:^(UIImage *image) {
//                    [weakSelf.aliOSS uploadAssetImage:image
//                                                index:(int)idx
//                                            tailIndex:0
//                                              quality:weakSelf.quality
//                                              isCover:NO
//                                                 time:0
//                                             progress:^(float progressValue) {
////                                                 if (progressBlock) {
////                                                     progressBlock(progressValue, sendCount / totalCount);
////                                                 }
//                                             }
//                                               result:^(NSError * _Nullable error, id  _Nullable result) {
//                                                   sendCount++;
////                                                   if (progressBlock) {
////                                                       progressBlock(100, sendCount / totalCount);
////                                                   }
//                                                   if (!error) {
//                                                       if (result) {
//                                                           [resultArr addObject:result];
//                                                           NSString * path = result[@"aliOSS"][@"data"][@"photo_url"];
//                                                           if (path) {
//                                                               [paths addObject:path];
//                                                           }
//                                                       }
//                                                       if (image) {
//                                                           [images addObject:image];
//                                                       }
//                                                   } else {
//                                                       failCount++;
//                                                       [failArr addObject:obj];
//                                                   }
//                                                   if (resultBlock) {
//                                                       resultBlock(sendCount, failCount, resultArr, failArr, images, paths);
//                                                   }
//                                               }];
//                }];
            }
            else if (obj.type == WALMEPhotoModelMediaTypeVideo) {
                //                [_uploadingAlbums addObject:@""];
                UIImage * image;
                [weakSelf p_walme_uploadVideoWithoutSts:obj coverImage:&image
//                                               progress:nil
                                                 result:^(NSError * _Nullable error, id  _Nullable result) {
                    sendCount++;
//                    if (progressBlock) {
//                        progressBlock(100, sendCount / totalCount);
//                    }
                    if (!error) {
                        if (result) {
                            [resultArr addObject:result];
                            NSString * path = result[@"aliOSS"][@"data"][@"photo_url"];
                            if (path) {
                                [paths addObject:path];
                            }
                        }
                        if (image) {
                            [images addObject:image];
                        }
                    } else {
                        failCount++;
                        [failArr addObject:obj];
                    }
                    if (resultBlock) {
                        resultBlock(sendCount, failCount, resultArr, failArr, images, paths);
                    }
                }];
            }
        }];
    }];
}

- (void)walme_uploadVideo:(HXPhotoModel *)model
//                 progress:(WALMENetProgressBlock)progressBlock
                   result:(WALMEAliOSSImageResultBlock)resultBlock {
    if (model.type == WALMEPhotoModelMediaTypeVideo) {
        [WALMEVideoCompressHelper convertAsset:model.asset finished:^(BOOL result, NSString *videoPath) {
            UIImage * image;
//            image = [self.aliOSS uploadVideo:videoPath progress:progressBlock result:resultBlock];
            _selectedImage = image;
        }];
    } else {
        NSString *domain = @"com.CodeFrame.WALMEChatAliOSS.ErrorDomain";
        NSString *desc = @"错误类型";
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey : desc };
        NSError *error = [NSError errorWithDomain:domain
                                             code:-1111
                                         userInfo:userInfo];
        if (resultBlock) {
            resultBlock(error, nil);
        }
    }
}

- (void)p_walme_uploadVideoWithoutSts:(HXPhotoModel *)model coverImage:(UIImage **)image
//                             progress:(WALMENetProgressBlock)progressBlock
                               result:(WALMEAliOSSImageResultBlock)resultBlock {
    if (model.type == WALMEPhotoModelMediaTypeVideo) {
        [WALMEVideoCompressHelper convertAsset:model.asset finished:^(BOOL result, NSString *videoPath) {
//            [self.aliOSS uploadVideoWithoutSts:videoPath coverImage:image dic:nil progress:progressBlock result:resultBlock];
        }];
    } else {
        NSString *domain = @"com.CodeFrame.WALMEChatAliOSS.ErrorDomain";
        NSString *desc = @"错误类型";
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey : desc };
        NSError *error = [NSError errorWithDomain:domain
                                             code:-1111
                                         userInfo:userInfo];
        if (resultBlock) {
            resultBlock(error, nil);
        }
    }
}

- (void)walme_uploadUnKnown:(HXPhotoModel *)model
//                   progress:(WALMENetProgressBlock)progressBlock
                     result:(WALMEAliOSSImageResultBlock)resultBlock {
    if ( model.type == WALMEPhotoModelMediaTypeVideo) {
//        [self walme_uploadVideo:model progress:progressBlock result:resultBlock];
    } else {
//        [self walme_uploadImage:model progress:progressBlock result:resultBlock];
    }
}

- (void)walme_uploadUnKnowns:(NSArray<HXPhotoModel *> *)models
//                    progress:(WALMEAlbumUploadProgress)progressBlock
                      result:(WALMEAlbumUploadResult)resultBlock {
//    [self walme_uploadImages:models progress:progressBlock result:resultBlock];
}

#pragma mark - getter

- (BOOL)singleSelected {
    if (_model) return _model.maxNumber == 1;
    return YES;
}

- (NSString *)uploadType {
    return _option.uploadType;
}

- (CGSize)maxPhotoSize {
    if (_model) return (CGSize){_model.maxWidth, _model.maxHeight};
    else return (CGSize){CGFLOAT_MAX, CGFLOAT_MAX};
}

- (CGSize)minPhotoSize {
    if (_model) return (CGSize){_model.minWidth, _model.minHeight};
    else return CGSizeZero;
}

- (int)maxWidth {
    return _model.maxWidth;
}

- (int)maxHeight {
    return _model.maxHeight;
}

- (int)minWidth {
    return _model.minWidth;
}

- (int)minHeight {
    return _model.minHeight;
}

- (NSInteger)maxNum {
    if (_model) return _model.maxNumber;
    else return 9;
}

- (NSInteger)maxPhotoNum {
    if (_model) return _model.maxNumber;
    else return 9;
}

- (NSInteger)maxVideoNum {
    if (_model) return _model.maxNumber;
    else return 1;
}

- (int)quality {
    if (_model) return _option.quality;
    else return 1;
}

- (NSString *)videoQuality {
    if (_model) return _option.videoQuality;
    else return @"middle";
}

- (NSInteger)maxVideoDuration {
    return _option.maxTime;
}

- (NSInteger)minVideoDuration {
    return _option.minTime;
}

- (BOOL)singleSelecteClip {
    if (_option) return _option.userEdit;
    else return NO;
}

- (WALMEAliOSS *)aliOSS {
    if (!_aliOSS) {
        _aliOSS = [[WALMEAliOSS alloc] initWithNSDictionary:_aliDic];
    }
    return _aliOSS;
}

@end
