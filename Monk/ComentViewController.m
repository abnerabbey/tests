//
//  ComentViewController.m
//  Monk
//
//  Created by Abner Castro Aguilar on 28/11/15.
//  Copyright © 2015 Abner Castro Aguilar. All rights reserved.
//

#import "ComentViewController.h"

@interface ComentViewController ()

@end

@implementation ComentViewController
{
    UIBarButtonItem *okButton;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Tu comentario";
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancelar" style:UIBarButtonItemStylePlain target:self action:@selector(cancelView)];
    okButton = [[UIBarButtonItem alloc] initWithTitle:@"Listo" style:UIBarButtonItemStyleDone target:self action:@selector(okView)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.rightBarButtonItem = okButton;
}

- (void)cancelView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)okView
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [[self delegate] didComment:self.commentTextView.text];
}

@end

























































































