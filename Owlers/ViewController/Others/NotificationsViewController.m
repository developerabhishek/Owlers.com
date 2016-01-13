//
//  NotificationsViewController.m
//  Owlers
//
//  Created by Biprajit Biswas on 30/09/15.
//  Copyright (c) 2015 JNT. All rights reserved.
//

#import "NotificationsViewController.h"
#import "SettingViewController.h"
@interface NotificationsViewController ()

@end

@implementation NotificationsViewController


- (IBAction)backbtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)switchAction:(id)sender {
    
//    if ([self. isOn]) {
//        self.myTextField.text = @"The Switch is Off";
//        NSLog(@"Switch is on");
//        [self.mySwitch setOn:NO animated:YES];
//    } else {
//        self.myTextField.text = @"The Switch is On";
//        [self.mySwitch setOn:YES animated:YES];
//    }
}
@end
