
//
//  LETADClipImageViewController.m
//  LetDate
//
//  Created by Jeremy on 2019/1/21.
//  Copyright © 2019 JersiZhu. All rights reserved.
//

#import "LETADClipImageViewController.h"
#import "LETADPhotoEditView.h"
//#import "LETADMHeader.h"
//#import "LETADClipImageViewmodel.h"
//#import "LETADCHeader.h"
#import "UIView+LETAD_Frame.h"
#import "UIImage+LETAD_Custom.h"
#import "UIColor+LETAD_Hex.h"

@interface LETADClipImageViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) LETADPhotoEditView *editView;
@property (assign, nonatomic) CGFloat minimumZoomScale;

@property (nonatomic, strong) UIButton *rotateButton;
@property (nonatomic, strong) UIButton *cropButton;
@property (nonatomic, strong) UIButton *backButton;

@end

#define LETADSCREENWIDTH     ([UIScreen mainScreen].bounds.size.width)
@implementation LETADClipImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self p_letad_create];
    [self p_letad_createButton];
}

- (void)p_letad_createButton {
    CGFloat width = LETADSCREENWIDTH - 20;
    CGFloat y = (self.view.height + width) / 2 + 50;
    
    self.backButton = ({
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(30, y, 80, 80);
        [button setImage:[UIImage imageNamed:@"letad_aremac_4"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(p_letad_back:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        button;
    });
    
    self.rotateButton = ({
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, y, 80, 80);
        button.centerX = self.view.width / 2;
        [button setImage:[UIImage imageNamed:@"letad_aremac_8"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(p_letad_rotate:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        button;
    });
    
    self.cropButton = ({
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        button.frame = CGRectMake(self.view.width - 80 - 30, y, 80, 80);
        [button setImage:[UIImage imageNamed:@"letad_aremac_6"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(p_letad_crop:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        button;
    });
}

- (void)p_letad_create {
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
    
    _editView = [[LETADPhotoEditView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_scrollView];
    [self.view addSubview:_editView];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    tap2.numberOfTapsRequired = 2;
    [_scrollView addGestureRecognizer:tap2];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = _image;
    [_scrollView addSubview:imageView];
    self.imageView = imageView;
    
    [self p_letad_setupModel];
}


- (void)p_letad_setupModel {
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
- (void)p_letad_rotate:(UIButton *)sender {
    _scrollView.transform = CGAffineTransformRotate(_scrollView.transform, -M_PI_2);
}

- (void)p_letad_crop:(UIButton *)sender {
    sender.enabled = NO;
    [self p_letad_clipImage];
}

- (void)p_letad_back:(UIButton *)sender {
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

- (void)p_letad_clipImage {
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
//    MBProgressHUD * hud = [self customProgressHUDTitle:nil];
//
//    if (_viewmodel.faceDetect) {
//        __weak typeof(self) weakSelf = self;
//        [_viewmodel letad_detectFace:image result:^(BOOL isSuccess, id result) {
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
//                    [weakSelf p_letad_commitAvatar:image parameter:str hud:hud];
//                }
//                else {
//                    NSString * str = _viewmodel.maxFace == 1 ? [NSString stringWithFormat:@"请上传小于%lu人的照片", _viewmodel.maxFace + 1] : @"未检测到人脸";
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [hud hideAnimated:YES];
//                        [weakSelf showAlert:str button:@"重新选择" handler:^{
//                            if (weakSelf.navigationController) {
//                                [weakSelf.navigationController popViewControllerAnimated:YES];
//                            } else {
//                                [weakSelf dismissViewControllerAnimated:YES completion:nil];
//                            }
//                        }];
//                    });
//                }
//
//            } else {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [hud hideAnimated:YES];
//                    NSString * str;
//                    if ([result isKindOfClass:[NSString class]]) {
//                        str = result;
//                    } else {
//                        str = LETADNetWorkErrorNoteString;
//                    }
//                    [weakSelf showTextHUD:str toView:weakSelf.view];
//                });
//            }
//        }];
//    } else {
//        [self p_letad_commitAvatar:image parameter:nil hud:hud];
//    }
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

//- (void)p_letad_commitAvatar:(UIImage *)image parameter:(NSString *)str hud:(MBProgressHUD *)hud {
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [hud hideAnimated:YES];
//    });
//    __weak typeof(self) weakSelf = self;
//    __block int count = 0;
//    __block NSString * originPath;
//    __block NSString * clipPath;
//    NSDictionary * dic;
//    if (str) {
//        dic = @{@"x:youtuRes": [str base64String]};
//    }
//    [_viewmodel letad_uploadImage:_image clipImage:image dic:dic progress:^(float progressValue) {
//        //        dispatch_async(dispatch_get_main_queue(), ^{
//        //
//        //        });
//    } result:^(BOOL isSuccess, id result, NSString *msg, BOOL isOrigin) {
//        __strong typeof(weakSelf) strongSelf = weakSelf;
//        dispatch_async(dispatch_get_main_queue(), ^{
//            weakSelf.cropButton.enabled = YES;
//            [hud hideAnimated:YES];
//        });
//        if (isSuccess) {
//            count++;
//            if (isOrigin) {
//                originPath = result[@"objectKey"];
//            } else {
//                clipPath = result[@"objectKey"];
//            }
//            if (count == 2) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    if (weakSelf.navigationController) {
//                        [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
//                    } else {
//                        [weakSelf dismissViewControllerAnimated:NO completion:nil];
//                        [weakSelf.presentingViewController dismissViewControllerAnimated:NO completion:nil];
//                    }
//                });
//                if ([strongSelf.delegate respondsToSelector:@selector(imageUploadFromClip:clipImage:success:result:originPath:clipPath:)]) {
//                    [strongSelf.delegate imageUploadFromClip:weakSelf.image
//                                                   clipImage:image
//                                                     success:YES
//                                                      result:result
//                                                  originPath:originPath
//                                                    clipPath:clipPath];
//                }
//            }
//        } else {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if (msg.length > 0) {
//                    [weakSelf showTextHUD:msg toView:weakSelf.view];
//                } else {
//                    [weakSelf showTextHUD:LETADNetWorkErrorNoteString toView:weakSelf.view];
//                }
//            });
//        }
//    }];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
