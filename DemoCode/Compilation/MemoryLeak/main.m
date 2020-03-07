//
//  main.m
//  MemoryLeak
//
//  Created by Jeremy on 2019/6/21.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

#import "fishhook.h"

static void(*orignViewDidLoad)(void);

void myViewDidLoad() {
    printf("🤙🤙🤙myViewDidLoad🤙🤙🤙");
    orignViewDidLoad();
}

int main(int argc, char * argv[]) {
    rcd_rebind_symbols((struct rcd_rebinding[1]){
        "viewDidLoad",
        (void *)myViewDidLoad,
        (void *)orignViewDidLoad,
    }, 1);
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
