//
//  MediaPreviewViewController.h
//  PhotoPick
//
//  Created by Jeremy on 2019/3/23.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PhotosUI/PhotosUI.h>
#import "AlbumListViewmodel.h"

NS_ASSUME_NONNULL_BEGIN

//@class ,HXPhotoView;
@class MediaPreviewCell, PhotoModel;

@protocol MediaPreviewViewControllerDelegate;

@interface MediaPreviewViewController : UIViewController

@property (weak, nonatomic) id<MediaPreviewViewControllerDelegate> delegate;
@property (strong, nonatomic) AlbumListViewmodel *viewmodel;

@property (strong, nonatomic) NSMutableArray<PhotoModel *> *modelArray; // 意义不明
@property (assign, nonatomic) NSInteger currentModelIndex;              // 当前展示图片的下标 在上个列表界面会用到
@property (assign, nonatomic) BOOL outside;                             // 意义不明
//@property (assign, nonatomic) BOOL selectPreview;                     // 意义不明
//@property (strong, nonatomic) HXPhotoView *photoView;                 // 意义不明

- (MediaPreviewCell *)currentPreviewCell:(PhotoModel *)model;
- (void)setSubviewAlphaAnimate:(BOOL)animete;

@end

@protocol MediaPreviewViewControllerDelegate <NSObject>
@optional

/**
 复选框点击

 @param previewController self
 @param model 点击的PhotoModel
 @param isChecked yes是选中 NO是取消
 */
- (void)MediaPreviewControllerDidSelect:(MediaPreviewViewController *)previewController
                                  model:(PhotoModel *)model
                              isChecked:(BOOL)isChecked;
//右上角完成按钮
- (void)MediaPreviewControllerDidDone:(MediaPreviewViewController *)previewController
                                model:(PhotoModel *)model;

@end

NS_ASSUME_NONNULL_END
