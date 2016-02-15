//
//  TransactionOTPViewController.m
//  Owlers
//
//  Created by RANVIJAI on 15/02/16.
//  Copyright © 2016 JNT. All rights reserved.
//

#import "TransactionOTPViewController.h"
#import "SharedPreferences.h"
#import "NetworkManager.h"
#import "ProductViewController.h"

@interface TransactionOTPViewController ()

@property (strong, nonatomic) IBOutlet UITextField *otpTxtFld;
@property (weak, nonatomic) IBOutlet UIView *otpBGView;

@end

@implementation TransactionOTPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.otpBGView.layer.borderWidth = 1;
    self.otpBGView.layer.borderColor = [UIColor colorWithRed:229.0f/225 green:229.0f/225 blue:229.0f/225 alpha:1].CGColor;
}


- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)submitBtnAction:(id)sender {
    [NetworkManager confirmOTP:self.otpTxtFld.text withComplitionHandler:^(id result, NSError *err) {
        if ([[result valueForKey:@"status"]  isEqual: @"success"]){
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"JNT" message:[result valueForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action)
                                 {
                                     [self signUpSuccess];
                                 }];
            [alertController addAction:ok];
            
            [self.navigationController presentViewController:alertController animated:YES completion:nil];
        }else{
            [[SharedPreferences sharedInstance] showCommonAlertWithMessage:[result valueForKey:@"message"]
                                                                withObject:self];
        }
    }];
}

- (void)signUpSuccess {
    // If SignUp screen is came from Product screen then pop it from stack else create the product view controller and set it on top of stack without signup screen
    NSArray *arr = [self.navigationController viewControllers];
    for (UIViewController *controller in arr) {
        if ([controller isMemberOfClass:[ProductViewController class]]) {
            [self.navigationController popToViewController:controller animated:YES];
            return;
        }
    }
    ProductViewController *productCon = [self.storyboard instantiateViewControllerWithIdentifier:@"ProductViewController"];
    NSMutableArray *marr = [NSMutableArray arrayWithArray:arr];
    [marr addObject:productCon];
    [self.navigationController setViewControllers:marr animated:NO];
}

@end
