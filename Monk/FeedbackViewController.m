//
//  FeedbackViewController.m
//  Monk
//
//  Created by Abner Castro Aguilar on 06/11/15.
//  Copyright © 2015 Abner Castro Aguilar. All rights reserved.
//

#import "FeedbackViewController.h"

@interface FeedbackViewController ()

@end

@implementation FeedbackViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Tu Feedback";
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Listo" style:UIBarButtonItemStyleDone target:self action:@selector(okView)];
    [doneButton setTintColor:[UIColor colorWithRed:0.737 green:0.635 blue:0.506 alpha:1.0]];
    self.navigationItem.rightBarButtonItem = doneButton;
}

- (void)okView
{
    [self showAbonoAlert];
}

- (void)showAbonoAlert
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"¡Gracias por tu Feedback!" message:@"Es importante para nosotros poder mejorar.\nTe hemos abonado $15.00 MXN para tu siguiente compra." preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    [[alert view] setTintColor:[UIColor colorWithRed:0.737 green:0.635 blue:0.506 alpha:1.0]];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
