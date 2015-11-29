//
//  CardViewController.m
//  Monk
//
//  Created by Abner Castro Aguilar on 31/10/15.
//  Copyright © 2015 Abner Castro Aguilar. All rights reserved.
//

#import "CardViewController.h"
#import <Parse/Parse.h>

@interface CardViewController ()

- (void)addCard;
- (void)getCards;

@end

@implementation CardViewController
{
    NSString *monkURL;
    
    NSDictionary *dictResponse;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    monkURL = @"https://monkapp.herokuapp.com";
    
    self.navigationItem.title = @"Tus Tarjetas";
    
    UIBarButtonItem *okButton = [[UIBarButtonItem alloc] initWithTitle:@"Listo" style:UIBarButtonItemStyleDone target:self action:@selector(okView)];
    okButton.tintColor = [UIColor colorWithRed:0.737 green:0.635 blue:0.506 alpha:1.0];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addCard)];
    addButton.tintColor = [UIColor colorWithRed:0.737 green:0.635 blue:0.506 alpha:1.0];
    
    self.navigationItem.leftBarButtonItem = addButton;
    self.navigationItem.rightBarButtonItem = okButton;
    
    self.tableViewCards.delegate = self;
    self.tableViewCards.dataSource = self;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [self getCards];
}

- (void)addCard
{
    [self performSegueWithIdentifier:@"addCard" sender:self];
}

- (void)okView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark TableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch(section)
    {
        case 0:
            return 1;
            break;
        case 1:
            return [self.arrayCards count];
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
            return @"Tu saldo acumulado en MonK con los cupones de promoción";
            break;
        case 1:
            return @"Tus tarjetas";
        default:
            break;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    
    switch(indexPath.section)
    {
        case 0:
            cell.textLabel.text = [NSString stringWithFormat:@"Tu Saldo MonK: %@", [[dictResponse objectForKey:@"saldo"] stringValue]];
            break;
        case 1:
        {
            NSDictionary *dictionary = [self.arrayCards objectAtIndex:indexPath.row];
            cell.textLabel.text = [NSString stringWithFormat:@"Tarjeta: %@", [dictionary objectForKey:@"digitos"]];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"ID: %@", [dictionary objectForKey:@"id"]];
        }
        break;
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)getCards
{
    PFUser *user = [PFUser currentUser];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/tarjetas?objectId=%@", monkURL, [user objectId]]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(!error){
            dictResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            self.arrayCards = [[NSMutableArray alloc] init];
            self.arrayCards = (NSMutableArray *)[dictResponse objectForKey:@"tarjetas"];
            if(self.arrayCards.count == 0)
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showLabelFeedback:@"Aún no tienes Tarjetas. Agrega alguna con el botón +"];
                });
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [[self tableViewCards] reloadData];
            });
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showLabelFeedback:@"No hay conexión a Internet. Inténtalo más tarde"];
            });
        }
    }];
    [task resume];
}

- (void)showLabelFeedback:(NSString *)feedbackString
{
    UILabel *labelFeedback = [[UILabel alloc] initWithFrame:CGRectMake(22.0, 200.0, self.view.frame.size.width - 44.0, 44.0)];
    labelFeedback.textColor = [UIColor colorWithRed:0.737 green:0.635 blue:0.506 alpha:1.0];
    labelFeedback.text = feedbackString;
    labelFeedback.textAlignment = NSTextAlignmentCenter;
    labelFeedback.font = [UIFont systemFontOfSize:14.0];
    labelFeedback.numberOfLines = 2;
    labelFeedback.alpha = 1.0;
    [[self tableViewCards] addSubview:labelFeedback];
}

@end






























































