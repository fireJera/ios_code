//
//  WALMEBottomPopView.m
//  CodeFrame
//
//  Created by Jeremy on 2019/8/1.
//  Copyright © 2019 InterestChat. All rights reserved.
//

#import "WALMEBottomPopView.h"
#import "WALMEPickerNode.h"
#import "NSArray+WALME_Custom.h"
#import "WALMEViewHeader.h"
#import "NSDate+WALME_Custom.h"

@implementation WALMEBottomDateView

- (void)layoutSubviews {
    [super layoutSubviews];
    _datePicker.frame = self.bounds;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self p_commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self p_commonInit];
    }
    return self;
}

- (void)p_commonInit {
    _datePicker = [[UIDatePicker alloc] init];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    _datePicker.locale = locale;
    _datePicker.minimumDate = [NSDate dateFromBaseDate:-80];
    _datePicker.maximumDate = [NSDate date];
    [self addSubview:_datePicker];
}

@end

@implementation WALMEBottomPickerView

- (void)layoutSubviews {
    [super layoutSubviews];
    _pickerView.frame = self.bounds;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self p_commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self p_commonInit];
    }
    return self;
}

- (void)p_commonInit {
    _pickerView = [[UIPickerView alloc] init];
    [self addSubview:_pickerView];
}

@end

@interface WALMEBottomPopView () <UIPickerViewDelegate, UIPickerViewDataSource>

@end

@implementation WALMEBottomPopView

- (void)layoutSubviews {
    [super layoutSubviews];
    _bgView.frame = (CGRect){0, self.height - 300, self.width, 300};
    _contentView.frame = (CGRect){0, 20, _bgView.width, _bgView.height - 20};
    _confirmBtn.frame = (CGRect){_bgView.width - 60 - 14, 10, 60, 20};
}

- (void)refreshView {
    [_contentView removeFromSuperview];
    _contentView = nil;
    [_bgView addSubview:self.contentView];
//    if ([_contentView isKindOfClass:[WALMEBottomPickerView class]]) {
//        [((WALMEBottomPickerView *)_contentView).pickerView reloadAllComponents];
//    }
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

#pragma mark - pickerviewdelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return _pickerNode.treeDepth;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    WALMEPickerNode * node = _pickerNode;
    for (int i = 0; i < component; i++) {
        if (i == 0) {
            break;
        }
        else {
            NSUInteger row = [pickerView selectedRowInComponent:component];
            node = [node.childNodes objectOrNilAtIndex:row];
        }
    }
    return node.childNodes.count;
}

//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
//    UILabel *label = (UILabel *)view;
//    if (!label) {
//        label = [[UILabel alloc]init];
//        label.textAlignment = NSTextAlignmentCenter;
//        label.backgroundColor = [UIColor clearColor];
//        label.font = [UIFont walme_PingFangMedium17];
//    }
//    label.textColor = [UIColor walme_colorWithRGB:0x7f7f7f];
//    label.text = [self pickerView:pickerView titleForRow:row forComponent:component];
//    [label sizeToFit];
//    label.textColor = [UIColor walme_colorWithRGB:0x212121];
//    return label;
//}

//- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
//    return 40;
//}

//- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
//
//}
//

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    WALMEPickerNode * node = _pickerNode;
    for (int i = 0; i < component; i++) {
        NSUInteger beforeRow = [pickerView selectedRowInComponent:i];
        node = [node.childNodes objectOrNilAtIndex:beforeRow];
    }
    return [node.childNodes objectOrNilAtIndex:row].nodeName;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    for (NSInteger i = component + 1; i < pickerView.numberOfComponents; i ++) {
        [pickerView reloadComponent:i];
    }
}

#pragma mark -  touch event

- (void)p_walme_confirm:(UIButton *)sender {
    [_delegate popViewConfirmed:self];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self removeFromSuperview];
}

#pragma mark - getter

- (WALMEBottomPopViewType)pickerType {
    return [_dataSource pickerType];
}

- (UIView *)picker {
    WALMEBottomPopViewType type = [_dataSource pickerType];
    switch (type) {
        case WALMEBottomPopViewTypeDefault:
        case WALMEBottomPopViewTypePicker:
        case WALMEBottomPopViewTypeAddress:
            return ((WALMEBottomPickerView *)_contentView).pickerView;
            break;
        case WALMEBottomPopViewTypeDate:
            return ((WALMEBottomDateView *)_contentView).datePicker;
            break;
    }
    return nil;
}

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self p_commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self p_commonInit];
    }
    return self;
}

- (void)p_commonInit {
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_bgView];
    
    _confirmBtn = ({
        UIButton * button = [WALMEViewHelper walme_buttonWithFrame:CGRectZero
                                                           bgImage:nil
                                                             image:nil
                                                             title:@"确定"
                                                         textColor:[UIColor blackColor]
                                                            method:@selector(p_walme_confirm:)
                                                            target:self];
        [_bgView addSubview:button];
        button;
    });
}

#pragma mark - lazy

- (UIView *)contentView {
    if (!_contentView) {
        WALMEBottomPopViewType type = [_dataSource pickerType];
        switch (type) {
            case WALMEBottomPopViewTypeDefault:
            case WALMEBottomPopViewTypePicker:
            case WALMEBottomPopViewTypeAddress: {
                _contentView = [[WALMEBottomPickerView alloc] init];
                ((WALMEBottomPickerView *)_contentView).pickerView.delegate = self;
                [((WALMEBottomPickerView *)_contentView).pickerView reloadAllComponents];
                NSArray<NSNumber *> * array = _dataSource.selectedIndexes;
                [array enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (obj.integerValue < [((WALMEBottomPickerView *)_contentView).pickerView numberOfRowsInComponent:idx]) {
                        [((WALMEBottomPickerView *)_contentView).pickerView selectRow:obj.integerValue inComponent:idx animated:YES];
                    }
                }];
//                [((WALMEBottomPickerView *)_contentView).pickerView reloadAllComponents];
            }
                break;
            case WALMEBottomPopViewTypeDate:
                _contentView = [[WALMEBottomDateView alloc] init];
                ((WALMEBottomDateView *)_contentView).datePicker.date = _dataSource.selectedDate;
                ((WALMEBottomDateView *)_contentView).datePicker.maximumDate = [NSDate dateFromBaseDate:-18];
//                [((WALMEBottomDateView *)_contentView).datePicker addTarget:self action:@selector(<#selector#>) forControlEvents:<#(UIControlEvents)#>]
                break;
        }
    }
    return _contentView;
}

@end
