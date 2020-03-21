//
//  DownloadCell.m
//  Concurrent
//
//  Created by Jeremy on 2020/3/13.
//  Copyright © 2020 Jeremy. All rights reserved.
//

#import "DownloadCell.h"

@implementation DownloadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)pauseDownload:(UIButton *)sender {
    sender.selected = !sender.selected;
    NSInteger tag = sender.tag;
    if (sender.selected) {
        if ([_delegate respondsToSelector:@selector(startDownloadForIndex:)]) {
            [_delegate startDownloadForIndex:tag];
        }
    }
    else {
        if ([_delegate respondsToSelector:@selector(pasueDownloadForIndex:)]) {
            [_delegate pasueDownloadForIndex:tag];
        }
    }
}

- (IBAction)deleteDownload:(UIButton *)sender {
    NSInteger tag = sender.tag;
    if ([_delegate respondsToSelector:@selector(removeDownloadForIndex:)]) {
        [_delegate removeDownloadForIndex:tag];
    }
}

@end
