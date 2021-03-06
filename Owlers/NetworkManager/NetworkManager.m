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
NSString *internetMessage   =   @"Please connect with internet";

@implementation NetworkManager

#pragma mark Get Base URL 

+ (NSString *)getBaseUrl{
    
    return BaseURLLive;
    
}

#pragma mark LoadAuction

+ (void)fetchEventListForLocation:(NSString *)locationID withRefereshController:(BOOL)shoudRefresh  withComplitionHandler:(CompletionHandler)completionBlock{
    
    if ([SharedPreferences isNetworkAvailable])
    {
        if (shoudRefresh) {
            [[SharedPreferences sharedInstance] showCustomeLoading];
        }
        
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [manager GET:[NSString stringWithFormat:@"%@/list_events.php",BaseUrl] parameters:@{@"location_id" : locationID} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [[SharedPreferences sharedInstance] removeCustomeLoading];
            NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            completionBlock(dataDict, nil);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [[SharedPreferences sharedInstance] removeCustomeLoading];
            completionBlock(nil, error);
        }];
        
    }else{
        [[SharedPreferences sharedInstance] showCommonAlertWithMessage:internetMessage withObject:nil];
    }
}

+ (void)fetchEventListForSelectedDate:(NSString *)dateString forLocation:(NSString *)locationID withComplitionHandler:(CompletionHandler)completionBlock{
    
    if ([SharedPreferences isNetworkAvailable])
    {
        //[SVProgressHUD showWithStatus:@"Loading.." maskType:SVProgressHUDMaskTypeGradient];
        [[SharedPreferences sharedInstance] showCustomeLoading];
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [manager GET:[NSString stringWithFormat:@"%@/list_events.php",BaseUrl] parameters:@{@"location_id" : locationID, @"date" : dateString} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [[SharedPreferences sharedInstance] removeCustomeLoading];
            //[SVProgressHUD dismiss];
            NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            completionBlock(dataDict, nil);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [[SharedPreferences sharedInstance] removeCustomeLoading];
            completionBlock(nil, error);
        }];
        
    }else{
        [[SharedPreferences sharedInstance] showCommonAlertWithMessage:internetMessage withObject:nil];
    }
}

+ (void)loadAcutionsForCity:(NSString *)cityID withComplitionHandler:(CompletionHandler)completionBlock{

    if ([SharedPreferences isNetworkAvailable])
    {
        //[SVProgressHUD showWithStatus:@"Loading.." maskType:SVProgressHUDMaskTypeGradient];
        [[SharedPreferences sharedInstance] showCustomeLoading];
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];

        NSDictionary *dict = nil;
        if (cityID) {
            dict = @{@"location_id" : cityID};
        }
        
        [manager GET:[NSString stringWithFormat:@"%@/auctions.php",BaseUrl] parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [[SharedPreferences sharedInstance] removeCustomeLoading];
            NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            completionBlock(dataDict, nil);

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [[SharedPreferences sharedInstance] removeCustomeLoading];
            completionBlock(nil, error);
        }];
        
    }else{
        [[SharedPreferences sharedInstance] showCommonAlertWithMessage:internetMessage withObject:nil];
    }
    
}

+ (void)loadLocationWithComplitionHandler:(CompletionHandler)completionBlock{

    if ([SharedPreferences isNetworkAvailable])
    {
        //[SVProgressHUD showWithStatus:@"Loading.." maskType:SVProgressHUDMaskTypeGradient];
        [[SharedPreferences sharedInstance] showCustomeLoading];
        
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [manager GET:[NSString stringWithFormat:@"%@/get_locations.php",BaseUrl] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            [[SharedPreferences sharedInstance] removeCustomeLoading];
            //[SVProgressHUD dismiss];
            completionBlock(dataDict, nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //[SVProgressHUD dismiss];
            completionBlock(nil, error);
        }];
        
    }else{
        [[SharedPreferences sharedInstance] showCommonAlertWithMessage:internetMessage withObject:nil];
    }
}

+ (void)searchEventForString:(NSString *)searchString withComplitionHandler:(CompletionHandler)completionBlock{
    
    if ([SharedPreferences isNetworkAvailable])
    {
        //[SVProgressHUD showWithStatus:@"Loading.." maskType:SVProgressHUDMaskTypeGradient];
        [[SharedPreferences sharedInstance] showCustomeLoading];
        
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [manager GET:[NSString stringWithFormat:@"%@/search_events.php",BaseUrl] parameters:@{@"search_box" : searchString} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [[SharedPreferences sharedInstance] removeCustomeLoading];
            //[SVProgressHUD dismiss];
            NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            completionBlock(dataDict, nil);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [[SharedPreferences sharedInstance] removeCustomeLoading];
            //[SVProgressHUD dismiss];
            completionBlock(nil, error);
        }];
        
    }else{
        [[SharedPreferences sharedInstance] showCommonAlertWithMessage:internetMessage withObject:nil];
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
        [[SharedPreferences sharedInstance] showCommonAlertWithMessage:internetMessage withObject:nil];
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
        [[SharedPreferences sharedInstance] showCommonAlertWithMessage:internetMessage withObject:nil];
    }
}

+ (void)saveBidForAuction:(NSString *)auctionID andBidAmount:(NSString *)amount andBuyNow:(BOOL)isBuyNow
    withComplitionHandler:(CompletionHandler)completionBlock{
    
    if ([SharedPreferences isNetworkAvailable])
    {
        [SVProgressHUD showWithStatus:@"Loading.." maskType:SVProgressHUDMaskTypeGradient];
        
        NSString *serviceName = @"save_bid.php";
        if (isBuyNow) {
            serviceName = @"save_buy_now.php";
        }
        
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [manager GET:[NSString stringWithFormat:@"%@/%@",BaseUrl,serviceName] parameters:@{@"auction_id":auctionID , @"user_id" : [[SharedPreferences sharedInstance] getUserID] , @"bid_amount" : amount} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            [SVProgressHUD dismiss];
            completionBlock(dataDict, nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD dismiss];
            completionBlock(nil, error);
        }];
        
    }else{
        [[SharedPreferences sharedInstance] showCommonAlertWithMessage:internetMessage withObject:nil];
    }
}


+ (void)getMyBidsWithComplitionHandler:(CompletionHandler)completionBlock{
    
    if ([SharedPreferences isNetworkAvailable])
    {
        [SVProgressHUD showWithStatus:@"Loading.." maskType:SVProgressHUDMaskTypeGradient];
        
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [manager GET:[NSString stringWithFormat:@"%@/auctions.php",BaseUrl] parameters:@{@"user_id" : [[SharedPreferences sharedInstance] getUserID]} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            [SVProgressHUD dismiss];
            completionBlock(dataDict, nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD dismiss];
            completionBlock(nil, error);
        }];
        
    }else{
        [[SharedPreferences sharedInstance] showCommonAlertWithMessage:internetMessage withObject:nil];
    }
}

+ (void)getAllBooking:(CompletionHandler)completionBlock{
    
    if ([SharedPreferences isNetworkAvailable])
    {
        [SVProgressHUD showWithStatus:@"Loading.." maskType:SVProgressHUDMaskTypeGradient];
        
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [manager GET:[NSString stringWithFormat:@"%@/get_booking.php",BaseUrl] parameters:@{@"user_id" : [[SharedPreferences sharedInstance] getUserID]} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            [SVProgressHUD dismiss];
            completionBlock(dataDict, nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD dismiss];
            completionBlock(nil, error);
        }];
        
    }else{
        [[SharedPreferences sharedInstance] showCommonAlertWithMessage:internetMessage withObject:nil];
    }
}

#pragma mark
#pragma mark Event-Booking
#pragma mark

+ (void)getEventDetails:(NSString *)eventID withComplitionBlock:(CompletionHandler)completionBlock{
    
    if ([SharedPreferences isNetworkAvailable])
    {
        [SVProgressHUD showWithStatus:@"Loading.." maskType:SVProgressHUDMaskTypeGradient];
        
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [manager GET:[NSString stringWithFormat:@"%@/event_details.php",BaseUrl] parameters:@{@"event_id" : eventID} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            [SVProgressHUD dismiss];
            completionBlock(dataDict, nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD dismiss];
            completionBlock(nil, error);
        }];
        
    }else{
        [[SharedPreferences sharedInstance] showCommonAlertWithMessage:internetMessage withObject:nil];
    }
}

+ (void)bookEvent:(NSDictionary *)dict withComplitionBlock:(CompletionHandler)completionBlock{
    
    if ([SharedPreferences isNetworkAvailable])
    {
        [SVProgressHUD showWithStatus:@"Loading.." maskType:SVProgressHUDMaskTypeGradient];
        
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [manager GET:[NSString stringWithFormat:@"%@/book_event.php",BaseUrl] parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            [SVProgressHUD dismiss];
            completionBlock(dataDict, nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD dismiss];
            completionBlock(nil, error);
        }];
        
    }else{
        [[SharedPreferences sharedInstance] showCommonAlertWithMessage:internetMessage withObject:nil];
    }
}

+ (void)bookOffer:(NSDictionary *)dict withComplitionBlock:(CompletionHandler)completionBlock{
    
    if ([SharedPreferences isNetworkAvailable])
    {
        [SVProgressHUD showWithStatus:@"Loading.." maskType:SVProgressHUDMaskTypeGradient];
        
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [manager GET:[NSString stringWithFormat:@"%@/book_offer.php",BaseUrl] parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            [SVProgressHUD dismiss];
            completionBlock(dataDict, nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD dismiss];
            completionBlock(nil, error);
        }];
        
    }else{
        [[SharedPreferences sharedInstance] showCommonAlertWithMessage:internetMessage withObject:nil];
    }
}

#pragma mark
#pragma mark Login/Signup/Passowrdchange
#pragma mark

+ (void)signUpWithEmail:(NSString *)email andPassword:(NSString *)password andMobile:(NSString *)mobile andName:(NSString *)name withComplitionHandler:(CompletionHandler)completionBlock{
    
    if ([SharedPreferences isNetworkAvailable])
    {
        [SVProgressHUD showWithStatus:@"Loading.." maskType:SVProgressHUDMaskTypeGradient];
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];

        [manager GET:[NSString stringWithFormat:@"%@/signup.php",BaseUrl] parameters:@{@"name":name , @"email":email , @"password" : password, @"phone" : mobile, @"source" : @"iPhone" , @"mac_addr" : @"4545.7765.767" } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            [SVProgressHUD dismiss];
            completionBlock(dataDict, nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD dismiss];
            completionBlock(nil, error);
        }];
        
    }else{
        [[SharedPreferences sharedInstance] showCommonAlertWithMessage:internetMessage withObject:nil];
    }
}


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
        [[SharedPreferences sharedInstance] showCommonAlertWithMessage:internetMessage withObject:nil];
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
        [[SharedPreferences sharedInstance] showCommonAlertWithMessage:internetMessage withObject:nil];
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
        [[SharedPreferences sharedInstance] showCommonAlertWithMessage:internetMessage withObject:nil];
    }
}

+ (void)changeOldPassword:(NSString *)oldPassword toNewPassword:(NSString *)newPassword withComplitionHandler:(CompletionHandler)completionBlock{

    if ([SharedPreferences isNetworkAvailable])
    {
        [SVProgressHUD showWithStatus:@"Loading.." maskType:SVProgressHUDMaskTypeGradient];

        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [manager GET:[NSString stringWithFormat:@"%@/change_pwd.php",BaseUrl] parameters:@{@"oldPwd":oldPassword , @"userID" : [[SharedPreferences sharedInstance] getUserID] , @"newPwd" : newPassword} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            [SVProgressHUD dismiss];
            completionBlock(dataDict, nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD dismiss];
            completionBlock(nil, error);
        }];
        
    }else{
        [[SharedPreferences sharedInstance] showCommonAlertWithMessage:internetMessage withObject:nil];
    }
}

+ (void)forgetPasswordForEmail:(NSString *)email withComplitionHandler:(CompletionHandler)completionBlock{
    
    if ([SharedPreferences isNetworkAvailable])
    {
        [SVProgressHUD showWithStatus:@"Loading.." maskType:SVProgressHUDMaskTypeGradient];
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [manager GET:[NSString stringWithFormat:@"%@/forgot.php",BaseUrl] parameters:@{@"email_id":email} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            [SVProgressHUD dismiss];
            completionBlock(dataDict, nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD dismiss];
            completionBlock(nil, error);
        }];
        
    }else{
        [[SharedPreferences sharedInstance] showCommonAlertWithMessage:internetMessage withObject:nil];
    }
}


+ (void)editUserProfile:(NSString *)name andMobileNumber:(NSString *)mobile withComplitionHandler:(CompletionHandler)completionBlock{
    
    if ([SharedPreferences isNetworkAvailable])
    {
        [SVProgressHUD showWithStatus:@"Loading.." maskType:SVProgressHUDMaskTypeGradient];
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [manager GET:[NSString stringWithFormat:@"%@/update_profile.php",BaseUrl] parameters:@{@"name" : name, @"user_id" :[[SharedPreferences sharedInstance] getUserID], @"mob_no" : mobile} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            [SVProgressHUD dismiss];
            completionBlock(dataDict, nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD dismiss];
            completionBlock(nil, error);
        }];
        
    }else{
        [[SharedPreferences sharedInstance] showCommonAlertWithMessage:internetMessage withObject:nil];
    }
}

+ (void)uploadUserProfilePicture:(NSString *)profilePic withComplitionHandler:(CompletionHandler)completionBlock{
    
    if ([SharedPreferences isNetworkAvailable])
    {
        [SVProgressHUD showWithStatus:@"Loading.." maskType:SVProgressHUDMaskTypeGradient];
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [manager GET:[NSString stringWithFormat:@"%@/update_profile.php",BaseUrl] parameters:@{@"user_id" :[[SharedPreferences sharedInstance] getUserID], @"profile_pic" : profilePic} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            [SVProgressHUD dismiss];
            completionBlock(dataDict, nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD dismiss];
            completionBlock(nil, error);
        }];
        
    }else{
        [[SharedPreferences sharedInstance] showCommonAlertWithMessage:internetMessage withObject:nil];
    }
}

#pragma mark
#pragma mark OTP Confirmation
#pragma mark


+ (void)confirmOTP:(NSString *)otp withComplitionHandler:(CompletionHandler)completionBlock{
    
    if ([SharedPreferences isNetworkAvailable])
    {
        [SVProgressHUD showWithStatus:@"Loading.." maskType:SVProgressHUDMaskTypeGradient];
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [manager GET:[NSString stringWithFormat:@"%@/otp_conf.php",BaseUrl] parameters:@{@"user_id" :[[SharedPreferences sharedInstance] getUserID], @"otp" : otp} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            [SVProgressHUD dismiss];
            completionBlock(dataDict, nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD dismiss];
            completionBlock(nil, error);
        }];
        
    }else{
        [[SharedPreferences sharedInstance] showCommonAlertWithMessage:internetMessage withObject:nil];
    }
}

@end
