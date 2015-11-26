//
//  TutorialRootViewController.m
//  Monk
//
//  Created by Abner Castro Aguilar on 26/11/15.
//  Copyright © 2015 Abner Castro Aguilar. All rights reserved.
//

#import "TutorialRootViewController.h"

@interface TutorialRootViewController ()

@end

@implementation TutorialRootViewController
{
    UIBarButtonItem *okButton;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"MonK";
    okButton = [[UIBarButtonItem alloc] initWithTitle:@"Listo" style:UIBarButtonItemStyleDone target:self action:@selector(okTutorial)];
    okButton.enabled = NO;
    self.navigationItem.rightBarButtonItem = okButton;
    
    self.pageImages = [NSArray arrayWithObjects:@"come.jpg", @"cuida.jpg", @"sentidos.jpg", @"conecta.jpg", nil];
    self.pageTitles = [NSArray arrayWithObjects:@"Come Saludable\nIngredientes y recetas Premium", @"Cuida el Planeta\nIngredientes de bajo impacto ambiental", @"Come Sabroso\nDeleita a tus 5 sentidos", @"Conecta con Otros\nTerraza con jardín privado para conectar con amigos", nil];
    
    self.pageViewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    
    PageContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
}

- (void)okTutorial
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (PageContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if([self.pageTitles count] == 0 || (index >= [self.pageTitles count]))
        return nil;
    
    if(index == [self.pageTitles count] - 1)
        okButton.enabled = YES;
    else
        okButton.enabled = NO;
    
    PageContentViewController *pageContentViewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"PageContentViewControler"];
    pageContentViewController.imageFile = self.pageImages[index];
    pageContentViewController.titleText = self.pageTitles[index];
    pageContentViewController.pageIndex = index;
    
    return pageContentViewController;
}

#pragma mark PageView Delegate
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((PageContentViewController *)viewController).pageIndex;
    if(index == 0 || index == NSNotFound)
        return nil;
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((PageContentViewController *)viewController).pageIndex;
    if(index == NSNotFound)
        return nil;
    index++;
    if(index == [self.pageTitles count])
        return nil;
    return [self viewControllerAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.pageTitles count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

@end







































































