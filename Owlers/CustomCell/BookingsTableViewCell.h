//
//  BookingsTableViewCell.h
//  Owlers
//
//  Created by RANVIJAI on 17/01/16.
//  Copyright © 2016 JNT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookingsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *eventName;
@property (weak, nonatomic) IBOutlet UILabel *eventVenue;
@property (weak, nonatomic) IBOutlet UILabel *warnings;
@property (weak, nonatomic) IBOutlet UILabel *eventDesc;
@property (weak, nonatomic) IBOutlet UILabel *eventTerms;
@property (weak, nonatomic) IBOutlet UILabel *bookingDate;
@property (weak, nonatomic) IBOutlet UILabel *bookingTime;
@property (weak, nonatomic) IBOutlet UILabel *bookingPrice;

@end
