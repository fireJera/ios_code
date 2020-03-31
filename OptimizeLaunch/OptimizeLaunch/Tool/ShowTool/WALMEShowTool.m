//
//  WALMEShowTool.m
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import "WALMEShowTool.h"

//#import "MBProgressHUD.h"
//#define kAnimationDuration        (2)
//#define kMessageLoadingColor      kColorWithRGB(0xFFFFFF)
//#define kMessageLoadingBackColor  kColorWithRGBAlpah(0x060C21, 0.5)
//#define kViewLoadingTextColor     kColorWithRGB(0x8C93AD)

@interface WALMEShowTool ()

//@property (nonatomic, assign) LCLoadingStyle loadingStyle;

@end

@implementation WALMEShowTool
//
//- (void)dealloc{
//
//}
//
//+ (void)showAlertTitle:(NSString *)title message:(NSString *)message toView:(UIView *)view {
//    if (view == nil) {
//        view = LCINSTANCE_KEYWINDOW;
//    }
//
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
//    hud.userInteractionEnabled = NO;
//    // Set the text mode to show only text.
//    hud.mode = MBProgressHUDModeCustomView;
//    hud.label.text = title;
//    hud.label.numberOfLines = 0;
//    hud.label.textColor = kMessageLoadingColor;
//    hud.detailsLabel.text = message;
//    hud.detailsLabel.textColor = kMessageLoadingColor;
//    hud.bezelView.color = kMessageLoadingBackColor;
//
//    [hud hideAnimated:YES afterDelay:kAnimationDuration];
//}
//
//+ (void)showSmallAlertTitle:(NSString *)title message:(NSString *)message toView:(UIView *)view {
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
//    hud.userInteractionEnabled = NO;
//    // Set the text mode to show only text.
//    hud.mode = MBProgressHUDModeText;
//    hud.backgroundView.backgroundColor = [UIColor clearColor];
//    hud.margin = 6;
//
//    hud.detailsLabel.text = title;
//    hud.detailsLabel.textColor = kMessageLoadingColor;
//    hud.bezelView.color = kMessageLoadingBackColor;
//    [hud hideAnimated:YES afterDelay:kAnimationDuration];
//}
//
//+ (void)showSmallAlertTitle:(NSString *)title message:(NSString *)message toView:(UIView *)view afterDelay:(NSTimeInterval)delay {
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
//    hud.userInteractionEnabled = NO;
//    // Set the text mode to show only text.
//    hud.mode = MBProgressHUDModeText;
//    hud.backgroundView.backgroundColor = [UIColor clearColor];
//    hud.margin = 6;
//    hud.offset = CGPointMake(0.f, 30);
//    hud.detailsLabel.text = title;
//    hud.detailsLabel.textColor = kMessageLoadingColor;
//    hud.bezelView.color = kMessageLoadingBackColor;
//    [hud hideAnimated:YES afterDelay:delay];
//}
//
//
//+ (void)showAlertTitle:(NSString *)title message:(NSString *)message OffsetDistance:(CGFloat)OffsetDistance {
//
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:LCINSTANCE_KEYWINDOW animated:YES];
//    hud.userInteractionEnabled = NO;
//    // Set the text mode to show only text.
//    hud.label.numberOfLines = 0;
//    hud.mode = MBProgressHUDModeText;
//    hud.label.text = title;
//    hud.label.textColor = kMessageLoadingColor;
//    hud.detailsLabel.text = message;
//    hud.detailsLabel.textColor = kMessageLoadingColor;
//    hud.bezelView.color = kMessageLoadingBackColor;
//    hud.bezelView.height = 30;
//    hud.offset = CGPointMake(0.f, OffsetDistance);
//
//    [hud hideAnimated:YES afterDelay:kAnimationDuration];
//}
//
//+ (void)showWhiteAlertTitle:(NSString *)title message:(NSString *)message imageName:(NSString *)imageName toView:(UIView *)view {
//    if (view == nil) {
//        view = LCINSTANCE_KEYWINDOW;
//    }
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
//    hud.userInteractionEnabled = NO;
//    hud.mode = MBProgressHUDModeCustomView;
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
//    hud.customView = imageView;
//    hud.backgroundView.backgroundColor = [UIColor clearColor];
//    hud.square = YES;
//    hud.minSize = CGSizeMake(120, 120);
//    hud.label.text = title;
//    hud.label.font = kFontFromPx(24);
//    hud.label.textColor = kViewLoadingTextColor;
//    hud.detailsLabel.text = message;
//    hud.detailsLabel.textColor = kViewLoadingTextColor;
//    hud.bezelView.color = kColorWithRGBAlpah(0xFFFFFF, 0.75);
//    [hud hideAnimated:YES afterDelay:kAnimationDuration];
//}
//
//#pragma mark - setter
//- (void)setLoadingStyle:(LCLoadingStyle)loadingStyle{
//    _loadingStyle = loadingStyle;
//}
//
//#pragma mark - class func
//+ (MBProgressHUD *)showLoadingInView:(UIView *)view style:(LCLoadingStyle )style {
//    if (view == nil) {
//        view = LCINSTANCE_KEYWINDOW;
//    }
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
//    switch (style) {
//        case LCLoadingStyle_Operational:
//            hud.userInteractionEnabled = NO;
//            break;
//
//        default:
//            break;
//    }
//
//    hud.square = NO;
//    hud.mode = MBProgressHUDModeIndeterminate;
//    hud.bezelView.color = [UIColor clearColor];
//    hud.bezelView.height = 30;
//    //    hud.customView = loadingImageView;
//    // 隐藏时候从父控件中移除
//    hud.removeFromSuperViewOnHide = YES;
//    // YES代表需要蒙版效果
//    //    hud.dimBackground = NO;
//    hud.backgroundColor = [UIColor colorWithWhite:0 alpha:0.05f];
//    return hud;
//}
//
//+ (void)hideLoadingInView:(UIView *)view {
//    if (view == nil) view = LCINSTANCE_KEYWINDOW;
//    [MBProgressHUD hideHUDForView:view animated:YES];
//}

@end

