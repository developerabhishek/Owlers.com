//
//  NetworkManager.h
//  Owlers
//
//  Created by Abhishek on 05/01/16.
//  Copyright © 2016 JNT. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CompletionHandler)(id result, NSError *err);

@interface NetworkManager : NSObject

//Auction
//+ (void)fetchEventListForLocation:(NSString *)locationID withComplitionHandler:(CompletionHandler)completionBlock;
+ (void)fetchEventListForLocation:(NSString *)locationID withRefereshController:(BOOL)shoudRefresh  withComplitionHandler:(CompletionHandler)completionBlock;
+ (void)loadAcutionsForCity:(NSString *)cityID withComplitionHandler:(CompletionHandler)completionBlock;
+ (void)loadLocationWithComplitionHandler:(CompletionHandler)completionBlock;
+ (void)loadAuctionDetailsForAuction:(NSString *)auctionID withComplitionHandler:(CompletionHandler)completionBlock;
+ (void)checkAuctionBidForAuction:(NSString *)auctionID withComplitionHandler:(CompletionHandler)completionBlock;
+ (void)saveBidForAuction:(NSString *)auctionID andBidAmount:(NSString *)amount andBuyNow:(BOOL)isBuyNow
    withComplitionHandler:(CompletionHandler)completionBlock;
+ (void)getMyBidsWithComplitionHandler:(CompletionHandler)completionBlock;
+ (void)searchEventForString:(NSString *)searchString withComplitionHandler:(CompletionHandler)completionBlock;
+ (void)getAllBooking:(CompletionHandler)completionBlock;
+ (void)fetchEventListForSelectedDate:(NSString *)dateString forLocation:(NSString *)locationID withComplitionHandler:(CompletionHandler)completionBlock;
+ (void)getEventDetails:(NSString *)eventID withComplitionBlock:(CompletionHandler)completionBlock;
+ (void)bookEvent:(NSDictionary *)dict withComplitionBlock:(CompletionHandler)completionBlock;
+ (void)bookOffer:(NSDictionary *)dict withComplitionBlock:(CompletionHandler)completionBlock;

// Login
+ (void)signUpWithEmail:(NSString *)email andPassword:(NSString *)password andMobile:(NSString *)mobile andName:(NSString *)name withComplitionHandler:(CompletionHandler)completionBlock;
+ (void)changeOldPassword:(NSString *)oldPassword toNewPassword:(NSString *)newPassword withComplitionHandler:(CompletionHandler)completionBlock;
+ (void)loginWithEmail:(NSString *)email andPassword:(NSString *)password withComplitionHandler:(CompletionHandler)completionBlock;
+ (void)loginVerificationWithName:(NSString *)name email:(NSString *)email andMobileNumber:(NSString *)mobile withComplitionHandler:(CompletionHandler)completionBlock;
+ (void)getUserProfileFromServerWithComplitionHandler:(CompletionHandler)completionBlock;
+ (void)editUserProfile:(NSString *)name andMobileNumber:(NSString *)mobile withComplitionHandler:(CompletionHandler)completionBlock;
+ (void)forgetPasswordForEmail:(NSString *)email withComplitionHandler:(CompletionHandler)completionBlock;
+ (void)uploadUserProfilePicture:(NSString *)profilePic withComplitionHandler:(CompletionHandler)completionBlock;
+ (void)confirmOTP:(NSString *)otp withComplitionHandler:(CompletionHandler)completionBlock;

@end
