////
////  PhotoSubViewCell.h
////  PhotoPick
////
////  Created by Jeremy on 2019/3/23.
////  Copyright © 2019 Jeremy. All rights reserved.
////
//
//#import <UIKit/UIKit.h>
//
//NS_ASSUME_NONNULL_BEGIN
//
//@class PhotoModel;
//
//@protocol PhotoSubViewCellDelegate;
//
//@interface PhotoSubViewCell : UICollectionViewCell
//@property (weak, nonatomic) id<PhotoSubViewCellDelegate> delegate;
//@property (copy, nonatomic) NSDictionary *dic;
//@property (strong, nonatomic, readonly) UIImageView *imageView;
//@property (strong, nonatomic) PhotoModel *model;
//
///**
// 删除网络图片时是否显示Alert // 默认显示
// */
//@property (assign, nonatomic) BOOL showDeleteNetworkPhotoAlert;
//// 重新下载
//- (void)againDownload;
//
//@end
//
//@protocol PhotoSubViewCellDelegate <NSObject>
//
//- (void)cellDidDeleteClcik:(UICollectionViewCell *)cell;
//- (void)cellNetworkingPhotoDownLoadComplete;
//@end
//
//NS_ASSUME_NONNULL_END
//
//
