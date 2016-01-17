//
//  LocationMenuItem.m
//  Owlers
//
//  Created by RANVIJAI on 16/01/16.
//  Copyright © 2016 JNT. All rights reserved.
//

#import "LocationMenuItem.h"

@interface LocationMenuItem ()

@property (nonatomic, strong) Location *location;

@end

@implementation LocationMenuItem

+ (LocationMenuItem*)itemWithLocation:(Location*)loc {
    LocationMenuItem *item = [[LocationMenuItem alloc] init];
    item.location = loc;
    item.displayName = loc.name;
    return item;
}

+ (NSArray *)menuItemsWithLocations:(NSArray*)locations {
    
    NSMutableArray *menuItems = [[NSMutableArray alloc] init];
    for (Location *loc in locations) {
        [menuItems addObject:[LocationMenuItem itemWithLocation:loc]];
    }
    return menuItems;
}

@end
