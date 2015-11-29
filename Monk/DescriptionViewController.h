//
//  DescriptionViewController.h
//  Monk
//
//  Created by Abner Castro Aguilar on 28/11/15.
//  Copyright © 2015 Abner Castro Aguilar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DescriptionViewController : UIViewController

@property (strong, nonatomic)UIImageView *imageBackground;
@property (weak, nonatomic) IBOutlet UIImageView *imageMenu;
@property (weak, nonatomic) IBOutlet UITextView *textMenuDescription;

@property (nonatomic, strong)NSData *imageData;
@property (nonatomic, strong)NSDictionary *dictionaryMenuDescription;

@end
