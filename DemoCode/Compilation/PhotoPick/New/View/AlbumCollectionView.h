////
////  AlbumCollectionView.h
////  PhotoPick
////
////  Created by Jeremy on 2019/3/23.
////  Copyright © 2019 Jeremy. All rights reserved.
////
//
//#import <UIKit/UIKit.h>
//
//NS_ASSUME_NONNULL_BEGIN
//
//@protocol AlbumCollectionViewDataSource, AlbumCollectionViewDelegate;
//
//@interface AlbumCollectionView : UICollectionView
//
//@property (weak, nonatomic) id<AlbumCollectionViewDelegate> delegate;
//@property (weak, nonatomic) id<AlbumCollectionViewDataSource> dataSource;
//@property (assign, nonatomic) BOOL editEnabled;
//
//@end
//
//@protocol AlbumCollectionViewDelegate <UICollectionViewDelegate>
//
//@required
///**
// *  当数据源更新的到时候调用，必须实现，需将新的数据源设置为当前的数据源(例如 :_data = newDataArray)
// *  @param newDataArray   更新后的数据源
// */
//- (void)dragCellCollectionView:(AlbumCollectionView *)collectionView newDataArrayAfterMove:(NSArray *)newDataArray;
//
//@optional
///**
// *  cell移动完毕，并成功移动到新位置的时候调用
// */
//- (void)dragCellCollectionViewCellEndMoving:(AlbumCollectionView *)collectionView;
///**
// *  成功交换了位置的时候调用
// *  @param fromIndexPath    交换cell的起始位置
// *  @param toIndexPath      交换cell的新位置
// */
//- (void)dragCellCollectionView:(AlbumCollectionView *)collectionView moveCellFromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath;
//@end
//
//@protocol AlbumCollectionViewDataSource<UICollectionViewDataSource>
//
//
//@required
///**
// *  返回整个CollectionView的数据，必须实现，需根据数据进行移动后的数据重排
// */
//- (NSArray *)dataSourceArrayOfCollectionView:(AlbumCollectionView *)collectionView;
//
//@end
//
//NS_ASSUME_NONNULL_END
