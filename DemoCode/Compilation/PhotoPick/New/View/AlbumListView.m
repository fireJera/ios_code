//
//  AlbumListView.m
//  PhotoPick
//
//  Created by Jeremy on 2019/3/22.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import "AlbumListView.h"
#import "AlbumModel.h"
#import "AlbumListViewmodel.h"
#import "AlbumTool.h"

@interface AlbumListViewCell ()

@property (strong, nonatomic) UIImageView *photoView;
@property (strong, nonatomic) UILabel *photoName;
@property (strong, nonatomic) UILabel *photoNum;
@property (strong, nonatomic) UIImageView *numIcon;
@property (strong, nonatomic) UIView *selectedView;

@end

@implementation AlbumListViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    [self.contentView addSubview:self.photoView];
    [self.contentView addSubview:self.photoName];
    [self.contentView addSubview:self.photoNum];
    [self.photoView addSubview:self.numIcon];
}

- (void)setViewmodel:(AlbumListViewmodel *)viewmodel {
    _viewmodel = viewmodel;
//    if (viewmodel.UIviewmodel.albumViewCellSelectedColor) {
//        self.selectedView.backgroundColor = viewmodel.UIviewmodel.albumViewCellSelectedColor;
//        self.selectedBackgroundView = self.selectedView;
//    }
    self.photoName.textColor = [UIColor blackTextColor];
    self.photoNum.textColor = [UIColor darkGrayColor];
    if (!self.numIcon.image) {
        self.numIcon.image = [AlbumTool imageNamed:@"compose_photo_filter_checkbox_checked@2x.png"];
    }
    UIColor * color =[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    self.backgroundColor = color;
}

- (void)setModel:(AlbumModel *)model {
    _model = model;
    
    __weak typeof(self) weakSelf = self;
    if (!model.asset) {
        model.asset = model.result.lastObject;
        model.albumCover = nil;
    }
    if (model.albumCover) {
        self.photoView.image = model.albumCover;
    } else {
        [AlbumTool getPhotoForPHAsset:model.asset size:CGSizeMake(60, 60) completion:^(UIImage * _Nonnull image, NSDictionary * _Nonnull info) {
            weakSelf.photoView.image = image;
            model.albumCover = image;
        }];
    }
    
    self.photoName.text = model.albumName;
    self.photoNum.text = [NSString stringWithFormat:@"%ld",(long)model.photoCount];
    if (model.selectCount > 0) {
        self.numIcon.hidden = NO;
    } else {
        self.numIcon.hidden = YES;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    self.photoView.frame = CGRectMake(10, 5, 50, 50);
    
    CGFloat photoNameX = CGRectGetMaxX(self.photoView.frame) + 10;
    CGFloat photoNameWith = self.model.nameWidth;
    if (photoNameWith > width - photoNameX - 50) {
        photoNameWith = width - photoNameX - 50;
    }
    self.photoName.frame = CGRectMake(photoNameX, 0, photoNameWith, 18);
    self.photoName.center = CGPointMake(self.photoName.center.x, height / 2);
    
    CGFloat photoNumX = CGRectGetMaxX(self.photoName.frame) + 5;
    CGFloat photoNumWidth = self.width - CGRectGetMaxX(self.photoName.frame) + 5 - 20;
    self.photoNum.frame = CGRectMake(photoNumX, 0, photoNumWidth, 15);
    self.photoNum.center = CGPointMake(self.photoNum.center.x, height / 2 + 2);
    
    CGFloat numIconX = 50 - 2 - 13;
    CGFloat numIconY = 2;
    CGFloat numIconW = 13;
    CGFloat numIconH = 13;
    self.numIcon.frame = CGRectMake(numIconX, numIconY, numIconW, numIconH);
}

#pragma mark - < 懒加载 >
- (UIImageView *)photoView {
    if (!_photoView) {
        _photoView = [[UIImageView alloc] init];
        _photoView.contentMode = UIViewContentModeScaleAspectFill;
        _photoView.clipsToBounds = YES;
    }
    return _photoView;
}
- (UILabel *)photoName {
    if (!_photoName) {
        _photoName = [[UILabel alloc] init];
        _photoName.font = [UIFont systemFontOfSize:17];
    }
    return _photoName;
}
- (UILabel *)photoNum {
    if (!_photoNum) {
        _photoNum = [[UILabel alloc] init];
        _photoNum.font = [UIFont systemFontOfSize:12];
    }
    return _photoNum;
}
- (UIImageView *)numIcon {
    if (!_numIcon) {
        _numIcon = [[UIImageView alloc] init];
    }
    return _numIcon;
}
- (UIView *)selectedView {
    if (!_selectedView) {
        _selectedView = [[UIView alloc] init];
    }
    return _selectedView;
}

@end

@interface AlbumListView () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) AlbumListViewmodel * viewmodel;
@end

@implementation AlbumListView

- (instancetype)initWithFrame:(CGRect)frame viewmodel:(AlbumListViewmodel *)viewmodel {
    self = [super initWithFrame:frame];
    if (self) {
        self.viewmodel = viewmodel;
        self.currentIndex = 0;
        [self setup];
    }
    return self;
}

- (void)setup {
    UIColor * color = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    self.backgroundColor = color;
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, width, height) style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = self.backgroundColor = color;
    [tableView registerClass:[AlbumListViewCell class] forCellReuseIdentifier:@"cellId"];
    [self addSubview:tableView];
    self.tableView = tableView;
}

- (void)setAlbumList:(NSArray<AlbumModel *> *)albumList {
    _albumList = albumList;
    [self.tableView reloadData];
    if (self.currentIndex < _albumList.count) {
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _albumList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AlbumListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    cell.viewmodel = self.viewmodel;
    cell.model = self.albumList[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.currentIndex = indexPath.row;
    if ([self.delegate respondsToSelector:@selector(albumListViewCellClick:animated:)]) {
        [self.delegate albumListViewCellClick:_albumList[indexPath.row] animated:YES];
    }
}
@end
