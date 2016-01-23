//
//  AppDelegate.m
//  Owlers
//
//  Created by Biprajit Biswas on 24/09/15.
//  Copyright (c) 2015 JNT. All rights reserved.
//

#import "AppDelegate.h"
#import "Connectionmanager.h"
#import "Header.h"
#import "DBmanager.h"
#import "SharedPreferences.h"
#import "ProductViewController.h"

#import <GooglePlus/GooglePlus.h>
#import <FBSDKLoginKit/FBSDKLoginManager.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "PGMerchantConfiguration.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [self initializePaytmSDK];
    
    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
    {
        // iOS 8 Notifications
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [application registerForRemoteNotifications];
    }
    else
    {
        // iOS < 8 Notifications
        [application registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
    }
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];
}

- (void)setRootViewController{

    UINavigationController *navigationController = nil;
    if([[SharedPreferences sharedInstance] isLogin])
    {
        ProductViewController *productiView =[[ProductViewController alloc]init];
        navigationController=[[UINavigationController alloc]initWithRootViewController:productiView];
    }else{
        StartinhViewController *startingview=[[StartinhViewController alloc]initWithNibName:@"StartinhViewController" bundle:Nil];
        navigationController=[[UINavigationController alloc]initWithRootViewController:startingview];
    }
    
    self.window.rootViewController=navigationController;
    [self.window makeKeyAndVisible];
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"DEVICETOKEN"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //NSLog(@"My token is: %@", token);
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    [[SharedPreferences sharedInstance] showCommonAlertWithMessage:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] withObject:nil];
    
}
- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    //NSLog(@"Failed to get token, error: %@", error);
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    
    if ([GPPURLHandler handleURL:url sourceApplication:sourceApplication annotation:annotation]) {
        return [GPPURLHandler handleURL:url
                      sourceApplication:sourceApplication
                             annotation:annotation];
    }else if([[FBSDKApplicationDelegate sharedInstance] application:application
                                                            openURL:url
                                                  sourceApplication:sourceApplication
                                                         annotation:annotation]){
        return YES;
    }
    return NO;
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  //  [FBAppCall handleDidBecomeActiveWithSession:self.session];
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
     [FBSDKAppEvents activateApp];
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  //  [self.session close];
    
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)initializePaytmSDK{
    //You will get default PGMerchantConfiguration object. By setting the below properties of object you can make a fully configured merchant object.
    PGMerchantConfiguration *merchant = [PGMerchantConfiguration defaultConfiguration];
    
    // Set the client SSL certificate path. Certificate.p12 is the certificate which you received from Paytm during the registration process. Set the password if the certificate is protected by a password.
//    merchant.clientSSLCertPath = [[NSBundle mainBundle]pathForResource:@"Certificate" ofType:@"p12"];
//    merchant.clientSSLCertPassword = @"password";
    
    //NOTE: If the client SSL certificate is not configured then set the clientSSLCertPath and clientSSLCertPassword to NULL.
    
    //configure the PGMerchantConfiguration object specific to your requirements
    merchant.merchantID = @"xacICLAJjCJyvm2f";
    merchant.website = @"Icedreamwap";
    merchant.industryID = @"Retail";
    merchant.channelID = @"WEB & WAP"; //provided by PG
}


@end


