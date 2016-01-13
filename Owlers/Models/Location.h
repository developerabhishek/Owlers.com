//
//  City.h
//  Owlers
//
//  Created by RANVIJAI on 11/01/16.
//  Copyright © 2016 JNT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Location : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *ID;


+ (Location*)cityWithLocation:(NSString*)location locationID:(NSString*)uniqueID;

@end
