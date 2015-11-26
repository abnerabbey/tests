//
//  TutorialRootViewController.h
//  Monk
//
//  Created by Abner Castro Aguilar on 26/11/15.
//  Copyright © 2015 Abner Castro Aguilar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageContentViewController.h"

@interface TutorialRootViewController : UIViewController <UIPageViewControllerDataSource>

@property (nonatomic, strong)UIPageViewController *pageViewController;
@property (nonatomic, strong)NSArray *pageTitles;
@property (nonatomic, strong)NSArray *pageImages;


@end
