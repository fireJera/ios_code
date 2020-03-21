//
//  main.m
//  Socket
//
//  Created by Jeremy on 2020/3/21.
//  Copyright © 2020 Jeremy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface Te : NSObject
    
@end

@implementation Te

@end

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
