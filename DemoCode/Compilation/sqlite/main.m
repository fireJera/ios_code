//
//  main.m
//  sqlite
//
//  Created by Jeremy on 2020/3/16.
//  Copyright © 2020 Jeremy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <mach/mach_time.h>

//void Munge8(void *data, uint32_t size) {
//    uint8_t * data8 = (uint8_t *)data;
//    uint8_t *data8End = data8 + size;
//    while (data8 != data8End) {
//        *data8++ = -*data8;
//    }
//}
//
//void Munge16(void *data, uint32_t size) {
//    uint16_t * data16 = (uint16_t *)data;
//    uint16_t * data16End = data16 + (size >> 1);
//    uint8_t * data8 = (uint8_t *)data16End;
//    uint8_t *data8End = data8 + (size & 0x00000001);
//    while (data16 != data16End) {
//        *data16++ = -*data16;
//    }
//    while (data8 != data8End) {
//        *data8++ = -*data8;
//    }
//}

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
//        uint64_t start = mach_absolute_time();
//
//        Munge8(<#void *data#>, <#uint32_t size#>);
//        Munge16(<#void *data#>, <#uint32_t size#>);
//
//        uint64_t stop = mach_absolute_time();
//        uint64_t difference = stop - start;
//        static double conversion = 0.0;
//        if( conversion == 0.0 )
//        {
//            mach_timebase_info_data_t info;
//            kern_return_t err =mach_timebase_info( &info );
//            //Convert the timebase into seconds
//            if( err == 0  )
//                conversion= 1e-9 * (double) info.numer / (double) info.denom;
//        }
//        float f = conversion * (double)difference;
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
