//
//  HXPhotoViewCell.h
//  微博照片选择
//
//  Created by 洪欣 on 17/2/8.
//  Copyright © 2017年 洪欣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@class HXPhotoModel;

@protocol HXPhotoViewCellDelegate;

@interface HXPhotoViewCell : UICollectionViewCell

@property (weak, nonatomic) id<HXPhotoViewCellDelegate> delegate;

//@property (weak, nonatomic) id<UIViewControllerPreviewing> previewingContext;
@property (assign, nonatomic) BOOL firstRegisterPreview;
@property (assign, nonatomic) BOOL singleSelected;
@property (strong, nonatomic) HXPhotoModel *model;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIView *maskView;
@property (strong, nonatomic) UIButton *selectBtn;
@property (assign, nonatomic) PHImageRequestID requestID;
@property (copy, nonatomic) NSDictionary *iconDic;

@property (nonatomic, assign) NSInteger maxTime;
@property (nonatomic, assign) NSInteger minTime;

- (void)startLivePhoto;
- (void)stopLivePhoto;

- (void)cancelRequest;

@end

@protocol HXPhotoViewCellDelegate <NSObject>

//- (void)didCameraClick;
- (void)cellDidSelectedBtnClick:(HXPhotoViewCell *)cell Model:(HXPhotoModel *)model;
- (void)cellChangeLivePhotoState:(HXPhotoModel *)model;

@end
