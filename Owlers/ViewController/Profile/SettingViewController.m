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
        case eSettingsActionShare:
            [self shareAction];
            break;

        default:
            break;
    }
    
    if (segueIdentifier){
        [self performSegueWithIdentifier:segueIdentifier sender:nil];
    }
}

#pragma mark
#pragma mark Private methods
#pragma mark

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

- (void)shareAction{
    NSString *textToShare = @"Please checkout the latest feature of owlers";
    NSURL *url = [NSURL URLWithString:@"https://www.google.co.in/?gfe_rd=cr&ei=O-2kVoL5OeqK8Qf7_ovoDA"];
    NSArray *objectsToShare = @[textToShare,url];
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    
    NSArray *excludeActivities = @[UIActivityTypeAirDrop,
                                   UIActivityTypePrint,
                                   UIActivityTypeAssignToContact,
                                   UIActivityTypeSaveToCameraRoll,
                                   UIActivityTypeAddToReadingList,
                                   UIActivityTypePostToFlickr,
                                   UIActivityTypePostToVimeo];
    
    controller.excludedActivityTypes = excludeActivities;
    
    [self presentViewController:controller animated:YES completion:nil];
}


@end
