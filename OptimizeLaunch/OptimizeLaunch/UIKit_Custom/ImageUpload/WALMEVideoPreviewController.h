//
//  WALMEVideoPreviewController.h
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PhotosUI/PhotosUI.h>
#import "WALMEAlbumListViewmodel.h"

@class HXPhotoModel;
NS_ASSUME_NONNULL_BEGIN

@class WALMEVideoPreviewController, HXDatePhotoPreviewViewCell, HXPhotoView, WALMEAlbumListViewmodel;

@protocol WALMEVideoPreviewControllerDelegate <NSObject>

@optional

//复选框选中
- (void)allPreviewdidSelectedClick:(HXPhotoModel *)model AddOrDelete:(BOOL)state;
//右上角完成按钮
- (void)previewControllerDidSelect:(WALMEVideoPreviewController *)previewController model:(HXPhotoModel *)model;
//原来的bootomview 底部点击完成
- (void)previewControllerDidDone:(WALMEVideoPreviewController *)previewController;
//上传视频 单个
- (void)videoPreviewUpload:(WALMEVideoPreviewController *)previewController success:(BOOL)isSuccess;
//上传图片
- (void)imageUploadFromVideo:(UIImage *)originImage clipImage:(UIImage *)clipImage success:(BOOL)isSuccess;

//混合上传
- (void)mixUploadFromAlbumPreview:(WALMEVideoPreviewController *)previewController
                        sendCount:(NSInteger)sendCount
                        failCount:(NSInteger)failCount
                      sendResults:(NSArray *)sendResults;

@end

@interface WALMEVideoPreviewController : UIViewController
<UIViewControllerTransitioningDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) id<WALMEVideoPreviewControllerDelegate> delegate;
@property (strong, nonatomic) WALMEAlbumListViewmodel *manager;
@property (strong, nonatomic) NSMutableArray *modelArray;
@property (assign, nonatomic) NSInteger currentModelIndex;
@property (assign, nonatomic) BOOL outside;
@property (assign, nonatomic) BOOL selectPreview;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) HXPhotoView *photoView;

@property (nonatomic, strong) WALMEAlbumListViewmodel * listViewmodel;

- (HXDatePhotoPreviewViewCell *)currentPreviewCell:(HXPhotoModel *)model;
- (void)setSubviewAlphaAnimate:(BOOL)animete;
@end

NS_ASSUME_NONNULL_END
