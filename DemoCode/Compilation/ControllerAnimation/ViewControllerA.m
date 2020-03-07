//
//  ViewControllerA.m
//  ViewAnimation
//
//  Created by super on 2018/12/17.
//  Copyright © 2018 Jeremy. All rights reserved.
//

#import "ViewControllerA.h"

@interface ViewControllerA ()

@end

@implementation ViewControllerA

//- (instancetype)initWithCoder:(NSCoder *)aDecoder {
//    if (self = [super initWithCoder:aDecoder]) {
//        self.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//    }
//    return self;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)popFromb:(UIStoryboardSegue *)segue {
    if ([segue.identifier isEqualToString:@"btoa"]) {
        NSLog(@"btoa");
    }
}

@end
