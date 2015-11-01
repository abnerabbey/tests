//
//  InitialViewController.m
//  Monk
//
//  Created by Abner Castro Aguilar on 30/10/15.
//  Copyright © 2015 Abner Castro Aguilar. All rights reserved.
//

#import "InitialViewController.h"

@interface InitialViewController ()

@end

@implementation InitialViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    //Interface customization
    self.buttonLogin.layer.borderWidth = 1.0;
    self.buttonLogin.layer.borderColor = [[UIColor colorWithRed:0.737 green:0.635 blue:0.506 alpha:1.0] CGColor];
}


- (IBAction)logInWithFacebook:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"logedIn" sender:self];
}
@end



























































