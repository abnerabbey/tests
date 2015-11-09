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
    NSURLSession *session;
    NSURL *menuURL;
    
    dispatch_queue_t imageQue;
    
}

@property (nonatomic, strong)NSMutableArray *arrayRows;

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
    
    menuURL = [NSURL URLWithString:@"https://monkapp.herokuapp.com/menus"];
    session = [NSURLSession sharedSession];
    imageQue = dispatch_queue_create("Image Que", NULL);
    
    [self showCodeAlertForNewUser];
    [self getMenu];
    [self getAssistanceResponse];
}

#pragma mark Table View Delegates
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.arrayRows objectAtIndex:section]integerValue];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self arrayMenuNames] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.arrayMenuNames objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    
    NSMutableArray *arrayForSection = [[NSMutableArray alloc] init];
    
    NSDictionary *dictionary = [self.arrayPlatillos objectAtIndex:indexPath.section];
    NSArray *arrayComplementos = [dictionary objectForKey:@"complementos"];
    [arrayForSection addObject:[dictionary objectForKey:@"nombre"]];
    if(arrayComplementos.count > 0)
        for (NSDictionary *dictionaryComplentos in arrayComplementos)
            [arrayForSection addObject:[dictionaryComplentos objectForKey:@"nombre"]];
    
    UILabel *labelName = (UILabel *)[cell viewWithTag:2];
    labelName.text = [arrayForSection objectAtIndex:indexPath.row];
    
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:1];
    
    NSDictionary *photoDictionary = [dictionary objectForKey:@"photo"];
    dispatch_async(imageQue, ^{
        UIImage *image = [self getImageMenu:photoDictionary];
        dispatch_async(dispatch_get_main_queue(), ^{
            imageView.image = image;
        });
    });
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"detailFood" sender:self];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    self.navigationItem.title = @"Cargando Menú...";
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.frame = CGRectMake(self.view.frame.size.width / 2 - 24.0, self.view.frame.size.height / 2 - 24.0, 24.0, 24.0);
    [activityIndicator startAnimating];
    [[self view] addSubview:activityIndicator];
    
    //NSURL Session
    NSURLSessionTask *task = [session dataTaskWithURL:menuURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [activityIndicator stopAnimating];
            [activityIndicator removeFromSuperview];
            self.navigationItem.title = @"Menú del día";
        });
        NSError *jsonError;
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        if(!jsonError){
            NSArray *jsonArray = (NSArray *)[jsonDictionary objectForKey:@"menus"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self prepareInfoToShow:jsonArray];
            });
        }
        else
            [self showLabelFeedback:@"Hubo un error al cargar el menú. Inténtalo más tarde"];
    }];
    [task resume];
}

#pragma mark Auxiliar Methods
- (BOOL)isPromoCodeValid:(NSString *)promoCode
{
    return YES;
}

-(void)prepareInfoToShow:(NSArray *)result
{
    self.arrayMenuNames = [[NSMutableArray alloc] init];
    self.arrayPlatillos = [[NSMutableArray alloc] init];
    
    NSMutableArray *arrayForPlatillos = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dictionary in result) {
        [[self arrayMenuNames] addObject:[dictionary objectForKey:@"nombre"]];
        [arrayForPlatillos addObject:[dictionary objectForKey:@"platillos"]];
    }
    for(int i = 0; i < arrayForPlatillos.count; i++){
        NSArray *array = [arrayForPlatillos objectAtIndex:i];
        NSDictionary *diction = [array objectAtIndex:0];
        [self.arrayPlatillos addObject:diction];
        
        //NSLog(@"array Platillos: %@\n\n\n\n\n\n\n\n\n\n\n\n", self.arrayPlatillos);
    }
    [self determineRowsPerSection:arrayForPlatillos];
    [[self tableMenu] reloadData];
}

- (void)showLabelFeedback:(NSString *)feedbackString
{
    UILabel *labelFeedback = [[UILabel alloc] initWithFrame:CGRectMake(22.0, 90.0, self.view.frame.size.width - 44.0, 44.0)];
    labelFeedback.textColor = [UIColor colorWithRed:0.737 green:0.635 blue:0.506 alpha:1.0];
    labelFeedback.text = feedbackString;
    labelFeedback.textAlignment = NSTextAlignmentCenter;
    labelFeedback.font = [UIFont systemFontOfSize:14.0];
    labelFeedback.numberOfLines = 2;
    labelFeedback.alpha = 1.0;
    [[self tableMenu] addSubview:labelFeedback];
}

- (void)determineRowsPerSection:(NSMutableArray *)arrayPlatillos
{
    NSDictionary *dictionary;
    self.arrayRows = [[NSMutableArray alloc] init];
    for (NSArray *array in arrayPlatillos) {
        dictionary = [array objectAtIndex:0];
        NSArray *arrayForRows = [dictionary objectForKey:@"complementos"];
        [self.arrayRows addObject:[NSNumber numberWithInteger:1 + arrayForRows.count]];
    }
}

- (UIImage *)getImageMenu:(NSDictionary *)photoDict
{
    NSURL *url = [NSURL URLWithString:[photoDict objectForKey:@"url"]];
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:imageData];
    return image;
}
@end























































































































