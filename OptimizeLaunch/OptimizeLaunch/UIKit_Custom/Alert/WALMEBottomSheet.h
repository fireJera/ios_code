//
//  WALMEBottomSheet.h
//  CodeFrame
//
//  Created by hd on 2019/4/9.
//  Copyright © 2019年 JersiZhu. All rights reserved.
//

#import <UIKit/UIKit.h>

//@protocol WALMEBottomSheetDelegate <NSObject>
////index 与标题在titleArray中的index一致
//- (void)walme_clickSheetAtIndex:(NSInteger)index;
//@end

@interface WALMEBottomSheet : UIView

//@property (nonatomic, weak) id<WALMEBottomSheetDelegate> delegate;
@property (nonatomic, copy) void (^ clickBlock)(NSInteger clickIndex);

//+ (instancetype)walme_bottomSheetWithTitleArray:(NSArray*)titleArray delegate:(id<WALMEBottomSheetDelegate>)delegate;
+ (instancetype)walme_bottomSheetWithTitleArray:(NSArray*)titleArray block:(void(^)(NSInteger index))block;

- (void)walme_updateWithTitleArray:(NSArray*)titleArray;
- (void)walme_show;
- (void)walme_hide;

@end

