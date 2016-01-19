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
    self.location.layer.borderWidth = 0.5f;
    self.location.layer.cornerRadius = 1.0f;
    self.location.layer.borderColor = [UIColor grayColor].CGColor;
}

@end
