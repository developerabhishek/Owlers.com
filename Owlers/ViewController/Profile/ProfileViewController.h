//
//  ProfileViewController.h
//  Owlers
//
//  Created by Biprajit Biswas on 30/09/15.
//  Copyright (c) 2015 JNT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UIViewController<UINavigationBarDelegate,UIImagePickerControllerDelegate,NSURLConnectionDataDelegate,NSURLConnectionDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>

{
    NSArray *array;
    NSMutableData *serDATA;
    NSMutableDictionary *serDICT;
    NSMutableData *serverData;
    NSMutableDictionary *serverDictionary;
    IBOutlet UIButton *addImageButton;
    NSIndexPath *indexpath;
}

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *emaillabel;
@property (strong, nonatomic) IBOutlet UILabel *mobileNoLabel;
- (IBAction)actionSheet:(id)sender;

@property (strong, nonatomic) IBOutlet UIImageView *profileImage;
@property(nonatomic,strong) IBOutlet UITableView *profileTbl;

- (IBAction)backBtnAction:(id)sender;
- (IBAction)bookingAction:(id)sender;
- (IBAction)walletAction:(id)sender;
@end
