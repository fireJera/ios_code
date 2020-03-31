//
//  WALMENavigationController.m
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import "WALMENavigationController.h"
#import "WALMEControllerHeader.h"

@interface WALMENavigationController ()

@end

@implementation WALMENavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.shadowImage = [UIImage new];
    self.navBarTintColor = [UIColor whiteColor];
    self.navBarTitleColor = [UIColor walme_colorWithRGB:0x212121];
    self.navBarBgAlpha = 1;
}

@end

