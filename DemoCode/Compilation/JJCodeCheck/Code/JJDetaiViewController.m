//
//  JJDetaiViewController.m
//  JJCodeCheck
//
//  Created by Jeremy on 2019/7/10.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import "JJDetaiViewController.h"
#import "JJIvar.h"
#import "JJProperty.h"
#import "JJMethod.h"
#import "JJIvarDetailViewController.h"
#import "JJMethodDetailViewController.h"

@interface JJDetaiViewController () 

@end

@implementation JJDetaiViewController

+ (instancetype)detailWithIvar:(JJIvar *)ivar {
    return [[JJIvarDetailViewController alloc] initWithIvar:ivar];
}

+ (instancetype)detailWithProperty:(JJProperty *)property {
    return [[JJIvarDetailViewController alloc] initWithProperty:property];
}

+ (instancetype)detailWithMethod:(JJMethod *)method {
    return [[JJMethodDetailViewController alloc] initWithMethod:method];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

@end
