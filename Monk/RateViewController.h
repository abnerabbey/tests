//
//  RateViewController.h
//  Monk
//
//  Created by Abner Castro Aguilar on 06/11/15.
//  Copyright © 2015 Abner Castro Aguilar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RateViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *buttonRate;
- (IBAction)rateMonk:(UIButton *)sender;
@end
