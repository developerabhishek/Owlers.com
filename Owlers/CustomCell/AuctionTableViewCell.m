//
//  AuctionTableViewCell.m
//  Owlers
//
//  Created by RANVIJAI on 16/01/16.
//  Copyright © 2016 JNT. All rights reserved.
//

#import "AuctionTableViewCell.h"

@implementation AuctionTableViewCell

- (void)updateViewWithData:(Auction*)data {
    self.timeLeft.text = [NSString stringWithFormat:@"%ldDay/s %02ld:%02ld:%02ld",(long)data.daysLeft, (long)data.hoursLeft, (long)data.minutesLeft, (long)data.secondsLeft];
}

@end
