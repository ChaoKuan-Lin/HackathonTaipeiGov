//
//  InfoViewController.m
//  Hackathon
//
//  Created by CANUOVRX on 2016/3/12.
//  Copyright © 2016年 MoBagel Inc. All rights reserved.
//

#import "InfoViewController.h"
#import "MyPageView.h"
#import <Parse/Parse.h>
#import "OCRHandler.h"
#import <LMGeocoder/LMGeocoder.h>


@interface InfoViewController ()<CLLocationManagerDelegate, HGPageScrollViewDelegate, HGPageScrollViewDataSource, scanDelegate , UITextFieldDelegate>

@end

@implementation InfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    raw1.image = [self.images  objectAtIndex:0];
//    raw2.image = [self.images  objectAtIndex:1];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager requestWhenInUseAuthorization];
    [locationManager startUpdatingLocation];
    
    licensePlateField.delegate = self;
    [[OCRHandler sharedInstance] setDelegate:self];

    [licensePlateField setText:[[OCRHandler sharedInstance] lastString]];
    [[OCRHandler sharedInstance] setLastString:nil];
    
    // now that we have the data, initialize the page scroll view
    _myPageScrollView = [[[NSBundle mainBundle] loadNibNamed:@"HGPageScrollView" owner:self options:nil] objectAtIndex:0];
    _myPageScrollView.delegate = self;
    [photosView addSubview:_myPageScrollView];
    
    [[OCRHandler sharedInstance] setDelegate:self];
    [[OCRHandler sharedInstance] OCR:[self.images objectAtIndex:0]];
}

-(void)response:(NSString *)scanText{
    if ([scanText isEqualToString:@""]) {
        [self dismissViewControllerAnimated:YES completion:nil];
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"錯誤" message:@"無法偵測車牌" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* alert = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [alertController addAction:alert];
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
        [licensePlateField setText:scanText];
    }

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // Navigation animation
    [self.navigationController.navigationBar setHidden:NO];
    [UIView animateWithDuration:0.3 delay:0.0 options:0 animations:^{
        self.navigationController.navigationBar.alpha = 1.0;
    } completion:^(BOOL finished) {
        loadingLicensePlate = [UIAlertController alertControllerWithTitle:@"車牌辨識中" message:@"請勿關閉此頁" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:loadingLicensePlate animated:YES completion:nil];
        
    }];
}


#pragma mark - HGPageScrollViewDataSource


- (NSInteger)numberOfPagesInScrollView:(HGPageScrollView *)scrollView;   // Default is 0 if not implemented
{
    return [self.images count];
}

- (HGPageView *)pageScrollView:(HGPageScrollView *)scrollView viewForPageAtIndex:(NSInteger)index;
{
    
    static NSString *pageId = @"pageId";
    MyPageView *pageView = [scrollView dequeueReusablePageWithIdentifier:pageId];
    
    if (!pageView) {
        // load a new page from NIB file
        pageView = [[[NSBundle mainBundle] loadNibNamed:@"MyPageView" owner:self options:nil] objectAtIndex:0];
        pageView.reuseIdentifier = pageId;
    }
    
    // configure the page
    
    UIImageView *imageView = (UIImageView*)[pageView viewWithTag:2];
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    [imageView setImage:[self.images objectAtIndex:index]];
    UITextView *textView = (UITextView*)[pageView viewWithTag:3];

    //adjust content size of scroll view
    UIScrollView *pageContentsScrollView = (UIScrollView*)[pageView viewWithTag:10];
    pageContentsScrollView.scrollEnabled = NO; //initially disable scroll
    
    // set the pageView frame height
    CGRect frame = pageView.frame;
    frame.size.height = 420;
    pageView.frame = frame;
    return pageView;
}


#pragma mark - HGPageScrollViewDelegate


-(IBAction)upload:(id)sender
{
    UIAlertController* controller = [UIAlertController alertControllerWithTitle:@"資料上傳..." message:@"請勿關閉應用程式" preferredStyle:UIAlertControllerStyleAlert];

    [self presentViewController:controller animated:YES completion:^{
    }];
    
    PFObject *testObject = [PFObject objectWithClassName:@"Report"];
    
    testObject[@"LicensePlatePicture"] = [PFFile fileWithData:UIImagePNGRepresentation([self.images  objectAtIndex:0])];
    
    NSMutableArray* Pictures = [[NSMutableArray alloc] initWithCapacity:self.images.count-1];
    for (int i = 1; i<self.images.count; i++) {
        [Pictures addObject:[PFFile fileWithData:UIImagePNGRepresentation([self.images  objectAtIndex:i])]];
    }
    testObject[@"Pictures"] = Pictures;
    
    testObject[@"LicensePlate"] = licensePlateField.text;
    testObject[@"Location"] = lastGeoPoint;
    testObject[@"State"] = @"Pending";
    
    testObject[@"Name"] = [[PFUser currentUser] username];
    CLLocationCoordinate2D coordinate =  CLLocationCoordinate2DMake(lastGeoPoint.latitude, lastGeoPoint.longitude );
    [[LMGeocoder sharedInstance] reverseGeocodeCoordinate:coordinate
                                                  service:kLMGeocoderGoogleService
                                        completionHandler:^(NSArray *results, NSError *error) {
                                            if (results.count && !error) {
                                                LMAddress *address = [results firstObject];
                                                NSLog(@"Address: %@", address.formattedAddress);
                                                testObject[@"Address"] = address.formattedAddress;
                                                
                                                [testObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                                                    [controller setTitle:@"資料已上傳"];
                                                    [controller setMessage:@"感謝您的回報"];
                                                    if (succeeded) {
                                                        UIAlertAction* alert = [UIAlertAction actionWithTitle:@"確認" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                                            [self.navigationController popToRootViewControllerAnimated:YES];
                                                        }];
                                                        [controller addAction:alert];
                                                    }else{
                                                        [controller setTitle:@"Error"];
                                                        UIAlertAction* alert = [UIAlertAction actionWithTitle:error.description style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                                        }];
                                                        [controller addAction:alert];
                                                    }
                                                }];

                                                
                                            }
                                        }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return NO;
}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {

    lastGeoPoint = [PFGeoPoint geoPointWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
    
    
}

@end
