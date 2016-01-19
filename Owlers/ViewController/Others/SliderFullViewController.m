//
//  SliderFullViewController.m
//  Owlers
//
//  Created by RANVIJAI on 19/01/16.
//  Copyright © 2016 JNT. All rights reserved.
//

#import "SliderFullViewController.h"
#import "APPChildViewController.h"
#import "SplashChildPageData.h"

@interface SliderFullViewController ()

@property (strong, nonatomic) UIPageViewController *pageController;
@property (nonatomic, assign)int currentIndex;

@end

@implementation SliderFullViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentIndex = 0;
    APPChildViewController *initialViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"segueSliderPageContainer"]) {
        self.pageController = (UIPageViewController*)segue.destinationViewController;
        self.pageController.dataSource = self;
    }
}

- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((APPChildViewController*) viewController).index;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    // Decrease the index by 1 to return
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((APPChildViewController*) viewController).index;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index >= self.pageDatalist.count) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return self.pageDatalist.count;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return self.currentIndex;
}

- (APPChildViewController *)viewControllerAtIndex:(NSUInteger)index {
    APPChildViewController *childViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"APPChildViewController"];
    childViewController.hideMessage = YES;
    childViewController.mode = UIViewContentModeScaleAspectFill;
    childViewController.index = index;
    childViewController.data = (SplashChildPageData*)[self.pageDatalist objectAtIndex:index];
    self.currentIndex = index;
    
    return childViewController;
}

@end
