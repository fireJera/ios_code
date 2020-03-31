//
//  WALMEAlbumListViewController.h
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "WALMEAlbumListViewmodel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol WALMEAlbumListViewControllerDelegate;

@class WALMEAlbumListViewmodel, HXPhotoViewCell, HXPhotoModel;

@interface WALMEAlbumListViewController : UIViewController

@property (strong, nonatomic) WALMEAlbumListViewmodel *viewmodel; // 照片管理类必须在跳转前赋值
@property (weak, nonatomic) id<WALMEAlbumListViewControllerDelegate> delegate;

@property (strong, nonatomic) NSMutableArray<HXPhotoModel *> *videos;
@property (strong, nonatomic) NSMutableArray<HXPhotoModel *> *objs;
@property (strong, nonatomic) NSMutableArray<HXPhotoModel *> *photos;

@end

@protocol WALMEAlbumListViewControllerDelegate <NSObject>

@optional

- (void)albumListViewControllerDidCancel:(WALMEAlbumListViewController *)albumListViewController;
- (void)albumListViewControllerDidFinish:(WALMEAlbumListViewController *)albumListViewController;

@end

NS_ASSUME_NONNULL_END
