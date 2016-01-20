//
//  SettingViewController.m
//  Owlers
//
//  Created by Biprajit Biswas on 30/09/15.
//  Copyright (c) 2015 JNT. All rights reserved.
//

#import "SettingViewController.h"
#import "ProductViewController.h"
#import "OwlersViewController.h"
#import "SettingsActionData.h"
#import "SettingsTableViewCell.h"

@interface SettingViewController ()

@property (strong, nonatomic) NSMutableArray *actionDatalist;

@end


@implementation SettingViewController

- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sharebtnAction:(id)sender {
    
    NSURL *url = [NSURL URLWithString:@"jfkdljfkjf"];
    NSArray *objectsToShare = @[url];
    //
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    //
    //    // Exclude all activities except AirDrop.
    //    NSArray *excludedActivities = @[UIActivityTypePostToTwitter, UIActivityTypePostToFacebook,
    //                                    UIActivityTypePostToWeibo,
    //                                    UIActivityTypeMessage, UIActivityTypeMail,
    //                                    UIActivityTypePrint, UIActivityTypeCopyToPasteboard,
    //                                    UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll,
    //                                    UIActivityTypeAddToReadingList, UIActivityTypePostToFlickr,
    //                                    UIActivityTypePostToVimeo, UIActivityTypePostToTencentWeibo];
    //    controller.excludedActivityTypes = excludedActivities;
    //
    //    // Present the controller
    [self presentViewController:controller animated:YES completion:nil];
    //
    
}

//- (NSURL *) fileToURL:(NSString*)filename
//{
//    NSArray *fileComponents = [filename componentsSeparatedByString:@"."];
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:[fileComponents objectAtIndex:0] ofType:[fileComponents objectAtIndex:1]];
//
//    return [NSURL fileURLWithPath:filePath];
//}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SettingsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseSettings"];
    [cell loadCellWithData:[self.actionDatalist objectAtIndex:indexPath.row]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.actionDatalist.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *segueIdentifier = nil;
    SettingsActionData *data = [self.actionDatalist objectAtIndex:indexPath.row];
    switch (data.action) {
        case eSettingsActionChangePassword:
            segueIdentifier = @"segueChangePassword";
            break;
        case eSettingsActionBilling:
            segueIdentifier = @"segueBillingDetails";
            break;
        case eSettingsActionNotification:
            segueIdentifier = @"segueNotifications";
            break;
        case eSettingsActionTermsAndCondition:
            segueIdentifier = @"segueTermsAndConditions";
            break;
        default:
            break;
    }
    
    if (segueIdentifier && ![segueIdentifier isEqualToString:@""]) {
        [self performSegueWithIdentifier:segueIdentifier sender:nil];
    }
}


- (NSMutableArray*)actionDatalist {
    if (!_actionDatalist) {
        _actionDatalist = [[NSMutableArray alloc] init];
        SettingsActionData *changePWD = [SettingsActionData dataWithAction:eSettingsActionChangePassword displayText:@"Change Password"];
        [_actionDatalist addObject:changePWD];
        SettingsActionData *billing = [SettingsActionData dataWithAction:eSettingsActionBilling displayText:@"Billing Detail"];
        [_actionDatalist addObject:billing];
        SettingsActionData *notification = [SettingsActionData dataWithAction:eSettingsActionNotification displayText:@"Notification Settings"];
        [_actionDatalist addObject:notification];
        SettingsActionData *share = [SettingsActionData dataWithAction:eSettingsActionShare displayText:@"Share"];
        [_actionDatalist addObject:share];
        SettingsActionData *rateus = [SettingsActionData dataWithAction:eSettingsActionRateUS displayText:@"Rate Us"];
        [_actionDatalist addObject:rateus];
        SettingsActionData *terms = [SettingsActionData dataWithAction:eSettingsActionTermsAndCondition displayText:@"Terms and Conditions"];
        [_actionDatalist addObject:terms];
    }
    return _actionDatalist;
}

@end
