//
//  ServiceViewController.h
//  Socket
//
//  Created by Jeremy on 2020/3/24.
//  Copyright © 2020 Jeremy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ServiceViewController : UIViewController

@property (nonatomic, strong) UITextField *textF; //消息输入框
@property (nonatomic, strong) UILabel *receLa;//消息展示
@property (nonatomic, strong) UILabel *listlabl;//客户端IP地址显示
@property (nonatomic, strong) UITextField *clientTf;//指定第几个连接的客户端

@end

NS_ASSUME_NONNULL_END
