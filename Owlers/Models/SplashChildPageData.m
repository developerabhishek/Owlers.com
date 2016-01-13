//
//  SplashChildPageData.m
//  Owlers
//
//  Created by RANVIJAI on 05/01/16.
//  Copyright © 2016 JNT. All rights reserved.
//

#import "SplashChildPageData.h"

@implementation SplashChildPageData


+ (SplashChildPageData*)dataWithImage:(UIImage*)img displayText:(NSString*)text {
    SplashChildPageData *data = [[SplashChildPageData alloc] init];
    data.img = img;
    data.displayTxt = text;
    return data;
}

@end
