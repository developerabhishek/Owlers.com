//
//  ForgotpasswordViewController.m
//  Owlers
//
//  Created by Biprajit Biswas on 24/09/15.
//  Copyright (c) 2015 JNT. All rights reserved.
//

#import "ForgotpasswordViewController.h"
#import "Header.h"
#import "SharedPreferences.h"
#import "NetworkManager.h"

@interface ForgotpasswordViewController ()

@property(nonatomic,strong) IBOutlet UITextField *emailAddress;

@end


@implementation ForgotpasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyBoard:)];
    [self.view addGestureRecognizer:gestureRecognizer];
    
}

-(void)hideKeyBoard:(UITapGestureRecognizer *)sender
{
    [self.emailAddress resignFirstResponder];
}

- (BOOL)validateEmail:(NSString *)email1
{
    NSString *emailRegex = @ "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email1];
}

- (IBAction)submitBtnAction:(id)sender {
    
    if (self.emailAddress.text.length == 0)
    {
        [[SharedPreferences sharedInstance] showCommonAlertWithMessage:@"Please enter email address." withObject:self];
    }
    else if (![self validateEmail:self.emailAddress.text])
    {
        [[SharedPreferences sharedInstance] showCommonAlertWithMessage:@"Please enter valid email address." withObject:self];
        self.emailAddress.text = @"";
    }

    else
    {
        [NetworkManager forgetPasswordForEmail:self.emailAddress.text withComplitionHandler:^(id result, NSError *err) {
        
            if (result && [[result valueForKey:@"status"] isEqualToString:@"success"])
            {

                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"JNT" message:[result valueForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action)
                                     {
                                         [self.navigationController popViewControllerAnimated:YES];
                                         
                                     }];
                [alertController addAction:ok];
                [self presentViewController:alertController animated:YES completion:nil];
            }else{
                [[SharedPreferences sharedInstance] showCommonAlertWithMessage:[result valueForKey:@"message"] withObject:self];
            }
        }];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
