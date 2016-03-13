//
//  HistoryTableViewCell.h
//  Hackathon
//
//  Created by CANUOVRX on 2016/3/12.
//  Copyright © 2016年 MoBagel Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryTableViewCell : UITableViewCell
{

}

@property(nonatomic, readwrite, weak) IBOutlet UILabel* date;
@property(nonatomic, readwrite, weak) IBOutlet UILabel* status;
@property(nonatomic, readwrite, weak) IBOutlet UIImageView* views;
@property(nonatomic, readwrite, weak) IBOutlet UILabel* address;
@end
