//
//  UIDevice+WALME_Custom.h
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (WALME_Custom)

@property (nonatomic, assign, readonly) BOOL isPad;

- (BOOL)isPad;
@end

NS_ASSUME_NONNULL_END
