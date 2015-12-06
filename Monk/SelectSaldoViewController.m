//
//  SelectSaldoViewController.m
//  Monk
//
//  Created by Abner Castro Aguilar on 06/12/15.
//  Copyright © 2015 Abner Castro Aguilar. All rights reserved.
//

#import "SelectSaldoViewController.h"

@interface SelectSaldoViewController ()

@end

@implementation SelectSaldoViewController
{
    BOOL isEditing;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Elige Saldo";
    UIBarButtonItem *okButton = [[UIBarButtonItem alloc] initWithTitle:@"Listo" style:UIBarButtonItemStyleDone target:self action:@selector(okView)];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancelar" style:UIBarButtonItemStylePlain target:self action:@selector(cancelView)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.rightBarButtonItem = okButton;
    self.textView.keyboardType = UIKeyboardTypeDecimalPad;
    self.textView.delegate = self;
    isEditing = NO;
}

#pragma mark TextView Delegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if(!isEditing){
        self.textView.text = @"";
        isEditing = YES;
    }
}

- (void)okView
{
    [[self delegate] didSelectSaldo:[self.textView.text floatValue]];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancelView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end




























































































