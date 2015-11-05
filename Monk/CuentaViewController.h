//
//  CuentaViewController.h
//  Monk
//
//  Created by Abner Castro Aguilar on 30/10/15.
//  Copyright © 2015 Abner Castro Aguilar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CuentaViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonRefresh;
@property (weak, nonatomic) IBOutlet UITableView *tableAccount;
@property (weak, nonatomic) IBOutlet UIButton *buttonPay;
- (IBAction)showMoreOptions:(UIBarButtonItem *)sender;
@end
