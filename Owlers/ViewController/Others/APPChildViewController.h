//
//  APPChildViewController.h
//  PageApp
//
//  Created by Rafael Garcia Leiva on 10/06/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SplashChildPageData.h"

@interface APPChildViewController : UIViewController

@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) SplashChildPageData *data;
@property (nonatomic) BOOL hideMessage;

@end
