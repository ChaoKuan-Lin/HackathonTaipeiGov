//
//  HistoryViewController.h
//  Hackathon
//
//  Created by CANUOVRX on 2016/3/12.
//  Copyright © 2016年 MoBagel Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CBStoreHouseRefreshControl/CBStoreHouseRefreshControl.h>

@interface HistoryViewController : UITableViewController
{
    NSMutableArray* reports;
    CBStoreHouseRefreshControl* storeHouseRefreshControl;
}
@end
