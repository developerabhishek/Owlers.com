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
#import "Header.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIView.h>
#import <UIKit/UIKitDefines.h>
#import "NetworkManager.h"
#import "SharedPreferences.h"
#import "Booking.h"
#import "BookingsTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface ProfileViewController ()

@property(nonatomic,strong) NSDictionary *bookingDictionary;
@property (nonatomic, strong) NSMutableArray *bookings;
@property (weak, nonatomic) IBOutlet UIImageView *bookingSeparator;
@property (weak, nonatomic) IBOutlet UIImageView *walletSeparator;
@property (weak, nonatomic) IBOutlet UIView *walletView;
@property (strong, nonatomic) NSIndexPath *selectedIndex;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self refreshProfile];
    [NetworkManager getAllBooking:^(id result, NSError *err) {
        
        if ([[result objectForKey:@"history"] isKindOfClass:[NSArray class]]) {
            NSArray *items =  (NSArray *) [result objectForKey:@"history"];
            
            for (NSDictionary *eventDict in items) {
                Booking *booking = [[Booking alloc] init];
                Event *event = [[Event alloc] init];
                booking.event = event;
                
                booking.noOfCouple = [[eventDict objectForKey:@"no_of_couples"] intValue];
                booking.noOfFemale = [[eventDict objectForKey:@"no_of_females"] intValue];
                booking.noOfMale = [[eventDict objectForKey:@"no_of_males"] intValue];
                booking.bookingDate = [eventDict objectForKey:@"booking_date"];
                booking.bookingNumber = [eventDict objectForKey:@"booking_number"];
                booking.totalAmount = [[eventDict objectForKey:@"total_amount"] intValue];
                booking.paymentMethod = [eventDict objectForKey:@"payment_method"];
                event.eventDate = [eventDict objectForKey:@"event_date"];
                event.eventDescription = [eventDict objectForKey:@"event_description"];
                event.name = [eventDict objectForKey:@"event_name"];
                event.terms = [eventDict objectForKey:@"event_terms"];
                event.venue = [eventDict objectForKey:@"event_venue"];
                
                [self.bookings addObject:booking];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.bookingsTbl reloadData];
            });
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //[self refreshProfile];
}

- (void)refreshProfile{

    [NetworkManager getUserProfileFromServerWithComplitionHandler:^(id result, NSError *err) {
        if ([[result objectForKey:@"status"] isEqualToString:@"Y"]) {
            serverDictionary = result;
            _nameLabel.text=[result  objectForKey:@"name"];
            _emaillabel.text=[result objectForKey:@"email"];
            _mobileNoLabel.text=[result objectForKey:@"phone"];
            if ([[result objectForKey:@"image_path"] length] > 2 ) {
                NSURL *url = [[NSURL alloc] initWithString:[result objectForKey:@"image_path"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.profileImage sd_setImageWithURL:url
                                         placeholderImage:[UIImage imageNamed:@"new_background_ullu.png"]];
                });
            }
        }
    }];
}

-(IBAction)bookingAction:(id)sender{
    self.bookingsTbl.hidden = NO;
    self.bookingSeparator.hidden = NO;
    self.walletView.hidden = YES;
    self.walletSeparator.hidden = YES;
}

-(IBAction)walletAction:(id)sender{
    self.bookingsTbl.hidden = YES;
    self.bookingSeparator.hidden = YES;
    self.walletView.hidden = NO;
    self.walletSeparator.hidden = NO;
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
                [[SharedPreferences sharedInstance] showCommonAlertWithMessage:@"Camera is not available" withObject:self];
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
                 [[SharedPreferences sharedInstance] showCommonAlertWithMessage:@"Gallery is not available" withObject:self];
            }
            break;
            
        default:
            break;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    UIImage *dImage = [self scaleImage:image toSize:CGSizeMake(40,40)];
    NSData *imageData = UIImageJPEGRepresentation(dImage, 0.7);
    NSString *base64String = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    [NetworkManager uploadUserProfilePicture:base64String withComplitionHandler:^(id result, NSError *err){
        [self refreshProfile];
    }];
    [self dismissViewControllerAnimated:YES completion:^{
        [addImageButton setTitle:@"Change Image" forState:UIControlStateNormal];
    }];
}


- (UIImage *) scaleImage:(UIImage*)image toSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.bookings.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BookingsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseBookingsTbleCell"];
    Booking *booking = [self.bookings objectAtIndex:indexPath.row];
    cell.eventName.text = booking.event.name;
    cell.eventVenue.text = booking.event.venue;
    cell.eventDesc.text = booking.event.eventDescription;
    cell.eventTerms.text = booking.event.terms;
    NSArray *arr = [booking.bookingDate componentsSeparatedByString:@" "];
    if (arr.count == 2) {
        cell.bookingDate.text = [arr objectAtIndex:0];
        cell.bookingTime.text = [arr objectAtIndex:1];
    }
    cell.bookingPrice.text = [NSString stringWithFormat:@"%d",booking.totalAmount];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectedIndex && (self.selectedIndex.row == indexPath.row)) {
        self.selectedIndex = nil;
    }else{
        self.selectedIndex = indexPath;
    }
    
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectedIndex && (self.selectedIndex.row == indexPath.row)) {
        return 275;
    }
    return 98;
}

- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (NSMutableArray*)bookings {
    if (!_bookings) {
        _bookings = [[NSMutableArray alloc] init];
    }
    return _bookings;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segueEditCon"]) {
        EditViewController *controller = (EditViewController*)[segue destinationViewController];
        controller.delegate = self;
        controller.dataDict = serverDictionary;
    }
}

- (void)updateProfile{
    [self refreshProfile];
}

@end
