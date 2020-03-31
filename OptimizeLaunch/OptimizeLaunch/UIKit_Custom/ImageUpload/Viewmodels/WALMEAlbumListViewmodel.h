//
//  HX_PhotoManager.h
//  微博照片选择
//
//  Created by 洪欣 on 17/2/8.
//  Copyright © 2017年 洪欣. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "WALMEAliOSS.h"

NS_ASSUME_NONNULL_BEGIN

@class HXAlbumModel, HXPhotoModel, HXPhotoTools, HXPhotoUIManager;

@class WALMEAlbumListModel, WALMEUploadOptions;

/**
 *  照片选择的管理类, 使用照片选择时必须先懒加载此类,然后赋值给对应的对象
 */

typedef NS_ENUM(NSUInteger, WALMEAlbumListSelectionType) {
    WALMEAlbumListSelectionTypePhoto = 0,        // 只选择图片
    WALMEAlbumListSelectionTypeVideo = 1,        // 只选择视频
    WALMEAlbumListSelectionTypeAll               // 图片和视频一起
};

@interface WALMEAlbumListViewmodel : NSObject

/**
 每行多少个
 相册列表每行多少个照片 默认4个 iphone 4s / 5  默认3个
 */
@property (assign, nonatomic) NSInteger columnCount;

/**
 照片列表按日期倒序 - HXPhotoAlbumStylesSystem 时有用 默认 NO
 */
@property (assign, nonatomic) BOOL reverseDate;

/**
 默认 all
 */
@property (nonatomic, assign) WALMEAlbumListSelectionType selectionType;

/**
 第一张是否在头部 yes - header no footer default yes
 */
@property (assign, nonatomic) BOOL firstTop;

/**
 *  是否缓存相册, manager会监听系统相册变化(需要此功能时请不要关闭监听系统相册功能)   默认YES
 */
@property (assign, nonatomic) BOOL cacheAlbum;

/**
 *  是否监听系统相册  -  如果开启了缓存相册 自动开启监听   默认 YES
 */
@property (assign, nonatomic) BOOL monitorSystemAlbum;

///**
// 是否为单选模式 默认 NO
// */
//@property (assign, nonatomic) BOOL singleSelected;

///**
// 单选模式下是否需要裁剪  默认YES
// */
//@property (assign, nonatomic) BOOL singleSelecteClip;

/**
 是否开启查看GIF图片功能 - 默认开启
 */
@property (assign, nonatomic) BOOL showGif;

/**
 是否开启查看LivePhoto功能呢 - 默认 NO
 */
@property (assign, nonatomic) BOOL showLive;

///**
// 最大选择数 等于 图片最大数 + 视频最大数 默认9 - 必填
// */
//@property (assign, nonatomic) NSInteger maxNum;
//
///**
// 图片最大选择数 默认9 - 必填
// */
//@property (assign, nonatomic) NSInteger maxPhotoNum;
//
///**
// 视频最大选择数 // 默认1 - 必填
// */
//@property (assign, nonatomic) NSInteger maxVideoNum;
//
///**
// 最长视频时间 默认 max_float
// */
//@property (nonatomic, assign) NSInteger maxVideoDuration;
//
///**
// 最短视频时间 默认 0 无限制
// */
//@property (nonatomic, assign) NSInteger minVideoDuration;
//
///**
// 最大图片大小 (size)默认 CGSizeZero = CGSizeMax
// */
//@property (nonatomic, assign) CGSize maxPhotoSize;
//
///**
// 最小图片大小 (size)默认 CGSizeZero
// */
//@property (nonatomic, assign) CGSize minPhotoSize;
/**
 是否在获取结果中使用压缩 默认 NO
 */
@property (nonatomic, assign) BOOL shouldCompress;

///**
// 压缩质量 0-1 默认 1
// */
//@property (nonatomic, assign) NSInteger quality;

/**
 是否可以打开相机 默认 NO
 */
@property (nonatomic, assign) BOOL showCamera;

/**
 是否保存照片到相机 默认 YES
 */
@property (nonatomic, assign) BOOL saveCameraPhotoToAlbum;

/**
 collectionViewCell 要用到的icon
 */
@property (nonatomic, strong) NSDictionary<NSString *, UIImage *> *albumListCellIcon;

@property (strong, nonatomic) HXAlbumModel *albumModel;

/*-------------------------------------------------------*/
//------// 当要删除的已选中的图片或者视频的时候需要在对应的end数组里面删除
// 例如: 如果删除的是通过相机拍的照片需要在 endCameraList 和 endCameraPhotos 数组删除对应的图片模型
@property (strong, nonatomic) NSMutableArray *selectedList;
@property (strong, nonatomic) NSMutableArray *selectedPhotos;
@property (strong, nonatomic) NSMutableArray *selectedVideos;

/**
上传图片成功后的结果
*/
@property (nonatomic, copy) NSDictionary *mediaResult;
/**
 裁剪后的照片
 */
@property (nonatomic, strong) UIImage * _Nullable selectedImage;

/**
 裁剪前的原照
 */
@property (nonatomic, strong) UIImage * _Nullable selectedOriginImage;

/**
 裁剪后的照片的上传的路径（完整）
 */
@property (nonatomic, copy) NSString * _Nullable uploadPath;
/**
 裁剪后的原照的上传的路径（完整）
 */
@property (nonatomic, copy) NSString * _Nullable uploadOriginPath;

/**
 裁剪后的原照的上传的路径 （不完整）
 */
@property (nonatomic, copy) NSString * _Nullable uploadName;


@property (nonatomic, strong) NSArray<UIImage *> * _Nullable selectedImages;
@property (nonatomic, copy) NSArray * uploadedResults;

// 全地址路径
@property (nonatomic, copy) NSArray<NSString *> * uploadedPaths;

// 无host地址路径
@property (nonatomic, copy) NSArray<NSString *> * uploadedNames;

/**
 所有相册
 */
@property (strong, nonatomic, readonly) NSArray<HXAlbumModel *> *albums;

/**  是否正在照片控制器里选择图片  */
@property (assign, nonatomic) BOOL selecting;


/**  系统相册发生了变化  */
@property (copy, nonatomic) void (^photoLibraryDidChangeWithPhotoViewController)(NSArray *collectionChanges);
@property (copy, nonatomic) void (^photoLibraryDidChangeWithPhotoPreviewViewController)(NSArray *collectionChanges);
@property (copy, nonatomic) void (^photoLibraryDidChangeWithVideoViewController)(NSArray *collectionChanges);
@property (copy, nonatomic) void (^photoLibraryDidChangeWithPhotoView)(NSArray *collectionChanges ,BOOL selecting);

/**  是否为相机拍摄的图片  */
@property (assign, nonatomic) BOOL cameraPhoto;



#pragma mark - Bussiness
@property (nonatomic, strong) WALMEAlbumListModel * model;
@property (nonatomic, strong) WALMEUploadOptions * option;
//@property (nonatomic, copy, readonly) NSMutableArray * uploadingAlbums;
@property (nonatomic, copy, readonly) NSDictionary * aliDic;

///**
// @param type 选择类型
// @return self
// */
//- (instancetype)initWithType:(WALMEAlbumListSelectionType)type;

/**
 获取系统所有相册
 
 @param albums 相册集合
 */
- (void)fetchAllAlbum:(void(^)(NSArray<HXAlbumModel *> *albums))albums IsShowSelectTag:(BOOL)isShow;
- (void)getAllPhotoAlbums:(void(^)(HXAlbumModel *firstAlbumModel))firstModel albums:(void(^)(NSArray<HXAlbumModel *> *albums))albums isFirst:(BOOL)isFirst;
/**
 根据PHFetchResult获取某个相册里面的所有图片和视频

 @param result PHFetchResult对象
 @param index 相册下标
 @param list 照片和视频的集合
 */
- (void)fetchAllPhotoForPHFetchResult:(PHFetchResult *)result Index:(NSInteger)index fetchResult:(void(^)(NSArray<HXPhotoModel *> *photos, NSArray<HXPhotoModel *> *videos, NSArray<HXPhotoModel *> *Objs))list;

- (void)getPhotoListWithAlbumModel:(HXAlbumModel *)albumModel complete:(void (^)(NSArray<HXPhotoModel *> *allList, NSArray<HXPhotoModel *> *previewList, NSArray<HXPhotoModel *> *photoList, NSArray<HXPhotoModel *> *videoList, HXPhotoModel *firstSelectModel))complete;

/**
 清空所有已选数组
 */
- (void)clearSelectedList;

/**
 生成Cell用于展示照片属性的Icon Image
 */
- (void)getCellIcons;


/**
 *  本地图片数组 <UIImage *> 装的是UIImage对象 - 已设置为选中状态
 */
@property (copy, nonatomic) NSArray *localImageList NS_UNAVAILABLE;

/**
 是否开启3DTouch预览功能 默认 YES
 */
@property (assign, nonatomic) BOOL open3DTouchPreview NS_UNAVAILABLE;

/**
 添加本地图片数组  内部会将  deleteTemporaryPhoto 设置为NO
 
 @param images <UIImage *> 装的是UIImage对象
 @param selected 是否选中  选中的话HXPhotoView自动添加显示 没选中可以在相册里手动选中
 */
- (void)addLocalImage:(NSArray *)images selected:(BOOL)selected NS_UNAVAILABLE;

/**
 将本地图片添加到相册中  内部会将  deleteTemporaryPhoto 设置为NO
 
 @param images <UIImage *> 装的是UIImage对象
 */
- (void)addLocalImageToAlbumWithImages:(NSArray *)images NS_UNAVAILABLE;


- (void)getImage NS_UNAVAILABLE;

/**
 将传入数组里的所有模型添加到已选数组中
 
 @param list 模型数组
 */
- (void)addSpecifiedArrayToSelectedArray:(NSArray *)list NS_UNAVAILABLE;

@end

typedef void(^WALMEAlbumUploadProgress)(float singleProgress, float totalProgress);
typedef void(^WALMEAlbumUploadResult)(int sendCount,
                                      int failCount,
                                      NSArray * sendResults,
                                      NSArray<HXPhotoModel *> * failModels,
                                      NSArray<UIImage *> * _Nullable successImages,
                                      NSArray<NSString *> * _Nullable photoPaths);

@interface WALMEAlbumListViewmodel (Bussiness)

@property (assign, nonatomic, readonly) BOOL singleSelected;
@property (nonatomic, copy, readonly) NSString * uploadType;
@property (nonatomic, assign, readonly) int quality;
@property (nonatomic, copy, readonly) NSString * videoQuality;
//@property (nonatomic, assign, readonly) int minTime;
//@property (nonatomic, assign, readonly) int maxTime;

@property (assign, nonatomic, readonly) NSInteger maxNum;
@property (assign, nonatomic, readonly) NSInteger maxPhotoNum;

@property (assign, nonatomic, readonly) NSInteger maxVideoNum;
@property (nonatomic, assign, readonly) NSInteger maxVideoDuration;
@property (nonatomic, assign, readonly) NSInteger minVideoDuration;

@property (nonatomic, assign, readonly) CGSize maxPhotoSize;
@property (nonatomic, assign, readonly) CGSize minPhotoSize;
@property (nonatomic, assign, readonly) int maxWidth;
@property (nonatomic, assign, readonly) int maxHeight;
@property (nonatomic, assign, readonly) int minHeight;
@property (nonatomic, assign, readonly) int minWidth;

//@property (nonatomic, assign, readonly) int maxNumer;
@property (nonatomic, assign, readonly) BOOL singleSelecteClip;

- (instancetype)initWithNSDictionary:(NSDictionary *)dictionary;

//传一张图
- (void)walme_uploadImage:(HXPhotoModel *)model
//                 progress:(WALMENetProgressBlock)progressBlock
                   result:(WALMEAliOSSImageResultBlock)resultBlock;

//传多张图 也可为视频
- (void)walme_uploadImages:(NSArray<HXPhotoModel *> *)models progress:(WALMEAlbumUploadProgress)progressBlock result:(WALMEAlbumUploadResult)resultBlock;

//传一个视频
- (void)walme_uploadVideo:(HXPhotoModel *)model
//                 progress:(WALMENetProgressBlock)progressBlock
                   result:(WALMEAliOSSImageResultBlock)resultBlock;

//传一个视频或一张图
- (void)walme_uploadUnKnown:(HXPhotoModel *)model
//                   progress:(WALMENetProgressBlock)progressBlock
                     result:(WALMEAliOSSImageResultBlock)msgBlock;

//传多个未知(可能是图和视频) 实际上是调用 uploadImages
- (void)walme_uploadUnKnowns:(NSArray<HXPhotoModel *> *)models
//                    progress:(WALMEAlbumUploadProgress)progressBlock
                      result:(WALMEAlbumUploadResult)resultBlock;

@end

NS_ASSUME_NONNULL_END
