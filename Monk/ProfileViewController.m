//
//  ProfileViewController.m
//  Monk
//
//  Created by Abner Castro Aguilar on 31/10/15.
//  Copyright © 2015 Abner Castro Aguilar. All rights reserved.
//

#import "ProfileViewController.h"
#import <Parse/Parse.h>

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Compartir Código";
    
    UIBarButtonItem *okButton = [[UIBarButtonItem alloc] initWithTitle:@"Listo" style:UIBarButtonItemStyleDone target:self action:@selector(okView)];
    okButton.tintColor = [UIColor colorWithRed:0.737 green:0.635 blue:0.506 alpha:1.0];
    self.navigationItem.rightBarButtonItem = okButton;
    
    self.buttonShare.layer.borderColor = [[UIColor colorWithRed:0.737 green:0.635 blue:0.506 alpha:1.0] CGColor];
    self.buttonShare.layer.borderWidth = 1.0;
    
    PFUser *user = [PFUser currentUser];
    
    [[self labelMessage] setText:[NSString stringWithFormat:@"%@, invita a tus nuevos amigos y gana $50 MXN por cada uno que se registre y compre.", user[@"firstName"]]];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.labelCode.text = [defaults objectForKey:@"userCode"];
    
}

- (void)okView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)sharePromoCode:(UIButton *)sender
{
    NSString *codigo = self.labelCode.text;
    NSString *texto = [NSString stringWithFormat:@"Ven, conoce el restaurante MonK y obtén un descuento como primer usuario con mi código de promoción: %@", codigo];
    NSArray *array = [NSArray arrayWithObject:texto];
    UIActivityViewController *activityView = [[UIActivityViewController alloc] initWithActivityItems:array applicationActivities:nil];
    [activityView setValue:@"Prueba MonK. Aquí tienes una comida gratis..." forKey:@"subject"];
    NSArray *excludeActivities = @[UIActivityTypeAirDrop,
                                   UIActivityTypePrint,
                                   UIActivityTypeAssignToContact,
                                   UIActivityTypeSaveToCameraRoll,
                                   UIActivityTypeAddToReadingList,
                                   UIActivityTypePostToFlickr,
                                   UIActivityTypePostToVimeo];
    activityView.excludedActivityTypes = excludeActivities;
    [self presentViewController:activityView animated:YES completion:nil];
}
@end





























































