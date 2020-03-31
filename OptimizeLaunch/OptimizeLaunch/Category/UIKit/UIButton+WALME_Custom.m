//
//  UIButton+WALME_Custom.m
//  CodeFrame
//
//  Created by Jeremy on 2019/4/24.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import "UIButton+WALME_Custom.h"
#import "UIView+WALME_Frame.h"
#import "WALMEAliLog.h"
#import <objc/runtime.h>

@implementation UIButton (WALME_Custom)

//+ (void)load {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
////        [self swizzleSEL:@selector(sendAction:to:from:forEvent:) withSEL:@selector(walme_sendAction:to:from:forEvent:)];
////        [self swizzleSEL:@selector(sendAction:to:forEvent:) withSEL:@selector(walme_sendAction:to:forEvent:)];
////        [self swizzleSEL:@selector(sendActionsForControlEvents:) withSEL:@selector(walme_sendActionsForControlEvents:)];
//        SEL originalSEL = @selector(sendAction:to:forEvent:);
//        SEL swizzledSEL = @selector(walme_sendAction:to:forEvent:);
//        Class class = [self class];
//
//        Method originalMethod = class_getInstanceMethod(class, originalSEL);
//        Method swizzledMethod = class_getInstanceMethod(class, swizzledSEL);
//
//        BOOL didAddMethod =
//        class_addMethod(class,
//                        originalSEL,
//                        method_getImplementation(swizzledMethod),
//                        method_getTypeEncoding(swizzledMethod));
//
//        if (didAddMethod) {
//            class_replaceMethod(class,
//                                swizzledSEL,
//                                method_getImplementation(originalMethod),
//                                method_getTypeEncoding(originalMethod));
//        } else {
//            method_exchangeImplementations(originalMethod, swizzledMethod);
//        }
//    });
//}
//
//- (BOOL)sbtn_sendAction:(SEL)action to:(id)target from:(id)sender forEvent:(UIEvent *)event {
//    return [self sbtn_sendAction:action to:target from:sender forEvent:event];
//}
//
//- (void)sbtn_sendActionsForControlEvents:(UIControlEvents)controlEvents {
//    [self sbtn_sendActionsForControlEvents:controlEvents];
//}

//- (void)walme_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
//    [self walme_sendAction:action to:target forEvent:event];
//    NSMutableDictionary<NSString *, NSString *> * dic = [NSMutableDictionary dictionary];
//    UIViewController * controller = self.viewController;
//    NSString * module = NSStringFromClass(controller.class);
////    NSString * actionName = NSStringFromSelector(action);
//    NSString * actionName = self.logActionName;
//    if (!actionName) {
//        actionName = NSStringFromSelector(action);
//    }
//    [dic setValue:module forKey:@"module"];
//    [dic setValue:actionName forKey:@"aciton"];
//    WALMEAliLog * aliLog = [WALMEAliLog new];
//    [aliLog putKesAndValues:dic toTopic:@"" toSource:@""];
//}

- (void)imagePosition:(WALMEButtonImagePosition)position withSpacing:(CGFloat)spacing {
    switch (position) {
        case WALMEButtonImagePositionDefault:
        case WALMEButtonImagePositionLeft:
            self.imageEdgeInsets = UIEdgeInsetsMake(0, -0.5 * spacing, 0, 0.5 * spacing);
            self.titleEdgeInsets = UIEdgeInsetsMake(0, 0.5 * spacing, 0, -0.5 * spacing);
            break;
        case WALMEButtonImagePositionTop: {
            CGFloat width = self.imageView.frame.size.width;
            CGFloat height = self.imageView.frame.size.height;
            CGFloat textInstrinsicWidth = self.titleLabel.intrinsicContentSize.width;
            CGFloat textInstrinsicHeight = self.titleLabel.intrinsicContentSize.height;
            self.imageEdgeInsets = UIEdgeInsetsMake(-textInstrinsicHeight - spacing, 0, 0, -textInstrinsicWidth);
            self.titleEdgeInsets = UIEdgeInsetsMake(0, -width, -height - spacing, 0);
        }
            break;
        case WALMEButtonImagePositionRight: {
            CGFloat imageWidth = self.imageView.frame.size.width;
            CGFloat texthWidth = self.titleLabel.frame.size.height;
            CGFloat imageOffset = texthWidth + 0.5 * spacing;
            CGFloat textOffset = imageWidth + 0.5 * spacing;
            self.imageEdgeInsets = UIEdgeInsetsMake(0, imageOffset, 0, -imageOffset);
            self.titleEdgeInsets = UIEdgeInsetsMake(0, -textOffset, 0, textOffset);
        }
            break;
        case WALMEButtonImagePositionBottom: {
            CGFloat width = self.imageView.frame.size.width;
            CGFloat height = self.imageView.frame.size.height;
            CGFloat textInstrinsicWidth = self.titleLabel.intrinsicContentSize.width;
            CGFloat textInstrinsicHeight = self.titleLabel.intrinsicContentSize.height;
            self.imageEdgeInsets = UIEdgeInsetsMake(textInstrinsicHeight + spacing, 0, 0, -textInstrinsicWidth);
            self.titleEdgeInsets = UIEdgeInsetsMake(0, -width, height + spacing, 0);
        }
            break;
    }
}

@end
