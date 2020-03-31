//
//  WALMEAlbumListModel.h
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface WALMEAlbumListModel : NSObject

@property (nonatomic, assign) int maxNumber;            //最大数量
@property (nonatomic, assign) int maxWidth;             //最大宽度
@property (nonatomic, assign) int maxHeight;            //最大高度
@property (nonatomic, assign) int minWidth;             //最小高度
@property (nonatomic, assign) int minHeight;            //最小宽度

@end


NS_ASSUME_NONNULL_END
