//
//  BidSectionViewController.h
//  Owlers
//
//  Created by Biprajit Biswas on 22/10/15.
//  Copyright (c) 2015 JNT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Auction.h"

@interface BidSectionViewController : UIViewController<NSURLConnectionDataDelegate,NSURLConnectionDelegate,UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UILabel *descLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *imageoo;
@property (strong, nonatomic) IBOutlet UILabel *maxbidLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalBidLabel;
@property (strong, nonatomic) IBOutlet UIButton *buyNowBtn;
@property (strong, nonatomic) IBOutlet UITextField *bidAmtTextFld;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerBottomconstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerTopconstraint;
@property (strong, nonatomic) Auction *auction;

- (IBAction)backBtnAction:(id)sender;
- (IBAction)cancelBtnAction:(id)sender;
- (IBAction)buyBtnAction:(id)sender;
- (IBAction)submitBtnAction:(id)sender;

@end
