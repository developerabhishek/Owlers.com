//
//  ProductViewController.m
//  Owlers
//
//  Created by Biprajit Biswas on 25/09/15.
//  Copyright (c) 2015 JNT. All rights reserved.
//

#import "ProductViewController.h"
#import "OwlersViewController.h"
#import "Header.h"
#import "UIImageView+WebCache.h"
#import "DSLCalendarView.h"
#import "SharedPreferences.h"
#import "NetworkManager.h"
#import "LocationCollectionViewCell.h"
#import "Location.h"
#import "ProductTableViewCell.h"
#import "Event.h"
#import "SegueMenuItem.h"

#import "SharedPreferences.h"
#import "NetworkManager.h"
#import "PopOverBackgroundView.h"

#define MENU_ITEM_HEIGHT 45
#define MENU_ITEM_WIDTH 150
#define MENU_MAX_HEIGHT  self.view.frame.size.height * 2/3

@interface ProductViewController ()  <DSLCalendarViewDelegate>{
    
    NSURLConnection *connection_json;
}
@property (nonatomic, weak) IBOutlet UIView *calendarContainerView;
@property (nonatomic, weak) IBOutlet UITableView *productsTbl;
@property (nonatomic, weak) IBOutlet UIView *searchBarContainer;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *secondaryViewHeightConstraint;
@property (nonatomic, weak) IBOutlet UICollectionView *locationCollectionView;
@property (nonatomic, weak) IBOutlet UIButton *auctionBtn;
@property (nonatomic, weak) IBOutlet UIButton *locationBtn;
@property (nonatomic, weak) IBOutlet UIButton *menuBtn;
@property (nonatomic, weak) IBOutlet UITextField *searchTxtField;
@property (nonatomic, weak) IBOutlet UIButton *calenderButton;
@property (nonatomic, strong) DSLCalendarView *calendarView;
@property (nonatomic, strong) Event *selectedEvent;
@property (nonatomic, strong) NSDate * selectedDate;
@property (nonatomic, strong) NSMutableArray *locationItems;
@property (nonatomic, strong) NSMutableArray *eventItems;
@property (nonatomic, strong) NSMutableArray *menuItems;

@end

@implementation ProductViewController

UIRefreshControl *refreshControl;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self refreshMenuList];
    
    /**********[OWLERS LOADER WORK START]***********/
    self.loaderOwlersImage.hidden = NO;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.toValue = [NSNumber numberWithDouble:M_PI_2];
    animation.duration = 0.4f;
    animation.cumulative = YES;
    animation.repeatCount = HUGE_VALF;
    [self.loaderOwlersImage.layer addAnimation:animation forKey:@"activityIndicatorAnimation"];
    /**********[OWLERS LOADER WORK END]***********/
    
    [NetworkManager loadLocationWithComplitionHandler:^(id result, NSError *err) {
        
        NSArray *temparr = [result objectForKey:@"Locations"];
        
        for (NSDictionary *dic in temparr) {
            
            NSString *location = [dic objectForKey:@"location_name"];
            NSString *locationid = [dic objectForKey:@"location_id"];
            if (location && locationid) {
                [self.locationItems addObject:[Location cityWithLocation:location locationID:locationid]];
            }
        }
        if ([self.locationItems count]) {
            [self fetchEventsForLocation:[self.locationItems firstObject]];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.locationCollectionView reloadData];
        });
    }];
    [self setDateButtonTitleForDate:[NSDate date] withServiceCall:false];
    
    /*********[Table Refresh Control]************/
    
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.backgroundColor = [UIColor blackColor] ;
    refreshControl.tintColor = [UIColor whiteColor];
    
    [refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    
    [self.productsTbl addSubview:refreshControl];
    
    /*****[CALENDER VIEW]*****/
    
    self.secondaryViewHeightConstraint.constant = 0;
    [self.view layoutIfNeeded];
}

- (void)setDateButtonTitleForDate:(NSDate *)date withServiceCall:(BOOL)shouldServiceCall {

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MMMM-yyyy"];
    NSString *dateStr  = [dateFormatter stringFromDate:date];
    [self.calenderButton setTitle:dateStr forState:UIControlStateNormal];

    if (shouldServiceCall) {
        [NetworkManager fetchEventListForSelectedDate:dateStr withComplitionHandler:^(id result, NSError *err) {
            [self reloadTableData:result];
        }];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [self refreshMenuList];
}

- (void)refreshMenuList{
    [self.menuItems removeAllObjects];
    
    if ([[SharedPreferences sharedInstance] isLogin]) {
        SegueMenuItem *item1 = [SegueMenuItem itemWithSegueIdentifier:@"segueProfile"];
        item1.displayName = @"Profile";
        [self.menuItems addObject:item1];
        SegueMenuItem *item2 = [SegueMenuItem itemWithSegueIdentifier:@"segueSetings"];
        item2.displayName = @"Setings";
        [self.menuItems addObject:item2];
        SegueMenuItem *item3 = [SegueMenuItem itemWithSegueIdentifier:@"segueAuction"];
        item3.displayName = @"Deal Area";
        [self.menuItems addObject:item3];
        SegueMenuItem *item4 = [SegueMenuItem itemWithSegueIdentifier:@"segueMyBids"];
        item4.displayName = @"My Deals";
        [self.menuItems addObject:item4];
        SegueMenuItem *item5 = [SegueMenuItem itemWithSegueIdentifier:@"segueLogout"];
        item5.displayName = @"Logout";
        [self.menuItems addObject:item5];
    }else{
        SegueMenuItem *item1 = [SegueMenuItem itemWithSegueIdentifier:@"segueLogin"];
        item1.displayName = @"Login";
        [self.menuItems addObject:item1];
        SegueMenuItem *item2 = [SegueMenuItem itemWithSegueIdentifier:@"segueSignup"];
        item2.displayName = @"Signup";
        [self.menuItems addObject:item2];
    }
}


#pragma mark - CalendarDelegate protocol conformance

-(void)dayChangedToDate:(NSDate *)selectedDate
{
    NSLog(@"dayChangedToDate %@(GMT)",selectedDate);
}

- (void)handleRefresh:(id)sender
{
    [NetworkManager fetchEventListForLocation:@"1" withComplitionHandler:^(id result, NSError *err) {
        [refreshControl endRefreshing];
    }];
}

-(void)viewDidLayoutSubviews {
    
    self.auctionBtn.layer.cornerRadius = self.auctionBtn.frame.size.width/2;
    self.auctionBtn.layer.borderColor = [UIColor colorWithRed:251.0f/255 green:156.0f/255 blue:0.0f/255 alpha:1].CGColor;
    self.auctionBtn.layer.borderWidth = 2.0f;
}

#pragma marks UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.eventItems.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedEvent = (Event*)[self.eventItems objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"segueOwlers" sender:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseProductCell"];
    Event *event = [self.eventItems objectAtIndex:indexPath.row];
    cell.eventLbl.text = event.name;
    cell.venueLbl.text = event.venue;
    cell.locationLbl.text = event.locationCode;
    NSString *temp_img = @"http://owlers.com/event_images/";
    [cell.productImgView sd_setImageWithURL:[NSURL URLWithString:[temp_img stringByAppendingString:event.imageURL]]
                                     placeholderImage:[UIImage imageNamed:@"new_background_ullu.png"]];
    return cell;
}


#pragma marks UICollection View Delegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.locationItems.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    LocationCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"reuseCityCollectionCell" forIndexPath:indexPath];
    Location *location = [self.locationItems objectAtIndex:indexPath.row];
    cell.location.text = location.name;
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    Location *location = (Location*)[self.locationItems objectAtIndex:indexPath.row];
    [self.locationBtn setTitle:location.name forState:UIControlStateNormal];
    [self fetchEventsForLocation:location];
}

-(void)fetchEventsForLocation:(Location*)location{
    
    [NetworkManager fetchEventListForLocation:location.ID withComplitionHandler:^(id result, NSError *err) {
        [self reloadTableData:result];
    }];
}

- (void)reloadTableData:(NSDictionary *)data{
    [self.eventItems removeAllObjects];
    NSArray *items = [data objectForKey:@"items"];
    for (NSDictionary *dict in items) {
        Event *event = [[Event alloc] init];
        event.address = [dict objectForKey:@"address"];
        event.createdDate = [dict objectForKey:@"created_date"];
        event.eventDescription = [dict objectForKey:@"event_desc"];
        event.endTime = [dict objectForKey:@"event_end"];
        event.ID = [dict objectForKey:@"event_id"];
        event.imageURL = [dict objectForKey:@"event_image"];
        event.location = [dict objectForKey:@"event_location"];
        event.name = [dict objectForKey:@"event_name"];
        event.startTime = [dict objectForKey:@"event_start"];
        event.locationCode = [dict objectForKey:@"location_code"];
        event.title = [dict objectForKey:@"title"];
        event.venue = [dict objectForKey:@"venue"];
        [self.eventItems addObject:event];
    }
    [self.productsTbl reloadData];
}


#pragma mark UITextField delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}

#pragma calendar coding

- (void)calendarView:(DSLCalendarView*)calendarView didSelectRange:(DSLCalendarRange*)range
{
    if (range != nil) {
        [self setDateButtonTitleForDate:range.startDay.date withServiceCall:true];
        self.calendarContainerView.hidden = YES;
        self.secondaryViewHeightConstraint.constant = 0;
        [self.view layoutIfNeeded];
    }
    else {
        NSLog( @"No selection" );
    }
    
}

- (DSLCalendarRange*)calendarView:(DSLCalendarView *)calendarView didDragToDay:(NSDateComponents *)day selectingRange:(DSLCalendarRange *)range {
    if (NO) { // Only select a single day
        return [[DSLCalendarRange alloc] initWithStartDay:day endDay:day];
    }
    else if (/* DISABLES CODE */ (NO)) { // Don't allow selections before today
        NSDateComponents *today = [[NSDate date] dslCalendarView_dayWithCalendar:calendarView.visibleMonth.calendar];
        
        NSDateComponents *startDate = range.startDay;
        NSDateComponents *endDate = range.endDay;
        
        if ([self day:startDate isBeforeDay:today] && [self day:endDate isBeforeDay:today]) {
            return nil;
        }
        else {
            if ([self day:startDate isBeforeDay:today]) {
                startDate = [today copy];
            }
            if ([self day:endDate isBeforeDay:today]) {
                endDate = [today copy];
            }
            
            return [[DSLCalendarRange alloc] initWithStartDay:startDate endDay:endDate];
        }
    }
    
    return range;
}
- (void)calendarView:(DSLCalendarView *)calendarView willChangeToVisibleMonth:(NSDateComponents *)month duration:(NSTimeInterval)duration {
    NSLog(@"Will show %@ in %.3f seconds", month, duration);
}

- (void)calendarView:(DSLCalendarView *)calendarView didChangeToVisibleMonth:(NSDateComponents *)month {
    NSLog(@"Now showing %@", month);
}

- (BOOL)day:(NSDateComponents*)day1 isBeforeDay:(NSDateComponents*)day2 {
    return ([day1.date compare:day2.date] == NSOrderedAscending);
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
//    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"name contains[c] %@", searchText];
//    searchResults = [recipes filteredArrayUsingPredicate:resultPredicate];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"segueMenuPopUp"]) {
        MenuPopUpViewController *menuPopUp = [segue destinationViewController];
        menuPopUp.menuItems = self.menuItems;
        menuPopUp.delegate = self;
        
        menuPopUp.preferredContentSize = [self sizeForMenuPopUp];
        menuPopUp.presentationController.delegate = self;
        menuPopUp.popoverPresentationController.sourceRect = CGRectMake(0, self.menuBtn.frame.size.height, 0, 0);
        menuPopUp.popoverPresentationController.popoverBackgroundViewClass = [PopOverBackgroundView class];
    }else if ([segue.identifier isEqualToString:@"segueOwlers"]) {
        OwlersViewController *owlers = [segue destinationViewController];
        owlers.event = self.selectedEvent;
    }
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
   return UIModalPresentationNone;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}


#pragma -mark public Properties/Methods
- (IBAction)selectLocationAction:(UIButton*)sender {
    
    self.calendarContainerView.hidden = YES;
    self.locationCollectionView.hidden = !self.locationCollectionView.hidden;
    if (self.calendarContainerView.hidden && self.locationCollectionView.hidden) {
        self.secondaryViewHeightConstraint.constant = 0;
        [self.view layoutIfNeeded];
    }else{
        self.secondaryViewHeightConstraint.constant = 32;
        [self.view layoutIfNeeded];
    }
}

- (IBAction)displayCalendarAction:(UIButton*)sender {
    self.locationCollectionView.hidden = YES;
    self.calendarContainerView.hidden = !self.calendarContainerView.hidden;
    if (self.calendarContainerView.hidden && self.locationCollectionView.hidden) {
        self.secondaryViewHeightConstraint.constant = 0;
        [self.view layoutIfNeeded];
    }else{
    self.secondaryViewHeightConstraint.constant = self.view.bounds.size.height/2;
    [self.view layoutIfNeeded];
    }
    
    
    if (!self.calendarView) {
        CGRect rect  = self.calendarContainerView.bounds;
        rect.size.height = self.view.bounds.size.height/2;
        self.calendarView = [[DSLCalendarView alloc] initWithFrame:rect];
        [self.calendarContainerView addSubview:self.calendarView];
        [self.calendarView setDelegate:self];
        NSLog(@"\n\n### calendar added ###\n\n");
    }
}

- (IBAction)displaySearchBarAction:(UIButton*)sender {

    if (!self.searchBarContainer.hidden) {
        
        if(self.searchTxtField.text.length != 0){

            [NetworkManager searchEventForString:self.searchTxtField.text.self withComplitionHandler:^(id result, NSError *err) {
                [self reloadTableData:result];
            }];
        }else{
            
            [[SharedPreferences sharedInstance] showCommonAlertWithMessage:@"Search cannot be empty" withObject:self];
        }
    }
    
    self.searchBarContainer.hidden = NO;
}

- (IBAction)displayAuctionScreenAction:(UIButton*)sender {
    
    if ([[SharedPreferences sharedInstance] isLogin]) {
        [self performSegueWithIdentifier:@"segueAuction" sender:nil];
    }else{
        [[SharedPreferences sharedInstance] showCommonAlertWithMessage:@"Unable to auction without login" withObject:self];
    }
}

- (IBAction)seachBackAction:(id)sender{    
    self.searchBarContainer.hidden = YES;
    [self.searchTxtField resignFirstResponder];
}


#pragma -mark MenuDelegate methods
- (void)menuItemClicked:(MenuItem *)item {
    [self dismissViewControllerAnimated:NO completion:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        SegueMenuItem *segueItem = (SegueMenuItem*)item;
        if ([segueItem.identifier isEqualToString:@"segueLogout"]) {
            [[SharedPreferences sharedInstance] logoutUser];
            [self refreshMenuList];
        }else {
            [self performSegueWithIdentifier:segueItem.identifier sender:nil];
        }
    });
}

#pragma -mark private Properties/Methods
- (NSMutableArray*)locationItems {
    if (!_locationItems) {
        _locationItems = [[NSMutableArray alloc] init];
    }
    return _locationItems;
}

- (NSMutableArray*)eventItems {
    if (!_eventItems) {
        _eventItems = [[NSMutableArray alloc] init];
    }
    return _eventItems;
}

- (NSMutableArray*)menuItems {
    if (!_menuItems) {
        _menuItems = [[NSMutableArray alloc] init];
    }
    return _menuItems;
}

- (CGSize)sizeForMenuPopUp {
    
    CGSize size = CGSizeMake(MENU_ITEM_WIDTH, MENU_MAX_HEIGHT);
    float height = self.menuItems.count * MENU_ITEM_HEIGHT;
    if (height < MENU_MAX_HEIGHT) {
        size.height = height;
    }
    
    return size;
}

@end
