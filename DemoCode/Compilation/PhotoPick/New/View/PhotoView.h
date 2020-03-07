////
////  PhotoView.h
////  PhotoPick
////
////  Created by Jeremy on 2019/3/23.
////  Copyright © 2019 Jeremy. All rights reserved.
////
//
//#import <Foundation/Foundation.h>
//#import "AlbumListViewmodel.h"
////#import "HXCollectionView.h"
//
//NS_ASSUME_NONNULL_BEGIN
//
///*
// *  使用选择照片之后自动布局的功能时就创建此块View. 初始化方法传入照片管理类
// */
//@class PhotoViewDelegate;
//
//@interface PhotoView : UIView
//
//@property (weak, nonatomic) id<PhotoViewDelegate> delegate;
//@property (strong, nonatomic) AlbumListViewmodel *viewmodel;
//@property (strong, nonatomic) NSIndexPath *currentIndexPath;        // 自定义转场动画时用到的属性
//@property (strong, nonatomic) HXCollectionView *collectionView;
//
///**
// 每行个数 默认3;
// */
//@property (assign, nonatomic) NSInteger lineCount;
//
///**
// 每个item间距 默认 3
// */
//@property (assign, nonatomic) CGFloat spacing;
//
//- (instancetype)initWithFrame:(CGRect)frame WithManager:(AlbumListViewmodel *)manager;
///**  不要使用 "initWithFrame" 这个方法初始化否者会出现异常, 请使用下面这个三个初始化方法  */
//- (instancetype)initWithFrame:(CGRect)frame manager:(AlbumListViewmodel *)manager;
//- (instancetype)initWithManager:(AlbumListViewmodel *)manager;
//+ (instancetype)photoManager:(AlbumListViewmodel *)manager;
///**  跳转相册 如果需要选择相机/相册时 还是需要选择  */
//- (void)goPhotoViewController;
///**  跳转相册 过滤掉选择 - 不管需不需要选择 直接前往相册  */
//- (void)directGoPhotoViewController;
///**  跳转相机  */
//- (void)goCameraViewContoller;
///**  网络图片是否全部下载完成  */
//- (BOOL)networkingPhotoDownloadComplete;
///**  删除某个模型  */
//- (void)deleteModelWithIndex:(NSInteger)index;
///**  已下载完成的网络图片数量  */
//- (NSInteger)downloadNumberForNetworkingPhoto;
///**  刷新view  */
//- (void)refreshView;
///**  删除添加按钮(即不需要)  */
////- (void)deleteAddBtn;
//
//@end
//
//@protocol PhotoViewDelegate <NSObject>
//@optional
//// 代理返回 选择、移动顺序、删除之后的图片以及视频
//- (void)photoView:(PhotoView *)photoView changeComplete:(NSArray<PhotoModel *> *)allList photos:(NSArray<PhotoModel *> *)photos videos:(NSArray<PhotoModel *> *)videos original:(BOOL)isOriginal;
//
//// 这次在相册选择的图片,不是所有选择的所有图片.
////- (void)photoViewCurrentSelected:(NSArray<PhotoModel *> *)allList photos:(NSArray<PhotoModel *> *)photos videos:(NSArray<PhotoModel *> *)videos original:(BOOL)isOriginal;
//
//// 当view更新高度时调用
//- (void)photoView:(PhotoView *)photoView updateFrame:(CGRect)frame;
//
//// 删除网络图片的地址
//- (void)photoView:(PhotoView *)photoView deleteNetworkPhoto:(NSString *)networkPhotoUrl;
//
///**  网络图片全部下载完成时调用  */
//- (void)photoViewAllNetworkingPhotoDownloadComplete:(PhotoView *)photoView;
//
//@end
//
//NS_ASSUME_NONNULL_END
