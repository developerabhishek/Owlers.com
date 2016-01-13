//
//  ChangePasswordViewController.m
//  Owlers
//
//  Created by Biprajit Biswas on 30/09/15.
//  Copyright (c) 2015 JNT. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "SettingViewController.h"
#import "Header.h"
#import "SharedPreferences.h"
#import "NetworkManager.h"

@interface ChangePasswordViewController ()

@property (strong, nonatomic) IBOutlet UITextField *currnetPassword;
@property (strong, nonatomic) IBOutlet UITextField *newpassword;
@property (strong, nonatomic) IBOutlet UITextField *confirmPassword;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;

@end

@implementation ChangePasswordViewController{
NSDictionary *parsedObject;

}
NSString *UserId;

- (void)viewDidLoad {
    [super viewDidLoad];

    UserId= [[SharedPreferences sharedInstance] getUserID];
    
    UITapGestureRecognizer *keyBoardHideRecognizer = [[UITapGestureRecognizer alloc] init];
    [keyBoardHideRecognizer addTarget:self action:@selector(hideKeyBoard)];
    [self.view addGestureRecognizer:keyBoardHideRecognizer];
    
}

-(void)hideKeyBoard
{
    for (UIView *view in [self.view subviews])
    {
        if ([view isKindOfClass:[UITextField class]])
        {
            UITextField *textField = (UITextField *)view;
            [textField resignFirstResponder];
        }
    }
    
}

- (IBAction)backbtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)savebtnAction:(id)sender {
    
    NSString *showMessage = [[NSString alloc] init];
    
    [self.saveButton setEnabled:NO];
    
    if (self.currnetPassword.text.length == 0)
    {
        showMessage = @"Please enter old password";
    }
    else if (self.newpassword.text.length == 0 && self.confirmPassword.text.length == 0)
    {
        showMessage = @"Please enter new Password!";
    }
    else if(self.newpassword.text.length == 0 )
    {
        showMessage = @"Please enter new Password!";
    }
    else if(self.confirmPassword.text.length == 0)
    {
        showMessage = @"Please enter confirm Password!";
    }
    else if(![self.newpassword.text isEqualToString:self.confirmPassword.text])
    {
        showMessage = @"Password does not match";
    }
    
    if (showMessage.length != 0)
    {
        [self.saveButton setEnabled:YES];
        [[SharedPreferences sharedInstance] showCommonAlertWithMessage:showMessage withObject:self];
    }
    else
    {
        [NetworkManager changeOldPassword:self.currnetPassword.text toNewPassword:self.confirmPassword.text withComplitionHandler:^(id result, NSError *err) {
            
            if ([result valueForKey:@"message"])
            {
                
                [[SharedPreferences sharedInstance] showCommonAlertWithMessage:[result valueForKey:@"message"] withObject:self];
            }
            
        }];

    }
}

#pragma mark UITextField delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{    
    [textField resignFirstResponder];
    return YES;
}

@end
