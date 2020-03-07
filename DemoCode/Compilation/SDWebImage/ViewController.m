//
//  ViewController.m
//  SDWebImage
//
//  Created by super on 2018/12/27.
//  Copyright © 2018 Jeremy. All rights reserved.
//

#import "ViewController.h"
#import "SDWebImage/SDWebImagePrefetcher.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString * str = @"http://n.sinaimg.cn/news/1_img/upload/cf3881ab/533/w800h533/20181225/unpI-hqtwzec2426104.jpg";
    NSArray * array = @[str, str, str, str, str, str, str];
    [[SDWebImagePrefetcher sharedImagePrefetcher] prefetchURLs:array];
    // Do any additional setup after loading the view, typically from a nib.
}


@end
