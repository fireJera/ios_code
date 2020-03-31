//
//  HXAlbumListView.h
//  微博照片选择
//
//  Created by 洪欣 on 17/2/8.
//  Copyright © 2017年 洪欣. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "HXAlbumModel.h"

@class HXAlbumModel;

@protocol HXAlbumListViewDelegate <NSObject>

- (void)didTableViewCellClick:(HXAlbumModel *)model animate:(BOOL)anim;

@end

@class WALMEAlbumListViewmodel;
@interface HXAlbumListView : UIView
@property (weak, nonatomic) UITableView *tableView;
@property (weak, nonatomic) id<HXAlbumListViewDelegate> delegate;
@property (copy, nonatomic) NSArray *list;
@property (assign, nonatomic) NSInteger currentIndex;
- (instancetype)initWithFrame:(CGRect)frame manager:(WALMEAlbumListViewmodel *)manager;
@end

@interface HXAlbumListViewCell : UITableViewCell
@property (strong, nonatomic) HXAlbumModel *model;
@property (weak, nonatomic) WALMEAlbumListViewmodel *manager;
@end
