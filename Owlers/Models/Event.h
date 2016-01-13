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

@end
