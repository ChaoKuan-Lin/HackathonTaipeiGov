//
//  OCRHandler.h
//  Hackathon
//
//  Created by CANUOVRX on 2016/3/12.
//  Copyright © 2016年 MoBagel Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Client.h"
#import <UIKit/UIKit.h>

@protocol scanDelegate <NSObject>

- (void)response:(NSString*)scanText;
@end

@interface OCRHandler : NSObject
{


}

@property(nonatomic, readwrite, strong)NSString* lastString;
@property(nonatomic, readwrite, weak)id<scanDelegate> delegate;

+(id)sharedInstance;
-(void)OCR:(UIImage*)image;

@end
