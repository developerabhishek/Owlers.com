//
//  CityCollectionViewCell.m
//  Owlers
//
//  Created by RANVIJAI on 11/01/16.
//  Copyright © 2016 JNT. All rights reserved.
//

#import "LocationCollectionViewCell.h"

@implementation LocationCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    self.location.layer.borderWidth = 1.0f;
    self.location.layer.cornerRadius = 2.0f;
    self.location.layer.borderColor = [UIColor whiteColor].CGColor;
}

@end
