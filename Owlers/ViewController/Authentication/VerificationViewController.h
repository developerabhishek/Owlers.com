//
//  VerificationViewController.h
//  Owlers
//
//  Created by Biprajit Biswas on 04/11/15.
//  Copyright © 2015 JNT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VerificationViewController : UIViewController<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *userNameTxtFld;
@property (strong, nonatomic) IBOutlet UITextField *emailTxtFld;
@property (strong, nonatomic) IBOutlet UITextField *mobileTxtFld;


- (IBAction)continueBtnAction:(id)sender;
- (IBAction)backBtnAction:(id)sender;

@end
