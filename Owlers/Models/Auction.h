//
//  Auction.h
//  Owlers
//
//  Created by RANVIJAI on 16/01/16.
//  Copyright © 2016 JNT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Auction : NSObject

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *timeElapsed;
@property (nonatomic, copy) NSString *venue;
@property (nonatomic, copy) NSString *totalBids;
@property (nonatomic, copy) NSString *auctionDescription;
@property (nonatomic, copy) NSString *buyPrice;
@property (nonatomic, copy) NSString *openingPrice;
@property (nonatomic, copy) NSString *imgURL;
@property (nonatomic, assign) NSInteger daysLeft;
@property (nonatomic, assign) NSInteger hoursLeft;
@property (nonatomic, assign) NSInteger minutesLeft;
@property (nonatomic, assign) NSInteger secondsLeft;

@end
