//
//  StartinhViewController.h
//  Owlers
//
//  Created by Biprajit Biswas on 24/09/15.
//  Copyright (c) 2015 JNT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "SignupViewController.h"

@interface StartinhViewController : UIViewController<UIPageViewControllerDataSource>

@property (assign, nonatomic) NSInteger index;

- (IBAction)loginBtnAction:(id)sender;
- (IBAction)signinBtnAction:(id)sender;
- (IBAction)skipBtnAction:(id)sender;

@end
