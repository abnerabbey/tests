//
//  InitialViewController.m
//  Monk
//
//  Created by Abner Castro Aguilar on 30/10/15.
//  Copyright © 2015 Abner Castro Aguilar. All rights reserved.
//

#import "InitialViewController.h"
#import <Parse/Parse.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <ParseFacebookUtilsV4/ParseFacebookUtilsV4.h>

@interface InitialViewController ()

@end

@implementation InitialViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    //Interface customization
    self.buttonLogin.layer.borderWidth = 1.0;
    self.buttonLogin.layer.borderColor = [[UIColor colorWithRed:0.737 green:0.635 blue:0.506 alpha:1.0] CGColor];
    self.buttonLogin.layer.cornerRadius = 3.0;
}

- (void)viewDidAppear:(BOOL)animated
{
    PFUser *user = [PFUser currentUser];
    if(user)
        [self performSegueWithIdentifier:@"logedIn" sender:self];
}

- (IBAction)logInWithFacebook:(UIButton *)sender
{
    NSArray *permissions = @[@"public_profile", @"email"];
    [PFFacebookUtils logInInBackgroundWithReadPermissions:permissions block:^(PFUser * _Nullable user, NSError * _Nullable error) {
        if(!error)
        {
            if(!user)
            {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Sesión Cancelada" message:@"Debes iniciar sesión en Facebook para poder utilizar MonK." preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
                [alert.view setTintColor:[UIColor colorWithRed:0.737 green:0.635 blue:0.506 alpha:1.0]];
                [self presentViewController:alert animated:YES completion:nil];
            }
            else if(user.isNew)
            {
                FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields" : @"id,email,first_name,last_name,friends"}];
                [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                    if(!error)
                    {
                        NSDictionary *userData = (NSDictionary *)result;
                        NSLog(@"userData: %@", userData);
                        NSString *firstName = userData[@"first_name"];
                        NSString *lastName = userData[@"last_name"];
                        NSString *username = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
                        NSString *email = userData[@"email"];
                        NSString *facebookId = userData[@"id"];
                        
                        user[@"username"] = username;
                        user[@"email"] = email;
                        user[@"facebookId"] = facebookId;
                        user[@"firstName"] = firstName;
                        user[@"lastName"] = lastName;
                        [user saveInBackground];
                        
                        [self performSegueWithIdentifier:@"logedIn" sender:self];
                    }
                    else
                    {
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Ups" message:@"Hubo un error al registrarte en la base de datos. Inténtalo de nuevo, por favor." preferredStyle:UIAlertControllerStyleAlert];
                        [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
                        [alert.view setTintColor:[UIColor colorWithRed:0.737 green:0.635 blue:0.506 alpha:1.0]];
                        [self presentViewController:alert animated:YES completion:nil];
                    }
                }];
            }
            else
            {
                NSLog(@"Usuario logeado con Facebook");
                [self performSegueWithIdentifier:@"logedIn" sender:self];
            }
        }
        else
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Ups" message:@"Hubo un error al iniciar sesión. Inténtalo de nuevo." preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
            [alert.view setTintColor:[UIColor colorWithRed:0.737 green:0.635 blue:0.506 alpha:1.0]];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
}
@end



























































