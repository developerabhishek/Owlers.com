//
//  SettingsTableViewCell.m
//  Owlers
//
//  Created by RANVIJAI on 06/01/16.
//  Copyright © 2016 JNT. All rights reserved.
//

#import "SettingsTableViewCell.h"

@implementation SettingsTableViewCell

- (void)loadCellWithData:(SettingsActionData*)data {
    self.data = data;
    self.actionInfoLbl.text = self.data.displayTxt;
}

@end
