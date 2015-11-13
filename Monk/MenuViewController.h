//
//  MenuViewController.h
//  Monk
//
//  Created by Abner Castro Aguilar on 30/10/15.
//  Copyright © 2015 Abner Castro Aguilar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,NSURLSessionDelegate, NSURLSessionTaskDelegate>

//UI Properties
@property (weak, nonatomic) IBOutlet UITableView *tableMenu;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedAssitance;

//arraysMenus
@property (nonatomic, strong)NSMutableArray *arrayMenuNames;
@property (nonatomic, strong)NSMutableArray *arrayPlatillos;
@property (nonatomic, strong)NSMutableArray *imagesData;

//IBActions
- (IBAction)assistanceControl:(UISegmentedControl *)sender;
- (IBAction)viewAssitants:(UIBarButtonItem *)sender;
- (IBAction)shareMenu:(UIBarButtonItem *)sender;

@end
