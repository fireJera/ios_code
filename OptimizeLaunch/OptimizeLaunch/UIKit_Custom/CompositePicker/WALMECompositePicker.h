//
//  WALMECompositePicker.h
//  CodeFrame
//
//  Created by hd on 2019/4/13.
//  Copyright © 2019年 JersiZhu. All rights reserved.
//
//组合模式生成pickerView
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, WALMEPickerNextComRelation) {
    WALMEPickerNextComRelationNone,
    WALMEPickerNextComRelationGreater,
    WALMEPickerNextComRelationLess,
};

@class WALMEPickerNode;

typedef void(^WALMECompositePickBlock)(NSArray<NSNumber *> *rows);

@interface WALMECompositePicker : UIView

@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIColor *pickerLineColor;

@property (nonatomic, copy) WALMECompositePickBlock pickBlock;
@property (nonatomic, copy) NSArray<NSNumber *> * selectRows;

// WALMEPickerNextComRelationGreater default
@property (nonatomic, assign) WALMEPickerNextComRelation nextRelation;
@property (nonatomic, assign) NSInteger fromValue;
@property (nonatomic, assign) NSInteger toValue;

- (void)reloadPickerView;
- (void)walme_reloadDataWithRootNode:(WALMEPickerNode *)rootNode;

@end
