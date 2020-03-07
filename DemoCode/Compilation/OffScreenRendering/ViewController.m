//
//  ViewController.m
//  OffScreenRendering
//
//  Created by super on 2019/1/9.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *button = ({
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(100, 10, 100, 100);
//        btn.backgroundColor = [UIColor blackColor];
        btn.layer.cornerRadius = 50;
        [btn setImage:[UIImage imageNamed:@"sao.jpg"] forState:UIControlStateNormal];
//        btn.layer.masksToBounds = YES;
        [self.view addSubview:btn];
        btn.clipsToBounds = YES;
        btn;
    });
    
    UIButton *button1 = ({
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(100, 150, 100, 100);
        btn.backgroundColor = [UIColor blackColor];
        btn.layer.cornerRadius = 50;
        btn.layer.masksToBounds = YES;
        [self.view addSubview:btn];
        btn.clipsToBounds = YES;
        btn;
    });
    
    UIImageView * imageView = ({
       UIImageView * imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(100, 260, 100, 100);
        imageView.backgroundColor = [UIColor blackColor];
        imageView.layer.cornerRadius = 50;
        imageView.layer.masksToBounds = YES;
        imageView.image = [UIImage imageNamed:@"sao.jpg"];
        [self.view addSubview:imageView];
        imageView;
    });
    
    UIImageView * imageView1 = ({
        UIImageView * imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(100, 400, 100, 100);
//        imageView.backgroundColor = [UIColor blackColor];
        imageView.layer.cornerRadius = 50;
//        imageView.layer.masksToBounds = YES;
        [self.view addSubview:imageView];
        imageView.image = [UIImage imageNamed:@"sao.jpg"];
        imageView;
    });
    
    UIImageView * imageView2 = ({
        UIImageView * imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(100, 550, 100, 100);
//        imageView.backgroundColor = [UIColor blackColor];
        imageView.layer.cornerRadius = 50;
        imageView.layer.masksToBounds = YES;
        imageView.image = [UIImage imageNamed:@"sao.jpg"];
        [self.view addSubview:imageView];
        imageView;
    });
}


@end
