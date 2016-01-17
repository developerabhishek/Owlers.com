//
//  LocationMenuItem.h
//  Owlers
//
//  Created by RANVIJAI on 16/01/16.
//  Copyright © 2016 JNT. All rights reserved.
//

#import "MenuItem.h"
#import "Location.h"

@interface LocationMenuItem : MenuItem

@property (nonatomic, strong, readonly) Location *location;

+ (LocationMenuItem*)itemWithLocation:(Location*)loc;

+ (NSArray *)menuItemsWithLocations:(NSArray*)locations;

@end
