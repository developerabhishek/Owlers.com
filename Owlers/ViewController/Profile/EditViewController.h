//
//  EditViewController.h
//  Owlers
//
//  Created by Biprajit Biswas on 30/09/15.
//  Copyright (c) 2015 JNT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditViewController : UIViewController

@property(nonatomic,strong) NSDictionary *dataDict;

- (IBAction)backBtnAction:(id)sender;
- (IBAction)updateProfile:(id)sender;
- (IBAction)logout:(id)sender;
@end
