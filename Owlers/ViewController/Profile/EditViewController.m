//
//  EditViewController.m
//  Owlers
//
//  Created by Biprajit Biswas on 30/09/15.
//  Copyright (c) 2015 JNT. All rights reserved.
//

#import "EditViewController.h"
#import "ProfileViewController.h"
#import "SharedPreferences.h"
#import "NetworkManager.h"

@interface EditViewController ()

@property(nonatomic,strong) IBOutlet    UITextField *userName;
@property(nonatomic,strong) IBOutlet    UITextField *email;
@property(nonatomic,strong) IBOutlet    UITextField *phone;

@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showDataOnView];
    // Do any additional setup after loading the view from its nib.
}

- (void)showDataOnView{
    _userName.text=[_dataDict  objectForKey:@"name"];
    _email.text=[_dataDict objectForKey:@"email"];
    [_email setEnabled:NO];
    [_email setUserInteractionEnabled:NO];
    _phone.text=[_dataDict objectForKey:@"phone"];
}

- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)updateProfile:(id)sender{
    [NetworkManager editUserProfile:_userName.text andMobileNumber:_phone.text withComplitionHandler:^(id result, NSError *err) {
        
        if (result && [[result valueForKey:@"status"]  isEqual: @"success"])
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"JNT" message:[result valueForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action)
                                 {
                                     if (self.delegate != nil && [self.delegate respondsToSelector:@selector(updateProfile)]) {
                                         [self.delegate updateProfile];
                                     }
                                     
                                     [self.navigationController popViewControllerAnimated:YES];
                                     
                                 }];
            [alertController addAction:ok];
            [self presentViewController:alertController animated:YES completion:nil];
        }else{
            [[SharedPreferences sharedInstance] showCommonAlertWithMessage:[result valueForKey:@"message"] withObject:self];
        }
    }];
}

- (IBAction)logout:(id)sender{
    
    [[SharedPreferences sharedInstance] logoutUserWithSuccessBlock:^(BOOL isLoggedOut) {
        if (isLoggedOut) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
}


@end
