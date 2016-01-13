//
//  SplashChildPageData.h
//  Owlers
//
//  Created by RANVIJAI on 05/01/16.
//  Copyright © 2016 JNT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SplashChildPageData : NSObject

@property (nonatomic, strong) UIImage *img;
@property (nonatomic, copy) NSString *displayTxt;

+ (SplashChildPageData*)dataWithImage:(UIImage*)img displayText:(NSString*)text;

@end
