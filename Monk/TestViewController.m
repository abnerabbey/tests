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
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/cupon/registrar", monkURL]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    NSDictionary *cuponDictionary = @{@"cupon": @"4332jwe9"};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:cuponDictionary options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *cupon = @"cupon=23423fj";
    NSLog(@"String: %@", cupon);
    [request setHTTPBody:[cupon dataUsingEncoding:NSUTF8StringEncoding]];
    
    //[request setHTTPBody:jsonData];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(!error){
            NSDictionary *dicData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"Response: %@", dicData);
        }
        else
            NSLog(@"error description: %@", error.description);
    }];
    [task resume];
}
@end












































































