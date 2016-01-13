//
//  City.m
//  Owlers
//
//  Created by RANVIJAI on 11/01/16.
//  Copyright © 2016 JNT. All rights reserved.
//

#import "Location.h"

@implementation Location

+ (Location*)cityWithLocation:(NSString*)location locationID:(NSString*)uniqueID {
    Location *loc = [[Location alloc] init];
    loc.name = location;
    loc.ID = uniqueID;
    return loc;
}

@end
