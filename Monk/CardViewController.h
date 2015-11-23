//
//  CardViewController.h
//  Monk
//
//  Created by Abner Castro Aguilar on 31/10/15.
//  Copyright © 2015 Abner Castro Aguilar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

//Interface properties
@property (weak, nonatomic) IBOutlet UITableView *tableViewCards;

//Properties
@property (nonatomic, strong)NSMutableArray *arrayCards;


@end
