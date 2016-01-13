//
//  MyBidsViewController.m
//  Owlers
//
//  Created by Biprajit Biswas on 30/09/15.
//  Copyright (c) 2015 JNT. All rights reserved.
//

#import "MyBidsViewController.h"
#import "CustomCell1.h"
#import "SharedPreferences.h"
#import "NetworkManager.h"

@interface MyBidsViewController ()

@end

@implementation MyBidsViewController
NSString *UserId;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [NetworkManager getMyBidsWithComplitionHandler:^(id result, NSError *err) {
        dictionary = (NSMutableDictionary *)result;
        [self.tableView reloadData];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dictionary.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *celid =@"cell";
    CustomCell1 *cell = [tableView dequeueReusableCellWithIdentifier:celid];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCell1" owner:self options:nil];
        
        cell =[nib firstObject];
    }
    
    NSDictionary *dict = [[dictionary objectForKey:(@"items")]objectAtIndex:indexPath.row];
    if (dict) {
        cell.label1.text=[dict objectForKey:@"auction_name"];
        cell.label2.text =[dict objectForKey:@"venue"];
        cell.label3.text =[dict objectForKey:@"created_date"];
        cell.label4.text =[dict objectForKey:@"total_bids"];
    }
    
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
