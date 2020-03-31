//
//  WALMEViewHelper.h
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class WALMEImageTextField;

NS_ASSUME_NONNULL_BEGIN

@interface WALMEViewHelper : NSObject

+ (UIButton *)walme_buttonWithFrame:(CGRect)frame
                            bgImage:(nullable NSString *)bgImageName
                              image:(nullable NSString *)imageName
                              title:(nullable NSString *)title
                          textColor:(nullable UIColor *)color
                             method:(nullable SEL)method
                             target:(nullable id)target;

+ (UILabel *)walme_labelWithFrame:(CGRect)frame
                            title:(nullable NSString *)title
                         fontSize:(int)font
                        textColor:(nullable UIColor *)textColor;

+ (UILabel *)walme_labelWithFrame:(CGRect)frame
                            title:(nullable NSString *)title
                             font:(UIFont *)font
                        textColor:(nullable UIColor *)textColor;

//+ (UILabel *)titleLabel:(NSString *)title;

//+ (UITableView *)tableViewWithFrame:(CGRect)frame
//                       deleagte:(nullable id)delegate
//                     dateSource:(nullable id)dataSource
//                          style:(UITableViewStyle)style;
//
//+ (UITextField *)textFieldWithFrame:(CGRect)frame
//                       delegate:(nullable id)delegate
//                    palceHolder:(nullable NSString *)placeHolder;

+ (UIImageView *)imageViewWithFrame:(CGRect)frame
                          imageName:(nullable NSString *)imageName;
//
+ (UIImageView *)imageViewWithFrame:(CGRect)frame
                              image:(nullable UIImage *)image;

//+ (UIScrollView *)scrollViewWithFrame:(CGRect)frame
//                          delegate:(nullable id)delegate;

//+ (CAShapeLayer *)shadowLayer;
//
//+ (void)addShadowTo:(CALayer *)layer;
+ (void)addShadowTo:(CALayer *)layer
            opacity:(float)opacity
             offset:(CGSize)offset
             radius:(int)radius
              color:(UIColor *)color;

@end


NS_ASSUME_NONNULL_END
