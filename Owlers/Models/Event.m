//
//  Event.m
//  Owlers
//
//  Created by RANVIJAI on 11/01/16.
//  Copyright © 2016 JNT. All rights reserved.
//

#import "Event.h"

@implementation Event

- (NSMutableArray*)offers {
    if (!_offers) {
        _offers = [[NSMutableArray alloc] init];
    }
    return _offers;
}

@end
