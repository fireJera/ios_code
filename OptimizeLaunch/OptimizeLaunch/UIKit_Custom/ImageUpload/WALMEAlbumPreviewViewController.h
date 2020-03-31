//
//  WALMEAlbumPreviewViewController.h
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WALMEAlbumListViewmodel.h"

NS_ASSUME_NONNULL_BEGIN

@class WALMEAlbumPreviewViewController;

@protocol WALMEAlbumPreviewViewControllerDelegate <NSObject>

@optional
- (void)didSelectedClick:(HXPhotoModel *_Nullable)model AddOrDelete:(BOOL)state;
- (void)previewDidNextClick;

- (void)previewUpload:(WALMEAlbumPreviewViewController *)controller
            sendCount:(NSInteger)sendCount
            failCount:(NSInteger)failCount
          sendResults:(nullable NSArray *)sendResults;

- (void)imageUploadFromPhoto:(nullable UIImage *)originImage
                   clipImage:(nullable UIImage *)clipImage
                     success:(BOOL)isSuccess
                      result:(id)result;

@end

@class HXPhotoView, WALMEAlbumListViewmodel;

@interface WALMEAlbumPreviewViewController : UIViewController<UINavigationControllerDelegate>

@property (nonatomic, strong) WALMEAlbumListViewmodel * viewmodel;
@property (weak, nonatomic) id<WALMEAlbumPreviewViewControllerDelegate> delegate;
@property (strong, nonatomic) NSMutableArray *modelList;
@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) WALMEAlbumListViewmodel *manager;
@property (weak, nonatomic, readonly) UICollectionView *collectionView;
@property (assign, nonatomic) BOOL isPreview; // 是否预览
@property (strong, nonatomic) HXPhotoView *photoView;
@property (strong, nonatomic) UIButton *selectedBtn;
@property (strong, nonatomic) UIImage *gifCoverImage;
@property (strong, nonatomic) HXPhotoModel *currentModel; // 当前查看的照片模型

- (void)walme_setup;
- (void)selectClick;

@end

NS_ASSUME_NONNULL_END

