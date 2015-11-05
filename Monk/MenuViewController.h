//
//  MenuViewController.h
//  Monk
//
//  Created by Abner Castro Aguilar on 30/10/15.
//  Copyright © 2015 Abner Castro Aguilar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, NSURLSessionDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableMenu;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedAssitance;

- (IBAction)assistanceControl:(UISegmentedControl *)sender;
- (IBAction)viewAssitants:(UIBarButtonItem *)sender;
- (IBAction)shareMenu:(UIBarButtonItem *)sender;

@end
