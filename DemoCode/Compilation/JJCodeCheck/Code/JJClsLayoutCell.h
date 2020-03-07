//
//  JJClsLayoutCell.h
//  JJCodeCheck
//
//  Created by Jeremy on 2019/7/11.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JJClsLayoutCell : UITableViewCell

/*
 * red -> isa
 * white -> 0 补位
 *
 *
 *
 */

- (void)updateLayout:(NSInteger)length range:(NSIndexSet *)ranges;
- (void)updateLayout:(NSInteger)length layout:(NSArray<NSNumber *> *)layouts;

- (void)updateMethodLayout:(NSInteger)length layout:(NSArray<NSNumber *> *)layouts;

@end

NS_ASSUME_NONNULL_END
