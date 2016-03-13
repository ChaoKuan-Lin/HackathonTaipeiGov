//
//  InfoViewController.h
//  Hackathon
//
//  Created by CANUOVRX on 2016/3/12.
//  Copyright © 2016年 MoBagel Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "HGPageScrollView.h"
#import <Parse/Parse.h>

@interface InfoViewController : UIViewController
{
    IBOutlet UIImageView* raw1;

    IBOutlet UITextField* licensePlateField;

    
    CLLocationManager *locationManager;
    
    HGPageScrollView *_myPageScrollView;
    PFGeoPoint*         lastGeoPoint;
    
    IBOutlet UIView*    photosView;
    
    UIActivityViewController* activityView;

    UIAlertController* loadingLicensePlate;
}

@property (nonatomic, weak) NSArray* images;



@end
