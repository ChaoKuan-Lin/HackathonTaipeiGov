//
//  HistoryViewController.m
//  Hackathon
//
//  Created by CANUOVRX on 2016/3/12.
//  Copyright © 2016年 MoBagel Inc. All rights reserved.
//

#import "HistoryViewController.h"
#import <Parse/Parse.h>
#import "HistoryTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#

@interface HistoryViewController ()

@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIAlertController* controller = [UIAlertController alertControllerWithTitle:@"讀取中" message:@"資料更新" preferredStyle:UIAlertControllerStyleAlert];
    
    [self presentViewController:controller animated:YES completion:^{
    }];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    storeHouseRefreshControl = [CBStoreHouseRefreshControl attachToScrollView:self.tableView target:self refreshAction:@selector(refresh) plist:@"storehouse" color:[UIColor blackColor] lineWidth:1.5 dropHeight:80 scale:1 horizontalRandomness:150 reverseLoadingAnimation:YES internalAnimationFactor:0.5];
    
    [self refresh];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [storeHouseRefreshControl scrollViewDidScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [storeHouseRefreshControl scrollViewDidEndDragging];
}

-(void)refresh{
    
    PFQuery* query = [PFQuery queryWithClassName:@"Report"];
    [query whereKey:@"Name" equalTo:[[PFUser currentUser] username]];

    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"object = %@",objects);
            reports = [objects sortedArrayUsingComparator:
                                ^(PFObject* obj1, PFObject* obj2) {
                                    return [obj2.createdAt compare:obj1.createdAt]; // note reversed comparison here
                                }];;

            
            [self.tableView reloadData];

            
            [self dismissViewControllerAnimated:YES completion:nil];

            [storeHouseRefreshControl finishingLoading];
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [reports count];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = indexPath.row;
    static NSString* cellIdentify = @"HistoryTableViewCell";
    HistoryTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];

    switch (row%3) {
        case 0:
            cell.backgroundColor = [UIColor colorWithRed:231.0/255.0 green:167.0/255.0 blue:113.0/255.0 alpha:1.0];
            break;
        case 1:
            cell.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:220.0/255.0 blue:185.0/255.0 alpha:1.0];
            break;
        case 2:
            cell.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:196.0/255.0 blue:152.0/255.0 alpha:1.0];
            break;
        default:
            break;
    }
    
    PFObject* object = [reports objectAtIndex:row];
    
    PFFile* picture = [object objectForKey:@"LicensePlatePicture"];
    [cell.views setImageWithURL:[NSURL URLWithString:[picture url]]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd hh:mm"];
    NSString *stringFromDate = [formatter stringFromDate:object.createdAt];
    [cell.date setText:stringFromDate];

    cell.address.text = [object objectForKey:@"Address"];

    if ([[object objectForKey:@"State"] isEqualToString:@"Pending"]) {
        [cell.status setText:@"受理中"];
    }else{
        [cell.status setText:@"已受理"];
    }
    
    //    NSLog(@"%@",[object objectForKey:@"Location"]);
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
