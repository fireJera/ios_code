//
//  UIDevice+WALME_Custom.m
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import "UIDevice+WALME_Custom.h"

@implementation UIDevice (WALME_Custom)

- (BOOL)isPad {
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        //ipad
        return YES;
    } else {
        //iphone
        return NO;
    }
}

@end
