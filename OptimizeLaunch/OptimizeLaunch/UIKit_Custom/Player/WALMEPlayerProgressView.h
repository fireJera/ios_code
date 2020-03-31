//
//  WALMEPlayerProgressView.h
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WALMEPlayerProgressView : UIView

/**
 进度值 0-1
 */
@property (nonatomic, assign) float progressValue;

/**
 进度条的颜色
 */
@property (nonatomic, strong) UIColor * progressColor;

/**
 进度条的背景色
 */
@property (nonatomic, strong) UIColor * bottomColor;
@end
NS_ASSUME_NONNULL_END
