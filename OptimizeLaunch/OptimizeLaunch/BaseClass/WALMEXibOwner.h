//
//  WALMEXibOwner.h
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WALMEXibOwner : NSObject

@property (nonatomic, weak) IBOutlet UIView *view;

+(id)viewFromNibNamed:(NSString*) nibName;

@end


NS_ASSUME_NONNULL_END
