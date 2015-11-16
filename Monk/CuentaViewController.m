//
//  CuentaViewController.m
//  Monk
//
//  Created by Abner Castro Aguilar on 30/10/15.
//  Copyright © 2015 Abner Castro Aguilar. All rights reserved.
//

#import "CuentaViewController.h"
#import "ProfileViewController.h"
#import "CardViewController.h"
#import "RateViewController.h"
#import <Parse/Parse.h>

@interface CuentaViewController ()

- (void)showAlertPromoCode;
- (BOOL)accountIsOpen;
- (void)openAccount;
- (void)showFeedbackView;

@end

@implementation CuentaViewController
{
    UIButton *buttonStart;
    
    NSURL *cuponURL;
    NSString *monkURL;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.buttonPay.layer.cornerRadius = 3.0;
    
    //Verificar primero si la cuenta está abierta
    [self setFirstViewInterface];
    [self performSelector:@selector(showFeedbackView) withObject:nil afterDelay:1.0];
    
    monkURL = @"https://monkapp.herokuapp.com";
    cuponURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/cupon/registrar", monkURL]];
}


#pragma mark IBActions
- (IBAction)showMoreOptions:(UIBarButtonItem *)sender
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Más Opciones" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"Tus Tarjetas" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        CardViewController *cardView = [[self storyboard] instantiateViewControllerWithIdentifier:@"cardView"];
        UINavigationController *nv = [[UINavigationController alloc] initWithRootViewController:cardView];
        [self presentViewController:nv animated:YES completion:nil];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Compartir Mi Código" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ProfileViewController *profileView = [[self storyboard] instantiateViewControllerWithIdentifier:@"profileView"];
        UINavigationController *nv = [[UINavigationController alloc] initWithRootViewController:profileView];
        [self presentViewController:nv animated:YES completion:nil];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Introduce Un Código" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showAlertPromoCode];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cerrar Sesión" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [PFUser logOut];
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancelar" style:UIAlertActionStyleCancel handler:nil]];
    [alert.view setTintColor:[UIColor colorWithRed:0.737 green:0.635 blue:0.506 alpha:1.0]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark Other Methods
- (void)showAlertPromoCode
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Introduce Un Código" message:@"Introduce tu código de promoción :)\nPuedes hacerlo en cualquier otro momento" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Verificar" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textField = (UITextField *)alert.textFields[0];
        NSString *textFromTextField = textField.text;
        
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicator.frame = CGRectMake(self.view.frame.size.width / 2 - 24.0, self.view.frame.size.height / 2 - 24.0, 24.0, 24.0);
        [activityIndicator startAnimating];
        [[self view] addSubview:activityIndicator];
        self.navigationItem.title = @"Verificando código...";
        
        [self verifyPromoCode:textFromTextField];
        
        [activityIndicator removeFromSuperview];
        self.navigationItem.title = @"Tu Cuenta";
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancelar" style:UIAlertActionStyleDefault handler:nil]];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
    }];
    [alert.view setTintColor:[UIColor colorWithRed:0.737 green:0.635 blue:0.506 alpha:1.0]];
    [self presentViewController:alert animated:YES completion:nil];
}



- (BOOL)accountIsOpen
{
    return YES;
}

- (void)openAccount
{
    //Verificar primero si hay tarjeta asociada
    buttonStart.hidden = YES;
    self.tableAccount.hidden = NO;
    self.buttonPay.hidden = NO;
    self.buttonRefresh.enabled = YES;
}

- (void)showFeedbackView
{
    RateViewController *rateView = [[self storyboard] instantiateViewControllerWithIdentifier:@"rateView"];
    UINavigationController *nv = [[UINavigationController alloc] initWithRootViewController:rateView];
    [self presentViewController:nv animated:YES completion:nil];
}

#pragma mark Auxiliar Methods
- (void)setFirstViewInterface{
    self.tableAccount.hidden = YES;
    self.buttonPay.hidden = YES;
    self.buttonRefresh.enabled = NO;
    
    buttonStart = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    buttonStart.frame = CGRectMake(self.view.frame.size.width/2 - self.view.frame.size.width/2 + 10.0, self.view.frame.size.height/2 - 22.0, self.view.frame.size.width - 20.0, 44.0);
    [buttonStart addTarget:self action:@selector(openAccount) forControlEvents:UIControlEventAllTouchEvents];
    [buttonStart setTitle:@"Abrir Cuenta" forState:UIControlStateNormal];
    [buttonStart setTintColor:[UIColor whiteColor]];
    [buttonStart setBackgroundColor:[UIColor colorWithRed:0.737 green:0.635 blue:0.506 alpha:1.0]];
    buttonStart.layer.cornerRadius = 3.0;
    [self.view addSubview:buttonStart];
    
}

- (BOOL)isPromoCodeValid:(NSString *)promoCode
{
    NSLog(@"Pasó con el promo code: %@", promoCode);
    return YES;
}

- (void)verifyPromoCode:(NSString *)promoCode
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:cuponURL];
    NSURLSession *sessionPost = [NSURLSession sharedSession];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[promoCode dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionDataTask *task = [sessionPost dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(!error){
            NSError *jsonError;
            NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
            dispatch_async(dispatch_get_main_queue(), ^{
                if([[dictResponse objectForKey:@"status"] isEqualToString:@"ok"])
                {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Código Verificado" message:@"Código verificado con éxito. Puedes ver tu promoción al momento de pagar la cuenta :)" preferredStyle:UIAlertControllerStyleAlert];
                    [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
                    [alert.view setTintColor:[UIColor colorWithRed:0.737 green:0.635 blue:0.506 alpha:1.0]];
                    [self presentViewController:alert animated:YES completion:nil];
                }
                else
                {
                    UIAlertController *secondAlert = [UIAlertController alertControllerWithTitle:@"Código Incorrecto" message:@"Intenta introducir un código correcto más tarde" preferredStyle:UIAlertControllerStyleAlert];
                    [secondAlert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
                    [secondAlert.view setTintColor:[UIColor colorWithRed:0.737 green:0.635 blue:0.506 alpha:1.0]];
                    [self presentViewController:secondAlert animated:YES completion:nil];
                }
            });
        }
    }];
    [task resume];
}

@end




























































