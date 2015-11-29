//
//  PayViewController.m
//  Monk
//
//  Created by Abner Castro Aguilar on 25/11/15.
//  Copyright © 2015 Abner Castro Aguilar. All rights reserved.
//

#import "PayViewController.h"
#import "RateViewController.h"
#import <Parse/Parse.h>

@interface PayViewController ()

@end

@implementation PayViewController
{
    NSArray *arrayPropinas;
    
    NSIndexPath *previousIndexPath;
    
    float billPercent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self getCreditCards];
    
    arrayPropinas = [NSArray arrayWithObjects:@"15", @"20", @"25", @"30", @"35", @"40", @"45", @"50", nil];
    billPercent = 0.15;
    
    self.navigationItem.title = @"Pagar la cuenta";
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"Pagar" style:UIBarButtonItemStyleDone target:self action:@selector(pay)];
    self.navigationItem.rightBarButtonItem = barButton;
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancelar" style:UIBarButtonItemStylePlain target:self action:@selector(cancelPay)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    self.tableViewSetup.dataSource = self;
    self.tableViewSetup.delegate = self;
}

#pragma mark TableView Delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch(section)
    {
        case 0:
            return [self.arrayCards count];
            break;
        case 1:
            return [arrayPropinas count];
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
            return @"Selecciona la tarjeta con la que deseas pagar";
            break;
        case 1:
            return @"Selecciona la propina. Por default es el 15%";
            break;
        default:
            break;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *IDCell = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IDCell];
    if(!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:IDCell];
    switch(indexPath.section)
    {
        case 0:
            break;
        case 1:
            cell.textLabel.text = [NSString stringWithFormat:@"%@%%", [arrayPropinas objectAtIndex:indexPath.row]];
            if(indexPath.row == 0){
                [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
                previousIndexPath = indexPath;
            }
            break;
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch(indexPath.section)
    {
        case 0:
            break;
        case 1:
        {
            [[tableView cellForRowAtIndexPath:previousIndexPath] setAccessoryType:UITableViewCellAccessoryNone];
            if([[tableView cellForRowAtIndexPath:indexPath] accessoryType] == UITableViewCellAccessoryNone){
                [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
                billPercent = [[arrayPropinas objectAtIndex:indexPath.row] floatValue] / 100.0;
                NSLog(@"porcentaje de propina: %.2f", billPercent);
                previousIndexPath = indexPath;
            }
        }
        break;
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)getCreditCards
{
    PFUser *user = [PFUser currentUser];
    NSString *monkString = @"https://monkapp.herokuapp.com";
    NSURL *monkURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/tarjetas?objectId=%@", monkString, user.objectId]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:monkURL];
    NSURLSession *session = [NSURLSession sharedSession];
    [request setHTTPMethod:@"GET"];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(!error){
            NSDictionary *dicResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"response: %@", dicResponse);
        }
    }];
    [task resume];
}

- (void)pay
{
    UIAlertController *alertPay = [UIAlertController alertControllerWithTitle:@"Pagar la cuenta" message:@"Estás a punto de pagar la cuenta. ¿Estás seguro que deseas continuar?" preferredStyle:UIAlertControllerStyleAlert];
    [alertPay addAction:[UIAlertAction actionWithTitle:@"Pagar" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:^{
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"accountOpen"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[self delegate] didPayAccount];
        }];
    }]];
    [alertPay addAction:[UIAlertAction actionWithTitle:@"Cancelar" style:UIAlertActionStyleDefault handler:nil]];
    [alertPay.view setTintColor:[UIColor colorWithRed:0.737 green:0.635 blue:0.506 alpha:1.0]];
    [self presentViewController:alertPay animated:YES completion:nil];
}

- (void)cancelPay
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end










































































