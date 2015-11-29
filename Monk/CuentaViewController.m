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
- (void)openAccount;

@end

@implementation CuentaViewController
{
    UIButton *buttonStart;
    UILabel *labelFeedback;
    
    NSString *monkURL;
    NSString *totalToPay;
    
    NSUserDefaults *defaults;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.buttonPay.layer.cornerRadius = 3.0;
    
    defaults = [NSUserDefaults standardUserDefaults];
    
    monkURL = @"https://monkapp.herokuapp.com";
    self.arrayAccount = [[NSMutableArray alloc] init];
    
    self.tableAccount.delegate = self;
    self.tableAccount.dataSource = self;
    
    //Verificar primero si la cuenta está abierta
    if([defaults boolForKey:@"accountOpen"] == NO){
        [self setFirstViewInterface];
        [defaults setBool:YES forKey:@"accountOpen"];
        [defaults synchronize];
    }
    else{
        [self getAccountStatus];
    }
}

#pragma mark TableView Delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch(section)
    {
        case 0:
            return [[self arrayAccount] count];
            break;
        case 1:
            return [[self arrayComplementos] count];
        case 2:
            return 1;
            break;
        default:
            break;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch(section)
    {
        case 0:
            return @"Platillos";
            break;
        case 1:
            return @"Complementos";
            break;
        case 2:
            return @"Total a pagar";
        default:
            break;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *idCell = @"idCell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:idCell];
    
    switch(indexPath.section)
    {
        case 0:
        {
            NSDictionary *dictionary = [[self arrayAccount] objectAtIndex:indexPath.row];
            cell.textLabel.text = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"nombre"]];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"Precio: %@", [[dictionary objectForKey:@"precio"] stringValue]];
        }
        break;
        case 1:
        {
            NSDictionary *diction = [[self arrayComplementos] objectAtIndex:indexPath.row];
            cell.textLabel.text = [NSString stringWithFormat:@"%@", [diction objectForKey:@"nombre"]];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"Precio: %@", [[diction objectForKey:@"precio"] stringValue]];
        }
        break;
        case 2:
            if(totalToPay)//Para evitar que salga esta sección antes de que aparezca la cuenta
                cell.textLabel.text = [NSString stringWithFormat:@"Total a Pagar: %@", totalToPay];
            break;
        default:
            break;
    }
    return cell;
}


#pragma mark IBActions
- (IBAction)showMoreOptions:(UIBarButtonItem *)sender
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Más Opciones" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"Tus Saldo y Tarjetas" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
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

- (IBAction)refreshAccount:(UIBarButtonItem *)sender
{
    [self getAccountStatus];
}

- (IBAction)payBill:(UIButton *)sender
{
    [self showPayView];
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

- (void)openAccount
{
    //Verificar primero si hay tarjeta asociada
    buttonStart.hidden = YES;
    self.tableAccount.hidden = NO;
    self.buttonPay.hidden = NO;
    self.buttonRefresh.enabled = YES;
    self.tableAccount.delegate =self;
    self.tableAccount.dataSource = self;
    
    [self callMesera];
    [self showLabelFeedback:@"Aquí aparecerá el estado de tu cuenta de consumo"];
}

- (void)callMesera
{
    PFUser *user = [PFUser currentUser];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/meseras/llamar?objectId=%@", monkURL, user.objectId]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    [request setHTTPMethod:@"POST"];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request];
    [task resume];
}

- (void)getAccountStatus
{
    self.arrayAccount = [[NSMutableArray alloc] init];
    self.navigationItem.title = @"Actualizando Cuenta...";
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.frame = CGRectMake(self.view.frame.size.width / 2 - 24.0, self.view.frame.size.height / 2 - 24.0, 24.0, 24.0);
    [activityIndicator startAnimating];
    [[self view] addSubview:activityIndicator];
    
    PFUser *user = [PFUser currentUser];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/user/cuenta?objectId=%@", monkURL, user.objectId]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [activityIndicator stopAnimating];
            [activityIndicator removeFromSuperview];
            self.navigationItem.title = @"Tu Cuenta";
        });
        if(!error){
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            NSDictionary *dictionaryCuenta = [dictionary objectForKey:@"cuenta"];
            totalToPay = [[dictionaryCuenta objectForKey:@"cantidad"] stringValue];
            self.arrayAccount = [dictionaryCuenta objectForKey:@"platillos"];
            self.arrayComplementos = [dictionaryCuenta objectForKey:@"complementos"];
            if(self.arrayAccount.count > 0)
                dispatch_async(dispatch_get_main_queue(), ^{
                    [labelFeedback removeFromSuperview];
                });
            dispatch_async(dispatch_get_main_queue(), ^{
                [[self tableAccount] reloadData];
            });
        }
    }];
    [task resume];
}

- (void)showPayView
{
    PayViewController *payView = [[self storyboard] instantiateViewControllerWithIdentifier:@"payView"];
    payView.delegate = self;
    UINavigationController *nv = [[UINavigationController alloc] initWithRootViewController:payView];
    [self presentViewController:nv animated:YES completion:nil];
}

#pragma mark PayView Delegate
- (void)didPayAccount
{
    self.arrayAccount = nil;
    totalToPay = nil;
    [self.tableAccount reloadData];
    [self setFirstViewInterface];
    [self showFeedbackView];
    [defaults setBool:NO forKey:@"accountOpen"];
    [defaults synchronize];
}

#pragma mark Auxiliar Methods
- (void)setFirstViewInterface{
    self.tableAccount.hidden = YES;
    self.buttonPay.hidden = YES;
    self.buttonRefresh.enabled = NO;
    
    buttonStart = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    buttonStart.frame = CGRectMake(self.view.frame.size.width/2 - self.view.frame.size.width/2 + 10.0, self.view.frame.size.height/2 - 22.0, self.view.frame.size.width - 20.0, 44.0);
    [buttonStart addTarget:self action:@selector(openAccount) forControlEvents:UIControlEventTouchUpInside];
    [buttonStart setTitle:@"Llamar a mesero/a" forState:UIControlStateNormal];
    [buttonStart setTintColor:[UIColor whiteColor]];
    [buttonStart setBackgroundColor:[UIColor colorWithRed:0.737 green:0.635 blue:0.506 alpha:1.0]];
    buttonStart.layer.cornerRadius = 3.0;
    [self.view addSubview:buttonStart];
    
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

- (void)showLabelFeedback:(NSString *)feedbackString
{
    labelFeedback = [[UILabel alloc] initWithFrame:CGRectMake(22.0, 90.0, self.view.frame.size.width - 44.0, 44.0)];
    labelFeedback.textColor = [UIColor colorWithRed:0.737 green:0.635 blue:0.506 alpha:1.0];
    labelFeedback.text = feedbackString;
    labelFeedback.textAlignment = NSTextAlignmentCenter;
    labelFeedback.font = [UIFont systemFontOfSize:14.0];
    labelFeedback.numberOfLines = 2;
    labelFeedback.alpha = 1.0;
    [[self tableAccount] addSubview:labelFeedback];
}

- (void)showFeedbackView
{
    RateViewController *rateView = [[self storyboard] instantiateViewControllerWithIdentifier:@"rateView"];
    UINavigationController *nv = [[UINavigationController alloc] initWithRootViewController:rateView];
    [self presentViewController:nv animated:YES completion:nil];
}


@end




























































