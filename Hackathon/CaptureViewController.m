//
//  CaptureViewController.m
//  Hackathon
//
//  Created by CANUOVRX on 2016/3/12.
//  Copyright © 2016年 MoBagel Inc. All rights reserved.
//

#import "CaptureViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "InfoViewController.h"
#import "OCRHandler.h"

@interface CaptureViewController ()

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureDevice *device;
@property (nonatomic, strong) AVCaptureStillImageOutput *output;

@end

@implementation CaptureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    maxCounter = 5;
    
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    [self.navigationController.navigationBar setHidden:YES];
    
    images = [[NSMutableArray alloc] initWithCapacity:2];
    
    self.session = [[AVCaptureSession alloc] init];
    self.session.sessionPreset = AVCaptureSessionPresetPhoto;
    
    NSArray *myDevices = [AVCaptureDevice devices];
    
    NSError *error = nil;
    for (AVCaptureDevice *device in myDevices) {
        if ([device position] == AVCaptureDevicePositionBack) {
            
            AVCaptureDeviceInput *myDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
            
            if (error) {
                //裝置取得失敗時的處理常式
            } else {
                [self.session addInput:myDeviceInput];
            }
            break;
        }
    }
    
    hintBaseCenter = [hintView center];
    [hintView setCenter:CGPointMake(hintBaseCenter.x, hintBaseCenter.y+50)];
    
    [hintView setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.6f]];
    [hintView.layer setCornerRadius:10];
    
    controller = [UIAlertController alertControllerWithTitle:@"繼續拍攝" message:@"更多影片?" preferredStyle:UIAlertControllerStyleAlert];
    

    UIAlertAction* alert = [UIAlertAction actionWithTitle:@"繼續" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [controller addAction:alert];
    alert = [UIAlertAction actionWithTitle:@"確認" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self performSegueWithIdentifier:@"infoSeg" sender:nil];
    }];
    [controller addAction:alert];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [images removeAllObjects];
    
    self.navigationController.navigationBar.translucent = YES;
    
    //hide navigation bar
    [UIView animateWithDuration:0.3 delay:0.0 options:0 animations:^{
        self.navigationController.navigationBar.alpha = 0.0;
    } completion:NULL];
}

-(void)animation:(BOOL)bottom text:(NSString*)text
{
    label.text = text;
    if (bottom) {
        [hintView setCenter:CGPointMake(hintBaseCenter.x, hintBaseCenter.y+100)];
    }

    hintView.alpha = 0;
    [UIView animateWithDuration:0.8f animations:^{
        hintView.alpha = 0.9;
        [hintView setCenter:CGPointMake(hintView.center.x, hintView.center.y-100)];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.0f animations:^{
            hintView.alpha = 1.0;
            [hintView setCenter:CGPointMake(hintBaseCenter.x, hintBaseCenter.y)];
        }];
    }];

}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    [self animation:YES text:@"請拍攝車牌"];
    
    if (self.session.isRunning) {
        return;
    }
    float viewWidth = self.view.frame.size.width;
    float viewHeight = self.view.frame.size.height;
    
    //建立 AVCaptureVideoPreviewLayer
    AVCaptureVideoPreviewLayer *myPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    [myPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    [myPreviewLayer setBounds:CGRectMake(0, 0, viewWidth, viewHeight)];
    
    UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
    [myView.layer addSublayer:myPreviewLayer];
    myView.center = CGPointMake(viewWidth , viewHeight);
    
    [self.view addSubview:myView];
    
    self.output = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *myOutputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey,nil];
    [self.output setOutputSettings:myOutputSettings];
    
    [self.session addOutput:self.output];
    [self.view bringSubviewToFront:hintView];
    //啟用攝影機
    [self.session startRunning];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];

}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)capture {
    [self.output captureStillImageAsynchronouslyFromConnection:[self.output.connections objectAtIndex:0] completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        NSData *data = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];

        NSLog(@"snap...");
        UIImage* IMAGE = [[UIImage alloc] initWithData:data];
        
        [images addObject:[self imageWithImage:IMAGE scaledToSize:CGSizeMake(320, 480)]];
        if (images.count == 1){
            [UIView animateWithDuration:0.05f animations:^{
                [hintView setCenter:CGPointMake(hintBaseCenter.x, hintBaseCenter.y-10)];
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.5f animations:^{
                    [hintView setCenter:CGPointMake(hintBaseCenter.x, hintBaseCenter.y+100)];
                }];
            }];
            
            UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"繼續" message:@"請拍攝至少一張全景圖" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* alert = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
            [alertController addAction:alert];
            [self presentViewController:alertController animated:YES completion:nil];
            
        }else if (images.count == maxCounter){
            [self performSegueWithIdentifier:@"infoSeg" sender:nil];
        
        }else{
            [self presentViewController:controller animated:YES completion:^{
                

            }];
        }
    }];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    InfoViewController* controller = segue.destinationViewController;
    if ([controller isKindOfClass:[InfoViewController class]]) {
        controller.images = images;
    }
}

@end
