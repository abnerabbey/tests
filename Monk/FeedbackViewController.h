//
//  FeedbackViewController.h
//  Monk
//
//  Created by Abner Castro Aguilar on 06/11/15.
//  Copyright © 2015 Abner Castro Aguilar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComentViewController.h"

@interface FeedbackViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, CommentViewDelgate>

@property (weak, nonatomic) IBOutlet UITableView *tableViewFeed;

@property (nonatomic, strong)NSMutableArray *servicioArrayFeed;
@property (nonatomic, strong)NSMutableArray *comidaArrayFeed;
@property (nonatomic, strong)NSMutableArray *lugarArrayFeed;

@property int numberOfStars;


@end
