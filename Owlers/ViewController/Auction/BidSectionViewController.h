//
//  BidSectionViewController.h
//  Owlers
//
//  Created by Biprajit Biswas on 22/10/15.
//  Copyright (c) 2015 JNT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BidSectionViewController : UIViewController<NSURLConnectionDataDelegate,NSURLConnectionDelegate,UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UILabel *descLabel;
@property(strong,nonatomic) IBOutlet UILabel *nameLabel;
@property(nonatomic,strong) IBOutlet UIImageView *imageoo;
@property (strong, nonatomic) IBOutlet UILabel *maxbidLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalBidLabel;
@property(nonatomic,strong)IBOutlet UILabel *amountLabel;
@property (strong, nonatomic) IBOutlet UITextField *bidAmtTextFld;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollview;

- (id)initwithDict:(NSDictionary *)auctionDict;
- (IBAction)backBtnAction:(id)sender;
- (IBAction)cancelBtnAction:(id)sender;
- (IBAction)buyBtnAction:(id)sender;
- (IBAction)submitBtnAction:(id)sender;

@end
