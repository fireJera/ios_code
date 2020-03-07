//
//  ViewController.h
//  GPUImage
//
//  Created by Jeremy on 2019/3/9.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController


@end

typedef void(^LETADExecuteDisplayLinkBlock) (CADisplayLink *displayLink);

@interface CADisplayLink (letad_Block)
+ (CADisplayLink *)displayLinkWithExecuteBlock:(LETADExecuteDisplayLinkBlock)block;
@end


@interface UIView (LETAD_Frame)

//这些不是真正的属性哦，不要误会
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat right;
@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat bottom;

@end
