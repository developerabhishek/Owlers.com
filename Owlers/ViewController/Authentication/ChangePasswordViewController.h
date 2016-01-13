//
//  ChangePasswordViewController.h
//  Owlers
//
//  Created by Biprajit Biswas on 30/09/15.
//  Copyright (c) 2015 JNT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Connectionmanager.h"
@interface ChangePasswordViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate>

- (IBAction)backbtnAction:(id)sender;
- (IBAction)savebtnAction:(id)sender;

@end
