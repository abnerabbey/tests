//
//  SaldoCardViewController.h
//  Monk
//
//  Created by Abner Castro Aguilar on 08/12/15.
//  Copyright © 2015 Abner Castro Aguilar. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SaldoCardViewDelegate <NSObject>

- (void)didSelectSaldoCard:(float)saldoCard;

@end

@interface SaldoCardViewController : UIViewController <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (retain)id <SaldoCardViewDelegate> delegate;
@end
