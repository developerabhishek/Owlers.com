//
//  AuctionViewController.h
//  Owlers
//
//  Created by Biprajit Biswas on 26/10/15.
//  Copyright (c) 2015 JNT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AuctionViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,NSURLConnectionDataDelegate,NSURLConnectionDelegate>
{
    NSMutableData *serverData;
    NSMutableDictionary *serverDict;
    NSArray *array;
    
    NSMutableData *serDATA;
    NSMutableDictionary *serDICT;
    NSArray *arr;
    
    BOOL citycheck;
    IBOutlet UIButton *cityBtn;
}

@property (strong, nonatomic)  NSString *location_id;
@property (strong, nonatomic) IBOutlet UITableView *tableView1;
@property(nonatomic,strong) IBOutlet UITableView *citytable;
- (IBAction)backBtnAction:(id)sender;
- (IBAction)cityBtn:(id)sender;

@end
