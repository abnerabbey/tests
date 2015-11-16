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
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/user/registrar", monkURL]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/user/registrar?user[nombre]=AbnerAbbey&user[email]=abner@hotmail.com&user[password]=1223344&user[objectId]=234234&user[token]=34534553&user[device]=iOS", monkURL]]];
    [request setHTTPMethod:@"POST"];
    
    //OPCIÓN 1
    NSDictionary *dictionary = @{@"email": @"prueba1010@hotmail.com", @"password": @"12345678", @"objectId": @"12389hdsj2", @"token": @"asdoijqo3093u4"};
    //OPCIÓN 2
    NSDictionary *userDictionary = @{@"user": dictionary};
    
    //OPCIÓN 3
    NSString *params = @"email=prueba@hotmail.com&password=12345678&objectId=12389hdsj2&token=asdoijqo3093u4";
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:userDictionary options:NSJSONWritingPrettyPrinted error:nil];
    //NSLog(@"%@", [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding]);
    
    //[request setHTTPBody:data];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(!error){
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"dictionary: %@", dictionary);
        }
    }];
    [task resume];
}
@end












































































