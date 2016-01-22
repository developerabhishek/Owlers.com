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
    
    
//    // Override point for customization after application launch.
//    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
//    
//    [self setRootViewController];
    
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
    NSLog(@"My token is: %@", token);
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    [[SharedPreferences sharedInstance] showCommonAlertWithMessage:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] withObject:nil];
    
}
- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    //NSLog(@"Failed to get token, error: %@", error);
}

#pragma mark - Operation With Locaal database
-(void)saveLocalStoredSurveyOnServer:(NSArray *)array
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        //Background Thread
        
        for (int i = 0; i < [array count]; i++)
        {
            NSMutableDictionary *jsonDict = [[NSMutableDictionary alloc] init];
            [jsonDict setValue:[[array objectAtIndex:i] valueForKey:@"user_id"] forKey:@"user_id"];
            [jsonDict setValue:[[array objectAtIndex:i] valueForKey:@"lat"] forKey:@"lat"];
            [jsonDict setValue:[[array objectAtIndex:i] valueForKey:@"lng"] forKey:@"lng"];
            [jsonDict setValue:[[array objectAtIndex:i] valueForKey:@"comment"] forKey:@"comment"];
            
            [jsonDict setValue:[[array objectAtIndex:i] valueForKey:@"currentTime"] forKey:@"date_time"];
            
            [jsonDict setValue:[[array objectAtIndex:i] valueForKey:@"answer"] forKey:@"questionlist"];
            
            [jsonDict setValue:@"0" forKey:@"distance"];
            [jsonDict setValue:@"0" forKey:@"status"];
            
            // Code to send expense data on server
            NSMutableData *body = [NSMutableData data];
            NSError *writeError = nil;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict options:NSJSONWritingPrettyPrinted error:&writeError];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSURL *postUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/postaudit.php",BaseUrl]];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:postUrl];
            [request setCachePolicy:NSURLRequestUseProtocolCachePolicy];
            [request setTimeoutInterval:7.0];
            [request setHTTPMethod:@"POST"];
            
            NSString *contentType = [NSString stringWithFormat:@"application/json"];
            [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
            [body appendData:[[NSString stringWithFormat:@"%@",jsonString] dataUsingEncoding:NSUTF8StringEncoding]];
            [request setHTTPBody:body];
            
            // [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
            
            NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
            
            if (data.length > 0)
            {
                NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                
                if ([[parsedObject valueForKey:@"success"] integerValue] == 1)
                {
                    
                    NSData *imageData = UIImagePNGRepresentation([[array objectAtIndex:i] valueForKey:@"survey_image"]);
                    
                    if (imageData.length > 0 )  // Means image is selected so upload in background
                    {
                        [self uploadSurveyImageImaBackGround:[parsedObject objectForKey:@"auditid"] withImage:[[array objectAtIndex:i] valueForKey:@"survey_image"] surveyId:[[array objectAtIndex:i] valueForKey:@"survey_id"]];
                    }
                    else
                    {
                        // delete survey from local database
                       
                        
                    }
                }
            }
        }
    });
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



-(void)uploadSurveyImageImaBackGround:(NSString *)auditid withImage:(UIImage *)image surveyId:(NSString *)surveyId
{
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        
        NSData *imageData = UIImagePNGRepresentation(image);
        
        //Background Thread
        NSMutableData *body = [NSMutableData data];
        
        NSString *postUrl=[[NSString stringWithFormat:@"%@/auditimage.php?auditid=%@",BaseUrl,auditid]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        
        postUrl = [postUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [request setURL:[NSURL URLWithString:postUrl]];
        
        [request setCachePolicy:NSURLRequestUseProtocolCachePolicy];
        
        [request setTimeoutInterval:10.0];
        
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[[NSString stringWithString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"upload\"; filename=\"%@\"\r\n",@".png"]] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[NSData dataWithData:imageData]];
        
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [request setHTTPMethod:@"POST"];
        
        [request setHTTPBody:body];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
         {
             dispatch_async(dispatch_get_main_queue(), ^(void){
                 //Run UI Updates
                 
                 if (data.length > 0)
                 {
                     NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                     NSLog(@"parsedObject =%@",parsedObject);
                                      }
                 else
                 {
                     NSLog(@"Image is not uploaded due to some issue");
                 }
             });
         }];
    });
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


- (NSDictionary *)parametersDictionaryFromQueryString:(NSString *)queryString {
    
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    
    NSArray *queryComponents = [queryString componentsSeparatedByString:@"&"];
    
    for(NSString *s in queryComponents) {
        NSArray *pair = [s componentsSeparatedByString:@"="];
        if([pair count] != 2) continue;
        
        NSString *key = pair[0];
        NSString *value = pair[1];
        
        md[key] = value;
    }
    
    return md;
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

//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
//{
//    
//    if ([[url scheme] isEqualToString:@"myapp"] == YES)
//    {
//        NSDictionary *d = [self parametersDictionaryFromQueryString:[url query]];
//        
//        NSString *token = d[@"oauth_token"];
//        NSString *verifier = d[@"oauth_verifier"];
//        
//        LoginViewController *vc = (LoginViewController *)[[[self window] rootViewController] presentedViewController];
//        [vc setOAuthToken:token oauthVerifier:verifier];
//        
//        return YES;
//    }
 /*   else
    {
        return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication withSession:self.session];
    }*/
//    return NO;
//
//}




@end


