//
//  Connectionmanager.h
//  Owlers
//
//  Created by Biprajit Biswas on 28/09/15.
//  Copyright (c) 2015 JNT. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>

@interface ConnectionManager : NSObject

+(ConnectionManager *)getSharedInstance;
- (BOOL) isConnectionAvailable;
- (BOOL)checkInternateConnection;

@end
