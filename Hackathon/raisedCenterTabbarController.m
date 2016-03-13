//
//  raisedCenterTabbarController.m
//  Hackathon
//
//  Created by CANUOVRX on 2016/3/12.
//  Copyright © 2016年 MoBagel Inc. All rights reserved.
//

#import "raisedCenterTabbarController.h"
#import "PickerHandler.h"
#import "AppDelegate.h"
#import "CaptureViewController.h"
#import "HistoryTableViewCell.h"

@interface raisedCenterTabbarController () <UITabBarControllerDelegate>

@end

@implementation raisedCenterTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    for (UIViewController* controller in self.viewControllers) {
        if ([controller isKindOfClass:[UINavigationController class]]){
            UINavigationController* nav = (UINavigationController*)controller;
            for (UIViewController* viewC in nav.viewControllers) {
                if ([viewC isKindOfClass:[CaptureViewController class]]) {
                    self.captureC = viewC;
                }
            }
        }
    }

    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:242.0/255.0 green:211.0/255.0 blue:153.0/255.0 alpha:1.0]];
    [[UITabBar appearance] setBarTintColor:[UIColor colorWithRed:235.0/255.0 green:184.0/255.0 blue:93.0/255.0 alpha:1.0]];
    
    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:217.0/255.0 green:65.0/255.0 blue:14.0/255.0 alpha:1.0]];
    
    // Change the title color of tab bar items
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor blackColor], NSForegroundColorAttributeName,
                                                       nil] forState:UIControlStateNormal];
    
//    UIColor *titleHighlightedColor = [UIColor colorWithRed:252/255.0 green:218/255.0 blue:49/255.0 alpha:1.0];
//    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                                       [UIColor colorWithRed:242.0/255.0 green:211.0/255.0 blue:153.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
//                                                       nil] forState:UIControlStateHighlighted];

    
    //initization centerButton
    self.centerButton = [[UIButton alloc] init];
    [self.centerButton setImage:[UIImage imageNamed:@"camera.png"] forState:UIControlStateNormal];
    [self.centerButton addTarget:self action:@selector(snap) forControlEvents:UIControlEventTouchUpInside];

//    self.tabBar.delegate = self;
}
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if (item.tag == 2) {
        self.centerButton.enabled = NO;
    }else{
        self.centerButton.enabled = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)snap
{
    [self.captureC capture];
//    PickerHandler* picker = [[PickerHandler alloc] init];
//    NSLog(@"%@",self.viewControllers);
//    UINavigationController* controller = self;
//    [picker setupFrom:controller];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
