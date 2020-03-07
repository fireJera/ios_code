//
//  LETADClipImageViewController.h
//  LetDate
//
//  Created by Jeremy on 2019/1/21.
//  Copyright © 2019 JersiZhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LETADNewClipImageDelegate <NSObject>

- (void)imageUploadFromClip:(UIImage *)originImage
                  clipImage:(UIImage *)clipImage
                    success:(BOOL)isSuccess
                     result:(id)result
                 originPath:(NSString *)originPath
                   clipPath:(NSString *)clipPath;

@end

//@class LETADClipImageViewmodel;

NS_ASSUME_NONNULL_BEGIN

@interface LETADClipImageViewController : UIViewController

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, weak) id<LETADNewClipImageDelegate> delegate;
//@property (nonatomic, strong) LETADClipImageViewmodel * viewmodel;

@end

NS_ASSUME_NONNULL_END
