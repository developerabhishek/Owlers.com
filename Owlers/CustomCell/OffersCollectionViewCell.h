//
//  OffersCollectionViewCell.h
//  Owlers
//
//  Created by RANVIJAI on 20/01/16.
//  Copyright © 2016 JNT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OffersCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *offerLbl;
- (IBAction)callForOffer:(id)sender;

@end
