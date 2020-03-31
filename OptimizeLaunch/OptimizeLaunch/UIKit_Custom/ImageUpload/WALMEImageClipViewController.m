//
//  WALMEImageClipViewController.m
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import "WALMEImageClipViewController.h"
#import "WALMEPhotoEditView.h"
#import "WALMEViewmodelHeader.h"
#import "WALMEImageClipViewmodel.h"
#import "WALMEControllerHeader.h"
#import "WALMEOpenPageHelper.h"
#import <UIKit/UIKit.h>

@interface WALMEImageClipViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) WALMEPhotoEditView *editView;
@property (assign, nonatomic) CGFloat minimumZoomScale;

@property (nonatomic, strong) UIButton *rotateButton;
@property (nonatomic, strong) UIButton *cropButton;
@property (nonatomic, strong) UIButton *backButton;

@end


@implementation WALMEImageClipViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self p_walme_create];
    [self p_walme_createButton];
}

- (void)p_walme_createButton {
    CGFloat width = 0 - 20;
    CGFloat y = (self.view.height + width) / 2 + 50;
    const CGFloat btnWidth = 48;
    const CGFloat btnLeft = 40;
    self.backButton = ({
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(btnLeft, y, btnWidth, btnWidth);
        [button setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(p_walme_back:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        button;
    });
    
    self.rotateButton = ({
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, y, btnWidth, btnWidth);
        button.centerX = self.view.width / 2;
        [button setImage:[UIImage imageNamed:@"icon_rotation"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(p_walme_rotate:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        button;
    });
    
    self.cropButton = ({
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        button.frame = CGRectMake(self.view.width - btnWidth - btnLeft, y, btnWidth, btnWidth);
        [button setImage:[UIImage imageNamed:@"icon_finish"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(p_walme_crop:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        button;
    });
}

- (void)p_walme_create {
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    _scrollView.bouncesZoom = YES;
    _scrollView.multipleTouchEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.scrollsToTop = NO;
    _scrollView.bounces = YES;
    
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _scrollView.delaysContentTouches = NO;
    _scrollView.canCancelContentTouches = YES;
    _scrollView.alwaysBounceVertical = NO;
    
    _editView = [[WALMEPhotoEditView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_scrollView];
    [self.view addSubview:_editView];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    tap2.numberOfTapsRequired = 2;
    [_scrollView addGestureRecognizer:tap2];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = _image;
    [_scrollView addSubview:imageView];
    self.imageView = imageView;
    
    [self p_walme_setupModel];
}

- (void)p_walme_setupModel {
    if (!_image) {
        return;
    }
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    CGFloat imgWidth = _imageView.image.size.width;
    CGFloat imgHeight = _imageView.image.size.height;
    
    CGFloat w;
    CGFloat h;
    
    imgHeight = width / imgWidth * imgHeight;
    if (imgHeight > imgWidth) {
        //长图
        w = height / _imageView.image.size.height * imgWidth;
        h = height;
        _scrollView.maximumZoomScale = width / w + 0.5;
    } else {
        w = width;
        h = imgHeight;
        _scrollView.maximumZoomScale = 2.5;
    }
    
    CGFloat diameter = width - 20;
    CGFloat multiple = 1.05f;
    if (h < w) {
        if (w > diameter) {
            if (h < diameter) {
                multiple = diameter / h + 0.1;
            }
        } else {
            multiple = diameter / h + 0.1;
        }
    } else {
        if (h < diameter) {
            multiple = diameter / w + 0.1;
        } else {
            if (w < diameter) {
                multiple = diameter / w + 0.1;
            }
        }
    }
    _scrollView.frame = self.view.bounds;
    _scrollView.layer.masksToBounds = NO;
    _scrollView.contentSize = CGSizeMake(width, h);
    if (h < w) {
        _scrollView.contentInset = UIEdgeInsetsMake(height / 2 - (diameter / 2), 10, height / 2 - (diameter / 2), 10);
    } else {
        _scrollView.contentInset = UIEdgeInsetsMake(height / 2 - (diameter / 2), 10, height / 2 - (diameter / 2), 10);
    }
    
    self.imageView.frame = CGRectMake(0, 0, w, h);
    _scrollView.minimumZoomScale = 0.8;
    self.minimumZoomScale = multiple;
    _scrollView.maximumZoomScale = 2.0;
    [_scrollView setZoomScale:1 animated:NO];
}

#pragma mark button click
- (void)p_walme_rotate:(UIButton *)sender {
    _scrollView.transform = CGAffineTransformRotate(_scrollView.transform, -M_PI_2);
}

- (void)p_walme_crop:(UIButton *)sender {
    sender.enabled = NO;
    [self p_walme_clipImage];
}

- (void)p_walme_back:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(walme_clipCancle)]) {
        [_delegate walme_clipCancle];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - < UIScrollViewDelegate >
- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView;
}

#pragma mark - < 点击事件 >
- (void)dismissClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)doubleTap:(UITapGestureRecognizer *)tap {
    CGFloat width = self.scrollView.frame.size.width;
    CGFloat height = self.scrollView.frame.size.height;
    if (_scrollView.zoomScale > self.minimumZoomScale) {
        [_scrollView setZoomScale:self.minimumZoomScale animated:YES];
    } else {
        CGPoint touchPoint = [tap locationInView:self.imageView];
        CGFloat newZoomScale = _scrollView.maximumZoomScale;
        CGFloat xsize = width / newZoomScale;
        CGFloat ysize = height / newZoomScale;
        [self.scrollView zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
    }
}

- (void)p_walme_clipImage {
    NSString *cameraIdentifier = @"";
    NSDate *nowDate = [NSDate date];
    NSString *dateStr = [NSString stringWithFormat:@"%ld", (long)[nowDate timeIntervalSince1970]];
    NSString *numStr = [NSString stringWithFormat:@"%d",arc4random()%10000];
    cameraIdentifier = [cameraIdentifier stringByAppendingString:dateStr];
    cameraIdentifier = [cameraIdentifier stringByAppendingString:numStr];
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    CGFloat diameter = width - 20;
    CGRect frame = [self.view convertRect:CGRectMake(10, (height / 2 - diameter / 2), diameter, diameter) toView:_imageView];
    UIImage *image = [self imageFromView:_imageView atFrame:frame];
//    MBProgressHUD * hud = [self.view customProgressHUDTitle:nil];
    
    if (_viewmodel.faceDetect) {
        __weak typeof(self) weakSelf = self;
//        [_viewmodel walme_detectFace:image result:^(BOOL isSuccess, id result) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                weakSelf.cropButton.enabled = YES;
//            });
//            if (isSuccess) {
//                NSString * str;
//                if ([result isKindOfClass:[NSString class]]) {
//                    str = (NSString *)result;
//                }
//                NSDictionary * resultDic = [str convertToObject];
//                NSArray * array = resultDic[@"face"];
//                
//                if (array.count <= _viewmodel.maxFace && array.count > 0) {
//                    NSString * str = result;
//                    [weakSelf p_walme_commitAvatar:image parameter:str hud:hud];
//                }
//                else {
//                    NSString * str = _viewmodel.maxFace == 1 ? [NSString stringWithFormat:@"请上传小于%d人的照片", (int)(_viewmodel.maxFace + 1)] : @"未检测到人脸";
//                    dispatch_async(dispatch_get_main_queue(), ^{
////                        [hud hideAnimated:YES];
//                        [WALMEOpenPageHelper walme_showCustomAlertWithTitle:str block:^(WALMEOpenAlert * _Nonnull alert) {
//                            alert.title(@"重新选择").destructiveStyle().actionHandler = ^(UIAlertAction * _Nonnull action) {
//                                if (weakSelf.navigationController) {
//                                    [weakSelf.navigationController popViewControllerAnimated:YES];
//                                } else {
//                                    [weakSelf dismissViewControllerAnimated:YES completion:nil];
//                                }
//                                
//                            };
//                        }];
//                    });
//                }
//                
//            } else {
//                dispatch_async(dispatch_get_main_queue(), ^{
////                    [hud hideAnimated:YES];
//                    NSString * str;
//                    if ([result isKindOfClass:[NSString class]]) {
//                        str = result;
//                    } else {
////                        str = WALMENetWorkErrorNoteString;
//                    }
////                    [weakSelf.view showTextHUD:str];
//                });
//            }
//        }];
    } else {
//        [self p_walme_commitAvatar:image parameter:nil hud:hud];
    }
}

//获得某个范围内的屏幕图像
- (UIImage *)imageFromView:(UIView *)theView atFrame:(CGRect)r {
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    //    UIRectClip(r);
    [theView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    CGImageRef imagRef = CGImageCreateWithImageInRect([theImage CGImage], r);
    UIImage* newImage = [UIImage imageWithCGImage: imagRef];
    CGImageRelease(imagRef);
    UIGraphicsEndImageContext();
    return newImage;//[self clipImage:theImage];
}

- (void)p_walme_commitAvatar:(UIImage *)image parameter:(NSString *)str hud:(MBProgressHUD *)hud {
    dispatch_async(dispatch_get_main_queue(), ^{
//        [hud hideAnimated:YES];
    });
    __weak typeof(self) weakSelf = self;
    __block int count = 0;
    __block NSString * originPath;
    __block NSString * clipPath;
    __block NSString * clipName;
    __block NSString * originName;
    __block id originResult;
    __block id clipResult;
    NSDictionary * dic;
    if (str) {
        dic = @{@"x:youtuRes": [str base64String]};
    }
    [_viewmodel walme_uploadImage:_image clipImage:image dic:dic result:^(NSError * _Nonnull error, id  _Nonnull result, BOOL isOrigin) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        weakSelf.cropButton.enabled = YES;
//        [hud hideAnimated:YES];
        if (!error) {
            count++;
            if (!result[@"youtuRes"]) {
                NSMutableDictionary * mDic = [result mutableCopy];
                if (str) {
                    NSDictionary *obj = [str convertToObject];
                    if (obj) {
                        [mDic setObject:obj forKey:@"youtuRes"];
                    }
                    result = [mDic copy];
                }
            }
            if (isOrigin) {
                originName = result[@"objectKey"];
                originPath = result[@"aliOSS"][@"data"][@"photo_url"];
                originResult = result;
            } else {
                clipName = result[@"objectKey"];
                clipPath = result[@"aliOSS"][@"data"][@"photo_url"];
                clipResult = result;
            }
            if (count == 2) {
                if (!weakSelf.navigationController) {
                    [weakSelf dismissViewControllerAnimated:NO completion:nil];
                }
                if ([strongSelf.delegate respondsToSelector:@selector(imageUploadFromClip:clipImage:originPath:clipPath:originName:clipName:originResult:clipResult:error:)]) {
                    [strongSelf.delegate imageUploadFromClip:weakSelf.image clipImage:image originPath:originPath clipPath:clipPath originName:originName clipName:clipName originResult:originResult clipResult:clipResult error:error];
                }
            }
        } else {
//            [weakSelf.view showTextHUD:error.description];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
