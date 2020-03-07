//
//  PhotoResultModel.h
//  PhotoPick
//
//  Created by Jeremy on 2019/3/21.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

typedef NS_ENUM(NSUInteger, PhotoResultModelMediaType) {
    PhotoResultModelMediaTypePhoto = 0,   // 照片
    PhotoResultModelMediaTypeVideo        // 视频
};

NS_ASSUME_NONNULL_BEGIN

@interface PhotoResultModel : NSObject

/**  标记  */
@property (assign, nonatomic) NSInteger index;
@property (assign, nonatomic) NSInteger photoIndex;
@property (assign, nonatomic) NSInteger videoIndex;

/**  资源类型  */
@property (assign, nonatomic) PhotoResultModelMediaType mediaType;

/**  原图URL  */
@property (strong, nonatomic) NSURL *fullSizeImageURL;

/**  原尺寸image 如果资源为视频时此字段为视频封面图片  */
@property (strong, nonatomic) UIImage *displaySizeImage;

/**  原图方向  */
@property (assign, nonatomic) int fullSizeImageOrientation;

/**  视频Asset  */
@property (strong, nonatomic) AVAsset *avAsset;

/**  视频URL  */
@property (strong, nonatomic) NSURL *videoURL;

/**  创建日期  */
@property (strong, nonatomic) NSDate *creationDate;

/**  位置信息  */
@property (strong, nonatomic) CLLocation *location;


@end

NS_ASSUME_NONNULL_END
