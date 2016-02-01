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
    
    
//    checkAuctionBidForAuction
    
    [NetworkManager checkAuctionBidForAuction:self.auction.ID withComplitionHandler:^(id result, NSError *err) {
        if ([[result objectForKey:@"status"] isEqualToString:@"Success"]) {
            [self updateAuctionPrice:result];
        }
    }];
    
    UITapGestureRecognizer *keyBoardHideRecognizer = [[UITapGestureRecognizer alloc] init];
    [keyBoardHideRecognizer addTarget:self action:@selector(hideKeyBoard)];
    [self.view addGestureRecognizer:keyBoardHideRecognizer];
}

- (void)setDetailsOfAution:(Auction *)auction{
    self.descLabel.text= auction.auctionDescription;
    self.nameLabel.text= [auction.name uppercaseString];
    [self.buyNowBtn setTitle:[NSString stringWithFormat:@"Buy Now For Rs. %@",auction.buyPrice] forState:UIControlStateNormal];
    NSString *imageURL = [NSString stringWithFormat:@"http://owlers.com/auction_images/%@",auction.imgURL];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.imageoo sd_setImageWithURL:[NSURL URLWithString:imageURL]
                        placeholderImage:[UIImage imageNamed:@"new_background_ullu.png"]];
    });
}

- (void)updateAuctionPrice:(NSDictionary *)dict{
    self.totalBidLabel.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"total_bids"]];
    self.maxbidLabel.text = [NSString stringWithFormat:@"Rs. %@",[dict objectForKey:@"max_bidAmount"]];

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
    
    if ([self.bidAmtTextFld.text length] > 0) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"JNT" message:@"Are you sure you want to submit the bid?" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action)
                                 {
                                     [alertController dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
        [alertController addAction:cancel];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action)
                             {
                                [self submitTheBid];
                                 
                             }];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];

    }else{
        [[SharedPreferences sharedInstance] showCommonAlertWithMessage:@"Please enter the bid amount." withObject:self];
    }
}

- (void)submitTheBid{
    [NetworkManager saveBidForAuction:self.auction.ID andBidAmount:self.bidAmtTextFld.text andBuyNow:FALSE withComplitionHandler:^(id result, NSError *err) {
        if (![[result  objectForKey:@"status"] isEqualToString:@"Failure"]) {
            self.maxbidLabel.text = self.bidAmtTextFld.text;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"BIDSUBMITTED" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
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
