//
//  BidSectionViewController.m
//  Owlers
//
//  Created by Biprajit Biswas on 22/10/15.
//  Copyright (c) 2015 JNT. All rights reserved.
//

#import "BidSectionViewController.h"
#import "ProductViewController.h"
#import "Connectionmanager.h"
#import "Header.h"
#import "NetworkManager.h"
#import "SharedPreferences.h"
#import "UIImageView+WebCache.h"

@interface BidSectionViewController ()

@property(nonatomic,strong) NSDictionary    *acutionData;

@end

@implementation BidSectionViewController
NSString *UserId;


- (id)initwithDict:(NSDictionary *)auctionDict{
    if(self == [super init]){
        _acutionData = auctionDict;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setDetailsOfAution:_acutionData];
    [NetworkManager loadAuctionDetailsForAuction:[_acutionData objectForKey:@"auction_id"] withComplitionHandler:^(id result, NSError *err) {
        _acutionData = [[result objectForKey:@"items"] firstObject];
        [self setDetailsOfAution:_acutionData];
    }];
    
    UITapGestureRecognizer *keyBoardHideRecognizer = [[UITapGestureRecognizer alloc] init];
    [keyBoardHideRecognizer addTarget:self action:@selector(hideKeyBoard)];
    [self.view addGestureRecognizer:keyBoardHideRecognizer];
}

- (void)setDetailsOfAution:(NSDictionary *)dict{
    self.descLabel.text= [dict objectForKey:@"auction_desc"];
    self.nameLabel.text= [dict objectForKey:@"auction_name"];
    self.amountLabel.text= [dict objectForKey:@"buy_now_price"];
    self.totalBidLabel.text=[NSString stringWithFormat:@"%@",[dict objectForKey:@"total_bids"]];
    self.maxbidLabel.text=[NSString stringWithFormat:@"%@",[dict objectForKey:@"opening_price"]];
    
    NSString *imageURL = [NSString stringWithFormat:@"http://owlers.com/auction_images/%@",[dict objectForKey:@"auction_image"]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.imageoo sd_setImageWithURL:[NSURL URLWithString:imageURL]
                        placeholderImage:[UIImage imageNamed:@"new_background_ullu.png"]];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)cancelBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)buyBtnAction:(id)sender {
    [NetworkManager saveBidForAuction:[_acutionData objectForKey:@"auction_id"] andBidAmount:[_acutionData objectForKey:@"buy_now_price"] andBuyNow:TRUE withComplitionHandler:^(id result, NSError *err){
        NSString* message = [result  objectForKey:@"message"];
        [[SharedPreferences sharedInstance] showCommonAlertWithMessage:message withObject:self];
    }];    
}

- (IBAction)submitBtnAction:(id)sender {
    [NetworkManager saveBidForAuction:[_acutionData objectForKey:@"auction_id"] andBidAmount:self.bidAmtTextFld.text andBuyNow:FALSE withComplitionHandler:^(id result, NSError *err) {
        if (![[result  objectForKey:@"status"] isEqualToString:@"Failure"]) {
            self.maxbidLabel.text = self.bidAmtTextFld.text;
        }
        NSString* message = [result  objectForKey:@"message"];
        [[SharedPreferences sharedInstance] showCommonAlertWithMessage:message withObject:self];
    }];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return textField;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [self animateScrolView:CGPointMake(0, 120)];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [self animateScrolView:CGPointMake(0, 0)];
}

- (void)animateScrolView:(CGPoint)contentOffset{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.scrollview.contentOffset = contentOffset;
    [UIView commitAnimations];
}

-(void)hideKeyBoard
{
    [self.bidAmtTextFld resignFirstResponder];
    [self animateScrolView:CGPointMake(0, 0)];
}


@end
