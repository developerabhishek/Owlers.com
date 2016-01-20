//
//  AuctionViewController.m
//  Owlers
//
//  Created by Biprajit Biswas on 26/10/15.
//  Copyright (c) 2015 JNT. All rights reserved.
//

#import "AuctionViewController.h"
#import "BidSectionViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "SVProgressHUD.h"
#import "Header.h"
#import "SharedPreferences.h"
#import "NetworkManager.h"
#import "Location.h"
#import "LocationMenuItem.h"
#import "PopOverBackgroundView.h"
#import "AuctionTableViewCell.h"
#import "Auction.h"

#define MENU_ITEM_HEIGHT 45
#define MENU_ITEM_WIDTH 150
#define MENU_MAX_HEIGHT  self.view.frame.size.height * 2/3

@interface AuctionViewController ()

@property (weak, nonatomic) IBOutlet UITableView *auctionTbl;
@property (weak, nonatomic) IBOutlet UIButton *locationBtn;
@property (nonatomic, strong) Auction *auction;
@property (nonatomic, strong) NSMutableArray *locationItems;
@property (nonatomic, strong) NSMutableArray *auctionItems;
@property (strong, nonatomic) NSTimer *timer;

@end

@implementation AuctionViewController


NSURLConnection *conne_ction ,*connection_;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"segueBidSection"]) {
        BidSectionViewController *controller = (BidSectionViewController*)segue.destinationViewController;
        controller.auction = self.auction;
    }else if ([segue.identifier isEqualToString:@"seguePopupLocations"]) {
        MenuPopUpViewController *menuPopUp = (MenuPopUpViewController*)segue.destinationViewController;
        menuPopUp.menuSeparatorColor = [UIColor colorWithRed:251.0f/255 green:156.0f/255 blue:21.0f/255 alpha:1];
        menuPopUp.menuItems = [LocationMenuItem menuItemsWithLocations:self.locationItems];
        menuPopUp.delegate = self;
        
        menuPopUp.preferredContentSize = [self sizeForMenuPopUp];
        menuPopUp.presentationController.delegate = self;
        menuPopUp.popoverPresentationController.sourceRect = CGRectMake(self.locationBtn.frame.size.width/2, self.locationBtn.frame.size.height, 0, 0);
        menuPopUp.popoverPresentationController.popoverBackgroundViewClass = [PopOverBackgroundView class];
    }
}

- (void)loadData{
    
    [NetworkManager loadLocationWithComplitionHandler:^(id result, NSError *err) {
        serDICT = result;
        NSArray *locArr = [serDICT objectForKey:(@"Locations")];
        for (NSDictionary *locDict in locArr) {
            Location *loc = [[Location alloc] init];
            loc.ID = [locDict objectForKey:@"location_id"];
            loc.name = [locDict objectForKey:@"location_name"];
            [self.locationItems addObject:loc];
        }
        if (self.locationItems.count > 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
            [self loadAuctionsForLocation:[self.locationItems objectAtIndex:0]];
            });
        }
    }];
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [self.auctionItems count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Auction *auction = [self.auctionItems objectAtIndex:indexPath.row];
    AuctionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseActionTblCell"];
    cell.auctionName.text = [auction.name uppercaseString];
//    cell.timeLeft.text = auction.timeElapsed;
    cell.venue.text = auction.venue;
    cell.totalBids.text = auction.totalBids;
    [cell updateViewWithData:auction];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.auction = [self.auctionItems objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"segueBidSection" sender:nil];
}

- (void)loadAuctionsForLocation:(Location *)location{
    [self disableTimer];
    [self.auctionItems removeAllObjects];
    [NetworkManager loadAcutionsForCity:location.ID withComplitionHandler:^(id result, NSError *err) {
        serverDict = result;
        NSArray *items = [serverDict objectForKey:@"items"];
        for (NSDictionary *dict in items) {
            Auction *auction = [[Auction alloc] init];
            auction.ID = [dict objectForKey:@"auction_id"];
            auction.name = [dict objectForKey:@"auction_name"];
            auction.timeElapsed = [dict objectForKey:@"time_elapsed"];
            auction.venue = [dict objectForKey:@"venue"];
            auction.totalBids = [dict objectForKey:@"total_bids"];
            auction.auctionDescription = [dict objectForKey:@"auction_desc"];
            auction.buyPrice = [dict objectForKey:@"buy_now_price"];
            auction.openingPrice = [dict objectForKey:@"opening_price"];
            auction.imgURL = [dict objectForKey:@"auction_image"];
            
            NSArray *arr = [auction.timeElapsed componentsSeparatedByString:@":"];
            if (arr.count > 0) {
                auction.daysLeft = [[arr objectAtIndex:0] integerValue];
            }
            if (arr.count > 1) {
                auction.hoursLeft = [[arr objectAtIndex:1] integerValue];
            }
            if (arr.count > 2) {
                auction.minutesLeft = [[arr objectAtIndex:2] integerValue];
            }
            if (arr.count > 3) {
                auction.secondsLeft = [[arr objectAtIndex:3] integerValue];
            }
            
            [self.auctionItems addObject:auction];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.auctionTbl reloadData];
            [self enableTimer];
        });
        
    }];
}

- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSMutableArray*)locationItems {
    if (!_locationItems) {
        _locationItems = [[NSMutableArray alloc] init];
    }
    return _locationItems;
}

- (NSMutableArray*)auctionItems {
    if (!_auctionItems) {
        _auctionItems = [[NSMutableArray alloc] init];
    }
    return _auctionItems;
}

- (CGSize)sizeForMenuPopUp {
    
    CGSize size = CGSizeMake(self.locationBtn.frame.size.width, MENU_MAX_HEIGHT);
    float height = self.locationItems.count * MENU_ITEM_HEIGHT;
    if (height < MENU_MAX_HEIGHT) {
        size.height = height;
    }
    return size;
}


#pragma -mark MenuDelegate methods
- (void)menuItemClicked:(MenuItem *)item {
    [self dismissViewControllerAnimated:NO completion:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        Location *location = [(LocationMenuItem*)item location];
        [self.locationBtn setTitle:location.name forState:UIControlStateNormal];
        [self loadAuctionsForLocation:location];
    });
}


- (void)updateData {

    for (Auction *auction in self.auctionItems) {
        
        long totalSecondsLeft = auction.daysLeft*24*60*60 + auction.hoursLeft*60*60 + auction.minutesLeft*60 + auction.secondsLeft - 1;
        if (totalSecondsLeft > 0) {
            auction.daysLeft = totalSecondsLeft/(24*60*60);
            totalSecondsLeft = totalSecondsLeft % (24*60*60);
            auction.hoursLeft = totalSecondsLeft/(60*60);
            totalSecondsLeft = totalSecondsLeft % (60*60);
            auction.minutesLeft = totalSecondsLeft/60;
            auction.secondsLeft = totalSecondsLeft % 60;
        }
    }
}

- (void)update{

    [self updateData];
    NSArray *visibleCells = [self.auctionTbl visibleCells];
    self.view.userInteractionEnabled = NO;
    for (AuctionTableViewCell *cell in visibleCells) {
        [cell updateViewWithData:[self.auctionItems objectAtIndex:[[self.auctionTbl indexPathForCell:cell] row]]];
    }
    self.view.userInteractionEnabled = YES;
}

- (void)enableTimer{
    [self disableTimer];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(update) userInfo:nil repeats:YES];
}
- (void)disableTimer{
    [_timer invalidate];
    _timer = nil;
}

- (void)viewWillDisappear:(BOOL)animated {
    [self disableTimer];
    [super viewDidDisappear:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [self enableTimer];
}

@end
