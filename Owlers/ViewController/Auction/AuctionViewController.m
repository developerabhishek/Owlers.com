//
//  AuctionViewController.m
//  Owlers
//
//  Created by Biprajit Biswas on 26/10/15.
//  Copyright (c) 2015 JNT. All rights reserved.
//

#import "AuctionViewController.h"
#import "CustomCell2.h"
#import "CustomCell4.h"
#import "ProductViewController.h"
#import "BidSectionViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "SVProgressHUD.h"
#import "Header.h"
#import "SharedPreferences.h"
#import "NetworkManager.h"

@interface AuctionViewController ()

@end

@implementation AuctionViewController

@synthesize tableView1;
@synthesize citytable;
NSURLConnection *conne_ction ,*connection_;
- (void)viewDidLoad {
    [super viewDidLoad];

    NSLog(@"%@",[[UIDevice currentDevice] model]);
    NSLog(@"%@",[[UIDevice currentDevice] name]);
    
    
    self.citytable.hidden=YES;
    [self loadData];
}

- (void)loadData{
    [NetworkManager loadAcutionsForCity:nil withComplitionHandler:^(id result, NSError *err) {
        serverDict = result;
        [self.tableView1 reloadData];
    }];
    
    [NetworkManager loadLocationWithComplitionHandler:^(id result, NSError *err) {
        serDICT = result;
        [self.citytable reloadData];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  tableView ==tableView1 ?  [[serverDict objectForKey:@"items"] count] : [[serDICT objectForKey:@"Locations"] count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return tableView == citytable ? 48 : 160;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView ==tableView1) {
        static NSString *celid =@"cell";
        CustomCell2 *cell = [tableView dequeueReusableCellWithIdentifier:celid];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCell2" owner:self options:nil];
            
            cell = [nib firstObject];
        }
        
        citytable.backgroundColor = [UIColor darkGrayColor];
        cell.label1.text=[[[serverDict objectForKey:(@"items")]objectAtIndex:indexPath.row]objectForKey:@"auction_name"];
        cell.label2.text =[[[serverDict objectForKey:(@"items")]objectAtIndex:indexPath.row]objectForKey:@"time_elapsed"];
        cell.label3.text =[[[serverDict objectForKey:(@"items")]objectAtIndex:indexPath.row]objectForKey:@"venue"];
        cell.label4.text =[[[serverDict objectForKey:(@"items")]objectAtIndex:indexPath.row]objectForKey:@"total_bids"];
        return cell;
        
    }
    static NSString *celid1 =@"cell";
    CustomCell4*cell1 = [tableView dequeueReusableCellWithIdentifier:celid1];
    if (cell1 == nil)
    {
        NSArray *nib1 = [[NSBundle mainBundle] loadNibNamed:@"CustomCell4" owner:self options:nil];
        
        cell1 = [nib1 firstObject];
    }
    
    cell1.backgroundColor = [UIColor clearColor];
    cell1.label.text=[[[serDICT objectForKey:(@"Locations")]objectAtIndex:indexPath.row]objectForKey:@"location_name"];
    
    return cell1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView ==tableView1) {
        
        NSDictionary *dict = [[serverDict objectForKey:(@"items")]objectAtIndex:indexPath.row];
        BidSectionViewController *bid =[[BidSectionViewController alloc]initwithDict:dict];
        [self.navigationController pushViewController:bid animated:YES];
    }
    else {
        [cityBtn setTitle:[[[serDICT objectForKey:(@"Locations")]objectAtIndex:indexPath.row]objectForKey:@"location_name"] forState:UIControlStateNormal];
        
        NSString *cityID = [[[serDICT objectForKey:(@"Locations")]objectAtIndex:indexPath.row]objectForKey:@"location_id"];
        citytable.hidden=YES;
        
        [NetworkManager loadAcutionsForCity:cityID withComplitionHandler:^(id result, NSError *err) {
            serverDict = result;
            [self.tableView1 reloadData];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cityBtn:(id)sender {
    
    if (citycheck) {
        citycheck=NO;
        self.citytable.hidden=YES;
    }
    else{
        citycheck=YES;
        self.citytable.hidden=NO;
    }
}

@end
