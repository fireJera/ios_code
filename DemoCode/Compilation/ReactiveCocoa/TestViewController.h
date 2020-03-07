//
//  TestViewController.h
//  ReactiveCocoa
//
//  Created by Jeremy on 2019/1/17.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RACSubject;
NS_ASSUME_NONNULL_BEGIN

@interface TestViewController : UIViewController
@property (nonatomic, strong) RACSubject * delegateSignal;
@end

NS_ASSUME_NONNULL_END
