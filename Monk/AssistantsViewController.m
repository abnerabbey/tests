//
//  AssistantsViewController.m
//  Monk
//
//  Created by Abner Castro Aguilar on 30/10/15.
//  Copyright © 2015 Abner Castro Aguilar. All rights reserved.
//

#import "AssistantsViewController.h"

@interface AssistantsViewController ()

@end

@implementation AssistantsViewController
{
    UISegmentedControl *assistantFilter;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    assistantFilter = [[UISegmentedControl alloc] initWithItems:@[@"Asistirán", @"Tal Vez"]];
    assistantFilter.tintColor = [UIColor colorWithRed:0.737 green:0.635 blue:0.506 alpha:1.0];
    [assistantFilter addTarget:self action:@selector(filterAssistants) forControlEvents:UIControlEventValueChanged];
    
    UIBarButtonItem *okButton = [[UIBarButtonItem alloc] initWithTitle:@"Listo" style:UIBarButtonItemStyleDone target:self action:@selector(okView)];
    okButton.tintColor = [UIColor colorWithRed:0.737 green:0.635 blue:0.506 alpha:1.0];
    
    self.navigationItem.titleView = assistantFilter;
    assistantFilter.selectedSegmentIndex = 0;
    self.navigationItem.rightBarButtonItem = okButton;
}

- (void)okView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)filterAssistants
{
    switch(assistantFilter.selectedSegmentIndex)
    {
        case 0:
            NSLog(@"Segmento 0");
            break;
        case 1:
            NSLog(@"Segmento 1");
            break;
        default:
            break;
    }
}

@end


































































