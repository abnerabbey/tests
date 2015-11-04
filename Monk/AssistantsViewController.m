//
//  AssistantsViewController.m
//  Monk
//
//  Created by Abner Castro Aguilar on 30/10/15.
//  Copyright © 2015 Abner Castro Aguilar. All rights reserved.
//

#import "AssistantsViewController.h"
#import <Parse/Parse.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface AssistantsViewController ()

- (void)requestForFriends;

@end

@implementation AssistantsViewController
{
    UISegmentedControl *assistantFilter;
    
    NSMutableArray *arrayAttending;
    NSMutableArray *arrayMaybe;
    NSArray *arrayfriends;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self tableAssistants] setDelegate:self];
    [[self tableAssistants] setDataSource:self];
    
    arrayAttending = [[NSMutableArray alloc] init];
    arrayMaybe = [[NSMutableArray alloc] init];
    
    assistantFilter = [[UISegmentedControl alloc] initWithItems:@[@"Asistirán", @"Tal Vez"]];
    assistantFilter.tintColor = [UIColor colorWithRed:0.737 green:0.635 blue:0.506 alpha:1.0];
    [assistantFilter addTarget:self action:@selector(filterAssistants) forControlEvents:UIControlEventValueChanged];
    
    UIBarButtonItem *okButton = [[UIBarButtonItem alloc] initWithTitle:@"Listo" style:UIBarButtonItemStyleDone target:self action:@selector(okView)];
    okButton.tintColor = [UIColor colorWithRed:0.737 green:0.635 blue:0.506 alpha:1.0];
    
    self.navigationItem.titleView = assistantFilter;
    assistantFilter.selectedSegmentIndex = 0;
    self.navigationItem.rightBarButtonItem = okButton;
    
    [self requestForFriends];
}

#pragma mark TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(assistantFilter.selectedSegmentIndex == 0)
        return [arrayAttending count];
    else
        return [arrayMaybe count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    
    if(assistantFilter.selectedSegmentIndex == 0)
        cell.textLabel.text = [arrayAttending objectAtIndex:indexPath.row];
    else if(assistantFilter.selectedSegmentIndex == 1)
        cell.textLabel.text = [arrayMaybe objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark Other Methods
- (void)okView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)filterAssistants
{
    [[self tableAssistants] reloadData];
}

- (void)requestForFriends
{
    FBSDKGraphRequest *friendsRequest = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me/friends" parameters:@{@"fields":@"friends"}];
    [friendsRequest startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        if(!error)
        {
            NSDictionary *dictionary = (NSDictionary *)result;
            arrayfriends = (NSArray *)[dictionary objectForKey:@"data"];
            [self filterFriends:arrayfriends];
        }
        else if([[error localizedDescription] isEqualToString:@"The Internet connection appears to be offline."])
        {
            [self showLabelFeedback:@"Sin conexión. Verifica tu conexión a Internet e inténtalo de nuevo."];
        }
        else
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Ups" message:@"Hubo un error al verificar los asistentes. Inténtalo de nuevo." preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [self showLabelFeedback:@"Hubo un inconveniente al verificar los asistentes. Inténtalo de nuevo."];
            }]];
            [[alert view] setTintColor:[UIColor colorWithRed:0.737 green:0.635 blue:0.506 alpha:1.0]];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
}

- (void)filterFriends:(NSArray *)friends
{
    [arrayAttending removeAllObjects];
    [arrayMaybe removeAllObjects];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Asistencia"];
    for(int i = 0; i < [friends count]; i++)
    {
        [query includeKey:@"user"];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
            if(object)
            {
                if([[object objectForKey:@"response"] intValue] == 0)
                    [arrayAttending addObject:[friends objectAtIndex:i]];
                else if([[object objectForKey:@"response"] intValue] == 1)
                    [arrayMaybe addObject:[friends objectAtIndex:i]];
            }
        }];
    }
    [[self tableAssistants] reloadData];
    if(arrayAttending.count == 0 || arrayMaybe.count == 0)
    {
        [self showLabelFeedback:@"Aún no tienes amigos que puedan asistir a Monk. Invítalos a la app por redes sociales :)"];
    }
}

- (void)showLabelFeedback:(NSString *)feedbackString
{
    UILabel *labelFeedback = [[UILabel alloc] initWithFrame:CGRectMake(22.0, 90.0, self.view.frame.size.width - 44.0, 44.0)];
    labelFeedback.textColor = [UIColor colorWithRed:0.737 green:0.635 blue:0.506 alpha:1.0];
    labelFeedback.text = feedbackString;
    labelFeedback.textAlignment = NSTextAlignmentCenter;
    labelFeedback.font = [UIFont systemFontOfSize:14.0];
    labelFeedback.numberOfLines = 2;
    labelFeedback.alpha = 0.6;
    [[self tableAssistants] addSubview:labelFeedback];
}

@end


































































