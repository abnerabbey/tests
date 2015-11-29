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
#import "DescriptionViewController.h"
#import <Parse/Parse.h>



@interface MenuViewController ()
{
    NSURLSession *session;
    NSURL *menuURL;
    NSString *monkURL;
    
    NSString *currentDate;
    
    dispatch_queue_t imageQue;
    
    UIActivityIndicatorView *activityIndicator;
    
    NSDictionary *dictionaryMenuDescription;
    NSData *dataImage;
    
}

- (void)getAssistanceResponse;
- (void)showContentForNewUser;
- (void)getMenu;
- (void)verifyPromoCode:(NSString *)promoCode;

@end

@implementation MenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Interface customization
    currentDate = [self getCurrentDate];
    [[self tableMenu] setDelegate:self];
    [[self tableMenu] setDataSource:self];
    
    monkURL = @"https://monkapp.herokuapp.com";
    
    menuURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/menus", monkURL]];
    session = [NSURLSession sharedSession];
    imageQue = dispatch_queue_create("Image Que", NULL);
    
    [self showContentForNewUser];
    [self getMenu];
    [self getAssistanceResponse];
    
    //For push notifications codes
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushCodeReceived) name:@"pushCode" object:nil];
}

#pragma mark Table View Delegates
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayMenus.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"Menú de: %@", currentDate];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    
    NSDictionary *dictionMenu = [self.arrayMenus objectAtIndex:indexPath.row];
    
    UILabel *labelName = (UILabel *)[cell viewWithTag:2];
    labelName.text = [dictionMenu objectForKey:@"nombre"];
    
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:1];
    imageView.image = [UIImage imageWithData:[self.imagesData objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    dataImage = [self.imagesData objectAtIndex:indexPath.row];
    dictionaryMenuDescription = [self.arrayMenus objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"menuSegue" sender:self];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"menuSegue"]){
        DescriptionViewController *descriptionView = [segue destinationViewController];
        descriptionView.imageData = dataImage;
        descriptionView.dictionaryMenuDescription = dictionaryMenuDescription;
    }
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
        NSString *texto = @"Vamos a comer a MonK hoy...! mira el menú en\nhttps://www.facebook.com/MonkPolanco";
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

- (void)showContentForNewUser
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
            
            UIActivityIndicatorView *activityPromoIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            activityPromoIndicator.frame = CGRectMake(self.view.frame.size.width / 2 - 24.0, self.view.frame.size.height / 2 - 24.0, 24.0, 24.0);
            [activityPromoIndicator startAnimating];
            [[self view] addSubview:activityPromoIndicator];
            self.navigationItem.title = @"Verificando código...";
            
            [self verifyPromoCode:textFromTextField];
            
            [activityPromoIndicator stopAnimating];
            [activityPromoIndicator removeFromSuperview];
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
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.frame = CGRectMake(self.view.frame.size.width / 2 - 24.0, self.view.frame.size.height / 2 - 24.0, 24.0, 24.0);
    [activityIndicator startAnimating];
    [[self view] addSubview:activityIndicator];
    
    //NSURL Session
    NSURLSessionTask *task = [session dataTaskWithURL:menuURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //Whatever it happens, We remove the from the interface the activity indicator and we change the navigation bar title
        dispatch_async(dispatch_get_main_queue(), ^{
            [activityIndicator stopAnimating];
            [activityIndicator removeFromSuperview];
            self.navigationItem.title = @"Menú del día";
        });
        //If there's no error (Internet connection error) we get the JSON form the data downloaded
        if(!error){
            NSError *jsonError;
            NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            
            //If there's no error while parsing the data to json format,
            if(!jsonError){
                NSArray *menusArray = (NSArray *)[jsonDictionary objectForKey:@"menus"];
                if(menusArray.count > 0){
                    self.arrayMenus = menusArray;
                    [self getImagesFromJSON:menusArray];
                }
                else
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self showLabelFeedback:@"Aún no hay menú del día. Inténtalo más tarde"];
                    });
            }
            //If there's an error with the json downloaded, we show a label to feedback the user
            else
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showLabelFeedback:@"Hubo un error al cargar el menú. Inténtalo más tarde"];
                });
        }
        //If there's no connection we shoe the label feedback for the users
        else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showLabelFeedback:@"No hay conexión a Internet. Inténtalo más tarde"];
        });
        }
    }];
    [task resume];
}

- (void)verifyPromoCode:(NSString *)promoCode
{
    PFUser *user = [PFUser currentUser];
    NSURL *cuponURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/cupon/registrar?objectId=%@", monkURL, user.objectId]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:cuponURL];
    NSURLSession *sessionPost = [NSURLSession sharedSession];
    [request setHTTPMethod:@"POST"];
    NSString *promoCodeReady = [NSString stringWithFormat:@"cupon=%@",promoCode];
    [request setHTTPBody:[promoCodeReady dataUsingEncoding:NSUTF8StringEncoding]];
    
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

#pragma mark Auxiliar Methods
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

-(void)pushCodeReceived
{
    UIAlertController *alertPromoPush = [UIAlertController alertControllerWithTitle:@"Promoción!" message:@"Introduce el código de promoción recibido en la notificación para hacerla válida! :)" preferredStyle:UIAlertControllerStyleAlert];
    [alertPromoPush addAction:[UIAlertAction actionWithTitle:@"Verificar" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textField = (UITextField *)alertPromoPush.textFields[0];
        NSString *textFromTextField = textField.text;
        
        UIActivityIndicatorView *activityPromoIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityPromoIndicator.frame = CGRectMake(self.view.frame.size.width / 2 - 24.0, self.view.frame.size.height / 2 - 24.0, 24.0, 24.0);
        [activityPromoIndicator startAnimating];
        [[self view] addSubview:activityPromoIndicator];
        self.navigationItem.title = @"Verificando código...";
        
        [self verifyPromoCode:textFromTextField];
        
        [activityPromoIndicator stopAnimating];
        [activityPromoIndicator removeFromSuperview];
        self.navigationItem.title = @"Menú del día";
    }]];
    [alertPromoPush addAction:[UIAlertAction actionWithTitle:@"Cancelar" style:UIAlertActionStyleDefault handler:nil]];
    [alertPromoPush.view setTintColor:[UIColor colorWithRed:0.737 green:0.635 blue:0.506 alpha:1.0]];
    [alertPromoPush addTextFieldWithConfigurationHandler:nil];
    [self presentViewController:alertPromoPush animated:YES completion:nil];
}

#pragma mark Test Methods
- (void)getImagesFromJSON:(NSArray *)arrayMenu
{
    self.imagesData = [[NSMutableArray alloc] init];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.navigationItem.title = @"Cargando Menú...";
        activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicator.frame = CGRectMake(self.view.frame.size.width / 2 - 24.0, self.view.frame.size.height / 2 - 24.0, 24.0, 24.0);
        [activityIndicator startAnimating];
        [[self view] addSubview:activityIndicator];
    });
    dispatch_async(imageQue, ^{
        for (NSDictionary *dictionary in arrayMenu) {
            NSDictionary *imageDictionary = [dictionary objectForKey:@"image"];
            NSString *imageString = [imageDictionary objectForKey:@"url"];
            NSURL *urlImage = [NSURL URLWithString:imageString];
            NSData *imageData = [NSData dataWithContentsOfURL:urlImage];
            [[self imagesData] addObject:imageData];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [activityIndicator stopAnimating];
            [activityIndicator removeFromSuperview];
            self.navigationItem.title = @"Menú";
            [[self tableMenu] reloadData];
        });
    });
}

- (NSString *)getCurrentDate
{
    NSDate *date = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateStyle:NSDateFormatterLongStyle];
    [df setTimeStyle:NSDateFormatterNoStyle];
    NSString *dateString = [df stringFromDate:date];
    
    return dateString;
}

@end























































































































