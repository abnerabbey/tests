//
//  MenuViewController.m
//  Monk
//
//  Created by Abner Castro Aguilar on 30/10/15.
//  Copyright © 2015 Abner Castro Aguilar. All rights reserved.
//

#import "MenuViewController.h"
#import "AssistantsViewController.h"
#import "FriendsViewController.h"

#import <Parse/Parse.h>

@interface MenuViewController ()
{
    NSArray *menu;
}

- (void)getAssistanceResponse;
- (void)showCodeAlertForNewUser;
- (void)getMenu;
@end

@implementation MenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Interface customization
    [[self tableMenu] setDelegate:self];
    [[self tableMenu] setDataSource:self];
    
    [self showCodeAlertForNewUser];
    [self getMenu];
    [self getAssistanceResponse];
}

#pragma mark Table View Delegates
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [menu count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.view.frame.size.height/5.0;
}

#pragma mark IBActions
- (IBAction)assistanceControl:(UISegmentedControl *)sender
{
    PFQuery *query = [PFQuery queryWithClassName:@"Asistencia"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if(object)
        {
            [object setObject:[NSNumber numberWithInteger:sender.selectedSegmentIndex] forKey:@"response"];
            [object saveInBackground];
        }
        else
        {
            PFObject *newObject = [PFObject objectWithClassName:@"Asistencia"];
            [newObject setObject:[PFUser currentUser] forKey:@"user"];
            [newObject setObject:[NSNumber numberWithInteger:sender.selectedSegmentIndex] forKey:@"response"];
            [newObject saveInBackground];
        }
    }];
}

- (IBAction)viewAssitants:(UIBarButtonItem *)sender
{
    AssistantsViewController *assistantView = [[self storyboard] instantiateViewControllerWithIdentifier:@"assistView"];
    UINavigationController *nv = [[UINavigationController alloc] initWithRootViewController:assistantView];
    [self presentViewController:nv animated:YES completion:nil];
}

- (IBAction)shareMenu:(UIBarButtonItem *)sender
{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Invita a tus amigos!" message:@"Selecciona una opción" preferredStyle:UIAlertControllerStyleActionSheet];
    [controller addAction:[UIAlertAction actionWithTitle:@"Amigos en la app" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        FriendsViewController *friendsView = [[self storyboard] instantiateViewControllerWithIdentifier:@"friendsView"];
        UINavigationController *nv = [[UINavigationController alloc] initWithRootViewController:friendsView];
        [self presentViewController:nv animated:YES completion:nil];
    }]];
    [controller addAction:[UIAlertAction actionWithTitle:@"Amigos en las redes sociales" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *texto = @"Échale un ojo al menú de MonK :)";
        NSArray *array = [NSArray arrayWithObject:texto];
        UIActivityViewController *activityView = [[UIActivityViewController alloc] initWithActivityItems:array applicationActivities:nil];
        NSArray *excludeActivities = @[UIActivityTypeAirDrop,
                                       UIActivityTypePrint,
                                       UIActivityTypeAssignToContact,
                                       UIActivityTypeSaveToCameraRoll,
                                       UIActivityTypeAddToReadingList,
                                       UIActivityTypePostToFlickr,
                                       UIActivityTypePostToVimeo];
        activityView.excludedActivityTypes = excludeActivities;
        [self presentViewController:activityView animated:YES completion:nil];
    }]];
    [controller addAction:[UIAlertAction actionWithTitle:@"Cancelar" style:UIAlertActionStyleCancel handler:nil]];
    //Tint color method for iOS 8. For iOS 7 look for reference.
    [[controller view] setTintColor:[UIColor colorWithRed:0.737 green:0.635 blue:0.506 alpha:1.0]];
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark Other Methods
- (void)getAssistanceResponse
{
    PFQuery *query = [PFQuery queryWithClassName:@"Asistencia"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if(object)
            [[self segmentedAssitance] setSelectedSegmentIndex:[[object objectForKey:@"response"] integerValue]];
    }];
}

- (void)showCodeAlertForNewUser
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL exists = [[defaults objectForKey:@"newUser"] boolValue];
    if(!exists)
    {
        [defaults setObject:[NSNumber numberWithBool:YES] forKey:@"newUser"];
        [defaults synchronize];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"¡Bienvenido a MonK!" message:@"Si tienes un código de promoción, ¡introdúcelo!\nPuedes hacerlo en cualquier otro momento sólo una vez." preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"Verificar" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            UITextField *textField = (UITextField *)alert.textFields[0];
            NSString *textFromTextField = textField.text;
            
            UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            activityIndicator.frame = CGRectMake(self.view.frame.size.width / 2 - 24.0, self.view.frame.size.height / 2 - 24.0, 24.0, 24.0);
            [activityIndicator startAnimating];
            [[self view] addSubview:activityIndicator];
            self.navigationItem.title = @"Verificando código...";
            
            if([self isPromoCodeValid:textFromTextField]){
                
            }
            else{
                
            }
            
            [activityIndicator removeFromSuperview];
            self.navigationItem.title = @"Menú del día";
            
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"Más Tarde" style:UIAlertActionStyleDefault handler:nil]];
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        }];
        [alert.view setTintColor:[UIColor colorWithRed:0.737 green:0.635 blue:0.506 alpha:1.0]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)getMenu
{
    self.tableMenu.hidden = YES;
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.frame = CGRectMake(self.view.frame.size.width / 2 - 24.0, self.view.frame.size.height / 2 - 24.0, 24.0, 24.0);
    [activityIndicator startAnimating];
    [[self view] addSubview:activityIndicator];
    
    NSURL *url = [NSURL URLWithString:@"https://monkapp.herokuapp.com/menus"];
    
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    [sessionConfig setAllowsCellularAccess:YES];
    [sessionConfig setTimeoutIntervalForRequest:30.0];
    [sessionConfig setTimeoutIntervalForResource:60.0];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
    [[session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        [activityIndicator stopAnimating];
        [activityIndicator removeFromSuperview];
        
        if(!error){
            if(data){
                
                self.tableMenu.hidden = NO;
                
                NSError *jsonError;
                NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
                NSLog(@"dictionary: %@", dictionary);
                NSArray *resultArray = [dictionary objectForKey:@"menus"];
                [self fillMenuArray:resultArray];
            }
            else{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error de servidor" message:@"Hubo un error al obtener el menú de los servidores de MonK. Inténtalo más tarde" preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"Intentar" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [self refreshMenu];
                }]];
                [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
                [alert.view setTintColor:[UIColor colorWithRed:0.737 green:0.635 blue:0.506 alpha:1.0]];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }
        else
            [self makeButtonRefresh];
    }] resume];
}

#pragma mark Auxiliar Methods
- (BOOL)isPromoCodeValid:(NSString *)promoCode
{
    return YES;
}

-(void)fillMenuArray:(NSArray *)result
{
    
}

- (void)makeButtonRefresh
{
    
}

- (void)refreshMenu
{
    [self getMenu];
}


@end























































































































