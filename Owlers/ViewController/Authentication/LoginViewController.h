//
//  LoginViewController.h
//  Owlers
//
//  Created by Biprajit Biswas on 25/09/15.
//  Copyright (c) 2015 JNT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <GooglePlus/GooglePlus.h>
#import "AppDelegate.h"

@interface LoginViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate,GPPSignInDelegate>

@property (strong, nonatomic) IBOutlet UITextField *emailtxtfld;
@property (strong, nonatomic) IBOutlet UITextField *pwdtextfld;
@property (strong, nonatomic) IBOutlet FBSDKLoginButton *fbloginaction;
@property (retain, nonatomic) IBOutlet GPPSignInButton *googleloginaction;

- (IBAction)backbtnaction:(id)sender;
- (IBAction)loginbtnaction:(id)sender;
- (IBAction)fbloginaction:(id)sender;
- (IBAction)googleloginaction:(id)sender;

@end
