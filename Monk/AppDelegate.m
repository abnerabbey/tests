//
//  AppDelegate.m
//  Monk
//
//  Created by Abner Castro Aguilar on 30/10/15.
//  Copyright © 2015 Abner Castro Aguilar. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <ParseFacebookUtilsV4/ParseFacebookUtilsV4.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Parse setApplicationId:@"b05rGd5t1rFEXuik4NPgJJNzZW1CaUCQEvSlBPLw" clientKey:@"uKl1gIqrRdR2hqzjJRDUgyZQFqZapv0JZ9NOALNT"];
    
    [PFFacebookUtils initializeFacebookWithApplicationLaunchOptions:launchOptions];
    
    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:0.737 green:0.635 blue:0.506 alpha:1.0]];
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:0.737 green:0.635 blue:0.506 alpha:1.0]];
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *tokenDevice = [[[[deviceToken description]
                               stringByReplacingOccurrencesOfString: @"<" withString: @""]
                              stringByReplacingOccurrencesOfString: @">" withString: @""]
                             stringByReplacingOccurrencesOfString: @" " withString: @""];
    PFUser *user = [PFUser currentUser];
    NSString *email = [user email];
    NSString *password = [user objectForKey:@"facebookId"];
    NSString *objectId = [user objectId];
    NSMutableDictionary *userElements = [[NSMutableDictionary alloc] init];
    [userElements setObject:[user username] forKey:@"username"];
    [userElements setObject:email forKey:@"email"];
    [userElements setObject:password forKey:@"password"];
    [userElements setObject:objectId forKey:@"objectId"];
    [userElements setObject:tokenDevice forKey:@"token"];
    //NSDictionary *userDictionary = @{@"user": userElements};
    [self postJSONToServer:(NSDictionary *)userElements];
    
    PFInstallation *installation = [PFInstallation currentInstallation];
    [installation setDeviceTokenFromData:deviceToken];
    installation.channels = @[@"global", [NSString stringWithFormat:@"user_%@", objectId]];
    [installation saveInBackground];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [PFPush handlePush:userInfo];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                   openURL:url
                                         sourceApplication:sourceApplication
                                                annotation:annotation];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark Other Methods
- (void)postJSONToServer:(NSDictionary *)dictionary
{
    NSLog(@"pasa");
    NSString *monkURL = @"https://monkapp.herokuapp.com";
    NSString *nombre = [[dictionary objectForKey:@"username"] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *email = [dictionary objectForKey:@"email"];
    NSString *password = [dictionary objectForKey:@"password"];
    NSString *objectId = [dictionary objectForKey:@"objectId"];
    NSString *token = [dictionary objectForKey:@"token"];
    
    NSURLSession *sessionPost = [NSURLSession sharedSession];
    //NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/user/registrar", monkURL]]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/user/registrar?user[nombre]=%@&user[email]=%@&user[password]=%@&user[objectId]=%@&user[device_token]=%@&user[device]=iOS", monkURL, nombre, email, password, objectId, token]]];
    NSString *string = [NSString stringWithFormat:@"%@/user/registrar?user[nombre]=%@&user[email]=%@&user[password]=%@&user[objectId]=%@&user[device_token]=%@&user[device]=iOS", monkURL, nombre, email, password, objectId, token];
    NSLog(@"%@", string);
    [request setHTTPMethod:@"POST"];
    
    //NSDictionary *userDictionary = @{@"user":dictionary};
    //NSLog(@"%@", userDictionary);
    //NSData *jsonData = [NSJSONSerialization dataWithJSONObject:userDictionary options:NSJSONWritingPrettyPrinted error:nil];
    //[request setHTTPBody:jsonData];
    NSURLSessionDataTask *task = [sessionPost dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(!error){
            NSError *jsonError;
            NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:[dictResponse objectForKey:@"codigo"] forKey:@"userCode"];
            [defaults synchronize];
            NSLog(@"Response: %@", dictResponse);
        }
        else
            NSLog(@"error description: %@", [error description]);
    }];
    [task resume];
}

@end






























































