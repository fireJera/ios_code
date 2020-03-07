//
//  AlbumListView.h
//  PhotoPick
//
//  Created by Jeremy on 2019/3/22.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AlbumModel, AlbumListViewmodel;

NS_ASSUME_NONNULL_BEGIN

@protocol AlbumListViewDelegate;

@interface AlbumListViewCell : UITableViewCell
@property (strong, nonatomic) AlbumModel *model;
@property (weak, nonatomic) AlbumListViewmodel *viewmodel;
@end

@interface AlbumListView : UIView

@property (weak, nonatomic) UITableView *tableView;
@property (weak, nonatomic) id<AlbumListViewDelegate> delegate;
@property (copy, nonatomic) NSArray<AlbumModel *> *albumList;
@property (assign, nonatomic) NSInteger currentIndex;

- (instancetype)initWithFrame:(CGRect)frame viewmodel:(AlbumListViewmodel *)viewmodel;

@end

@protocol AlbumListViewDelegate <NSObject>

- (void)albumListViewCellClick:(AlbumModel *)model animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
