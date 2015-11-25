//
//  TestViewController.m
//  Monk
//
//  Created by Abner Castro Aguilar on 15/11/15.
//  Copyright © 2015 Abner Castro Aguilar. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (IBAction)makePostRequest:(UIButton *)sender
{
    NSString *monkURL = @"https://monkapp.herokuapp.com";
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/feedback?objectId=WgJZpYb2RR", monkURL]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    NSDictionary *dictionary = @{@"calificaciones": @"prueba"};
    NSData *dataDictionary = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil];
    NSString *jsonStr1 = [[NSString alloc] initWithData:dataDictionary encoding:NSUTF8StringEncoding];
    [jsonStr1 stringByReplacingOccurrencesOfString:@"\\/" withString:@""];
    NSData *jsonData2 = [jsonStr1 dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPBody:jsonData2];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(!error){
            NSDictionary *dicResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"Response: %@", dicResponse);
        }
    }];
    [task resume];
    
}
@end












































































