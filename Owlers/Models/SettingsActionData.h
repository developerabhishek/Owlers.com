//
//  SettingsActionData.h
//  Owlers
//
//  Created by RANVIJAI on 05/01/16.
//  Copyright © 2016 JNT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Enums.h"

@interface SettingsActionData : NSObject

@property (nonatomic, copy) NSString *displayTxt;
@property (nonatomic, assign) SettingsAction action;

+ (SettingsActionData*)dataWithAction:(SettingsAction)action displayText:(NSString*)text;

@end
