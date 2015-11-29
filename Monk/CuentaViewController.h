//
//  CuentaViewController.h
//  Monk
//
//  Created by Abner Castro Aguilar on 30/10/15.
//  Copyright © 2015 Abner Castro Aguilar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayViewController.h"

@interface CuentaViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, PayViewDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonRefresh;
@property (weak, nonatomic) IBOutlet UITableView *tableAccount;
@property (weak, nonatomic) IBOutlet UIButton *buttonPay;

- (IBAction)showMoreOptions:(UIBarButtonItem *)sender;
- (IBAction)refreshAccount:(UIBarButtonItem *)sender;
- (IBAction)payBill:(UIButton *)sender;

@property (nonatomic, strong)NSMutableArray *arrayAccount;
@property (nonatomic, strong)NSArray *arrayComplementos;

@end
