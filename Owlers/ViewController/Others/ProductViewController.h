//
//  ProductViewController.h
//  Owlers
//
//  Created by Biprajit Biswas on 25/09/15.
//  Copyright (c) 2015 JNT. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import <Foundation/Foundation.h>
#import "LoginViewController.h"
#import <CoreGraphics/CoreGraphics.h>
#import "CalendarView.h"
#import "MenuPopUpViewController.h"

@interface ProductViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UIAlertViewDelegate , UIAdaptivePresentationControllerDelegate, MenuDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *loaderOwlersImage;

- (IBAction)selectLocationAction:(UIButton*)sender;
- (IBAction)displayCalendarAction:(UIButton*)sender;
- (IBAction)displaySearchBarAction:(UIButton*)sender;
- (IBAction)displayAuctionScreenAction:(UIButton*)sender;
- (IBAction)seachBackAction:(id)sender;

@end
