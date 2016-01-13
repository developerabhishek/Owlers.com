//
//  MyBidsViewController.h
//  Owlers
//
//  Created by Biprajit Biswas on 30/09/15.
//  Copyright (c) 2015 JNT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyBidsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,NSURLConnectionDataDelegate,NSURLConnectionDelegate>

{
    NSMutableDictionary *dictionary;
    IBOutlet UILabel *mybidsLabel;
    IBOutlet UILabel *bidsLabel;
}
- (IBAction)backBtnAction:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
