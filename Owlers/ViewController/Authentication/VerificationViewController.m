//
//  VerificationViewController.m
//  Owlers
//
//  Created by Biprajit Biswas on 04/11/15.
//  Copyright © 2015 JNT. All rights reserved.
//

#import "VerificationViewController.h"
#import "Connectionmanager.h"
#import "Header.h"
#import "ProductViewController.h"
#import "SharedPreferences.h"
#import "NetworkManager.h"
#import "TransactionOTPViewController.h"

@interface VerificationViewController ()


@end

@implementation VerificationViewController
NSDictionary *parsedObject;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.    
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    self.userNameTxtFld.text = [prefs valueForKey:@"name"];
    self.emailTxtFld.text =  [prefs valueForKey:@"userEmail"];
    [self.userNameTxtFld setUserInteractionEnabled:false];
    [self.emailTxtFld setUserInteractionEnabled:false];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)continueBtnAction:(id)sender {
    
    if ([self validateFields]) {
        [NetworkManager loginVerificationWithName:self.userNameTxtFld.text email:self.emailTxtFld.text andMobileNumber:self.mobileTxtFld.text withComplitionHandler:^(id result, NSError *err) {
            if ([[result valueForKey:@"status"]  isEqual: @"success"])
            {
                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                [user setObject:[result objectForKey:@"user_id"] forKey:@"userID"];
                
                if ([user objectForKey:@"picture"]) {
                    
                    NSString *imageURLStr = [user objectForKey:@"picture"];
                    NSURL *imageURL = [[NSURL alloc] initWithString:imageURLStr];
                    if (imageURL) {
                        NSData *imageData = [NSData dataWithContentsOfURL:imageURL options:NSDataReadingMapped error:nil];
                        NSString *base64String = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
                        [NetworkManager uploadUserProfilePicture:base64String withComplitionHandler:^(id result, NSError *err){
                            [self moveToOtpPage];
                        }];
                    }else{
                        [self moveToOtpPage];
                    }
                }else{
                    [self moveToOtpPage];
                }
            }else{
                [[SharedPreferences sharedInstance] showCommonAlertWithMessage:[result valueForKey:@"message"] withObject:self];
            }
        }];
    }
}

- (BOOL)validateFields{

    NSString *errorMessage = nil;
    if (!self.userNameTxtFld.text || [self.userNameTxtFld.text length] <= 0 ) {
        errorMessage = @"User name can't be blank";
    }
    else if (!self.emailTxtFld.text || [self.emailTxtFld.text length] <= 0 ) {
        errorMessage = @"Email can't be blank";
    }
    else if (!self.mobileTxtFld.text || [self.mobileTxtFld.text length] <= 0 ) {
        errorMessage = @"Mobile number can't be blank";
    }
    
    if (errorMessage) {
        [[SharedPreferences sharedInstance] showCommonAlertWithMessage:errorMessage withObject:self];
        return false;
    }
    
    return true;
}

- (void)moveToOtpPage{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                         bundle:nil];
    TransactionOTPViewController *yourViewController = (TransactionOTPViewController *)[storyboard instantiateViewControllerWithIdentifier:@"segueOTP"];
    [self.navigationController pushViewController:yourViewController animated:YES];

}

- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
