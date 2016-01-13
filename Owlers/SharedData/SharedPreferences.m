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


@end
