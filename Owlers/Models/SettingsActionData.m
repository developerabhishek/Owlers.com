//
//  SettingsActionData.m
//  Owlers
//
//  Created by RANVIJAI on 05/01/16.
//  Copyright © 2016 JNT. All rights reserved.
//

#import "SettingsActionData.h"

@implementation SettingsActionData

+ (SettingsActionData*)dataWithAction:(SettingsAction)action displayText:(NSString*)text
{
    SettingsActionData *data = [[SettingsActionData alloc] init];
    data.action = action;
    data.displayTxt = text;
    return data;
}

@end
