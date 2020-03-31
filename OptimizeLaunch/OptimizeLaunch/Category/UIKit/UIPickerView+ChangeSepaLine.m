//
//  UIPickerView+ChangeSepaLine.m
//  CodeFrame
//
//  Created by hd on 2019/4/13.
//  Copyright © 2019年 JersiZhu. All rights reserved.
//

#import "UIPickerView+ChangeSepaLine.h"

@implementation UIPickerView (ChangeSepaLine)

@dynamic seperatorLineColor;

//- (void)didAddSubview:(UIView *)subView {
//    [super didAddSubview:subView];
//    if (CGRectGetHeight(subView.bounds) < 1) {
//        subView.backgroundColor =  [UIColor colorWithRed:116/255.0 green:169/255.0 blue:203/255.0 alpha:1/1.0];
//    }
//}

- (void)setSeperatorLineColor:(UIColor *)seperatorLineColor {
    for(UIView *speartorView in self.subviews)
    {
        if (speartorView.frame.size.height < 1)//取出分割线view
        {
            speartorView.backgroundColor = seperatorLineColor;
//            [UIColor colorWithRed:116/255.0 green:169/255.0 blue:203/255.0 alpha:1/1.0];
        }
    }
}

- (UIColor *)seperatorLineColor {
    return nil;
}

@end
