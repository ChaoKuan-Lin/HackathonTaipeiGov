//
//  PickerHandler.m
//  Hackathon
//
//  Created by CANUOVRX on 2016/3/12.
//  Copyright © 2016年 MoBagel Inc. All rights reserved.
//

#import "PickerHandler.h"
#import "CaptureViewController.h"

@implementation PickerHandler 

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void) setupFrom:(UIViewController*)controller
{
    UINavigationController* captureC = [controller.storyboard instantiateViewControllerWithIdentifier:@"CaptureNavigationController"];
    
    [controller presentViewController:captureC animated:YES completion:^{
        
    }];
}


@end