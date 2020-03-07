//
//  CustomNavigationBar.m
//  PhotoPick
//
//  Created by Jeremy on 2019/3/22.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import "CustomNavigationBar.h"
#import "AlbumTool.h"

@implementation CustomNavigationBar

- (void)layoutSubviews {
    [super layoutSubviews];
    if (@available(iOS 11.0, *)) {
        self.height = kNavigationBarHeight;
        for (UIView *view in self.subviews) {
            if([NSStringFromClass([view class]) containsString:@"Background"]) {
                view.frame = self.bounds;
            }
            else if ([NSStringFromClass([view class]) containsString:@"ContentView"]) {
                CGRect frame = view.frame;
                frame.origin.y = kNavigationBarHeight - 44;
                frame.size.height = self.bounds.size.height - frame.origin.y;
                view.frame = frame;
            }
        }
    }
}
@end
