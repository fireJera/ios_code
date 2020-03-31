//
//  WALMECoreTextData.h
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

@class WALMETextLinkData, WALMELabelComponent;

NS_ASSUME_NONNULL_BEGIN

@interface WALMECoreTextData : NSObject

@property (nonatomic, assign) CTFrameRef ctFrame;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat width;

@property (nonatomic, strong) NSArray<WALMETextLinkData *> * linkArray;

//@property (nonatomic, strong) NSArray<WALMELabelComponent *> * components;

@end

NS_ASSUME_NONNULL_END
