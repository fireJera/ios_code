//
//  WALMEBottomPopView.h
//  CodeFrame
//
//  Created by Jeremy on 2019/8/1.
//  Copyright © 2019 InterestChat. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WALMEPickerNode;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, WALMEBottomPopViewType) {
    WALMEBottomPopViewTypePicker,
    WALMEBottomPopViewTypeAddress,
    WALMEBottomPopViewTypeDate,
    WALMEBottomPopViewTypeDefault,
};

@protocol WALMEBottomPopViewDataSource, WALMEBottomPopViewDelegate;

@interface WALMEBottomDateView : UIView

@property (nonatomic, strong) UIDatePicker * datePicker;

@end

@interface WALMEBottomPickerView : UIView

@property (nonatomic, strong) UIPickerView * pickerView;

@end

@interface WALMEBottomPopView : UIView

@property (nonatomic, strong) UIView * bgView;
@property (nonatomic, strong) UIView * contentView;

@property (nonatomic, strong) UIButton * confirmBtn;

@property (nonatomic, strong, readonly) UIView * picker;
@property (nonatomic, strong) WALMEPickerNode * pickerNode;
@property (nonatomic, assign, readonly) WALMEBottomPopViewType pickerType;

@property (nonatomic, weak) id<WALMEBottomPopViewDataSource> dataSource;
@property (nonatomic, weak) id<WALMEBottomPopViewDelegate> delegate;

- (void)refreshView;

@end

@protocol WALMEBottomPopViewDataSource <NSObject>

- (WALMEBottomPopViewType)pickerType;
- (NSDate *)selectedDate;
- (NSArray<NSNumber *> *)selectedIndexes;

@end

@protocol WALMEBottomPopViewDelegate <NSObject>

- (void)popViewConfirmed:(WALMEBottomPopView *)popView;

@end

NS_ASSUME_NONNULL_END
