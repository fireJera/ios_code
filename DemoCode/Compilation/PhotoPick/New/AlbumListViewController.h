//
//  AlbumListViewController.h
//  PhotoPick
//
//  Created by Jeremy on 2019/3/21.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class AlbumListViewmodel, PhotoModel;

@protocol AlbumListViewControllerDelegate;

@interface AlbumListViewController : UIViewController

@property (nonatomic, weak) id<AlbumListViewControllerDelegate> delegate;
@property (nonatomic, strong) AlbumListViewmodel * viewmodel;

@property (strong, nonatomic) NSMutableArray<PhotoModel *> *videos;
@property (strong, nonatomic) NSMutableArray<PhotoModel *> *objs;
@property (strong, nonatomic) NSMutableArray<PhotoModel *> *photos;

@end

@protocol AlbumListViewControllerDelegate <NSObject>

@optional

- (void)albumListViewControllerDidCancel:(AlbumListViewController *)albumListViewController;
- (void)albumListViewControllerDidFinish:(AlbumListViewController *)albumListViewController;

@end

NS_ASSUME_NONNULL_END
