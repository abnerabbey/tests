//
//  CardViewController.m
//  Monk
//
//  Created by Abner Castro Aguilar on 31/10/15.
//  Copyright © 2015 Abner Castro Aguilar. All rights reserved.
//

#import "CardViewController.h"

@interface CardViewController ()

- (void)addCard;

@end

@implementation CardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Tu Tarjeta";
    
    UIBarButtonItem *okButton = [[UIBarButtonItem alloc] initWithTitle:@"Listo" style:UIBarButtonItemStyleDone target:self action:@selector(okView)];
    okButton.tintColor = [UIColor colorWithRed:0.737 green:0.635 blue:0.506 alpha:1.0];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addCard)];
    addButton.tintColor = [UIColor colorWithRed:0.737 green:0.635 blue:0.506 alpha:1.0];
    
    self.navigationItem.leftBarButtonItem = addButton;
    self.navigationItem.rightBarButtonItem = okButton;
}

- (void)addCard
{
    [self performSegueWithIdentifier:@"addCard" sender:self];
}

- (void)okView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end






























































