//
//  LETADVideoPreviewViewController.h
//  LetDate
//
//  Created by Jeremy on 2019/1/21.
//  Copyright © 2019 JersiZhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PhotosUI/PhotosUI.h>
#import "HXPhotoManager.h"

NS_ASSUME_NONNULL_BEGIN

@class LETADVideoPreviewViewController, HXDatePhotoPreviewViewCell, HXPhotoView;
//, LETADAlbumListViewmodel;

@protocol LETADVideoPreviewViewControllerDelegate <NSObject>

@optional

//复选框选中
- (void)allPreviewdidSelectedClick:(HXPhotoModel *)model AddOrDelete:(BOOL)state;
//右上角完成按钮
- (void)previewControllerDidSelect:(LETADVideoPreviewViewController *)previewController model:(HXPhotoModel *)model;
//原来的bootomview 底部点击完成
- (void)previewControllerDidDone:(LETADVideoPreviewViewController *)previewController;
//上传视频 单个
- (void)videoPreviewUpload:(LETADVideoPreviewViewController *)previewController success:(BOOL)isSuccess;
//上传图片
- (void)imageUploadFromVideo:(UIImage *)originImage clipImage:(UIImage *)clipImage success:(BOOL)isSuccess;
//混合上传
- (void)mixUploadFromAlbumPreview:(LETADVideoPreviewViewController *)previewController
                           source:(id)albums
                          success:(BOOL)isSuccess
                           result:result;

@end
@interface LETADVideoPreviewViewController : UIViewController
<UIViewControllerTransitioningDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) id<LETADVideoPreviewViewControllerDelegate> delegate;
@property (strong, nonatomic) HXPhotoManager *manager;
@property (strong, nonatomic) NSMutableArray *modelArray;
@property (assign, nonatomic) NSInteger currentModelIndex;
@property (assign, nonatomic) BOOL outside;
@property (assign, nonatomic) BOOL selectPreview;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) HXPhotoView *photoView;

//@property (nonatomic, strong) LETADAlbumListViewmodel * listViewmodel;

- (HXDatePhotoPreviewViewCell *)currentPreviewCell:(HXPhotoModel *)model;
- (void)setSubviewAlphaAnimate:(BOOL)animete;
@end

NS_ASSUME_NONNULL_END
