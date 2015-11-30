//
//  OtherBillViewController.h
//  Monk
//
//  Created by Abner Castro Aguilar on 29/11/15.
//  Copyright © 2015 Abner Castro Aguilar. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OtherBillDelegate <NSObject>

- (void)didSelectOtherBill:(float)bill;

@end

@interface OtherBillViewController : UIViewController <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textOtherView;

@property (retain)id <OtherBillDelegate> delegate;

@end
