//
//  UIButton+WALME_Custom.h
//  CodeFrame
//
//  Created by Jeremy on 2019/4/24.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    WALMEButtonImagePositionDefault,
    WALMEButtonImagePositionLeft,
    WALMEButtonImagePositionTop,
    WALMEButtonImagePositionBottom,
    WALMEButtonImagePositionRight,
} WALMEButtonImagePosition;

@interface UIButton (WALME_Custom)

- (void)imagePosition:(WALMEButtonImagePosition)position withSpacing:(CGFloat)spacing;

@end

NS_ASSUME_NONNULL_END
