//
//  Booking.h
//  Owlers
//
//  Created by RANVIJAI on 17/01/16.
//  Copyright © 2016 JNT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Event.h"

@interface Booking : NSObject

@property (nonatomic) int noOfMale;
@property (nonatomic) int noOfFemale;
@property (nonatomic) int noOfCouple;
@property (nonatomic) int totalAmount;
@property (nonatomic, copy) NSString *bookingDate;
@property (nonatomic, copy) NSString *bookingNumber;
@property (nonatomic, copy) NSString *eventDate;
@property (nonatomic, copy) NSString *paymentMethod;
@property (nonatomic, strong) Event *event;

@end
