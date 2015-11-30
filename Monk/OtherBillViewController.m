//
//  OtherBillViewController.m
//  Monk
//
//  Created by Abner Castro Aguilar on 29/11/15.
//  Copyright © 2015 Abner Castro Aguilar. All rights reserved.
//

#import "OtherBillViewController.h"

@interface OtherBillViewController ()

@end

@implementation OtherBillViewController
{
    BOOL isEditing;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Otra propina";
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancelar" style:UIBarButtonItemStylePlain target:self action:@selector(cancelView)];
    UIBarButtonItem *okButton = [[UIBarButtonItem alloc] initWithTitle:@"Listo" style:UIBarButtonItemStyleDone target:self action:@selector(okView)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.rightBarButtonItem = okButton;
    self.textOtherView.keyboardType = UIKeyboardTypeDecimalPad;
    self.textOtherView.delegate = self;
    isEditing = NO;
}

#pragma mark TextView Delegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if(!isEditing){
        isEditing = YES;
        textView.text = @"";
    }
}

- (void)cancelView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)okView
{
    [[self delegate] didSelectOtherBill:[self.textOtherView.text floatValue]];
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end












































































