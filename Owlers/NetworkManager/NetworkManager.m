//
//  NetworkManager.m
//  Owlers
//
//  Created by Abhishek on 05/01/16.
//  Copyright © 2016 JNT. All rights reserved.
//

#import "NetworkManager.h"
#import "AFHTTPRequestOperationManager.h"
#import "SVProgressHUD.h"
#import "SharedPreferences.h"
#import "Header.h"

NSString *BaseURLLive   =   @"http://www.owlers.com/services";
NSString *BaseURLDemo   =   @"http://www.owlers.com/services";

@implementation NetworkManager

#pragma mark Get Base URL 

+ (NSString *)getBaseUrl{
    
    return BaseURLLive;
    
}

#pragma mark LoadAuction

+ (void)loadAcutionsForCity:(NSString *)cityID withComplitionHandler:(CompletionHandler)completionBlock{

    if ([SharedPreferences isNetworkAvailable])
    {
        [SVProgressHUD showWithStatus:@"Loading.." maskType:SVProgressHUDMaskTypeGradient];
        
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [manager GET:[NSString stringWithFormat:@"%@/auctions.php",BaseUrl] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [SVProgressHUD dismiss];
            NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            completionBlock(dataDict, nil);

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD dismiss];
            completionBlock(nil, error);
        }];
        
    }else{
        [[SharedPreferences sharedInstance] showCommonAlertWithMessage:@"Please connect with internet" withObject:nil];
    }
    
}

+ (void)loadLocationWithComplitionHandler:(CompletionHandler)completionBlock{

    if ([SharedPreferences isNetworkAvailable])
    {
        [SVProgressHUD showWithStatus:@"Loading.." maskType:SVProgressHUDMaskTypeGradient];
        
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [manager GET:[NSString stringWithFormat:@"%@/get_locations.php",BaseUrl] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            [SVProgressHUD dismiss];
            completionBlock(dataDict, nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD dismiss];
            completionBlock(nil, error);
        }];
        
    }else{
        [[SharedPreferences sharedInstance] showCommonAlertWithMessage:@"Please connect with internet" withObject:nil];
    }
    
}


+ (void)loadAuctionDetailsForAuction:(NSString *)auctionID withComplitionHandler:(CompletionHandler)completionBlock{
    
    if ([SharedPreferences isNetworkAvailable])
    {
        [SVProgressHUD showWithStatus:@"Loading.." maskType:SVProgressHUDMaskTypeGradient];
        
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [manager GET:[NSString stringWithFormat:@"%@/auctions.php",BaseUrl] parameters:@{@"auction_id":auctionID} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            [SVProgressHUD dismiss];
            completionBlock(dataDict, nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD dismiss];
            completionBlock(nil, error);
        }];
        
    }else{
        [[SharedPreferences sharedInstance] showCommonAlertWithMessage:@"Please connect with internet" withObject:nil];
    }
    
}

+ (void)checkAuctionBidForAuction:(NSString *)auctionID withComplitionHandler:(CompletionHandler)completionBlock{
    
    if ([SharedPreferences isNetworkAvailable])
    {
        [SVProgressHUD showWithStatus:@"Loading.." maskType:SVProgressHUDMaskTypeGradient];
        
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [manager GET:[NSString stringWithFormat:@"%@/get_bid.php",BaseUrl] parameters:@{@"auction_id":auctionID} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            [SVProgressHUD dismiss];
            completionBlock(dataDict, nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD dismiss];
            completionBlock(nil, error);
        }];
        
    }else{
        [[SharedPreferences sharedInstance] showCommonAlertWithMessage:@"Please connect with internet" withObject:nil];
    }
}

+ (void)saveBidForAuction:(NSString *)auctionID andBidAmount:(NSString *)amount andBuyNow:(BOOL)isBuyNow
    withComplitionHandler:(CompletionHandler)completionBlock{
    
    if ([SharedPreferences isNetworkAvailable])
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *userID = [defaults objectForKey:@"userID"] ? [defaults objectForKey:@"userID"] : @"31";

        [SVProgressHUD showWithStatus:@"Loading.." maskType:SVProgressHUDMaskTypeGradient];
        
        NSString *serviceName = @"save_bid.php";
        if (isBuyNow) {
            serviceName = @"save_buy_now.php";
        }
        
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [manager GET:[NSString stringWithFormat:@"%@/%@",BaseUrl,serviceName] parameters:@{@"auction_id":auctionID , @"user_id" : userID , @"bid_amount" : amount} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            [SVProgressHUD dismiss];
            completionBlock(dataDict, nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD dismiss];
            completionBlock(nil, error);
        }];
        
    }else{
        [[SharedPreferences sharedInstance] showCommonAlertWithMessage:@"Please connect with internet" withObject:nil];
    }
}


#pragma mark
#pragma mark Login/Signup/Passowrdchange
#pragma mark

+ (void)loginWithEmail:(NSString *)email andPassword:(NSString *)password withComplitionHandler:(CompletionHandler)completionBlock{
    
    if ([SharedPreferences isNetworkAvailable])
    {
        [SVProgressHUD showWithStatus:@"Loading.." maskType:SVProgressHUDMaskTypeGradient];
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [manager GET:[NSString stringWithFormat:@"%@/signin.php",BaseUrl] parameters:@{@"email":email , @"password" : password} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            [SVProgressHUD dismiss];
            completionBlock(dataDict, nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD dismiss];
            completionBlock(nil, error);
        }];
        
    }else{
        [[SharedPreferences sharedInstance] showCommonAlertWithMessage:@"Please connect with internet" withObject:nil];
    }
}

+ (void)loginVerificationWithName:(NSString *)name email:(NSString *)email andMobileNumber:(NSString *)mobile withComplitionHandler:(CompletionHandler)completionBlock{
    
    if ([SharedPreferences isNetworkAvailable])
    {
        [SVProgressHUD showWithStatus:@"Loading.." maskType:SVProgressHUDMaskTypeGradient];
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [manager GET:[NSString stringWithFormat:@"%@/social_login.php",BaseUrl] parameters:@{@"name" : name, @"email" : email, @"image_path" : @"", @"mobile" : mobile,@"source" : @"iPhone", @"mac_addr" : @"4545.7765.767"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            [SVProgressHUD dismiss];
            completionBlock(dataDict, nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD dismiss];
            completionBlock(nil, error);
        }];
        
    }else{
        [[SharedPreferences sharedInstance] showCommonAlertWithMessage:@"Please connect with internet" withObject:nil];
    }
}

+ (void)getUserProfileFromServerWithComplitionHandler:(CompletionHandler)completionBlock{
    
    if ([SharedPreferences isNetworkAvailable])
    {
        [SVProgressHUD showWithStatus:@"Loading.." maskType:SVProgressHUDMaskTypeGradient];
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [manager GET:[NSString stringWithFormat:@"%@/profile.php",BaseUrl] parameters:@{@"user_id" : [[SharedPreferences sharedInstance] getUserID]} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            [SVProgressHUD dismiss];
            completionBlock(dataDict, nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD dismiss];
            completionBlock(nil, error);
        }];
        
    }else{
        [[SharedPreferences sharedInstance] showCommonAlertWithMessage:@"Please connect with internet" withObject:nil];
    }
}

+ (void)changeOldPassword:(NSString *)oldPassword toNewPassword:(NSString *)newPassword withComplitionHandler:(CompletionHandler)completionBlock{

    if ([SharedPreferences isNetworkAvailable])
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *userID = [defaults objectForKey:@"userID"] ? [defaults objectForKey:@"userID"] : @"31";
        
        [SVProgressHUD showWithStatus:@"Loading.." maskType:SVProgressHUDMaskTypeGradient];

        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [manager GET:[NSString stringWithFormat:@"%@/change_pwd.php",BaseUrl] parameters:@{@"oldPwd":oldPassword , @"userID" : userID , @"newPwd" : newPassword} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            [SVProgressHUD dismiss];
            completionBlock(dataDict, nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD dismiss];
            completionBlock(nil, error);
        }];
        
    }else{
        [[SharedPreferences sharedInstance] showCommonAlertWithMessage:@"Please connect with internet" withObject:nil];
    }
}

+ (void)forgetPasswordForEmail:(NSString *)email withComplitionHandler:(CompletionHandler)completionBlock{
    
    if ([SharedPreferences isNetworkAvailable])
    {
        [SVProgressHUD showWithStatus:@"Loading.." maskType:SVProgressHUDMaskTypeGradient];
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [manager GET:[NSString stringWithFormat:@"%@/forgot.php",BaseUrl] parameters:@{@"Email":email} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            [SVProgressHUD dismiss];
            completionBlock(dataDict, nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD dismiss];
            completionBlock(nil, error);
        }];
        
    }else{
        [[SharedPreferences sharedInstance] showCommonAlertWithMessage:@"Please connect with internet" withObject:nil];
    }
}


+ (void)editUserProfile:(NSString *)name andMobileNumber:(NSString *)mobile withComplitionHandler:(CompletionHandler)completionBlock{
    
    if ([SharedPreferences isNetworkAvailable])
    {
        [SVProgressHUD showWithStatus:@"Loading.." maskType:SVProgressHUDMaskTypeGradient];
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];

        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        [manager GET:[NSString stringWithFormat:@"%@/update_profile.php",BaseUrl] parameters:@{@"name" : name, @"user_id" :[defaults objectForKey:@"userID"], @"mob_no" : mobile} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            [SVProgressHUD dismiss];
            completionBlock(dataDict, nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD dismiss];
            completionBlock(nil, error);
        }];
        
    }else{
        [[SharedPreferences sharedInstance] showCommonAlertWithMessage:@"Please connect with internet" withObject:nil];
    }
}


@end
