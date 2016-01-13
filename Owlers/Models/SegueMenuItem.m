//
//  SegueMenuItem.m
//  Owlers
//
//  Created by RANVIJAI on 11/01/16.
//  Copyright © 2016 JNT. All rights reserved.
//

#import "SegueMenuItem.h"

@implementation SegueMenuItem

+ (SegueMenuItem*)itemWithSegueIdentifier:(NSString*)identifier {
    SegueMenuItem *item = [[SegueMenuItem alloc] init];
    item.identifier = identifier;
    return item;
}

@end
