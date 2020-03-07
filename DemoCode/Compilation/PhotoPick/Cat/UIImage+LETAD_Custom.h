//
//  UIImage+LETAD_Custom.h
//  LetDate
//
//  Created by Jeremy on 2019/1/21.
//  Copyright © 2019 JersiZhu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (letad_Color)

+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageWithColor:(UIColor*)color size:(CGSize)size;

@end

@interface UIImage (LETAD_Custom)

+ (UIImage *)imageInLocalVideoPath:(NSString *)videoPath;
+ (UIImage *)imageInVideoUrl:(NSURL *)videoUrl;
- (UIImage *)addCornerRadius:(CGFloat)cornerRadius;
- (UIImage *)rotate:(UIImageOrientation)orient;

/**
 *  修改图片size
 *
 *  @param image      原图片
 *  @param targetSize 要修改的size
 *
 *  @return 修改后的图片
 */

+ (UIImage *)image:(UIImage *)image byScalingToSize:(CGSize)targetSize;
- (UIImage *)imageScaleToSize:(CGSize)targetSize;
- (UIImage *)scaleImage:(float)scale;

@end

@interface UIImage (letad_Base64)

- (NSString *)imageBase64String;

@end

NS_ASSUME_NONNULL_END
