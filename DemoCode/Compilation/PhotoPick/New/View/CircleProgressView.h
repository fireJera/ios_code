//
//  CircleProgressView.h
//  PhotoPick
//
//  Created by Jeremy on 2019/3/23.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CircleProgressView : UIView

@property (nonatomic, assign) CGFloat progress;

- (void)showError;

@end

NS_ASSUME_NONNULL_END
