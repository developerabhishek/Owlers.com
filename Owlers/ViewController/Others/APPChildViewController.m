//
//  APPChildViewController.m
//  PageApp
//
//  Created by Rafael Garcia Leiva on 10/06/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "APPChildViewController.h"

@interface APPChildViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *displayLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgBottomconstraint;

@end

@implementation APPChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imgView.image = self.data.img;
    self.displayLbl.text = self.data.displayTxt;
}

- (void)viewDidLayoutSubviews {
    [self.imgBottomconstraint setActive:self.hideMessage];
    self.displayLbl.hidden = self.hideMessage;
    self.imgView.contentMode = self.mode;
    [self.view layoutIfNeeded];
}

@end
