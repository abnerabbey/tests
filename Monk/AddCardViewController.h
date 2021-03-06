//
//  AddCardViewController.h
//  Monk
//
//  Created by Abner Castro Aguilar on 01/11/15.
//  Copyright © 2015 Abner Castro Aguilar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddCardViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textFieldTarjeta;
@property (weak, nonatomic) IBOutlet UITextField *textFieldCVV;
@property (weak, nonatomic) IBOutlet UITextField *textFieldExpiration;
@property (weak, nonatomic) IBOutlet UITextField *textFieldNombre;
@property (weak, nonatomic) IBOutlet UIButton *buttonAddCard;

@property (weak, nonatomic) IBOutlet UILabel *labelNoTarjeta;
@property (weak, nonatomic) IBOutlet UILabel *labelFechaExp;
@property (weak, nonatomic) IBOutlet UILabel *labelCVV;

- (IBAction)hideKeyboard:(UITapGestureRecognizer *)sender;
- (IBAction)addCard:(UIButton *)sender;

@end
