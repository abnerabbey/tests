//
//  PageContentViewController.m
//  Monk
//
//  Created by Abner Castro Aguilar on 26/11/15.
//  Copyright © 2015 Abner Castro Aguilar. All rights reserved.
//

#import "PageContentViewController.h"

@interface PageContentViewController ()

@end

@implementation PageContentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.backgroundImage.image = [UIImage imageNamed:self.imageFile];
    self.titleLabel.text = self.titleText;
    
    
}


@end


























































