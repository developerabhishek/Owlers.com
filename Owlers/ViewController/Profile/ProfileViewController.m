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

@property(nonatomic,strong) NSDictionary *bookingDictionary;

@end

@implementation ProfileViewController

NSURLConnection *connection_, *_connection;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [NetworkManager getUserProfileFromServerWithComplitionHandler:^(id result, NSError *err) {
        if ([[result objectForKey:@"status"] isEqualToString:@"Y"]) {
            serverDictionary = result;
            _nameLabel.text=[result  objectForKey:@"name"];
            _emaillabel.text=[result objectForKey:@"email"];
            _mobileNoLabel.text=[result objectForKey:@"phone"];
        }
    }];
    
    [NetworkManager getAllBooking:^(id result, NSError *err) {
        self.bookingDictionary = (NSDictionary *) result;
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

-(IBAction)bookingAction:(id)sender{
}

-(IBAction)walletAction:(id)sender{
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
    
    [self.profileImage setImage:chosenImage];
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

- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];    
}

@end
