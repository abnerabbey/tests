//
//  PayViewController.h
//  Monk
//
//  Created by Abner Castro Aguilar on 25/11/15.
//  Copyright © 2015 Abner Castro Aguilar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OtherBillViewController.h"

@protocol PayViewDelegate <NSObject>

- (void)didPayAccount;

@end

@interface PayViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, OtherBillDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableViewSetup;

@property (nonatomic, strong)NSArray *arrayCards;

@property (retain)id <PayViewDelegate> delegate;

@end
