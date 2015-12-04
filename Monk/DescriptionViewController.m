//
//  DescriptionViewController.m
//  Monk
//
//  Created by Abner Castro Aguilar on 28/11/15.
//  Copyright © 2015 Abner Castro Aguilar. All rights reserved.
//

#import "DescriptionViewController.h"

@interface DescriptionViewController ()

@end

@implementation DescriptionViewController
{
    dispatch_queue_t imageQue;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    imageQue = dispatch_queue_create("Image Queue", NULL);
    
    //Customize Interface
    self.navigationItem.title = [self.dictionaryMenuDescription objectForKey:@"nombre"];
    self.imageBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height)];
    self.imageBackground.image = [UIImage imageWithData:self.imageData];
    [self.view insertSubview:self.imageBackground atIndex:0];
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurView.frame = self.view.bounds;
    [self.imageBackground addSubview:blurView];
    
    /*dispatch_async(imageQue, ^{
        UIImage *image = [self getMenuImage];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageMenu.image = image;
        });
    });*/
    self.textMenuDescription.text = [self getMenuDescription];
    
    //NSLog(@"menu description: %@", self.dictionaryMenuDescription);
}

- (UIImage *)getMenuImage
{
    NSDictionary *imageDictionary = [self.dictionaryMenuDescription objectForKey:@"image"];
    NSString *imageString = [imageDictionary objectForKey:@"url"];
    NSURL *urlImage = [NSURL URLWithString:imageString];
    NSData *imageData = [NSData dataWithContentsOfURL:urlImage];
    UIImage *image = [UIImage imageWithData:imageData];
    return image;
}

- (NSString *)getMenuDescription
{
    NSMutableString *stringMenuDescription = [[NSMutableString alloc] init];
    [stringMenuDescription appendString:@"\n"];
    [stringMenuDescription appendString:[self.dictionaryMenuDescription objectForKey:@"descripcion"]];
    [stringMenuDescription appendString:@"\n"];
    [stringMenuDescription appendString:@"\n"];
    
    NSArray *arrayPlatillos = [self.dictionaryMenuDescription objectForKey:@"platillos"];
    for (NSDictionary *dicPlatillo in arrayPlatillos) {
        [stringMenuDescription appendString:[dicPlatillo objectForKey:@"nombre"]];
        [stringMenuDescription appendString:@"\n"];
        [stringMenuDescription appendString:[dicPlatillo objectForKey:@"descripcion"]];
        [stringMenuDescription appendString:@"\n"];
        [stringMenuDescription appendString:[NSString stringWithFormat:@"precio: %@\n", [[dicPlatillo objectForKey:@"precio"] stringValue]]];
        [stringMenuDescription appendString:@"\n"];
        NSArray *arrayComplementos = [dicPlatillo objectForKey:@"complementos"];
        for (NSDictionary *dicComplemento in arrayComplementos) {
            [stringMenuDescription appendString:[dicComplemento objectForKey:@"nombre"]];
            [stringMenuDescription appendString:@"\n"];
            [stringMenuDescription appendString:[dicComplemento objectForKey:@"descripcion"]];
            [stringMenuDescription appendString:@"\n"];
            [stringMenuDescription appendString:[NSString stringWithFormat:@"precio: %@\n", [[dicComplemento objectForKey:@"precio"] stringValue]]];
            [stringMenuDescription appendString:@"\n"];
        }
    }
    NSLog(@"%@", self.dictionaryMenuDescription);
    return (NSString *)stringMenuDescription;
}

@end

















































































