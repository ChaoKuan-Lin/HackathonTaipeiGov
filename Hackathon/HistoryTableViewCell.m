//
//  HistoryTableViewCell.m
//  Hackathon
//
//  Created by CANUOVRX on 2016/3/12.
//  Copyright © 2016年 MoBagel Inc. All rights reserved.
//

#import "HistoryTableViewCell.h"

@implementation HistoryTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [[self.views layer] setCornerRadius:10];
    [[self.views layer] setMasksToBounds:YES];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
