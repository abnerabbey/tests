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
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }]];
    [alertSheet addAction:[UIAlertAction actionWithTitle:@"Cancelar" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }]];
    [alertSheet.view setTintColor:[UIColor colorWithRed:0.737 green:0.635 blue:0.506 alpha:1.0]];
    [self presentViewController:alertSheet animated:YES completion:nil];
}

- (void)getFriends
{
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me/friends" parameters:@{@"fields":@"friends"}];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        if(!error)
        {
            NSDictionary *dictionary = (NSDictionary *)result;
            arrayFriends = [dictionary objectForKey:@"data"];
            [[self tableFriends] reloadData];
            if(arrayFriends.count == 0)
            {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Aún no hay amigos" message:@"Aún no tienes amigos que puedan asistir a Monk.\nInvítalos a la app por redes sociales :)" preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }]];
                [[alert view] setTintColor:[UIColor colorWithRed:0.737 green:0.635 blue:0.506 alpha:1.0]];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }
        else
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Ups" message:@"Hubo un error al cargar tus amigos. Inténtalo de nuevo." preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
            [alert.view setTintColor:[UIColor colorWithRed:0.737 green:0.635 blue:0.506 alpha:1.0]];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
}


- (void)okView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end


































































