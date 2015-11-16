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

@interface RateViewController ()

@end

@implementation RateViewController
{
    DXStarRatingView *ratingView;
    int rating;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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



- (IBAction)rateMonk:(UIButton *)sender
{
    if(rating <= 3)
        [self performSegueWithIdentifier:@"feedback" sender:self];
    else
        [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"feedback"])
    {
        FeedbackViewController *feedView = [segue destinationViewController];
        feedView.numberOfStars = rating;
    }
}

- (void)cancelRateView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end















































































