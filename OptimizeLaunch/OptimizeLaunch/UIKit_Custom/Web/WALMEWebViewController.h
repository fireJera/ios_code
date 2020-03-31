//
//  WALMEWebViewController.h
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WALMEWebViewController : UIViewController

@property (nonatomic, copy) NSString * urlString;                   //高优先级
@property (nonatomic, copy) NSURL * url;                            //低优先级
@property (nonatomic, copy) NSDictionary * funcData;

@property (nonatomic, strong) UIColor * navColor;

- (void)handleMessage;

@end

NS_ASSUME_NONNULL_END
