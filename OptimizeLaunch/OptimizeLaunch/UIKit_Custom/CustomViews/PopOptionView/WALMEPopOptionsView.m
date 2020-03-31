//
//  WALMEPopOptionsView.m
//  CodeFrame
//
//  Created by Jeremy on 2019/4/22.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import "WALMEPopOptionsView.h"
#import "WALMEViewHeader.h"
#import "UIPickerView+ChangeSepaLine.h"
#import "WALMEPopOptionsViewDataSource.h"
#import "WALMEPickerNode.h"
#import "NSDate+WALME_Custom.h"

@interface WALMEPopOptionsView () <UIPickerViewDelegate, UIPickerViewDataSource> {
    NSInteger _firstRow;
    NSInteger _secondRow;
    NSInteger _thirdRow;
}

@property (nonatomic, strong) WALMEPickerNode * rootNode;

@end

@implementation WALMEPopOptionsView

- (void)layoutSubviews {
    CGFloat contentLeft = 47, titleLeft = 14, titleTop = 14, closeRight = 14;
    CGFloat confirmLeft = 40, confirmBottom = 20, confirmHeight = 38;
    CGFloat contentHeight = 436;
    _contentView.frame = CGRectMake(contentLeft, (self.height - contentHeight) / 2, self.width - contentLeft * 2, contentHeight);
    
    CGFloat confirmWidth = _contentView.width - confirmLeft * 2;
    CGFloat confirmTop = _contentView.height - confirmHeight - confirmBottom;
    [_titleLabel sizeToFit];
    _titleLabel.left = titleLeft;
    _titleLabel.top = titleTop;
    _closeBtn.right = _contentView.width - closeRight;
    _closeBtn.centerY = _titleLabel.centerY;
    _confirmBtn.frame = (CGRect){confirmLeft, confirmTop, confirmWidth, confirmHeight};
    switch (_dataSource.viewType) {
        case WALMEPopOptionsViewTypeDefault:
        case WALMEPopOptionsViewTypePicker: {
            CGFloat pickTop = 20 + _titleLabel.bottom;
            CGFloat pickHeight = _confirmBtn.top - 20 - pickTop;
            _pickView.frame = (CGRect){confirmLeft, pickTop, confirmWidth, pickHeight};
        }
            break;
        case WALMEPopOptionsViewTypeDatePicker: {
            CGFloat signTop = 20;
            _dateLabel.top = _titleLabel.bottom + signTop;
            _dateLabel.centerX = _contentView.width / 2;
            CGFloat pickTop = 20 + _dateLabel.bottom, pickLeft = 20, pickWidth = _contentView.width - pickLeft * 2;
            CGFloat pickHeight = _confirmBtn.top - 20 - pickTop;
            _datePicker.frame = (CGRect){pickLeft, pickTop, pickWidth, pickHeight};
        }
            break;
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (!_rootNode) {
        return 2;
    }
    return [self.rootNode treeDepth];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (!_rootNode) {
        if (component == 0) {
            return MAX(0, _toValue - _fromValue + 1);
        }
        else if (component == 1) {
            return MAX(0, _toValue - (_fromValue + _firstRow) + 1);
        }
        return 0;
    }
    if (component == 0) {
        return _rootNode.nodeDegree;
    } else {
        WALMEPickerNode *node = self.rootNode;
        for (int i = 0; i < pickerView.numberOfComponents - 1; i++) {
            NSInteger selectedRow = [pickerView selectedRowInComponent:i];
            node = [node childNodeAtIndex:selectedRow];
        }
        return node.nodeDegree;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *label = (UILabel *)view;
    if (!label) {
        label = [[UILabel alloc]init];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont walme_PingFangMedium17];
    }
    label.textColor = [UIColor walme_colorWithRGB:0x7f7f7f];
    label.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    label.textColor = [UIColor walme_colorWithRGB:0x212121];
//    if (component == 0) {
//        /*选中后的row的字体颜色*/
//        /*重写- (nullable NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component NS_AVAILABLE_IOS(6_0) __TVOS_PROHIBITED; 方法加载 attributedText*/
////        pickerLabel.attributedText = [self pickerView:pickerView attributedTitleForRow:_firstRow forComponent:component];
//        label.textColor = [UIColor color_212121];
//    }
//    else if (component == 1) {
//        label.textColor = [UIColor color_212121];
//    }
//    else if (component == 2) {
//        label.textColor = [UIColor color_212121];
//    }
    return label;
}

//- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
//
//}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (!_rootNode) {
        if (component == 0) {
            return [NSString stringWithFormat:@"%d", (int)(_fromValue + row)];
        }
        else if (component == 1) {
            NSInteger firstRow = [pickerView selectedRowInComponent:0];
            return [NSString stringWithFormat:@"%d", (int)(_fromValue + firstRow + row)];
        }
        return @"";
    }
    WALMEPickerNode *node = self.rootNode;
    for (int i = 0; i < component; i ++) {
        NSInteger selectedRow = [pickerView selectedRowInComponent:i];
        node = [node childNodeAtIndex:selectedRow];
    }
    return [node childNodeAtIndex:row].nodeName;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return [_dataSource rowHeightforComponent:component];
}

#pragma mark - UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        _firstRow = row;
    }
    else if (component == 1) {
        _secondRow = row;
    }
    else if (component == 2) {
        _thirdRow = row;
    }
    for (NSInteger i = component + 1; i < pickerView.numberOfComponents; i ++) {
        [pickerView reloadComponent:i];
    }
}

#pragma mark - touch event

- (void)p_walme_confirm:(UIButton *)sender {
    [_dataSource walme_popOptionsViewConfirmOption:self];
}

- (void)p_walme_close:(UIButton *)sender {
    [self removeFromSuperview];
    [_dataSource walme_popOptionsViewWillClose:self];
}

- (void)p_walme_dateChanged:(UIButton *)sender {
//    [_dataSource walme_popOptionsViewDateChanged:self];
    _dateLabel.text = [_datePicker.date dateToSign];
//    _dateLabel.text = [_dataSource dateText];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSSet * allTouches = [event allTouches];
    UITouch * touch = [allTouches anyObject];
    CGPoint point = [touch locationInView:[touch view]];
    if (CGRectContainsPoint(_contentView.frame, point)) return;
    [_dataSource walme_popOptionsViewWillClose:self];
    [self removeFromSuperview];
}

#pragma mark - public method

- (void)refreshView {
    _titleLabel.text = _dataSource.optionTitle;
    switch (_dataSource.viewType) {
        case WALMEPopOptionsViewTypePicker: {
            
        }
            break;
        case WALMEPopOptionsViewTypeDatePicker: {
            
        }
        case WALMEPopOptionsViewTypeDefault: {
            [_pickView reloadAllComponents];
        }
            break;
    }
}

#pragma mark - setter

- (void)setDataSource:(id<WALMEPopOptionsViewDataSource>)dataSource {
    _dataSource = dataSource;
    switch (_dataSource.viewType) {
        case WALMEPopOptionsViewTypeDefault:
        case WALMEPopOptionsViewTypePicker: {
            [_contentView addSubview:self.pickView];
            _pickView.hidden = NO;
            _datePicker.hidden = YES;
            _dateLabel.hidden = YES;
            _rootNode = _dataSource.rootNode;
            if (!_rootNode) {
                _fromValue = _dataSource.fromValue;
                _toValue = _dataSource.toValue;
            }
            [_pickView reloadAllComponents];
            NSArray<NSNumber *> * selectedrRows = [_dataSource selectedRows];
            for (int i = 0; i < selectedrRows.count; i++) {
                NSInteger count = [self pickerView:_pickView numberOfRowsInComponent:i];
                NSInteger index = selectedrRows[i].integerValue;
                if (i == 0) {
                    _firstRow = index;
                }
                if (i == 1) {
                    _secondRow = index;
                }
                if (index < count) {
                    [_pickView selectRow:index inComponent:i animated:YES];
                }
            }
        }
            break;
        case WALMEPopOptionsViewTypeDatePicker: {
            [_contentView addSubview:self.datePicker];
            [_contentView addSubview:self.dateLabel];
            NSDate * date = _dataSource.birthday;
            if (date) {
                _datePicker.date = date;
            }
            _dateLabel.text = [_datePicker.date dateToSign];
            _datePicker.minimumDate = _dataSource.earlyDate;
            _datePicker.maximumDate = _dataSource.lateDate;
            _pickView.hidden = YES;
            _datePicker.hidden = NO;
            _dateLabel.hidden = NO;
        }
            break;
    }
    _titleLabel.text = _dataSource.optionTitle;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;
    [self p_walme_init];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (!self) return nil;
    [self p_walme_init];
    return self;
}

//- (instancetype)init {
//    self = [super init];
//    if (!self) return nil;
//    [self p_walme_init];
//
//    return self;
//}

- (void)p_walme_init {
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    self.userInteractionEnabled = YES;
    _firstRow = 0;
    _secondRow = 0;
    _thirdRow = 0;
    _contentView = [[UIView alloc] initWithFrame:CGRectZero];
    _contentView.backgroundColor = [UIColor whiteColor];
    _contentView.layer.cornerRadius = 8;
    _contentView.userInteractionEnabled = YES;
    [self addSubview:_contentView];
    
    _confirmBtn = [WALMEViewHelper walme_buttonWithFrame:CGRectZero
                                                 bgImage:nil
                                                   image:nil
                                                   title:@"确定"
                                               textColor:[UIColor whiteColor]
                                                  method:@selector(p_walme_confirm:)
                                                  target:self];
    _confirmBtn.backgroundColor = [UIColor walme_colorWithRGB:0x8358d0];
    _confirmBtn.layer.cornerRadius = 4;
    _confirmBtn.titleLabel.font = [UIFont walme_PingFangMedium16];
    [_contentView addSubview:_confirmBtn];
    
    _closeBtn = ({
        UIButton * button = [WALMEViewHelper walme_buttonWithFrame:CGRectZero
                                                           bgImage:nil
                                                             image:@"walme_my_7"
                                                             title:nil
                                                         textColor:nil
                                                            method:@selector(p_walme_close:)
                                                            target:self];
        [_contentView addSubview:button];
        button;
    });
    
    _titleLabel = [WALMEViewHelper walme_labelWithFrame:CGRectZero
                                                  title:nil
                                               fontSize:16
                                              textColor:[UIColor walme_colorWithRGB:0x4c4c4c]];
    [_contentView addSubview:_titleLabel];
}

- (UIPickerView *)pickView {
    if (!_pickView) {
        _pickView = [[UIPickerView alloc] init];
        _pickView.delegate = self;
        _pickView.dataSource = self;
    }
    return _pickView;
}

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [WALMEViewHelper walme_labelWithFrame:CGRectZero
                                                     title:nil
                                                      font:[UIFont walme_PingFangMedium16]
                                                 textColor:[UIColor walme_colorWithRGB:0x212121]];
    }
    return _dateLabel;
}

- (UIDatePicker *)datePicker {
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc] init];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        _datePicker.locale = locale;
        [_datePicker addTarget:self action:@selector(p_walme_dateChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _datePicker;
}


@end
