//
//  WALMELabelComponent.h
//  CodeFrame
//
//  Created by Jeremy on 2019/5/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, WALMELabelComponentType) {
    WALMELabelComponentTypeText,
    WALMELabelComponentTypeImage,
};

@interface WALMELabelComponent : NSObject

@property (nonatomic, copy) NSString * content;

/**
 文字颜色 default white
 */
@property (nonatomic, strong) UIColor * color;

@property (nonatomic, strong) UIFont * font;

@property (nonatomic, copy) NSDictionary * textAttributes;

/**
 点击时 返回
 */
@property (nonatomic, copy) NSString * identifier;

/**
 text image
 */
@property (nonatomic, assign) WALMELabelComponentType type;

@end

NS_ASSUME_NONNULL_END
