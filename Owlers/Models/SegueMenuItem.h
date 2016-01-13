//
//  SegueMenuItem.h
//  Owlers
//
//  Created by RANVIJAI on 11/01/16.
//  Copyright © 2016 JNT. All rights reserved.
//

#import "MenuItem.h"

@interface SegueMenuItem : MenuItem

@property (nonatomic, copy) NSString *identifier;


+ (SegueMenuItem*)itemWithSegueIdentifier:(NSString*)identifier;

@end
