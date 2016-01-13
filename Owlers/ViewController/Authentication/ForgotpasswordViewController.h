//
//  ForgotpasswordViewController.h
//  Owlers
//
//  Created by Biprajit Biswas on 24/09/15.
//  Copyright (c) 2015 JNT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "Connectionmanager.h"
@interface ForgotpasswordViewController : UIViewController<UITextFieldDelegate>

- (IBAction)submitBtnAction:(id)sender;
- (IBAction)backBtnAction:(id)sender;

@end
