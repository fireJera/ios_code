//
//  LETADPhotoPerviewViewController.h
//  LetDate
//
//  Created by Jeremy on 2019/1/21.
//  Copyright © 2019 JersiZhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXPhotoManager.h"

@class LETADPhotoPerviewViewController;

@protocol LETADPhotoPerviewViewControllerDelegate <NSObject>

@optional
- (void)didSelectedClick:(HXPhotoModel *)model AddOrDelete:(BOOL)state;
- (void)previewDidNextClick;

- (void)previewUpload:(LETADPhotoPerviewViewController *)controller source:(id)albums success:(BOOL)isSuccess result:(id)result;

- (void)imageUploadFromPhoto:(UIImage *)originImage
                   clipImage:(UIImage *)clipImage
                     success:(BOOL)isSuccess
                      result:(id)result;

@end

@class HXPhotoView;
//, LETADAlbumListViewmodel;

NS_ASSUME_NONNULL_BEGIN

@interface LETADPhotoPerviewViewController : UIViewController<UINavigationControllerDelegate>

//@property (nonatomic, strong) LETADAlbumListViewmodel * viewmodel;
@property (weak, nonatomic) id<LETADPhotoPerviewViewControllerDelegate> delegate;
@property (strong, nonatomic) NSMutableArray *modelList;
@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) HXPhotoManager *manager;
@property (weak, nonatomic, readonly) UICollectionView *collectionView;
@property (assign, nonatomic) BOOL isPreview; // 是否预览
@property (strong, nonatomic) HXPhotoView *photoView;
@property (strong, nonatomic) UIButton *selectedBtn;
@property (strong, nonatomic) UIImage *gifCoverImage;
@property (strong, nonatomic) HXPhotoModel *currentModel; // 当前查看的照片模型

- (void)letad_setup;
- (void)selectClick;

@end

NS_ASSUME_NONNULL_END
