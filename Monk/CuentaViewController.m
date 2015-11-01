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

@interface CuentaViewController ()

@end

@implementation CuentaViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}


- (IBAction)showMoreOptions:(UIBarButtonItem *)sender
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Más Opciones" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"Tu Tarjeta" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        CardViewController *cardView = [[self storyboard] instantiateViewControllerWithIdentifier:@"cardView"];
        UINavigationController *nv = [[UINavigationController alloc] initWithRootViewController:cardView];
        [self presentViewController:nv animated:YES completion:nil];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Tu Perfil" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ProfileViewController *profileView = [[self storyboard] instantiateViewControllerWithIdentifier:@"profileView"];
        UINavigationController *nv = [[UINavigationController alloc] initWithRootViewController:profileView];
        [self presentViewController:nv animated:YES completion:nil];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Introduce un código" style:UIAlertActionStyleDefault handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cerrar Sesión" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancelar" style:UIAlertActionStyleCancel handler:nil]];
    [alert.view setTintColor:[UIColor colorWithRed:0.737 green:0.635 blue:0.506 alpha:1.0]];
    [self presentViewController:alert animated:YES completion:nil];
}
@end




























































