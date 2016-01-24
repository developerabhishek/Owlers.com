//
//  SharedPreferences.m
//  Owlers
//
//  Created by Abhishek on 05/01/16.
//  Copyright © 2016 JNT. All rights reserved.
//

#import "SharedPreferences.h"
#import "Connectionmanager.h"



@implementation SharedPreferences

static SharedPreferences *sharedInstance;

+ (SharedPreferences*) sharedInstance{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedInstance = [[SharedPreferences alloc] init];
    });
    
    return sharedInstance;
}

+ (BOOL)isNetworkAvailable{
   return [[ConnectionManager getSharedInstance] isConnectionAvailable];
}

- (void)showCommonAlertWithMessage:(NSString *)alertMessage withObject:(UIViewController *)controllerObject{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"JNT" message:alertMessage preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alertController dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    [alertController addAction:ok];
    
    if (controllerObject == nil) {
        controllerObject = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    }
    [controllerObject presentViewController:alertController animated:YES completion:nil];
}

- (BOOL)isLogin{
    
    NSUserDefaults *defauls = [NSUserDefaults standardUserDefaults];
    if ([defauls objectForKey:@"userID"]) {
        return true;
    }
    return false;
}

- (void)logoutUser{    
    NSUserDefaults *defauls = [NSUserDefaults standardUserDefaults];
    [defauls removeObjectForKey:@"userID"];
    [defauls synchronize];
}



- (NSString *)getUserID{    
    NSUserDefaults *defauls = [NSUserDefaults standardUserDefaults];
    return [defauls objectForKey:@"userID"];
}

- (NSString *)getUserEmail{
    NSUserDefaults *defauls = [NSUserDefaults standardUserDefaults];
    return [defauls objectForKey:@"userEmail"];
}

- (void)showCustomeLoading{
    
    NSEnumerator *frontToBackWindows = [[[UIApplication sharedApplication]windows]reverseObjectEnumerator];
    UIImageView *loadingImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"global_icon_left_logo.png"]];
    [loadingImage setTag:123321];
    
    for (UIWindow *window in frontToBackWindows){
        if (window.windowLevel == UIWindowLevelNormal) {
            loadingImage.center = window.center;
            [window addSubview:loadingImage];
            break;
        }
    }
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.toValue = [NSNumber numberWithDouble:M_PI_2];
    animation.duration = 0.4f;
    animation.cumulative = YES;
    animation.repeatCount = HUGE_VALF;
    [loadingImage.layer addAnimation:animation forKey:@"activityIndicatorAnimation"];
    
}

- (void)removeCustomeLoading{
    
    NSEnumerator *frontToBackWindows = [[[UIApplication sharedApplication]windows]reverseObjectEnumerator];
    for (UIWindow *window in frontToBackWindows){
        if (window.windowLevel == UIWindowLevelNormal) {
            UIImageView *imgeView = (UIImageView *)[window viewWithTag:123321];
            if (imgeView) {
                [imgeView removeFromSuperview];
            }
            break;
        }
    }
}

@end
