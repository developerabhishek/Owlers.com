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

@end
