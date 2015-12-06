//
//  SelectSaldoViewController.h
//  Monk
//
//  Created by Abner Castro Aguilar on 06/12/15.
//  Copyright © 2015 Abner Castro Aguilar. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SaldoViewControllerDelegate <NSObject>

- (void)didSelectSaldo:(float)saldoSelected;

@end

@interface SelectSaldoViewController : UIViewController <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;


@property (retain)id <SaldoViewControllerDelegate> delegate;
@end
