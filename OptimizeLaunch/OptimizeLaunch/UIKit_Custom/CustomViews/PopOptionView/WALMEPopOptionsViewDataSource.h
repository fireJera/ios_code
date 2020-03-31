//
//  WALMEPopOptionsViewDataSource.h
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/22.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#ifndef WALMEPopOptionsViewDataSource_h
#define WALMEPopOptionsViewDataSource_h

#import "WALMEPopOptionsView.h"

typedef NS_ENUM(NSUInteger, WALMEPopOptionsViewType) {
    WALMEPopOptionsViewTypePicker,
    WALMEPopOptionsViewTypeDatePicker,
    WALMEPopOptionsViewTypeDefault,
};
@class WALMEPickerNode;

@protocol WALMEPopOptionsViewDataSource <NSObject>

@optional

@property (nonatomic, readonly) WALMEPopOptionsViewType viewType;

@property (nonatomic, copy, readonly) NSString * optionTitle;
@property (nonatomic, copy, readonly) NSString * seperatorColor;
@property (nonatomic, strong, readonly) WALMEPickerNode * rootNode;
@property (nonatomic, copy, readonly) NSArray<NSNumber *> * selectedRows;
@property (nonatomic, copy, readonly) NSDate * birthday;
@property (nonatomic, copy, readonly) NSDate * earlyDate;
@property (nonatomic, copy, readonly) NSDate * lateDate;

@property (readonly) NSInteger fromValue;
@property (readonly) NSInteger toValue;

- (CGFloat)rowHeightforComponent:(NSInteger)component;

- (void)walme_popOptionsViewDateChanged:(WALMEPopOptionsView *)optionView;
- (void)walme_popOptionsViewWillClose:(WALMEPopOptionsView *)optionView;
- (void)walme_popOptionsViewConfirmOption:(WALMEPopOptionsView *)optionView;

@end



#endif /* WALMEPopOptionsViewDataSource_h */
