//
//  SettingsTableViewCell.h
//  Owlers
//
//  Created by RANVIJAI on 06/01/16.
//  Copyright © 2016 JNT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsActionData.h"

@interface SettingsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *actionInfoLbl;
@property (nonatomic, strong) SettingsActionData *data;

- (void)loadCellWithData:(SettingsActionData*)data;

@end
