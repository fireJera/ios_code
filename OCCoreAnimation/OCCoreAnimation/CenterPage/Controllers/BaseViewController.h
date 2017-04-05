//
//  BaseViewController.h
//  OCCoreAnimation
//
//  Created by Jeremy on 4/5/17.
//  Copyright © 2017 Jeremy. All rights reserved.
//

#import "ViewController.h"

@interface BaseViewController : ViewController

-(NSString *)controllerTitle;
-(void)initView;
-(NSArray *)operateTitleArray;
-(void)clickBtn:(UIButton *)btn;
@end
