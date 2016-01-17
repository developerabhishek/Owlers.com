//
//  Event.h
//  Owlers
//
//  Created by RANVIJAI on 11/01/16.
//  Copyright © 2016 JNT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Event : NSObject

@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *atmosphere;
@property (nonatomic, copy) NSString *createdDate;
@property (nonatomic, copy) NSString *eventDescription;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *imageURL;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, copy) NSString *locationCode;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *venue;
@property (nonatomic) BOOL entryExistsForMale;
@property (nonatomic) BOOL entryExistsForFemale;
@property (nonatomic) BOOL entryExistsForCouple;
@property (nonatomic, copy) NSString *terms;
@property (nonatomic, copy) NSString *genreOfMusic;
@property (nonatomic, strong) NSArray *sliderImages;
@property (nonatomic, strong) NSArray *offers;
@property (nonatomic) int malePrice;
@property (nonatomic) int femalePrice;
@property (nonatomic) int couplePrice;
@property (nonatomic, copy) NSString *discountTitle;
@property (nonatomic) int discountValue;
@property (nonatomic, copy) NSString *eventDate;

@end
