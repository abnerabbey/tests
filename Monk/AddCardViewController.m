//
//  AddCardViewController.m
//  Monk
//
//  Created by Abner Castro Aguilar on 01/11/15.
//  Copyright © 2015 Abner Castro Aguilar. All rights reserved.
//

#import "AddCardViewController.h"

@interface AddCardViewController ()

@end

@implementation AddCardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Añadir Tarjeta";
    self.buttonAddCard.layer.borderColor = [[UIColor colorWithRed:0.737 green:0.635 blue:0.506 alpha:1.0] CGColor];
    self.buttonAddCard.layer.borderWidth = 1.0;
}

- (IBAction)addCard:(UIButton *)sender {
}
@end




























































