//
//  BidSectionViewController.m
//  Owlers
//
//  Created by Biprajit Biswas on 22/10/15.
//  Copyright (c) 2015 JNT. All rights reserved.
//

#import "BidSectionViewController.h"
//#import "ProductViewController.h"
#import "Connectionmanager.h"
#import "Header.h"
#import "NetworkManager.h"
#import "SharedPreferences.h"
#import "UIImageView+WebCache.h"

@interface BidSectionViewController ()

@end

@implementation BidSectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setDetailsOfAution:self.auction];
    
    [NetworkManager loadAuctionDetailsForAuction:self.auction.ID withComplitionHandler:^(id result, NSError *err) {
        NSDictionary *dict = [[result objectForKey:@"items"] firstObject];
        if (dict) {
            self.auction.ID = [dict objectForKey:@"auction_id"];
            self.auction.name = [dict objectForKey:@"auction_name"];
            self.auction.timeElapsed = [dict objectForKey:@"time_elapsed"];
            self.auction.venue = [dict objectForKey:@"venue"];
            self.auction.totalBids = [dict objectForKey:@"total_bids"];
            self.auction.auctionDescription = [dict objectForKey:@"auction_desc"];
            self.auction.buyPrice = [dict objectForKey:@"buy_now_price"];
            self.auction.openingPrice = [dict objectForKey:@"opening_price"];
            self.auction.imgURL = [dict objectForKey:@"auction_image"];
            [self setDetailsOfAution:self.auction];
        }
    }];
    
    UITapGestureRecognizer *keyBoardHideRecognizer = [[UITapGestureRecognizer alloc] init];
    [keyBoardHideRecognizer addTarget:self action:@selector(hideKeyBoard)];
    [self.view addGestureRecognizer:keyBoardHideRecognizer];
}

- (void)setDetailsOfAution:(Auction *)auction{
    self.descLabel.text= auction.auctionDescription;
    self.nameLabel.text= auction.name;
    [self.buyNowBtn setTitle:[NSString stringWithFormat:@"Buy Now For Rs. | %@",auction.buyPrice] forState:UIControlStateNormal];
    self.totalBidLabel.text = auction.totalBids;
    self.maxbidLabel.text = auction.openingPrice;
    
    NSString *imageURL = [NSString stringWithFormat:@"http://owlers.com/auction_images/%@",auction.imgURL];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.imageoo sd_setImageWithURL:[NSURL URLWithString:imageURL]
                        placeholderImage:[UIImage imageNamed:@"new_background_ullu.png"]];
    });
}

- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)cancelBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)buyBtnAction:(id)sender {
    [NetworkManager saveBidForAuction:self.auction.ID andBidAmount:self.auction.buyPrice andBuyNow:TRUE withComplitionHandler:^(id result, NSError *err){
        NSString* message = [result  objectForKey:@"message"];
        [[SharedPreferences sharedInstance] showCommonAlertWithMessage:message withObject:self];
    }];    
}

- (IBAction)submitBtnAction:(id)sender {
    [NetworkManager saveBidForAuction:self.auction.ID andBidAmount:self.bidAmtTextFld.text andBuyNow:FALSE withComplitionHandler:^(id result, NSError *err) {
        if (![[result  objectForKey:@"status"] isEqualToString:@"Failure"]) {
            self.maxbidLabel.text = self.bidAmtTextFld.text;
        }
        NSString* message = [result  objectForKey:@"message"];
        [[SharedPreferences sharedInstance] showCommonAlertWithMessage:message withObject:self];
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{

}

-(void)textFieldDidEndEditing:(UITextField *)textField{
}

-(void)hideKeyBoard
{
    [self.bidAmtTextFld resignFirstResponder];
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // add keyboard notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [super viewWillDisappear:animated];
}

-(void)keyboardDidShow:(NSNotification*)aNotification
{
    // move up the screen to the top of the keyboard so that user input fields will be still visible after keyboard appears
    NSDictionary* info = [aNotification userInfo];
    CGRect kbRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    kbRect = [self.view convertRect:kbRect toView:nil];
    self.containerTopconstraint.constant = - kbRect.size.height;
    self.containerBottomconstraint.constant = kbRect.size.height;
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}


-(void)keyboardDidHide:(NSNotification*)aNotification
{
    // move back the screen to normal position how it was when keyboard was not visible
    self.containerTopconstraint.constant = 0;
    self.containerBottomconstraint.constant = 0;
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}


@end
