//
//  MyBidsViewController.m
//  Owlers
//
//  Created by Biprajit Biswas on 30/09/15.
//  Copyright (c) 2015 JNT. All rights reserved.
//

#import "MyBidsViewController.h"
#import "CustomCell1.h"
#import "ProductViewController.h"
#import "Header.h"
@interface MyBidsViewController ()

@end

@implementation MyBidsViewController
NSString *UserId;
- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    UserId= [defaults objectForKey:@"userID"];
    

    NSString *urlstring =[NSString stringWithFormat:@"%@/auctions.php?user_id=41",BaseUrl];
    NSURL *url =[[NSURL alloc]initWithString:urlstring];
    NSURLRequest *request =[[NSURLRequest alloc]initWithURL:url];
    NSURLConnection *connection =[[NSURLConnection alloc]initWithRequest:request delegate:self];
    [connection start];
    
    }

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Error = %@", [error localizedDescription]);
}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    serverdata =[[NSMutableData alloc]init];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [serverdata appendData:data];
    
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    dictionary =[NSJSONSerialization JSONObjectWithData:serverdata options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"my json data =%@",dictionary);
    
    NSArray *bidArray = [[NSMutableArray alloc] init];
    bidArray = [dictionary objectForKey:(@"items")];
    if (bidArray.count == 0) {
    }else{
    [self.tableView reloadData];
    }
    
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
        
        cell =[nib objectAtIndex:0];
    }
    
    cell.label1.text=[[[dictionary objectForKey:(@"items")]objectAtIndex:indexPath.row]objectForKey:@"auction_name"];
    
    cell.label2.text =[[[dictionary objectForKey:(@"items")]objectAtIndex:indexPath.row]objectForKey:@"venue"];
    
    cell.label3.text =[[[dictionary objectForKey:(@"items")]objectAtIndex:indexPath.row]objectForKey:@"created_date"];
    
    cell.label4.text =[[[dictionary objectForKey:(@"items")]objectAtIndex:indexPath.row]objectForKey:@"total_bids"];
     
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
