//
//  LETADAlbumListViewController.h
//  LetDate
//
//  Created by Jeremy on 2019/1/21.
//  Copyright © 2019 JersiZhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXPhotoManager.h"

@class LETADAlbumListViewController;

@protocol LETADAlbumListViewControllerDelegate <NSObject>

@optional
/**
 点击下一步执行的代理  数组里面装的都是 HXPhotoModel 对象
 
 @param allList 所有对象 - 之前选择的所有对象
 @param photos 图片对象 - 之前选择的所有图片
 @param videos 视频对象 - 之前选择的所有视频
 @param original 是否原图
 */
- (void)photoViewControllerDidNext:(NSArray<HXPhotoModel *> *)allList Photos:(NSArray<HXPhotoModel *> *)photos Videos:(NSArray<HXPhotoModel *> *)videos Original:(BOOL)original;


/**
 上传完之后的回调 除了裁剪的图
 
 @param controller 控制器
 @param albums 上传的相册
 @param isSuccess 是否成功
 */
- (void)letad_albumUpload:(LETADAlbumListViewController *)controller source:(NSArray *)albums success:(BOOL)isSuccess result:(id)result;


/**
 裁剪的图上传完之后的回调
 
 @param originImage 原始图
 @param clipImage 裁剪图
 @param isSuccess 是否成功
 @param result 服务器返回结果
 @param originPath 原始网络地址
 @param clipPath 裁剪图网络地址
 */
- (void)letad_imageUploadFromList:(UIImage *)originImage
                        clipImage:(UIImage *)clipImage
                          success:(BOOL)isSuccess
                           result:(id)result
                       originPath:(NSString *)originPath
                         clipPath:(NSString *)clipPath;
/**
 点击取消执行的代理
 */
- (void)photoViewControllerDidCancel;

@end

//@class LETADAlbumListViewmodel;

NS_ASSUME_NONNULL_BEGIN

@interface LETADAlbumListViewController : UIViewController

//@property (nonatomic, strong) LETADAlbumListViewmodel * viewmodel;
@property (strong, nonatomic) HXPhotoManager *manager; // 照片管理类必须在跳转前赋值
@property (weak, nonatomic) id<LETADAlbumListViewControllerDelegate> delegate;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic, readonly) NSIndexPath *currentIndexPath;
@property (assign, nonatomic) BOOL isPreview;
@property (strong, nonatomic, readonly) HXAlbumModel *albumModel;

@property (strong, nonatomic) NSMutableArray *videos;
@property (strong, nonatomic) NSMutableArray *objs;
@property (strong, nonatomic) NSMutableArray *photos;
@end

NS_ASSUME_NONNULL_END
