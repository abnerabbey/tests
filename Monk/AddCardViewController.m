//
//  AddCardViewController.m
//  Monk
//
//  Created by Abner Castro Aguilar on 01/11/15.
//  Copyright © 2015 Abner Castro Aguilar. All rights reserved.
//

#import "AddCardViewController.h"
#import "Conekta.h"
#import <Parse/Parse.h>

@interface AddCardViewController ()

@end

@implementation AddCardViewController
{
    Conekta *conekta;
    
    NSString *monkURL;
}

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
    
    conekta = [[Conekta alloc] init];
    [conekta setDelegate:self];
    [conekta setPublicKey:@"key_Dffvvfy47F1oLLmYCrrDz7A"];
    [conekta collectDevice];
    
    monkURL = @"https://monkapp.herokuapp.com";
    
    
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

- (IBAction)addCard:(UIButton *)sender
{
    if([self.textFieldTarjeta.text isEqualToString:@""] || [self.textFieldCVV.text isEqualToString:@""] || ([self.textFieldExpiration.text isEqualToString:@""] || self.textFieldExpiration.text.length < 6) || [self.textFieldNombre.text isEqualToString:@""])
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Ups" message:@"Asegúrate de llenar los campos correctamente" preferredStyle:UIAlertControllerStyleAlert];
        [alert.view setTintColor:[UIColor colorWithRed:0.737 green:0.635 blue:0.506 alpha:1.0]];
        [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else{
        NSString *monthExpiration = [self.textFieldExpiration.text substringWithRange:NSMakeRange(0, 2)];
        NSString *yearExpiration = [self.textFieldExpiration.text substringWithRange:NSMakeRange(2, 4)];
        Card *card = [conekta.Card initWithNumber:self.textFieldTarjeta.text name:self.textFieldNombre.text cvc:self.textFieldCVV.text expMonth:monthExpiration expYear:yearExpiration];
        Token *token = [conekta.Token initWithCard:card];
        [token createWithSuccess:^(NSDictionary *data) {
            [self showAlertResponse:[data objectForKey:@"message"]];
            NSLog(@"data.%@", data);
            [self sendTokenToServer:[data objectForKey:@"code"]];
        } andError:^(NSError *error) {
        }];
    }
}

- (void)showAlertResponse:(NSString *)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Respuesta" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
    [alert.view setTintColor:[UIColor colorWithRed:0.737 green:0.635 blue:0.506 alpha:1.0]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)sendTokenToServer:(NSString *)token
{
    PFUser *user = [PFUser currentUser];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/tarjeta/registrar?objectId=%@", monkURL, user.objectId]];
    NSURLSession *session = [NSURLSession sharedSession];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    NSString *stringToken = [NSString stringWithFormat:@"conektaTokenId=%@&nombre=%@&telefono=""", token, self.textFieldNombre.text];
    NSData *tokenData = [stringToken dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:tokenData];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(!error){
            NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"dictResponse: %@", dictResponse);
            dispatch_async(dispatch_get_main_queue(), ^{
                [[self navigationController] popViewControllerAnimated:YES];
            });
        }
    }];
    [task resume];
}

- (void)sendTest
{
    PFUser *user = [PFUser currentUser];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/tarjeta/registrar?objectId=%@", monkURL, user.objectId]];
    NSURLSession *session = [NSURLSession sharedSession];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    NSString *stringToken = [NSString stringWithFormat:@"conektaTokenId=tok_test_amex_8431&nombre=JuanPerez&telefono="""];
    NSData *tokenData = [stringToken dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:tokenData];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(!error){
            NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"dictResponse: %@", dictResponse);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    }];
    [task resume];
}

@end




























































