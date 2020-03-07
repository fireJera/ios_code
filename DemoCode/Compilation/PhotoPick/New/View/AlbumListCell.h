//
//  AlbumListCell.h
//  PhotoPick
//
//  Created by Jeremy on 2019/3/22.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@class PhotoModel;

NS_ASSUME_NONNULL_BEGIN

@protocol AlbumListCellDelegate;

@interface AlbumListCell : UICollectionViewCell

@property (nonatomic, weak) id<AlbumListCellDelegate> delegate;
@property (assign, nonatomic) BOOL firstRegisterPreview;
@property (assign, nonatomic) BOOL singleSelected;
@property (strong, nonatomic) PhotoModel *model;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIView *maskView;
@property (strong, nonatomic) UIButton *selectBtn;
@property (assign, nonatomic) PHImageRequestID requestID;
@property (copy, nonatomic) NSDictionary *iconDic;


- (void)startLivePhoto;
- (void)stopLivePhoto;

- (void)cancelRequest;

@end

@protocol AlbumListCellDelegate <NSObject>

- (void)albumListCellDidSelectedBtnClick:(AlbumListCell *)cell model:(PhotoModel *)model;
- (void)albumListCellChangeLivePhotoState:(PhotoModel *)model;

@end

NS_ASSUME_NONNULL_END
