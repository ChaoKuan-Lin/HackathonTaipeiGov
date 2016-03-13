//
//  CaptureViewController.h
//  Hackathon
//
//  Created by CANUOVRX on 2016/3/12.
//  Copyright © 2016年 MoBagel Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CaptureViewController;

@protocol TLCaptureControllerDelegate <NSObject>

- (void)captureController:(CaptureViewController *)captureController captureImages:(NSMutableArray*)images;
@end

@interface CaptureViewController : UIViewController
{
    IBOutlet UIView* hintView;
    NSMutableArray* images;
    CGPoint            hintBaseCenter;
    IBOutlet UILabel* label;
    
    UIAlertController* controller;
    NSInteger       maxCounter;
}
@property (nonatomic, weak) id <TLCaptureControllerDelegate> delegate;

- (void)capture;

@end
