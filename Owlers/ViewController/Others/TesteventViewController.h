//
//  TesteventViewController.h
//  Owlers
//
//  Created by Biprajit Biswas on 15/10/15.
//  Copyright (c) 2015 JNT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"

@interface TesteventViewController : UIViewController

@property (strong, nonatomic) Event *event;

- (IBAction)backBtnAction:(id)sender;
- (IBAction)maleMinusAction:(id)sender;
- (IBAction)malePlusAction:(id)sender;
- (IBAction)femaleMinusAction:(id)sender;
- (IBAction)femalePlusAction:(id)sender;
- (IBAction)continueWithoutPayAction:(id)sender;
- (IBAction)payNowAction:(id)sender;


@end
