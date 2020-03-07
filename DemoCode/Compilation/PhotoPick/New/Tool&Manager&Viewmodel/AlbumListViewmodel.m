//
//  AlbumListViewmodel.m
//  PhotoPick
//
//  Created by Jeremy on 2019/3/21.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import "AlbumListViewmodel.h"
#import "AlbumModel.h"
#import <mach/mach_time.h>
#import "AppDelegate.h"
#import "AlbumTool.h"
#import "PhotoModel.h"

@interface AlbumListViewmodel () <PHPhotoLibraryChangeObserver>

@property (nonatomic, strong) NSMutableArray * allPhotos;
@property (nonatomic, strong) NSMutableArray * allVideos;
@property (nonatomic, strong) NSMutableArray * allObjs;
@property (nonatomic, strong) NSMutableArray * innerAlbums;

@property (nonatomic, assign) BOOL supportLiveInDevice;

@end

@implementation AlbumListViewmodel

- (instancetype)initWithSelectionType:(AlbumListSelectionType)selectionType {
    self = [super init];
    if (!self) return nil;
    [self p_init];
    _selectionType = selectionType;
    return self;
}

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    [self p_init];
    return self;
}

- (void)p_init {
    _selectionType = AlbumListSelectionTypeAll;
    _columnCount = 3;
    _reverseDate = YES;
    _scrollDirection = AlbumListScrollDirectionUp;
    _singleSelected = YES;
    _showGif = YES;
    _showLive = YES;
    _maxNum = 9;
    _maxPhotoNum = 9;
    _maxVideoNum = 1;
    _shouldCompress = NO;
    _quality = 1;
    _compressPNG = NO;
    _showCamera = NO;
    _selectedList = [NSMutableArray array];
    _selectedPhotos = [NSMutableArray array];
    _selectedVideos = [NSMutableArray array];
    _innerAlbums = [NSMutableArray array];
    _allObjs = [NSMutableArray array];
    _allVideos = [NSMutableArray array];
    _minPhotoSize = CGSizeZero;
    _maxPhotoSize = CGSizeZero;
    _maxVideoDuration = NSIntegerMax;
    _minVideoDuration = 0;
    _saveCameraPhotoToAlbum = YES;
    _showBottomView = NO;
    _supportLiveInDevice = [AlbumTool platform];
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
}

#pragma mark - setter

- (void)setSaveCameraPhotoToAlbum:(BOOL)saveCameraPhotoToAlbum {
    _saveCameraPhotoToAlbum = saveCameraPhotoToAlbum;
    if (saveCameraPhotoToAlbum) [self p_getAlbumToSaveCameraPhoto];
}

//- (void)setLocalImages:(NSArray<UIImage *> *)localImages {
//    _localImages = localImages;
//    if (localImages.count > 0) {
//        NSAssert([localImages.firstObject isKindOfClass:[UIImage class]], @"NSArray isn't UIImage array");
//    }
//    dispatch_apply(localImages.count, dispatch_get_global_queue(0, 0), ^(size_t index) {
//        UIImage * image = localImages[index];
//        PhotoModel * photo = [PhotoModel photoModelWithImage:image];
//        photo.selected = YES;
//        
//    });
//}

#pragma mark - public func

- (void)getCellIcons {
    if (!self.singleSelected && !self.albumListCellIcon) {
        self.albumListCellIcon = @{
                                      @"videoIcon" : [AlbumTool imageNamed:@"VideoSendIcon@2x.png"] ,
                                      @"gifIcon" : [AlbumTool imageNamed:@"timeline_image_gif@2x.png"] ,
                                      @"liveIcon" : [AlbumTool imageNamed:@"compose_live_photo_open_only_icon@2x.png"] ,
                                      @"liveBtnImageNormal" : [AlbumTool imageNamed:@"compose_live_photo_open_icon@2x.png"] ,
                                      @"liveBtnImageSelected" : [AlbumTool imageNamed:@"compose_live_photo_close_icon@2x.png"] ,
                                      @"liveBtnBackgroundImage" : [AlbumTool imageNamed:@"compose_live_photo_background@2x.png"] ,
                                      @"selectBtnNormal" : [AlbumTool imageNamed:@"compose_guide_check_box_default@2x.png"] ,
                                      @"selectBtnSelected" : [AlbumTool imageNamed:@"compose_guide_check_box_right@2x.png"] ,
                                      @"icloudIcon" : [AlbumTool imageNamed:@"icon_yunxiazai@2x.png"],
                                      };
    }
}

- (void)fetchAllAlbum:(void (^)(NSArray<AlbumModel *> * _Nonnull))albums {
    if (self.innerAlbums.count > 0) [self.innerAlbums removeAllObjects];
    // 获取系统智能相册
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    [smartAlbums enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(PHAssetCollection *collection, NSUInteger idx, BOOL * _Nonnull stop) {
        // 是否按创建时间排序
        PHFetchOptions *option = [[PHFetchOptions alloc] init];
        option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
        if (self.selectionType == AlbumListSelectionTypePhoto) {
            option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
        }else if (self.selectionType == AlbumListSelectionTypeVideo) {
            option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeVideo];
        }
        // 获取照片集合
        PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:collection options:option];
        // 过滤掉空相册
        if (result.count > 0 && ![[AlbumTool transFormPhotoTitle:collection.localizedTitle] isEqualToString:@"最近删除"]) {
            AlbumModel *albumModel = [[AlbumModel alloc] init];
            albumModel.photoCount = result.count;
            albumModel.albumName = collection.localizedTitle;
            albumModel.result = result;
            if ([[AlbumTool transFormPhotoTitle:collection.localizedTitle] isEqualToString:@"相机胶卷"] ||
                [[AlbumTool transFormPhotoTitle:collection.localizedTitle] isEqualToString:@"所有照片"]) {
                [self.innerAlbums insertObject:albumModel atIndex:0];
            } else {
                [self.innerAlbums addObject:albumModel];
            }
        }
    }];
    
    // 获取用户相册
    PHFetchResult *userAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
    [userAlbums enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(PHAssetCollection *collection, NSUInteger idx, BOOL * _Nonnull stop) {
        // 是否按创建时间排序
        PHFetchOptions *option = [[PHFetchOptions alloc] init];
        option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
        if (self.selectionType == AlbumListSelectionTypePhoto) {
            option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
        }else if (self.selectionType == AlbumListSelectionTypeVideo) {
            option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeVideo];
        }
        // 获取照片集合
        PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:collection options:option];
        
        // 过滤掉空相册
        if (result.count > 0) {
            AlbumModel *albumModel = [[AlbumModel alloc] init];
            albumModel.photoCount = result.count;
            albumModel.albumName = [AlbumTool transFormPhotoTitle:collection.localizedTitle];
            albumModel.result = result;
            [self.innerAlbums addObject:albumModel];
        }
    }];
    
    for (int i = 0 ; i < self.albums.count; i++) {
        AlbumModel *model = self.albums[i];
        model.index = i;
    }
    if (albums) {
        albums(self.albums);
    }
}

- (void)getAllAlbum:(void (^)(AlbumModel * _Nonnull))firstAlbum
             albums:(nonnull void (^)(NSArray<AlbumModel *> * _Nonnull))albums
          onlyFirst:(BOOL)onlyFirst {
    if (self.innerAlbums.count > 0) [self.innerAlbums removeAllObjects];
    // 获取系统智能相册
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    [smartAlbums enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(PHAssetCollection *collection, NSUInteger idx, BOOL * _Nonnull stop) {
        if (onlyFirst) {
            if ([[AlbumTool transFormPhotoTitle:collection.localizedTitle] isEqualToString:@"相机胶卷"] ||
                [[AlbumTool transFormPhotoTitle:collection.localizedTitle] isEqualToString:@"所有照片"]) {
                // 是否按创建时间排序
                PHFetchOptions *option = [[PHFetchOptions alloc] init];
                option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
                if (self.selectionType == AlbumListSelectionTypePhoto) {
                    option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
                } else if (self.selectionType == AlbumListSelectionTypeVideo) {
                    option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeVideo];
                }
                // 获取照片集合
                PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:collection options:option];
                
                AlbumModel *albumModel = [[AlbumModel alloc] init];
                albumModel.photoCount = result.count;
                albumModel.albumName = collection.localizedTitle;
                albumModel.result = result;
                albumModel.index = 0;
                if (firstAlbum) {
                    firstAlbum(albumModel);
                }
                *stop = YES;
            }
        } else {
            // 是否按创建时间排序
            PHFetchOptions *option = [[PHFetchOptions alloc] init];
            option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
            if (self.selectionType == AlbumListSelectionTypePhoto) {
                option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
            } else if (self.selectionType == AlbumListSelectionTypeVideo) {
                option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeVideo];
            }
            // 获取照片集合
            PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:collection options:option];
            // 过滤掉空相册
            if (result.count > 0 && ![[AlbumTool transFormPhotoTitle:collection.localizedTitle] isEqualToString:@"最近删除"]) {
                AlbumModel *albumModel = [[AlbumModel alloc] init];
                albumModel.photoCount = result.count;
                albumModel.albumName = collection.localizedTitle;
                albumModel.result = result;
                if ([[AlbumTool transFormPhotoTitle:collection.localizedTitle] isEqualToString:@"相机胶卷"] || [[AlbumTool transFormPhotoTitle:collection.localizedTitle] isEqualToString:@"所有照片"]) {
                    [self.innerAlbums insertObject:albumModel atIndex:0];
                } else {
                    [self.innerAlbums addObject:albumModel];
                }
            }
        }
    }];
    if (onlyFirst) {
        return;
    }
    // 获取用户相册
    PHFetchResult *userAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
    [userAlbums enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(PHAssetCollection *collection, NSUInteger idx, BOOL * _Nonnull stop) {
        // 是否按创建时间排序
        PHFetchOptions *option = [[PHFetchOptions alloc] init];
        option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
        if (self.selectionType == AlbumListSelectionTypePhoto) {
            option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
        } else if (self.selectionType == AlbumListSelectionTypeVideo) {
            option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeVideo];
        }
        // 获取照片集合
        PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:collection options:option];
        
        // 过滤掉空相册
        if (result.count > 0) {
            AlbumModel *albumModel = [[AlbumModel alloc] init];
            albumModel.photoCount = result.count;
            albumModel.albumName = [AlbumTool transFormPhotoTitle:collection.localizedTitle];
            albumModel.result = result;
            [self.innerAlbums addObject:albumModel];
        }
    }];
    for (int i = 0 ; i < self.albums.count; i++) {
        AlbumModel *model = self.innerAlbums[i];
        model.index = i;
    }
    if (albums) {
        albums(self.albums);
    }
}

- (void)getAllPhotoForAlbum:(AlbumModel *)albumModel
                   complete:(void (^)(NSArray<PhotoModel *> * _Nonnull, NSArray<PhotoModel *> * _Nonnull, NSArray<PhotoModel *> * _Nonnull, NSArray<PhotoModel *> * _Nonnull, PhotoModel * _Nonnull))complete {
    NSMutableArray *allArray = [NSMutableArray array];
    NSMutableArray *previewArray = [NSMutableArray array];
    NSMutableArray *videoArray = [NSMutableArray array];
    NSMutableArray *photoArray = [NSMutableArray array];
    
    __block PhotoModel *firstSelectModel;
    NSMutableArray *selectList = [NSMutableArray arrayWithArray:self.selectedList];
    if (self.reverseDate) {
        [albumModel.result enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(PHAsset *asset, NSUInteger idx, BOOL * _Nonnull stop) {
            PhotoModel *photoModel = [[PhotoModel alloc] init];
            photoModel.asset = asset;
            if ([[asset valueForKey:@"isCloudPlaceholder"] boolValue]) {
                photoModel.isIcloud = YES;
            }
            if (selectList.count > 0) {
                NSString *property = @"asset";
                NSPredicate *pred = [NSPredicate predicateWithFormat:@"%K = %@", property, asset];
                NSArray *newArray = [selectList filteredArrayUsingPredicate:pred];
                if (newArray.count > 0) {
                    PhotoModel *model = newArray.firstObject;
                    [selectList removeObject:model];
                    photoModel.selected = YES;
                    if ((model.type == PhotoModelMediaTypePhoto ||model.type == PhotoModelMediaTypeGif) ||
                        model.type == PhotoModelMediaTypeLive) {
//                        (model.type == PhotoModelMediaTypeLive || model.type == PhotoModelMediaTypeCameraPhoto)) {
                        [self.selectedPhotos replaceObjectAtIndex:[self.selectedPhotos indexOfObject:model] withObject:photoModel];
                    } else {
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
                photoModel.subType = PhotoModelMediaSubTypePhoto;
                if ([[asset valueForKey:@"filename"] hasSuffix:@"GIF"]) {
                    if (self.singleSelected && self.singleSelectedClip) {
                        photoModel.type = PhotoModelMediaTypePhoto;
                    } else {
                        photoModel.type = self.showGif ? PhotoModelMediaTypeGif : PhotoModelMediaTypePhoto;
                    }
                } else {
                    photoModel.type = PhotoModelMediaTypePhoto;
                    if (iOS9_1_Later && self.supportLiveInDevice) {
                        if (asset.mediaSubtypes == PHAssetMediaSubtypePhotoLive) {
                            if (!self.singleSelected) {
                                photoModel.type = self.showLive ? PhotoModelMediaTypeLive : PhotoModelMediaTypePhoto;
                            }
                        }
                    }
                }
                if (!photoModel.isIcloud) {
                    [photoArray addObject:photoModel];
                }
            }else if (asset.mediaType == PHAssetMediaTypeVideo) {
                photoModel.subType = PhotoModelMediaSubTypeVideo;
                photoModel.type = PhotoModelMediaTypeVideo;
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
            PhotoModel *photoModel = [[PhotoModel alloc] init];
            photoModel.asset = asset;
            if ([[asset valueForKey:@"isCloudPlaceholder"] boolValue]) {
                photoModel.isIcloud = YES;
            }
            if (selectList.count > 0) {
                NSString *property = @"asset";
                NSPredicate *pred = [NSPredicate predicateWithFormat:@"%K = %@", property, asset];
                NSArray *newArray = [selectList filteredArrayUsingPredicate:pred];
                if (newArray.count > 0) {
                    PhotoModel *model = newArray.firstObject;
                    [selectList removeObject:model];
                    photoModel.selected = YES;
                    if ((model.type == PhotoModelMediaTypePhoto || model.type == PhotoModelMediaTypeGif) ||
                        model.type == PhotoModelMediaTypeLive) {
//                        (model.type == PhotoModelMediaTypeLive || model.type == PhotoModelMediaTypeCameraPhoto)) {
                        [self.selectedPhotos replaceObjectAtIndex:[self.selectedPhotos indexOfObject:model] withObject:photoModel];
                    } else {
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
                photoModel.subType = PhotoModelMediaSubTypePhoto;
                if ([[asset valueForKey:@"filename"] hasSuffix:@"GIF"]) {
                    if (self.singleSelected && self.singleSelectedClip) {
                        photoModel.type = PhotoModelMediaTypePhoto;
                    } else {
                        photoModel.type = self.showGif ? PhotoModelMediaTypeGif : PhotoModelMediaTypePhoto;
                    }
                } else {
                    photoModel.type = PhotoModelMediaTypePhoto;
                    if (iOS9_1_Later && self.supportLiveInDevice) {
                        if (asset.mediaSubtypes == PHAssetMediaSubtypePhotoLive) {
                            if (!self.singleSelected) {
                                photoModel.type = self.showLive ? PhotoModelMediaTypeLive : PhotoModelMediaTypePhoto;
                            }
                        }
                    }
                }
                if (!photoModel.isIcloud) {
                    [photoArray addObject:photoModel];
                }
            } else if (asset.mediaType == PHAssetMediaTypeVideo) {
                photoModel.subType = PhotoModelMediaSubTypeVideo;
                photoModel.type = PhotoModelMediaTypeVideo;
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
    
    if (self.showCamera) {
        PhotoModel *model = [[PhotoModel alloc] init];
        model.type = PhotoModelMediaTypeCamera;
        if (photoArray.count == 0 && videoArray.count != 0) {
            model.thumbPhoto = [AlbumTool imageNamed:@"compose_photo_video@2x.png"];
        } else if (photoArray.count == 0) {
            model.thumbPhoto = [AlbumTool imageNamed:@"compose_photo_photograph@2x.png"];
        } else {
            model.thumbPhoto = [AlbumTool imageNamed:@"compose_photo_photograph@2x.png"];
        }
        if (!self.reverseDate) {
            model.dateSection = 0;
            model.dateItem = allArray.count;
            [allArray addObject:model];
        } else {
            model.dateSection = 0;
            model.dateItem = 0;
            [allArray insertObject:model atIndex:0];
        }
    }
//    NSInteger cameraIndex = self.showCamera ? 1 : 0;
//    if (self.cameraList.count > 0) {
//        NSInteger index = 0;
//        NSInteger photoIndex = 0;
//        NSInteger videoIndex = 0;
//        for (PhotoModel *model in self.cameraList) {
//            model.currentAlbumIndex = albumModel.index;
//            if (self.reverseDate) {
//                [allArray insertObject:model atIndex:cameraIndex + index];
//                [previewArray insertObject:model atIndex:index];
//                if (model.subType == PhotoModelMediaSubTypePhoto) {
//                    [photoArray insertObject:model atIndex:photoIndex];
//                    photoIndex++;
//                }else {
//                    [videoArray insertObject:model atIndex:videoIndex];
//                    videoIndex++;
//                }
//            } else {
//                NSInteger count = allArray.count;
//                [allArray insertObject:model atIndex:count - cameraIndex];
//                [previewArray addObject:model];
//                if (model.subType == PhotoModelMediaSubTypePhoto) {
//                    [photoArray addObject:model];
//                } else {
//                    [videoArray addObject:model];
//                }
//            }
//            index++;
//        }
//    }
    if (complete) {
        complete(allArray, previewArray, photoArray, videoArray, firstSelectModel);
    }
}

- (void)fetchPhotoForPHResult:(PHFetchResult *)result index:(NSInteger)index result:(void (^)(NSArray<PhotoModel *> * _Nonnull, NSArray<PhotoModel *> * _Nonnull, NSArray<PhotoModel *> * _Nonnull))list {
    NSMutableArray *photoAy = [NSMutableArray array];
    NSMutableArray *videoAy = [NSMutableArray array];
    NSMutableArray *objAy = [NSMutableArray array];
//    __block NSInteger cameraIndex = self.showCamera ? 1 : 0;
    
    [result enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(PHAsset *asset, NSUInteger idx, BOOL * _Nonnull stop) {
        PhotoModel *photoModel = [[PhotoModel alloc] init];
        photoModel.asset = asset;
        if ([[asset valueForKey:@"isCloudPlaceholder"] boolValue]) {
            photoModel.isIcloud = YES;
        }
        if (self.selectedList.count > 0) {
            NSMutableArray *selectedList = [NSMutableArray arrayWithArray:self.selectedList];
            for (PhotoModel *model in selectedList) {
                if ([model.asset.localIdentifier isEqualToString:photoModel.asset.localIdentifier]) {
                    photoModel.selected = YES;
                    if ((model.type == PhotoModelMediaTypePhoto || model.type == PhotoModelMediaTypeGif) ||
                        model.type == PhotoModelMediaTypeLive) {
//                        (model.type == PhotoModelMediaTypeLive || model.type == PhotoModelMediaTypeCameraPhoto)) {
                        [self.selectedPhotos replaceObjectAtIndex:[self.selectedPhotos indexOfObject:model] withObject:photoModel];
                    } else {
                        [self.selectedVideos replaceObjectAtIndex:[self.selectedVideos indexOfObject:model] withObject:photoModel];
                    }
                    [self.selectedList replaceObjectAtIndex:[self.selectedList indexOfObject:model] withObject:photoModel];
                    photoModel.thumbPhoto = model.thumbPhoto;
                    photoModel.previewPhoto = model.previewPhoto;
                    photoModel.isCloseLivePhoto = model.isCloseLivePhoto;
                }
            }
        }
        if (asset.mediaType == PHAssetMediaTypeImage) {
            photoModel.subType = PhotoModelMediaSubTypePhoto;
            if ([[asset valueForKey:@"filename"] hasSuffix:@"GIF"]) {
                if (self.singleSelected && self.singleSelectedClip) {
                    photoModel.type = PhotoModelMediaTypePhoto;
                } else {
                    photoModel.type = self.showGif ? PhotoModelMediaTypeGif : PhotoModelMediaTypePhoto;
                }
            } else {
                photoModel.type = PhotoModelMediaTypePhoto;
                if (iOS9_1_Later && self.supportLiveInDevice) {
                    if (asset.mediaSubtypes == PHAssetMediaSubtypePhotoLive) {
                        if (!self.singleSelected) {
                            photoModel.type = self.showLive ? PhotoModelMediaTypeLive : PhotoModelMediaTypePhoto;
                        }
                    }
                }
            }
            if (!photoModel.isIcloud) {
                [photoAy addObject:photoModel];
            }
        }else if (asset.mediaType == PHAssetMediaTypeVideo) {
            photoModel.subType = PhotoModelMediaSubTypeVideo;
            photoModel.type = PhotoModelMediaTypeVideo;
            [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:nil resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
                photoModel.avAsset = asset;
            }];
            NSString *timeLength = [NSString stringWithFormat:@"%0.0f",asset.duration];
            photoModel.videoTime = [AlbumTool getNewTimeFromDurationSecond:timeLength.integerValue];
            if (!photoModel.isIcloud) {
                [videoAy addObject:photoModel];
            }
        }
        photoModel.currentAlbumIndex = index;
        [objAy addObject:photoModel];
    }];
    if (self.showCamera) {
        PhotoModel *model = [[PhotoModel alloc] init];
        model.type = PhotoModelMediaTypeCamera;
        if (photoAy.count == 0 && videoAy.count != 0) {
            model.thumbPhoto = [AlbumTool imageNamed:@"compose_photo_video@2x.png"];
        }else if (videoAy.count == 0) {
            model.thumbPhoto = [AlbumTool imageNamed:@"compose_photo_photograph@2x.png"];
        }else {
            model.thumbPhoto = [AlbumTool imageNamed:@"compose_photo_photograph@2x.png"];
        }
        [objAy insertObject:model atIndex:0];
    }
//    if (index == 0) {
//        if (self.cameraList.count > 0) {
//            for (int i = 0; i < self.cameraList.count; i++) {
//                PhotoModel *phMD = self.cameraList[i];
//                [objAy insertObject:phMD atIndex:cameraIndex];
//            }
//            for (int i = 0; i < self.cameraPhotos.count; i++) {
//                PhotoModel *phMD = self.cameraPhotos[i];
//                [photoAy insertObject:phMD atIndex:0];
//            }
//            for (int i = 0; i < self.cameraVideos.count; i++) {
//                PhotoModel *phMD = self.cameraVideos[i];
//                [videoAy insertObject:phMD atIndex:0];
//            }
//        }
//    }
    if (list) {
        list(photoAy, videoAy, objAy);
    }
}

#pragma mark - PHPhotoLibraryChangeObserver
- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    NSMutableArray *array = [NSMutableArray array];
    for (AlbumModel *albumModel in self.innerAlbums) {
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
                [array addObject:@{@"collectionChanges" : collectionChanges, @"model" : self.albumModel}];
            }
        }
        if (array.count > 0) {
            if (self.photoLibraryDidChangeWithPhotoView) {
                self.photoLibraryDidChangeWithPhotoView(array, self.selecting);
            }
        }
    });
}

#pragma mark - private func

- (void)p_getAlbumToSaveCameraPhoto {
    if ([PHPhotoLibrary authorizationStatus] != PHAuthorizationStatusAuthorized) {
        [[UIApplication sharedApplication].keyWindow showImageHUDText:@"无法访问照片，请前往设置中允许\n访问照片"];
        return;
    }
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection *collection in smartAlbums) {
        if ([[AlbumTool transFormPhotoTitle:collection.localizedTitle] isEqualToString:@"相机胶卷"] ||
            [[AlbumTool transFormPhotoTitle:collection.localizedTitle] isEqualToString:@"所有照片"]) {
            PHFetchOptions *option = [[PHFetchOptions alloc] init];
            option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
            if (self.selectionType == AlbumListSelectionTypePhoto) {
                option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
            } else if (self.selectionType == AlbumListSelectionTypeVideo) {
                option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeVideo];
            }
            PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:collection options:option];
            AlbumModel *albumModel = [[AlbumModel alloc] init];
            albumModel.photoCount = result.count;
            albumModel.albumName = collection.localizedTitle;
            albumModel.result = result;
            self.albumModel = albumModel;
            break;
        }
    }
}

#pragma mark - getter

- (NSArray<AlbumModel *> *)albums {
    return _innerAlbums;
}

- (void)dealloc {
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

@end
