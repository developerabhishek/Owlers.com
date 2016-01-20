//
//  Connectionmanager.m
//  Owlers
//
//  Created by Biprajit Biswas on 28/09/15.
//  Copyright (c) 2015 JNT. All rights reserved.
//

#import "ConnectionManager.h"

@implementation ConnectionManager
static ConnectionManager * sharedInstance = Nil;

+(ConnectionManager *)getSharedInstance
{
    if (sharedInstance == Nil)
    {
        return  [[ConnectionManager alloc] init];
    }
    else
    {
        return sharedInstance;
    }
}

- (BOOL) isConnectionAvailable
{
    SCNetworkReachabilityFlags flags;
    BOOL receivedFlags;
    
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(CFAllocatorGetDefault(), [@"www.google.com" UTF8String]);
    receivedFlags = SCNetworkReachabilityGetFlags(reachability, &flags);
    CFRelease(reachability);
    
    if (!receivedFlags || (flags == 0) )
    {
        return FALSE;
    }
    else
    {
        //NSLog(@"True");
        return TRUE;
    }
}

- (BOOL)checkInternateConnection
{
    //return self.reachability.isReachable;
    
    SCNetworkReachabilityFlags flags;
    BOOL receivedFlags;
    
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(CFAllocatorGetDefault(), [@"www.google.com" UTF8String]);
    receivedFlags = SCNetworkReachabilityGetFlags(reachability, &flags);
    CFRelease(reachability);
    
    if (!receivedFlags || (flags == 0) )
    {
        return FALSE;
    }
    else
    {
        return TRUE;
    }
}

@end

