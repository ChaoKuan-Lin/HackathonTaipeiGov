//
//  raisedCenterTabbarController.h
//  Hackathon
//
//  Created by CANUOVRX on 2016/3/12.
//  Copyright © 2016年 MoBagel Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FinalRaisedCenterTabController/FinalRaisedCenterTabController.h>
#import "CaptureViewController.h"

@interface raisedCenterTabbarController : FinalRaisedCenterTabController
{
}

@property(nonatomic, readwrite, strong)CaptureViewController* captureC;


@end
