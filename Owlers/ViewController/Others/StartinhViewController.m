//
//  StartinhViewController.m
//  Owlers
//
//  Created by Biprajit Biswas on 24/09/15.
//  Copyright (c) 2015 JNT. All rights reserved.
//

#import "StartinhViewController.h"
#import "ProductViewController.h"
#import "APPChildViewController.h"
#import "SharedPreferences.h"
#import "NetworkManager.h"
#import "SharedPreferences.h"
#import "SplashChildPageData.h"

@interface StartinhViewController ()

@property (strong, nonatomic) UIPageViewController *pageController;
@property (strong, nonatomic) NSMutableArray *pageDatalist;
@property (strong, nonatomic) NSTimer *timer;
//@property (weak, nonatomic) IBOutlet UIImageView *blurIMgView;

@end

@implementation StartinhViewController

int currentIndex = 0;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    APPChildViewController *initialViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    
    if([[SharedPreferences sharedInstance] isLogin]) {
        [self performSegueWithIdentifier:@"segueProducts" sender:nil];
    }

}

-(void)timerCalled
{
    if(currentIndex <= 3 || currentIndex >= 0){
        if(currentIndex==3){
            
            currentIndex = 0;
        }else{
            
            currentIndex++;
        }
        
        APPChildViewController *initialViewController = [self viewControllerAtIndex:currentIndex];
        NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
        [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    }
    
}

- (IBAction)loginBtnAction:(id)sender {
    if ([SharedPreferences isNetworkAvailable]){
        [self performSegueWithIdentifier:@"segueLogin" sender:nil];
    }
    else{
        [[SharedPreferences sharedInstance] showCommonAlertWithMessage:@"The network connection is not available" withObject:self];
    }
}

- (IBAction)signinBtnAction:(id)sender {
    if ([SharedPreferences isNetworkAvailable]){
        [self performSegueWithIdentifier:@"segueSignUp" sender:nil];
    }
    else{
        [[SharedPreferences sharedInstance] showCommonAlertWithMessage:@"The network connection is not available" withObject:self];
    }
}

- (IBAction)skipBtnAction:(id)sender {
    
    if ([SharedPreferences isNetworkAvailable]){
        [self performSegueWithIdentifier:@"segueProducts" sender:nil];
    }
    else{
        [[SharedPreferences sharedInstance] showCommonAlertWithMessage:@"The network connection is not available" withObject:self];
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"segueSplashPageContainer"]) {
        self.pageController = (UIPageViewController*)segue.destinationViewController;
        self.pageController.dataSource = self;
    }
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
    return currentIndex;
}

- (APPChildViewController *)viewControllerAtIndex:(NSUInteger)index {
    APPChildViewController *childViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"APPChildViewController"];
    childViewController.index = index;
    childViewController.data = (SplashChildPageData*)[self.pageDatalist objectAtIndex:index];

    return childViewController;
}

- (NSMutableArray*)pageDatalist {
    if (!_pageDatalist) {
        _pageDatalist = [[NSMutableArray alloc] init];
        SplashChildPageData *data1 = [SplashChildPageData dataWithImage:[UIImage imageNamed:@"1.png"] displayText:@""];
        [_pageDatalist addObject:data1];
        SplashChildPageData *data2 = [SplashChildPageData dataWithImage:[UIImage imageNamed:@"3.png"] displayText:@"Bid for amaging offers, use them on-the-go"];
        [_pageDatalist addObject:data2];
        SplashChildPageData *data3 = [SplashChildPageData dataWithImage:[UIImage imageNamed:@"2.png"] displayText:@"Get access to the best party locations right from your phone"];
        [_pageDatalist addObject:data3];
        SplashChildPageData *data4 = [SplashChildPageData dataWithImage:[UIImage imageNamed:@"4.png"] displayText:@"Find the most exciting events in your city"];
        [_pageDatalist addObject:data4];
    }
    return _pageDatalist;
}

- (void)viewDidAppear:(BOOL)animated {
//    if([[SharedPreferences sharedInstance] isLogin]) {
//        [self performSegueWithIdentifier:@"segueProducts" sender:nil];
//    }
//    self.blurIMgView.hidden = YES;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(timerCalled) userInfo:nil repeats:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [_timer invalidate];
    _timer = nil;
}

@end
