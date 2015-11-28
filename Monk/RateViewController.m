//
//  RateViewController.m
//  Monk
//
//  Created by Abner Castro Aguilar on 06/11/15.
//  Copyright © 2015 Abner Castro Aguilar. All rights reserved.
//

#import "RateViewController.h"
#import "DXStarRatingView.h"
#import "FeedbackViewController.h"
#import <Parse/Parse.h>

@interface RateViewController ()

@end

@implementation RateViewController
{
    DXStarRatingView *ratingView;
    int rating;
    
    NSString *monkURL;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    monkURL = @"https://monkapp.herokuapp.com";
    
    self.navigationItem.title = @"Califícanos";
    self.buttonRate.layer.borderWidth = 1.0;
    self.buttonRate.layer.borderColor = [[UIColor colorWithRed:0.737 green:0.635 blue:0.506 alpha:1.0] CGColor];
    self.buttonRate.layer.cornerRadius = 3.0;
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancelar" style:UIBarButtonItemStylePlain target:self action:@selector(cancelRateView)];
    [cancelButton setTintColor:[UIColor colorWithRed:0.737 green:0.635 blue:0.506 alpha:1.0]];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    ratingView = [[DXStarRatingView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 60.0, self.view.frame.size.height/2 - 22.0, self.view.frame.size.width - 40.0, 44.0)];
    rating = 5;
    [ratingView setStars:5 callbackBlock:^(NSNumber *newRating) {
        rating = [newRating intValue];
    }];
    [[self view] addSubview:ratingView];
}


#pragma mark IBActions
- (IBAction)rateMonk:(UIButton *)sender
{
    if(rating <= 3)
        [self performSegueWithIdentifier:@"feedback" sender:self];
    else{
        [self showAbonoAlert];
        [self sendFeedBackToServer];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"feedback"])
    {
        FeedbackViewController *feedView = [segue destinationViewController];
        feedView.numberOfStars = rating;
    }
}

#pragma mark Other Methods
- (void)cancelRateView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showAbonoAlert
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"¡Gracias por tu Feedback!" message:@"Es importante para nosotros poder mejorar." preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:^{
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    }]];
    [[alert view] setTintColor:[UIColor colorWithRed:0.737 green:0.635 blue:0.506 alpha:1.0]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)sendFeedBackToServer
{
    PFUser *user = [PFUser currentUser];
    NSURL *feedbackURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/feedback?objectId=%@", monkURL, user.objectId]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:feedbackURL];
    [request setHTTPMethod:@"POST"];
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSString *stringfFeedback = [NSString stringWithFormat:@"ranking=%d", rating];
    NSData *dataFeedback = [stringfFeedback dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:dataFeedback];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(!error){
            NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"dictResponse: %@", dictResponse);
        }
    }];
    [task resume];
}

@end















































































