//
//  SaldoCardViewController.m
//  Monk
//
//  Created by Abner Castro Aguilar on 08/12/15.
//  Copyright © 2015 Abner Castro Aguilar. All rights reserved.
//

#import "SaldoCardViewController.h"

@interface SaldoCardViewController ()

@end

@implementation SaldoCardViewController
{
    BOOL isEditing;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Saldo tarjeta";
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
        textView.text = @"";
        isEditing = YES;
    }
}

- (void)okView
{
    [[self delegate] didSelectSaldoCard:[self.textView.text floatValue]];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancelView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end

































































































