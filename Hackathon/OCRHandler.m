//
//  OCRHandler.m
//  Hackathon
//
//  Created by CANUOVRX on 2016/3/12.
//  Copyright © 2016年 MoBagel Inc. All rights reserved.
//

#import "OCRHandler.h"
#import "ImageProccessor.h"
#import <AFNetworking/AFNetworking.h>
// Name of application you created
static NSString* MyApplicationID = @"HackathonTestingggg";
// Password should be sent to your e-mail after application was created
static NSString* MyPassword = @"OjQO/giaF120DKrbXhnZJRz6";

@interface OCRHandler ()<ClientDelegate>

@end

@implementation OCRHandler

static OCRHandler* instance = nil;

+(id)sharedInstance{
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}
+ (id)allocWithZone:(NSZone *)zone {
    
    return [self sharedInstance];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void)OCR:(UIImage*)image{
    
    NSDictionary* dic = @{
                          @"secret_key" : @"",
                          @"country" : @"au,auwide,eu,gb,kr,mx,sg,us",
                          @"tasks" : @"plate",
                          };
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:@"https://api.openalpr.com/v1/recognize" parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 1.0) name:@"image" fileName:@"image.jpg" mimeType:@"image/jpeg"];
        //        [formData appendPartWithFormData:UIImageJPEGRepresentation(image, 1.0) name:@"image"];
    } error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:nil
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      if (error) {
                          NSLog(@"Error: %@", error);
                      } else {
                          NSLog(@"%@ %@", response, responseObject);
                          NSArray* result = [[responseObject objectForKey:@"plate"] objectForKey:@"results"];
                          if (result.count > 0) {
                              [self.delegate response:[[[[result objectAtIndex:0] objectForKey:@"candidates"] objectAtIndex:0] objectForKey:@"plate"]];
                          }else{
                              [self.delegate response:@""];
                          }

                      }
                  }];
    
    [uploadTask resume];
    


}

@end
