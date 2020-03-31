//
//  DYLDLoadCal.m
//  OptimizeLaunch
//
//  Created by Jeremy on 2020/3/26.
//  Copyright © 2020 jercouple. All rights reserved.
//

#import "DYLDLoadCal.h"
#import <objc/runtime.h>
#import <dlfcn.h>
#import <limits.h>
#import <mach-o/ldsyms.h>
#import <mach-o/dyld.h>
#import <mach-o/nlist.h>
#import <string.h>


#define TIMESTAMP_NUMBER(interval) [NSNumber numberWithLongLong:interval * 1000 * 1000]

unsigned int count;
const char **classes;

static NSMutableArray * _loadInfoArray;

@implementation DYLDLoadCal

//+ (void)load {
//    _loadInfoArray = [NSMutableArray array];
//    CFAbsoluteTime time1 = CFAbsoluteTimeGetCurrent();
//    int imageCount = (int)_dyld_image_count();
//    for (int i = 0; i < imageCount; i++) {
//        const char *path = _dyld_get_image_name((unsigned)i);
//        NSString * imagePath = [NSString stringWithUTF8String:path];
//        
//        NSBundle *mainBundle = [NSBundle mainBundle];
//        NSString *bundlePath = [mainBundle bundlePath];
//        if ([imagePath containsString:bundlePath] && ![imagePath containsString:@".dylib"]) {
//            classes = objc_copyClassNamesForImage(path, &count);
//            
//            for (int j = 0; j < count; j++) {
//                NSString *className = [NSString stringWithCString:classes[j] encoding:NSUTF8StringEncoding];
//                if (![className isEqualToString:@""] && className) {
//                    Class class = object_getClass(NSClassFromString(className));
//                    
//                    SEL originalSelector = @selector(load);
//                    SEL swizzledSelector = @selector(LDAPM_load);
//                    
//                    Method originalMethod = class_getClassMethod(class, originalSelector);
//                    Method swizzledMethod = class_getClassMethod([DYLDLoadCal class], swizzledSelector);
//                    
//                    BOOL hasMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
//                    
//                    if (!hasMethod) {
//                        BOOL didAddMethod = class_addMethod(class,
//                                                            swizzledSelector,
//                                                            method_getImplementation(swizzledMethod),
//                                                            method_getTypeEncoding(swizzledMethod));
//                        
//                        if (didAddMethod) {
//                            swizzledMethod = class_getClassMethod(class, swizzledSelector);
//                            
//                            method_exchangeImplementations(originalMethod, swizzledMethod);
//                        }
//                    }
//                }
//            }
//        }
//    }
//}
//
//+ (void)LDAPM_load {
//    CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
//    [self LDAPM_load];
//    CFAbsoluteTime end = CFAbsoluteTimeGetCurrent();
//    NSDictionary * infoDic = @{
//        @"st" : TIMESTAMP_NUMBER(start),
//        @"ed" : TIMESTAMP_NUMBER(end),
//        @"name" : NSStringFromClass([self class]),
//    };
//    [_loadInfoArray addObject:infoDic];
//}

@end
