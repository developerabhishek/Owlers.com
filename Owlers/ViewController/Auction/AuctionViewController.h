//
//  AuctionViewController.h
//  Owlers
//
//  Created by Biprajit Biswas on 26/10/15.
//  Copyright (c) 2015 JNT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuPopUpViewController.h"

@interface AuctionViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,NSURLConnectionDataDelegate,NSURLConnectionDelegate, UIAdaptivePresentationControllerDelegate, MenuDelegate>
{
    NSMutableData *serverData;
    NSMutableDictionary *serverDict;
    NSArray *array;
    
    NSMutableData *serDATA;
    NSMutableDictionary *serDICT;
    NSArray *arr;
  
}

@property (strong, nonatomic)  NSString *location_id;
- (IBAction)backBtnAction:(id)sender;

@end
