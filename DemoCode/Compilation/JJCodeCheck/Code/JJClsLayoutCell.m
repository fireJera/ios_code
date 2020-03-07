//
//  JJClsLayoutCell.m
//  JJCodeCheck
//
//  Created by Jeremy on 2019/7/11.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import "JJClsLayoutCell.h"

@implementation JJClsLayoutCell {
    NSArray<UIView *> * _layoutViews;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)updateLayout:(NSInteger)length range:(NSIndexSet *)ranges {
    if (self.contentView.subviews.count == 0) {
        CGFloat left = 16, top = 16, vertical = 8, horizon = 8;
        CGFloat selfWidth = self.contentView.frame.size.width;
        const int columnCount = 8;
//        CGFloat selfHeight = self.contentView.frame.size.height;
        CGFloat width = (selfWidth - left * 2 - horizon * (columnCount - 1)) / columnCount;
        for (int i = 0; i < length; i++) {
            UIView * view = [[UIView alloc] initWithFrame:CGRectMake(left + (width + horizon) * (i % 8), top + (width + vertical) * (i / 8), width, width)];
            view.layer.borderColor = [UIColor redColor].CGColor;
            view.layer.borderWidth = 1;
//            view.tag = i + 1;
            if ([ranges containsIndex:i]) {
                view.backgroundColor = [UIColor blackColor];
            }
            if (i < 8) {
                view.backgroundColor = [UIColor redColor];
            }
            [self.contentView addSubview:view];
        }
    }
}

- (void)updateLayout:(NSInteger)length layout:(NSArray<NSNumber *> *)layouts {
    if (self.contentView.subviews.count == 0) {
        CGFloat left = 16, top = 16, vertical = 8, horizon = 8;
        CGFloat selfWidth = self.contentView.frame.size.width;
        const int columnCount = 8;
        //        CGFloat selfHeight = self.contentView.frame.size.height;
        CGFloat width = (selfWidth - left * 2 - horizon * (columnCount - 1)) / columnCount;
        for (int i = 0; i < length; i++) {
            UIView * view = [[UIView alloc] initWithFrame:CGRectMake(left + (width + horizon) * (i % 8), top + (width + vertical) * (i / 8), width, width)];
            view.layer.borderColor = [UIColor redColor].CGColor;
            view.layer.borderWidth = 1;
            //            view.tag = i + 1;
            for (int j = 0; j < layouts.count; j += 2) {
                NSInteger begin = [layouts[j] integerValue];
                NSInteger length = [layouts[j + 1] integerValue];
                NSInteger end = begin + length;
                if (i >= begin && i < end) {
                    UIColor * color = j % 4 == 0 ? [UIColor blueColor] : [UIColor yellowColor];
                    view.backgroundColor = color;
                }
            }
//            if ([ranges containsIndex:i]) {
//            }
            if (i < 8) {
                view.backgroundColor = [UIColor redColor];
            }
            [self.contentView addSubview:view];
        }
    }
}

- (void)updateMethodLayout:(NSInteger)length layout:(NSArray<NSNumber *> *)layouts {
    if (self.contentView.subviews.count == 0) {
        CGFloat left = 16, top = 16, vertical = 8, horizon = 8;
        CGFloat selfWidth = self.contentView.frame.size.width;
        const int columnCount = 8;
        //        CGFloat selfHeight = self.contentView.frame.size.height;
        CGFloat width = (selfWidth - left * 2 - horizon * (columnCount - 1)) / columnCount;
        for (int i = 0; i < length; i++) {
            UIView * view = [[UIView alloc] initWithFrame:CGRectMake(left + (width + horizon) * (i % 8), top + (width + vertical) * (i / 8), width, width)];
            view.layer.borderColor = [UIColor redColor].CGColor;
            view.layer.borderWidth = 1;
            for (int j = 0; j < layouts.count; j += 2) {
                NSInteger begin = [layouts[j] integerValue];
                NSInteger length = [layouts[j + 1] integerValue];
                NSInteger end = begin + length;
                
                if (i >= begin && i < end) {
                    UIColor * color;
                    if (j <= 1) {
                        color = [UIColor redColor];
                    }
                    else if (j <= 3) {
                        color = [UIColor blackColor];
                    }
                    else {
                        color = j % 4 == 0 ? [UIColor blueColor] : [UIColor yellowColor];
                    }
                    view.backgroundColor = color;
                }
            }
            [self.contentView addSubview:view];
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}



@end
