//
//  WALMEFrameParseConfig.h
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WALMEFrameParseConfig : NSObject

@property (nonatomic, assign) CGFloat width;

@property (nonatomic, assign) CGFloat leftInterval;
@property (nonatomic, assign) CGFloat topInterval;

@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, assign) UIFont * font;
@property (nonatomic, assign) CGFloat lineSpace;
@property (nonatomic, strong) UIColor * textColor;

@end

NS_ASSUME_NONNULL_END
