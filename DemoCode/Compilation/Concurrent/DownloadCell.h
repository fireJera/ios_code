//
//  DownloadCell.h
//  Concurrent
//
//  Created by Jeremy on 2020/3/13.
//  Copyright © 2020 Jeremy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DownloadCellDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface DownloadCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *downloadName;
@property (weak, nonatomic) IBOutlet UILabel *downloadPro;
@property (weak, nonatomic) IBOutlet UIProgressView *downProgressView;
@property (weak, nonatomic) IBOutlet UIButton *pauseBtn;
@property (weak, nonatomic) IBOutlet UIButton *delBtn;

@property (nonatomic, weak) id<DownloadCellDelegate> delegate;

@end

@protocol DownloadCellDelegate <NSObject>

- (void)pasueDownloadForIndex:(NSInteger)index;
- (void)startDownloadForIndex:(NSInteger)index;
- (void)removeDownloadForIndex:(NSInteger)index;

@end


NS_ASSUME_NONNULL_END
