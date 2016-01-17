//
//  EditViewController.h
//  Owlers
//
//  Created by Biprajit Biswas on 30/09/15.
//  Copyright (c) 2015 JNT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditViewController : UIViewController

- (id)initWithDict:(NSDictionary *)dict;
- (IBAction)backBtnAction:(id)sender;
- (IBAction)backBtn:(UIBarButtonItem *)sender;
- (IBAction)updateProfile:(id)sender;
- (IBAction)logout:(id)sender;
@end
