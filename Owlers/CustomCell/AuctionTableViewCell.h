//
//  AuctionTableViewCell.h
//  Owlers
//
//  Created by RANVIJAI on 16/01/16.
//  Copyright © 2016 JNT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AuctionTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *auctionName;
@property (weak, nonatomic) IBOutlet UILabel *timeLeft;
@property (weak, nonatomic) IBOutlet UILabel *venue;
@property (weak, nonatomic) IBOutlet UILabel *totalBids;

@end
