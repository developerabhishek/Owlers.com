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

@interface TesteventViewController ()
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
    
    self.malePriceLbl.text = [NSString stringWithFormat:@"%d",self.event.malePrice];
    self.femalePriceLbl.text = [NSString stringWithFormat:@"%d",self.event.femalePrice];
    self.couplePriceLbl.text = [NSString stringWithFormat:@"%d",self.event.couplePrice];
    [self.payNowBtn setTitle:[NSString stringWithFormat:@"PAY  NOW ( %@ )",self.event.discountTitle] forState:UIControlStateNormal];
    
    [self update];
}

- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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

}

- (IBAction)payNowAction:(id)sender {

    [[SharedPreferences sharedInstance] showCommonAlertWithMessage:@"Need to integrate payment page" withObject:self];
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

@end
