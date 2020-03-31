//
//  WALMEImageClipViewController.h
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol WALMEImageClipDelegate <NSObject>

- (void)imageUploadFromClip:(UIImage *)originImage
                  clipImage:(UIImage *)clipImage
                 originPath:(NSString *)originPath
                   clipPath:(NSString *)clipPath
                 originName:(NSString *)originName
                   clipName:(NSString *)clipName
               originResult:(id)originResult
                 clipResult:(id)clipResult
                      error:(NSError *)error;

@optional
- (void)walme_clipCancle;

@end

@class WALMEImageClipViewmodel;

@interface WALMEImageClipViewController : UIViewController

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, weak) id<WALMEImageClipDelegate> delegate;
@property (nonatomic, strong) WALMEImageClipViewmodel * viewmodel;

@end

NS_ASSUME_NONNULL_END
