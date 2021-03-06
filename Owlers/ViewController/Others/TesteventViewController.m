//
//  TesteventViewController.m
//  Owlers
//
//  Created by Biprajit Biswas on 15/10/15.
//  Copyright (c) 2015 JNT. All rights reserved.
//

#import "TesteventViewController.h"
#import "OwlersViewController.h"
#import "SharedPreferences.h"
#import "PGTransactionViewController.h"
#import "PGOrder.h"
#import "NetworkManager.h"
#import "SharedPreferences.h"
@interface TesteventViewController () <PGTransactionDelegate>
{
    int _maleCount, _femaleCount, _coupleCount;
}
@property (weak, nonatomic) IBOutlet UILabel *screenTitle;
@property (weak, nonatomic) IBOutlet UILabel *maleCountLbl;
@property (weak, nonatomic) IBOutlet UILabel *femaleCountLbl;
@property (weak, nonatomic) IBOutlet UILabel *payableMaleCountLbl;
@property (weak, nonatomic) IBOutlet UILabel *payableFemaleCountLbl;
@property (weak, nonatomic) IBOutlet UILabel *payableCoupleCountLbl;
@property (weak, nonatomic) IBOutlet UILabel *malePriceLbl;
@property (weak, nonatomic) IBOutlet UILabel *femalePriceLbl;
@property (weak, nonatomic) IBOutlet UILabel *couplePriceLbl;
@property (weak, nonatomic) IBOutlet UILabel *calculatedMalePriceLbl;
@property (weak, nonatomic) IBOutlet UILabel *calculatedFemalePriceLbl;
@property (weak, nonatomic) IBOutlet UILabel *calculatedCouplePriceLbl;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLbl;
@property (weak, nonatomic) IBOutlet UILabel *withoutPaymentPriceLbl;
@property (weak, nonatomic) IBOutlet UILabel *payNowPriceLbl;
@property (weak, nonatomic) IBOutlet UIButton *payNowBtn;

@end

@implementation TesteventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.maleCountLbl.layer.borderWidth = 1.0f;
    self.femaleCountLbl.layer.borderWidth = 1.0f;
    self.maleCountLbl.layer.borderColor = [UIColor colorWithRed:251.0f/255 green:156.0f/255 blue:21.0f/255 alpha:1].CGColor;
    self.femaleCountLbl.layer.borderColor = [UIColor colorWithRed:251.0f/255 green:156.0f/255 blue:21.0f/255 alpha:1].CGColor;
    
    _maleCount = 0;
    _femaleCount = 0;
    _coupleCount = 0;
    
    self.screenTitle.text = self.event.name;
    self.malePriceLbl.text = [NSString stringWithFormat:@"%d",self.event.malePrice];
    self.femalePriceLbl.text = [NSString stringWithFormat:@"%d",self.event.femalePrice];
    self.couplePriceLbl.text = [NSString stringWithFormat:@"%d",self.event.couplePrice];
    
    [self.payNowBtn setTitle:[NSString stringWithFormat:@"PAY  NOW ( %@ )",self.event.discountTitle?self.event.discountTitle : @"0% off"] forState:UIControlStateNormal];
    
    [self update];
}

- (IBAction)backBtnAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)maleMinusAction:(id)sender {
    if (_maleCount >= 1) {
        _maleCount--;
        [self update];
    }
}

- (IBAction)malePlusAction:(id)sender {
    _maleCount++;
    [self update];
}

- (IBAction)femaleMinusAction:(id)sender {
    if (_femaleCount >= 1) {
        _femaleCount--;
        [self update];
    }
}

- (IBAction)femalePlusAction:(id)sender {
    _femaleCount++;
    [self update];
}

- (IBAction)continueWithoutPayAction:(id)sender {

    if (_maleCount + _femaleCount + _coupleCount) {
        NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] initWithCapacity:0];
        [paramDict setObject:[[SharedPreferences sharedInstance] getUserID] forKey:@"user_id"];
        [paramDict setObject:self.event.ID forKey:@"event_id"];
        [paramDict setObject:[NSString stringWithFormat:@"%d",_maleCount] forKey:@"no_of_males"];
        [paramDict setObject:[NSString stringWithFormat:@"%d",_femaleCount] forKey:@"no_of_females"];
        [paramDict setObject:[NSString stringWithFormat:@"%d",_coupleCount] forKey:@"no_of_couples"];
        
        NSInteger totalPrice = ((_maleCount - _coupleCount)*self.event.malePrice )+ ((_femaleCount - _coupleCount)*self.event.femalePrice) + (_coupleCount*self.event.couplePrice);
        
        [paramDict setObject:[NSString stringWithFormat:@"%ld",(long)totalPrice] forKey:@"total_amount"];
        [paramDict setObject:@"Cash" forKey:@"payment_method"];
        [paramDict setObject:[NSString stringWithFormat:@"%ld",(long)totalPrice] forKey:@"sub_total"];
        
        [paramDict setObject:@"0" forKey:@"discount_percent"];
        [paramDict setObject:@"4545.7765.767" forKey:@"mac_addr"];
        [paramDict setObject:self.event.eventDescription forKey:@"event_description"];
        [paramDict setObject:self.event.terms ? self.event.terms : @"" forKey:@"event_terms"];
        
        
        [NetworkManager bookEvent:paramDict withComplitionBlock:^(id result, NSError *err) {
            NSLog(@"%@",result);
            NSString *message = nil;
            if (result && [[result objectForKey:@"status"] isEqualToString:@"Success"]) {
                message = [NSString stringWithFormat:@"%@.\nYour offer booking number is %@",[result objectForKey:@"message"],[result objectForKey:@"booking_number"]];
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"JNT" message:message preferredStyle:UIAlertControllerStyleAlert];                
                UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action)
                                     {
                                         [self backBtnAction:nil];
                                     }];
                [alertController addAction:ok];
                
                [self presentViewController:alertController animated:YES completion:nil];
                
            }else{
                message = [NSString stringWithFormat:@"%@.",[result objectForKey:@"message"]];
                [[SharedPreferences sharedInstance] showCommonAlertWithMessage:message withObject:self];
            }
            
        }];
    }else{
        [[SharedPreferences sharedInstance] showCommonAlertWithMessage:@"Please select number of Admits" withObject:self];
    }
}

- (IBAction)payNowAction:(id)sender {

    if (_maleCount + _femaleCount + _coupleCount) {
        NSInteger totalPrice = ((_maleCount - _coupleCount)*self.event.malePrice )+ ((_femaleCount - _coupleCount)*self.event.femalePrice) + (_coupleCount  *self.event.couplePrice);

        NSInteger discountedPrice  = totalPrice - ((totalPrice * self.event.discountValue)/100);
        NSString *sDiscountedPrice = [NSString stringWithFormat:@"%ld", (long)discountedPrice];

        PGMerchantConfiguration *mc = [PGMerchantConfiguration defaultConfiguration];

        mc.checksumGenerationURL = @"http://owlers.com/services/paytmChecksum/generateChecksum.php";
        mc.checksumValidationURL = @"http://owlers.com/services/paytmChecksum/verifyChecksum.php";

        NSMutableDictionary *orderDict = [[NSMutableDictionary alloc] initWithCapacity:0];
        orderDict[@"MID"] = @"Icedre48273242927966";
        orderDict[@"CHANNEL_ID"] = @"WAP";
        orderDict[@"INDUSTRY_TYPE_ID"] = @"Retail";
        orderDict[@"WEBSITE"] = @"Icedreamwap";
        //Order configuration in the order object
        orderDict[@"TXN_AMOUNT"] = sDiscountedPrice;
        orderDict[@"ORDER_ID"] = [self getUniqueOrderID];
        orderDict[@"REQUEST_TYPE"] = @"DEFAULT";
        orderDict[@"CUST_ID"] = [[SharedPreferences sharedInstance] getUserID];
        
        
        PGOrder *order = [PGOrder orderWithParams:orderDict];

        
        PGTransactionViewController *txnController = [[PGTransactionViewController alloc] initTransactionForOrder:order];
        UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:txnController];
        txnController.serverType = eServerTypeStaging;
        txnController.merchant = mc;
        txnController.delegate = self;
        [self presentViewController:navCtrl animated:YES completion:nil];
    }else{
        [[SharedPreferences sharedInstance] showCommonAlertWithMessage:@"Please select number of Admits" withObject:self];
    }
}

- (NSString *)getUniqueOrderID{
    
    
    int fromNumber = arc4random() + 1000000;
    int toNumber   = arc4random() + 10000000;
    int randomNumber = (arc4random()%(toNumber-fromNumber))+fromNumber;
    if (randomNumber < 0) {
        randomNumber = (randomNumber * -1);
    }
    return [NSString stringWithFormat:@"%ld", (long)randomNumber];
}


- (void)update {
    
    self.maleCountLbl.text = [NSString stringWithFormat:@"%d",_maleCount];
    self.femaleCountLbl.text = [NSString stringWithFormat:@"%d",_femaleCount];
    
    if (_maleCount <= _femaleCount) {
        _coupleCount = _maleCount;
    }else {
        _coupleCount = _femaleCount;
    }
    
    self.payableMaleCountLbl.text = [NSString stringWithFormat:@"%d",(_maleCount - _coupleCount)];
    self.payableFemaleCountLbl.text = [NSString stringWithFormat:@"%d",(_femaleCount - _coupleCount)];
    self.payableCoupleCountLbl.text = [NSString stringWithFormat:@"%d",_coupleCount];
    
    if (self.event) {
        self.calculatedMalePriceLbl.text = [NSString stringWithFormat:@"%d",(_maleCount - _coupleCount)*self.event.malePrice];
        self.calculatedFemalePriceLbl.text = [NSString stringWithFormat:@"%d",(_femaleCount - _coupleCount)*self.event.femalePrice];
        self.calculatedCouplePriceLbl.text = [NSString stringWithFormat:@"%d", _coupleCount*self.event.couplePrice];
        
        NSInteger totalPrice = ((_maleCount - _coupleCount)*self.event.malePrice )+ ((_femaleCount - _coupleCount)*self.event.femalePrice) + (_coupleCount*self.event.couplePrice);
        self.totalPriceLbl.text = [NSString stringWithFormat:@"%ld", (long)totalPrice];

        self.withoutPaymentPriceLbl.text = [NSString stringWithFormat:@"%ld", (long)totalPrice];
        NSInteger discountedPrice  = totalPrice - ((totalPrice * self.event.discountValue)/100);
        self.payNowPriceLbl.text = [NSString stringWithFormat:@"%ld", (long)discountedPrice];
    }
}

- (void)didSucceedTransaction:(PGTransactionViewController *)controller response:(NSDictionary *)response{
    
    [controller dismissViewControllerAnimated:YES completion:nil];
    
    if ([[response objectForKey:@"STATUS"] isEqualToString:@"TXN_SUCCESS"]) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"JNT" message:[response objectForKey:@"RESPMSG"] preferredStyle:UIAlertControllerStyleAlert];

        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action)
                             {
                                 [self dismissViewControllerAnimated:YES completion:nil];
                                 [[NSNotificationCenter defaultCenter] postNotificationName:@"TRANSACTION_SUCCESSFULL" object:nil];
                             }];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }    
}

//Called when transaction fails with any reason. Response dictionary will be having details about the failed transaction.
- (void)didFailTransaction:(PGTransactionViewController *)controller error:(NSError *)error response:(NSDictionary *)response{
    [[SharedPreferences sharedInstance] showCommonAlertWithMessage:[response objectForKey:@"RESPMSG"] withObject:self];
}

//Called when a transaction is cancelled by the user. Response dictionary will be having details about the cancelled transaction.
- (void)didCancelTransaction:(PGTransactionViewController *)controller error:(NSError*)error response:(NSDictionary *)response{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

//Called when Checksum HASH generation completes either by PG Server or Merchant Server.
- (void)didFinishCASTransaction:(PGTransactionViewController *)controller response:(NSDictionary *)response{
}


@end
