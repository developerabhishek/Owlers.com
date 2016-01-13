//
//  ProfileViewController.m
//  Owlers
//
//  Created by Biprajit Biswas on 30/09/15.
//  Copyright (c) 2015 JNT. All rights reserved.
//

#import "ProfileViewController.h"
#import "EditViewController.h"
#import "ProductViewController.h"
#import "CustomCell3.h"
#import "Header.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIView.h>
#import <UIKit/UIKitDefines.h>
#import "NetworkManager.h"
#import "SharedPreferences.h"


@interface ProfileViewController ()
@end

@implementation ProfileViewController

@synthesize tableview;


NSURLConnection *connection_, *_connection;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    tableview.delegate=self;
    tableview.dataSource=self;
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    [self.navigationItem setRightBarButtonItem:nil];
    self.navigationItem.hidesBackButton = YES;
    
    
//    NSString *_urlstring=[NSString stringWithFormat:@"%@/profile.php?user_id=%@",BaseUrl,[[NSUserDefaults standardUserDefaults] valueForKey:@"user_id"]];
//    
//    NSLog(@"Url to fetch profile details : %@",_urlstring);
//    //  [defaults objectForKey:@"userID"]];
//    NSURL *url_=[[NSURL alloc]initWithString:_urlstring];
//    NSURLRequest *request_=[[NSURLRequest alloc]initWithURL:url_];
//    connection_=[[NSURLConnection alloc]initWithRequest:request_ delegate:self];
//    [connection_ start];
//    
//  //  NSString *string_url=[NSString stringWithFormat:@"%@/get_booking.php?user_id=%@",BaseUrl,[[NSUserDefaults standardUserDefaults] valueForKey:@"user_id"]];
//    NSString *string_url=[NSString stringWithFormat:@"%@/get_booking.php?user_id=41",BaseUrl];
//    
//    
//    // NSLog(@"my json data =%@",string_url);
//    NSURL *_url=[[NSURL alloc]initWithString:string_url];
//    NSURLRequest *_request=[[NSURLRequest alloc]initWithURL:_url];
//    _connection=[[NSURLConnection alloc]initWithRequest:_request delegate:self];
//    [_connection start];
    
    [NetworkManager getUserProfileFromServerWithComplitionHandler:^(id result, NSError *err) {
        if ([[result objectForKey:@"status"] isEqualToString:@"Y"]) {
            serverDictionary = result;
            _nameLabel.text=[result  objectForKey:@"name"];
            _emaillabel.text=[result objectForKey:@"email"];
            _mobileNoLabel.text=[result objectForKey:@"phone"];
        }
    }];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (connection ==connection_) {
        NSLog(@"Error = %@", [error localizedDescription]);
    }
    else if (connection ==_connection){
        NSLog(@"Error =%@",[error localizedDescription]);
    }
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    if (connection ==connection_) {
        serverDictionary = [NSJSONSerialization JSONObjectWithData:serverData options:NSJSONReadingMutableLeaves error:nil];
        
        _nameLabel.text=[NSString stringWithFormat:@"%@",[serverDictionary  objectForKey:@"name"]];
        _emaillabel.text=[NSString stringWithFormat:@"%@",[serverDictionary objectForKey:@"email"]];
        _mobileNoLabel.text=[NSString stringWithFormat:@"%@",[serverDictionary objectForKey:@"phone"]];
    }
    
    else if (connection ==_connection)
    {
        serDICT =[NSJSONSerialization JSONObjectWithData:serDATA options:NSJSONReadingMutableLeaves error:nil];
        
        [self.tableview reloadData];
    }
    
}


-(IBAction)bokkingAction:(id)sender{
    
    [scrolview setContentOffset:CGPointMake(0, 0)];
    
    
    
}

-(IBAction)walletAction:(id)sender{
    
    
    [scrolview setContentOffset:CGPointMake(self.view.frame.size.width, 0)];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



- (IBAction)actionSheet:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"Select Image" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo With Camera", @"Choose Photo From Gallery", nil];
    [actionSheet showInView:self.view];
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                UIImagePickerController *gallery = [[UIImagePickerController alloc]init];
                [gallery setAllowsEditing:YES];
                [gallery setDelegate:self];
                [gallery setSourceType:UIImagePickerControllerSourceTypeCamera];
                [self presentViewController:gallery animated:YES completion:nil];
            }
            else
            {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Camera is not available" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alertView show];
            }
            break;
        case 1:
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
            {
                UIImagePickerController *gallery = [[UIImagePickerController alloc]init];
                [gallery setAllowsEditing:YES];
                [gallery setDelegate:self];
                [gallery setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
                [self presentViewController:gallery animated:YES completion:nil];
            }
            else
            {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Gallery is not available" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alertView show];
            }
            break;
            
        default:
            break;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"info = %@", info);
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.imageView.image = chosenImage;
    
    [profileImage setImage:chosenImage];
    [self dismissViewControllerAnimated:YES completion:^{
        [addImageButton setTitle:@"Change Image" forState:UIControlStateNormal];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)editbtnAction:(id)sender {
    EditViewController *edit=[[EditViewController alloc]initWithDict:serverDictionary];
    [self.navigationController pushViewController:edit animated:YES];
}

- (IBAction)backBtn:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return serDICT.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *celid =@"cell";
    CustomCell3*cell = [tableView dequeueReusableCellWithIdentifier:celid];
    
    /*******[CHECKING SERVER DATA IS EMPTY OR NOT]*********/
    if([[serDICT objectForKey:(@"history")] isEqualToString:@"No Data Found"]){
        NSLog(@"its not found");
        cell.label1.text = @"No Data Found";
    }
    else
    {
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCell3" owner:self options:nil];
            cell =(CustomCell3*)[nib objectAtIndex:0];
        }
        
        if (indexPath==indexpath) {
            cell.viewd.hidden = NO;
        }else
            cell.viewd.hidden=YES;
        cell.label1.text=[[[serDICT objectForKey:(@"history")]objectAtIndex:indexPath.row]objectForKey:@"event_name"];
        cell.label2.text=[[[serDICT objectForKey:(@"history")]objectAtIndex:indexPath.row]objectForKey:@"event_venue"];
        cell.rupees_Lab.text =[[[serDICT objectForKey:@"history"]objectAtIndex:indexpath.row]objectForKey:@"total_amount"];
        NSString *strgfhfg=[[[serDICT objectForKey:(@"history")]objectAtIndex:indexPath.row]objectForKey:@"event_date"];
        
        NSArray *itemsrr = [strgfhfg componentsSeparatedByString:@" "];   //take the one arraysplit the string
        
        
        NSString *dddd = [itemsrr objectAtIndex:0];
        cell.date_label.text =dddd;
        NSString *ddddff = [itemsrr objectAtIndex:1];
        cell.time_label.text =ddddff;
        NSString *payment_mrthod = [[[serDICT objectForKey:(@"history")]objectAtIndex:indexPath.row]objectForKey:@"payment_method"];
        
        if([payment_mrthod isEqual:@"Cash"]){
            cell.label3.text = @"Cash Payment !!";
        }else{
            cell.label3.text = @"Online Payment !!";
        }
        
    }
    
    return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    [userdefault setObject:@"" forKey:@"index"];
    
    if (indexpath==indexPath) {
        NSLog(@"this is same indexpath");
        indexpath=nil;
        [userdefault setObject:@"60" forKey:@"changecell"];
    }else{
        indexpath=indexPath;
        [userdefault setObject:@"250" forKey:@"changecell"];
    }
    
    [tableview reloadData];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexpath==indexPath) {
        return 248;
    }
    
    return 83;
    
}

- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
