//
//  WALMELabelView.h
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WALMECoreTextData, WALMETextLinkData;

NS_ASSUME_NONNULL_BEGIN

// https://www.jianshu.com/p/9ffcdc0003e0
// https://www.jianshu.com/p/4d049b5f4c6b
//@protocol WALMELabelViewDelegate <NSObject>
//
//@optional
//- (void)walme_clickText:(WALMETextLinkData *)linkData;
//
//@end

typedef void(^WALMELabelViewBlock)(WALMETextLinkData * linkData);

@class WALMELabelComponent;

@interface WALMELabelView : UIView

@property (nonatomic, strong) WALMECoreTextData * data;
@property (nonatomic, copy) WALMELabelViewBlock clickBlock;
//@property (nonatomic, weak) id<WALMELabelViewDelegate> delegate;

//+ (instancetype)labelWithTextComponent:(NSArray<WALMELabelComponent *> *)components;
//- (instancetype)initWithTextComponent:(NSArray<WALMELabelComponent *> *)components;
//- (instancetype)initWithTextComponent:...;

@end

NS_ASSUME_NONNULL_END
