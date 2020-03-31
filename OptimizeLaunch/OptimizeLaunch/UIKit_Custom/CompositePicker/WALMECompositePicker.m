//
//  WALMECompositePicker.m
//  CodeFrame
//
//  Created by hd on 2019/4/13.
//  Copyright © 2019年 JersiZhu. All rights reserved.
//

#import "WALMECompositePicker.h"
#import "UIPickerView+ChangeSepaLine.h"
#import "WALMEPickerNode.h"

@interface WALMECompositePicker() <UIPickerViewDataSource,UIPickerViewDelegate>
@property (nonatomic, strong) WALMEPickerNode *rootNode;
@end

@implementation WALMECompositePicker

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self walme_setPickerView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _pickerView.frame = self.bounds;
}

#pragma mark - SetView
- (void)walme_setPickerView {
    _nextRelation = WALMEPickerNextComRelationGreater;
    _pickerView = [[UIPickerView alloc] initWithFrame:self.bounds];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    
    [self addSubview:_pickerView];
}

//- (void)setPickerLineColor:(UIColor *)pickerLineColor {
//    _pickerView.seperatorLineColor = pickerLineColor;
//}

#pragma mark - UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 36;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    _pickerView.seperatorLineColor = _pickerLineColor;
    if (!_rootNode && _nextRelation > WALMEPickerNextComRelationNone) {
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
 /*

- (nullable NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
    WALMEPickerNode *node = self.rootNode;
    for (int i = 0; i < component; i ++) {
        NSInteger selectedRow = [pickerView selectedRowInComponent:i];
        node = [node childNodeAtIndex:selectedRow];
    }
    BOOL selected = [pickerView selectedRowInComponent:component] == row;
    NSLog(@"row >>> %d,component >>>> %d,selectRow >>> %d",row,component,[pickerView selectedRowInComponent:component]);
    NSString *nodeName = [node childNodeAtIndex:row].nodeName;
    return [self walme_pickerTitleWithStr:nodeName selected:selected];
}
  */

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    for (NSInteger i = component + 1; i < pickerView.numberOfComponents; i ++) {
        [pickerView reloadComponent:i];
    }
    NSInteger cCount = [self numberOfComponentsInPickerView:pickerView];
    NSMutableArray * array = [NSMutableArray array];
    for (int i = 0; i < cCount; i++) {
        NSInteger row = [pickerView selectedRowInComponent:i];
        [array addObject:@(row)];
    }
    if (_pickBlock) {
        _pickBlock(array);
    }
//    [pickerView reloadAllComponents];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (!_rootNode && _nextRelation > WALMEPickerNextComRelationNone) {
        return 2;
    }
    return [self.rootNode treeDepth];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (!_rootNode && _nextRelation > WALMEPickerNextComRelationNone) {
        if (component == 0) {
            return MAX(0, _toValue - _fromValue + 1);
        }
        else if (component == 1) {
            NSInteger firstRow = [pickerView selectedRowInComponent:0];
            return MAX(0, _toValue - (_fromValue + firstRow) + 1);
        }
        return 0;
    }
    WALMEPickerNode *node = self.rootNode;
    if (component == 0) {
        return self.rootNode.nodeDegree;
    } else {
        for (int i = 0; i < pickerView.numberOfComponents - 1; i ++) {
            NSInteger selectedRow = [pickerView selectedRowInComponent:i];
            node = [node childNodeAtIndex:selectedRow];
        }
        return node.nodeDegree;
    }
}

//- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
//    return 36;
//}

#pragma mark - setter

- (void)setSelectRows:(NSArray<NSNumber *> *)selectRows {
    for (int i = 0; i < selectRows.count; i++) {
        NSInteger index = selectRows[i].integerValue;
        [_pickerView selectRow:index inComponent:i animated:YES];
    }
}

#pragma mark - public

- (void)reloadPickerView {
    [_pickerView reloadAllComponents];
}

- (void)walme_reloadDataWithRootNode:(WALMEPickerNode *)rootNode {
    self.rootNode = rootNode;
    [_pickerView reloadAllComponents];
}

//#pragma mark - private Mehtod
//- (NSAttributedString *)walme_pickerTitleWithStr:(NSString *)str selected:(BOOL)selected {
//    if (str == nil) {
//        return nil;
//    }
//    UIFont *font = selected ? [UIFont fontWithName:@"PingFangSC-Medium" size:17] : [UIFont systemFontOfSize:16];
//    UIColor *textColor = selected ? [UIColor colorWithRed:33/255.0 green:33/255.0 blue:33/255.0 alpha:1/1.0] : [UIColor colorWithRed:127/255.0 green:127/255.0 blue:127/255.0 alpha:1/1.0];
//
//    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:textColor}];
//    NSLog(@"nodeName ...... %@",str);
//    return attrStr.copy;
//}

@end
