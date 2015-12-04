//
//  FriendsViewController.m
//  Monk
//
//  Created by Abner Castro Aguilar on 30/10/15.
//  Copyright © 2015 Abner Castro Aguilar. All rights reserved.
//

#import "FriendsViewController.h"
#import <Parse/Parse.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>


@interface FriendsViewController ()

- (void)sendPushNotificationToFriend:(NSInteger)indexPathRow;

@end

@implementation FriendsViewController
{
    NSMutableArray *arrayFriends;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableFriends.delegate = self;
    self.tableFriends.dataSource = self;
    
    arrayFriends = [[NSMutableArray alloc] init];

    self.navigationItem.title = @"Tus Amigos";
    
    UIBarButtonItem *okButton = [[UIBarButtonItem alloc] initWithTitle:@"Listo" style:UIBarButtonItemStyleDone target:self action:@selector(okView)];
    okButton.tintColor = [UIColor colorWithRed:0.737 green:0.635 blue:0.506 alpha:1.0];
    self.navigationItem.rightBarButtonItem = okButton;
    
    [self getFriends];
}

#pragma mark TableView Delegates
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrayFriends count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    cell.textLabel.text = [arrayFriends objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertController *alertSheet = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"Invitar a %@", [arrayFriends objectAtIndex:indexPath.row]] message:@"Invítalo a comer a MonK hoy :)" preferredStyle:UIAlertControllerStyleActionSheet];
    [alertSheet addAction:[UIAlertAction actionWithTitle:@"Invitar" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self sendPushNotificationToFriend:indexPath.row];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }]];
    [alertSheet addAction:[UIAlertAction actionWithTitle:@"Cancelar" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }]];
    [alertSheet.view setTintColor:[UIColor colorWithRed:0.737 green:0.635 blue:0.506 alpha:1.0]];
    [self presentViewController:alertSheet animated:YES completion:nil];
}

#pragma mark Other Methods
- (void)getFriends
{
    self.navigationItem.title = @"Cargando amigos...";
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.frame = CGRectMake(self.view.frame.size.width / 2 - 24.0, self.view.frame.size.height / 2 - 24.0, 24.0, 24.0);
    [activityIndicator startAnimating];
    [[self view] addSubview:activityIndicator];
    
    FBSDKGraphRequest *friendsRequest = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me/friends" parameters:@{@"fields":@"friends"}];
    [friendsRequest startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        self.navigationItem.title = @"Tus Amigos";
        [activityIndicator stopAnimating];
        [activityIndicator removeFromSuperview];
        if(!error)
        {
            NSMutableArray *arrayWithFriends = [[NSMutableArray alloc] init];
            PFUser *user = [PFUser currentUser];
            NSString *userFBID = [user objectForKey:@"facebookId"];
            
            NSDictionary *dictionary = (NSDictionary *)result;
            NSArray *arrayData = [dictionary objectForKey:@"data"];
            
            for (NSDictionary *dic in arrayData) {
                NSDictionary *dicFriends = [dic objectForKey:@"friends"];
                NSArray *array = [dicFriends objectForKey:@"data"];
                for (NSDictionary *dicData in array) {
                    NSString *friendId = [dicData objectForKey:@"id"];
                    if(![friendId isEqualToString:userFBID])
                        [arrayWithFriends addObject:friendId];
                }
            }
            NSArray *friendsData = [NSArray arrayWithArray:(NSArray *)arrayWithFriends];
            [self filterFriends:friendsData];
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

- (void)sendPushNotificationToFriend:(NSInteger)indexPathRow
{
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:arrayFriends[indexPathRow]];
    PFUser *myUser = [PFUser currentUser];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if(!error){
            PFUser *userSelected = (PFUser *)object;
            NSString *userChannel = [NSString stringWithFormat:@"user_%@", [userSelected objectId]];
            //Create a push notification
            PFPush *push = [[PFPush alloc] init];
            [push setChannel:userChannel];
            [push setMessage:[NSString stringWithFormat:@"%@, te invita a comer hoy a MonK. Checa el menú :)", [myUser username]]];
            [push sendPushInBackground];
        }
    }];
}

- (void)filterFriends:(NSArray *)friends
{
    NSLog(@"friends: %@", friends);
    PFQuery *friendQuery = [PFUser query];
    [friendQuery whereKey:@"facebookId" containedIn:friends];
    [friendQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if(!error){
            NSLog(@"objects: %@", objects);
            for (PFUser *user in objects) {
                [arrayFriends addObject:user.username];
            }
            [[self tableFriends] reloadData];
        }
        else{
            NSLog(@"error description: %@", error.description);
        }
    }];
}


- (void)okView
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
    [[self tableFriends] addSubview:labelFeedback];
}

@end


































































