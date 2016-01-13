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
+ (void)loadAcutionsForCity:(NSString *)cityID withComplitionHandler:(CompletionHandler)completionBlock;
+ (void)loadLocationWithComplitionHandler:(CompletionHandler)completionBlock;
+ (void)loadAuctionDetailsForAuction:(NSString *)auctionID withComplitionHandler:(CompletionHandler)completionBlock;
+ (void)checkAuctionBidForAuction:(NSString *)auctionID withComplitionHandler:(CompletionHandler)completionBlock;
+ (void)saveBidForAuction:(NSString *)auctionID andBidAmount:(NSString *)amount andBuyNow:(BOOL)isBuyNow
    withComplitionHandler:(CompletionHandler)completionBlock;

// Login
+ (void)changeOldPassword:(NSString *)oldPassword toNewPassword:(NSString *)newPassword withComplitionHandler:(CompletionHandler)completionBlock;
+ (void)loginWithEmail:(NSString *)email andPassword:(NSString *)password withComplitionHandler:(CompletionHandler)completionBlock;
+ (void)loginVerificationWithName:(NSString *)name email:(NSString *)email andMobileNumber:(NSString *)mobile withComplitionHandler:(CompletionHandler)completionBlock;
+ (void)getUserProfileFromServerWithComplitionHandler:(CompletionHandler)completionBlock;
+ (void)editUserProfile:(NSString *)name andMobileNumber:(NSString *)mobile withComplitionHandler:(CompletionHandler)completionBlock;
+ (void)forgetPasswordForEmail:(NSString *)email withComplitionHandler:(CompletionHandler)completionBlock;


@end
