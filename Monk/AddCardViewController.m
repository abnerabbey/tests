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
    
    self.textFieldTarjeta.keyboardType = UIKeyboardTypeNumberPad;
    self.textFieldCVV.keyboardType = UIKeyboardTypeNumberPad;
    self.textFieldExpiration.keyboardType = UIKeyboardTypeNumberPad;
    
    self.textFieldTarjeta.delegate = self;
    self.textFieldCVV.delegate = self;
    self.textFieldExpiration.delegate = self;
    self.textFieldNombre.delegate = self;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Atención!" message:@"Tus tarjetas se guardarán de manera segura en el servidor, nunca en tu dispositivo!" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
    [alert.view setTintColor:[UIColor colorWithRed:0.737 green:0.635 blue:0.506 alpha:1.0]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark TextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)hideKeyboard:(UITapGestureRecognizer *)sender
{
    [[self view] endEditing:YES];
}

- (IBAction)addCard:(UIButton *)sender {
}
@end




























































