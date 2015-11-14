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
    NSArray *arrayFriends;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableFriends.delegate = self;
    self.tableFriends.dataSource = self;

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
    
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me/friends" parameters:@{@"fields":@"friends"}];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        self.navigationItem.title = @"Tus Amigos";
        [activityIndicator stopAnimating];
        [activityIndicator removeFromSuperview];
        if(!error)
        {
            NSDictionary *dictionary = (NSDictionary *)result;
            arrayFriends = [dictionary objectForKey:@"data"];
            [[self tableFriends] reloadData];
            if(arrayFriends.count == 0)
            {
                [self showLabelFeedback:@"Aún no tienes amigos que puedan asistir a MonK. Invítalos a la app por redes sociales :)"];
            }
        }
        else
        {
            if([[error localizedDescription] isEqualToString:@"The Internet connection appears to be offline."])
                [self showLabelFeedback:@"Sin conexión. Verifica tu conexión a Internet e inténtalo de nuevo."];
            else{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Ups" message:@"Hubo un error al cargar tus amigos. Inténtalo de nuevo." preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
                [alert.view setTintColor:[UIColor colorWithRed:0.737 green:0.635 blue:0.506 alpha:1.0]];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }
    }];
}

- (void)sendPushNotificationToFriend:(NSInteger)indexPathRow
{
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query whereKey:@"username" equalTo:arrayFriends[indexPathRow]];
    PFUser *currentUser = [PFUser currentUser];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if(!error){
            [PFPush sendPushDataToChannelInBackground:[NSString stringWithFormat:@"user_%@", [object objectId]] withData:@{@"alert": [NSString stringWithFormat:@"%@ te invita a comer hoy a MonK :)", currentUser.username]} block:^(BOOL succeeded, NSError * _Nullable error) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"¡Listo!" message:[NSString stringWithFormat:@"Has invitado a %@ a comer hoy a MonK", [object objectForKey:@"username"]] preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
                [alert.view setTintColor:[UIColor colorWithRed:0.737 green:0.635 blue:0.506 alpha:1.0]];
                [self presentViewController:alert animated:YES completion:nil];
            }];
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


































































