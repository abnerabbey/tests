//
//  PayViewController.m
//  Monk
//
//  Created by Abner Castro Aguilar on 25/11/15.
//  Copyright © 2015 Abner Castro Aguilar. All rights reserved.
//

#import "PayViewController.h"
#import "RateViewController.h"

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
    
    arrayPropinas = [NSArray arrayWithObjects:@"15", @"20", @"25", @"30", @"35", @"40", @"45", @"50", nil];
    billPercent = 0.15;
    
    self.navigationItem.title = @"Pagar la cuenta";
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"Pagar" style:UIBarButtonItemStyleDone target:self action:@selector(pay)];
    self.navigationItem.rightBarButtonItem = barButton;
    
    self.tableViewSetup.dataSource = self;
    self.tableViewSetup.delegate = self;
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
            return [self.arrayAccounts count];
            break;
        case 1:
            return [self.arrayCards count];
            break;
        case 2:
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
            return @"Elige si quieres pagar tu cuenta y la de alguien más";
            break;
        case 1:
            return @"Selecciona la tarjeta con la que deseas pagar";
            break;
        case 2:
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
            break;
        case 2:
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
            break;
        case 2:
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



- (void)pay
{
    [self dismissViewControllerAnimated:YES completion:^{
        [[self delegate] didPayAccount];
    }];
}

@end










































































