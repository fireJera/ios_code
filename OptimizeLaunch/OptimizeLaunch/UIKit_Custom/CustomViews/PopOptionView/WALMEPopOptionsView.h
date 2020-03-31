//
//  WALMEPopOptionsView.h
//  CodeFrame
//
//  Created by Jeremy on 2019/4/22.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WALMEPopOptionsViewDataSource;

NS_ASSUME_NONNULL_BEGIN

@interface WALMEPopOptionsView : UIView

@property (nonatomic, strong) UIView * contentView;
@property (nonatomic, strong) UIPickerView * pickView;
@property (nonatomic, strong) UIButton * confirmBtn;
@property (nonatomic, strong) UIButton * closeBtn;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * dateLabel;
@property (nonatomic, strong) UIDatePicker * datePicker;

@property (nonatomic, strong) id<WALMEPopOptionsViewDataSource> dataSource;

@property (nonatomic, assign) NSInteger fromValue;
@property (nonatomic, assign) NSInteger toValue;

@property (nonatomic, assign) NSInteger earlyDate;
@property (nonatomic, assign) NSInteger lateDate;

- (void)refreshView;

@end

NS_ASSUME_NONNULL_END
