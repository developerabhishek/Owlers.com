//
//  TransactionOTPViewController.m
//  Owlers
//
//  Created by RANVIJAI on 15/02/16.
//  Copyright © 2016 JNT. All rights reserved.
//

#import "TransactionOTPViewController.h"

@interface TransactionOTPViewController ()

@property (strong, nonatomic) IBOutlet UITextField *otpTxtFld;

@end

@implementation TransactionOTPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.otpTxtFld.layer.borderWidth = 1;
    self.otpTxtFld.layer.borderColor = [UIColor colorWithRed:229.0f/225 green:229.0f/225 blue:229.0f/225 alpha:1].CGColor;
}


- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)submitBtnAction:(id)sender {

}

@end
