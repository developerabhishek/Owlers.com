//
//  Offer.h
//  Owlers
//
//  Created by RANVIJAI on 20/01/16.
//  Copyright © 2016 JNT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Offer : NSObject

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *terms;
@property (nonatomic, copy) NSString *offerTitle;
@property (nonatomic, copy) NSString *offerDescription;
@property (nonatomic, assign) NSInteger value;
@property (nonatomic, assign) BOOL isValid;

@end
