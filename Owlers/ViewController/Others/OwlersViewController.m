//
//  OwlersViewController.m
//  Owlers
//
//  Created by Biprajit Biswas on 01/10/15.
//  Copyright (c) 2015 JNT. All rights reserved.
//

#import "OwlersViewController.h"
#import "Header.h"
#import "LoginViewController.h"
#import "Connectionmanager.h"
#import "SharedPreferences.h"
#import "APPChildViewController.h"
#import "SplashChildPageData.h"
#import "TesteventViewController.h"
#import "SliderFullViewController.h"
#import "Utility.h"
#import "Offer.h"
#import "OffersCollectionViewCell.h"
#import "NetworkManager.h"
#import "SharedPreferences.h"

@interface OwlersViewController ()

@property (strong,nonatomic) IBOutlet UIView *subview;
@property (strong,nonatomic) IBOutlet UIView *sliderImageContainer;
@property (strong, nonatomic) UIPageViewController *pageController;
@property (strong, nonatomic) NSMutableArray *pageDatalist;
@property (strong, nonatomic) NSTimer *timer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailLblHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewChildContainerHeightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (weak, nonatomic) IBOutlet UICollectionView *offersCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *offerDescLbl;
@property (weak, nonatomic) IBOutlet UILabel *offerTermsLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *offerAgreementContainerHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *offerDescLblHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *offerTermsLblHeightConstraint;
@property (strong, nonatomic) Offer *selectedOffer;

- (IBAction)offerDescMoreBtnAction:(UIButton *)sender;
- (IBAction)offerTermsMoreBtnAction:(UIButton *)sender;
- (IBAction)offerAgreeBtnAction:(id)sender;
- (IBAction)offerDisagreeBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *offerPopUpContainer;
- (IBAction)hideOfferPopUpContainer:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *offerPopUp;

@end

@implementation OwlersViewController

NSString *UserId, *discount_value = @"0";

int currentPageIndex = 0;

-(void)mapurl:(NSString*)address
{
    //NSLog(@"11  11111");
    Class mapItemClass = [MKMapItem class];
    if (mapItemClass && [mapItemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)])
    {
        // Create an MKMapItem to pass to the Maps app
        CLLocationCoordinate2D coordinate =
        CLLocationCoordinate2DMake(16.775, -3.009);
        
        MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate
                                                       addressDictionary:nil];
        
        MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
        [mapItem setName:@"My Place"];
        
        // Set the directions mode to "Walking"
        // Can use MKLaunchOptionsDirectionsModeDriving instead
        NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeWalking};
        // Get the "Current User Location" MKMapItem
        MKMapItem *currentLocationMapItem = [MKMapItem mapItemForCurrentLocation];
        // Pass the current location and destination map items to the Maps app
        // Set the direction mode in the launchOptions dictionary
        [MKMapItem openMapsWithItems:@[currentLocationMapItem, mapItem]
                       launchOptions:launchOptions];
       
     
    }
    //iOS 4/5:
    else
    {
       // NSLog(@"33   3333333");
        NSString *mapsURL = [NSString stringWithFormat:@"http://maps.google.com/maps?q=%@", [address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
       // NSLog(@"my url =%@",mapsURL);
    }
}
//-(void)offermethodcall{
//    if (array_offers.count>0) {
//        scroll_offer.backgroundColor = [UIColor yellowColor];
//        scroll_offer.frame = CGRectMake(10, scroll_offer.frame.origin.y, 320*6, 50);
//        scroll_offer.scrollEnabled = YES;
//        scroll_offer.pagingEnabled=NO;
//        scroll_offer.contentSize = CGSizeMake(420*3, 0);
//        
//        for (int i =0; i<=array_offers.count; i++) {
//            
//            
//            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(i*self.view.frame.size.width, 0, self.view.frame.size.width, 50)];
//            if (i%2==0) {
//                view.backgroundColor = [UIColor greenColor];
//            }else
//                view.backgroundColor = [UIColor blueColor];
//            
//            UIButton *btn_call = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, 30, 30)];
//            
//            [btn_call setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//            
//            UIView *viewInside = [[UIView alloc] initWithFrame:CGRectMake(i*self.view.frame.size.width, 0, self.view.frame.size.width, 50)];
//            UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 30, 30)];
//            
//            UILabel *label = [[ UILabel alloc] initWithFrame:CGRectMake(40, 15, self.view.frame.size.width-50, 20)];
//            
//           // NSDictionary *tempdic = [array_offers objectAtIndex:i];
//            
//           // label.text = [tempdic objectForKey:@"title"];
//            label.textColor = [UIColor blackColor];
//            label.font = [UIFont systemFontOfSize:15];
//            [viewInside addSubview:image];
//            [viewInside addSubview:label];
//            [view addSubview:btn_call];
//            [view addSubview:viewInside];
//            
//            [scroll_offer addSubview:view];
//            
//            
//        }
//        
//    }
//    
//    
//    
//}

-(void)timerCalled
{
    if(currentPageIndex < self.pageDatalist.count || currentPageIndex >= 0){
        if(currentPageIndex == self.pageDatalist.count-1){
            
            currentPageIndex = 0;
        }else{
            
            currentPageIndex++;
        }
        
        APPChildViewController *initialViewController = [self viewControllerAtIndex:currentPageIndex];
        NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
        [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"segueOwelrsPageContainer"]) {
        self.pageController = (UIPageViewController*)segue.destinationViewController;
        self.pageController.dataSource = self;
    }else if ([segue.identifier isEqualToString:@"segueSliderFullPage"]) {
        SliderFullViewController *controller = (SliderFullViewController*)segue.destinationViewController;
        controller.pageDatalist = self.pageDatalist;
    }else if ([segue.identifier isEqualToString:@"seguePayment"]) {
        TesteventViewController *controller = (TesteventViewController*)segue.destinationViewController;
        controller.event = self.event;
    }
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((APPChildViewController*) viewController).index;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    // Decrease the index by 1 to return
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((APPChildViewController*) viewController).index;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index >= self.pageDatalist.count) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return self.pageDatalist.count;
}

- (APPChildViewController *)viewControllerAtIndex:(NSUInteger)index {
    APPChildViewController *childViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"APPChildViewController"];
    childViewController.hideMessage = YES;
    childViewController.mode = UIViewContentModeScaleAspectFill;
    childViewController.index = index;
    if (index < [self.pageDatalist count]) {
        childViewController.data = (SplashChildPageData*)[self.pageDatalist objectAtIndex:index];
    }
    return childViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.event.offers removeAllObjects];
    self.activity.hidden =YES;
    self.offerPopUp.layer.borderWidth = 1.0f;
    self.offerPopUp.layer.borderColor = [UIColor colorWithRed:251.0f/255 green:156.0f/255 blue:21.0f/255 alpha:1].CGColor;
    
    [NetworkManager getEventDetails:self.event.ID withComplitionBlock:^(id result, NSError *err) {
        [self createUIForController:result];
    }];
   }

- (void)downloadEventImages {
    [self.pageDatalist removeAllObjects];
    if (self.event.sliderImages.count==0) {
        return;
    }
    
    for (int i=0; i < self.event.sliderImages.count; i++) {
        UIImageView *temp_btn = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width*i, 0, self.view.frame.size.width, scroll1.frame.size.height)];
        [temp_btn setBackgroundColor:[UIColor blackColor]];
        
        temp_btn.clipsToBounds = YES;
        NSString *temp_img = @"http://owlers.com/event_images/";
        temp_img = [temp_img stringByAppendingString:[self.event.sliderImages objectAtIndex:i ]];
        [self downloadImageWithURL:[NSURL URLWithString:temp_img] completionBlock:^(BOOL succeeded, UIImage *image) {
            if (succeeded) {
                temp_btn.image = image;
                SplashChildPageData *data = [SplashChildPageData dataWithImage:image displayText:@""];
                [self.pageDatalist addObject:data];
                dispatch_async(dispatch_get_main_queue(), ^{
                    APPChildViewController *initialViewController = [self viewControllerAtIndex:0];
                    [self.pageController setViewControllers:@[initialViewController]
                                                      direction:UIPageViewControllerNavigationDirectionForward
                                                       animated:NO completion:nil];
                });
            }}];
        [scroll1 addSubview:temp_btn];
    }
}



- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    //NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    //NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
   

    if (currentLocation != nil) {
        locationmanager = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        locationmanager = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
    }
    
    // Reverse Geocoding
    //NSLog(@"Resolving the Address");
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        //NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
            locationmanager = [NSString stringWithFormat:@"%@ %@\n%@ %@\n%@\n%@",
                                 placemark.subThoroughfare, placemark.thoroughfare,
                                 placemark.postalCode, placemark.locality,
                                 placemark.administrativeArea,
                                 placemark.country];
        } else {
            //NSLog(@"%@", error.debugDescription);
        }
    } ];

}
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    [self.mapview setRegion:[self.mapview regionThatFits:region] animated:YES];
       [self.mapview setRegion:[self.mapview regionThatFits:region] animated:YES];
    
    
    //[mapView setCenterCoordinate:mapView.userLocation.location.coordinate animated:YES];
    
    // Add an annotation
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = userLocation.coordinate;
    point.title = @"Where am I?";
    point.subtitle = @"I'm here!!!";
    [self.mapview addAnnotation:point];

}
- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views {
    MKCoordinateRegion region;
    region = MKCoordinateRegionMakeWithDistance(locationmanager.location.coordinate,1000,1000);
    
    CLLocationCoordinate2D centre = [mv centerCoordinate];
   
     if (firstLaunch) {
        region = MKCoordinateRegionMakeWithDistance(locationmanager.location.coordinate,1000,1000);
        firstLaunch=NO;
    }else {
        //Set the center point to the visible region of the map and change the radius to match the search radius passed to the Google query string.
        region = MKCoordinateRegionMakeWithDistance(centre,currenDist,currenDist);
    }
    //Set the visible region of the map.
    [mv setRegion:region animated:YES];

    [mv setRegion:region animated:YES];
    
}
-(void) queryGooglePlaces: (NSString *) googleType {
    // Build the url string to send to Google. NOTE: The kGOOGLE_API_KEY is a constant that should contain your own API key that you obtain from Google. See this link for more info:
    // https://developers.google.com/maps/documentation/places/#Authentication
    NSString *url = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?address=%22+", currentCentre.latitude, currentCentre.longitude, [NSString stringWithFormat:@"%i", currenDist], googleType];
    
    //Formulate the string as a URL object.
    NSURL *googleRequestURL=[NSURL URLWithString:url];
    
    // Retrieve the results of the URL.
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL: googleRequestURL];
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
}
-(void)fetchedData:(NSData *)responseData {
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          
                          options:kNilOptions
                          error:&error];
    
    //The results from Google will be an array obtained from the NSDictionary object with the key "results".
    NSArray* places = [json objectForKey:@"results"];
    
    //Write out the data to the console.
    //NSLog(@"Google Data: %@", places);
    [self plotPositions:places];

}
-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    //Get the east and west points on the map so you can calculate the distance (zoom level) of the current map view.
    MKMapRect mRect = self.mapview.visibleMapRect;
    MKMapPoint eastMapPoint = MKMapPointMake(MKMapRectGetMinX(mRect), MKMapRectGetMidY(mRect));
    MKMapPoint westMapPoint = MKMapPointMake(MKMapRectGetMaxX(mRect), MKMapRectGetMidY(mRect));
    self.annotation.coordinate = self.mapview.centerCoordinate;

    //Set your current distance instance variable.
    currenDist = MKMetersBetweenMapPoints(eastMapPoint, westMapPoint);
    
    //Set your current center point on the map instance variable.
    currentCentre = self.mapview.centerCoordinate;
}

-(void)plotPositions:(NSArray *)data {
    // 1 - Remove any existing custom annotations but not the user location blue dot.
    for (id<MKAnnotation> annotation in self.mapview.annotations) {
        if ([annotation isKindOfClass:[MapPoint class]]) {
            [self.mapview removeAnnotation:annotation];
        }
    }
    // 2 - Loop through the array of places returned from the Google API.
    for (int i=0; i<[data count]; i++) {
        //Retrieve the NSDictionary object in each index of the array.
        NSDictionary* place = [data objectAtIndex:i];
        // 3 - There is a specific NSDictionary object that gives us the location info.
        NSDictionary *geo = [place objectForKey:@"geometry"];
        // Get the lat and long for the location.
        NSDictionary *loc = [geo objectForKey:@"location"];
        // 4 - Get your name and address info for adding to a pin.
        NSString *name=[place objectForKey:@"name"];
        NSString *vicinity=[place objectForKey:@"vicinity"];
        // Create a special variable to hold this coordinate info.
        CLLocationCoordinate2D placeCoord;
        // Set the lat and long.
//        placeCoord.latitude=[[loc objectForKey:@"lat"] doubleValue];
//        placeCoord.longitude=[[loc objectForKey:@"lng"] doubleValue];
        
        placeCoord.latitude=[[loc objectForKey:@"lat"] doubleValue];
        placeCoord.longitude=[[loc objectForKey:@"lng"] doubleValue];
        // 5 - Create a new annotation.
        MapPoint *placeObject = [[MapPoint alloc] initWithName:name address:vicinity coordinate:placeCoord];
        [self.mapview addAnnotation:placeObject];
    }
}
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    // Define your reuse identifier.
    static NSString *identifier = @"MapPoint";
    
    if ([annotation isKindOfClass:[MapPoint class]]) {
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [self.mapview dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        } else {
            annotationView.annotation = annotation;
        }
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        annotationView.animatesDrop = YES;
        return annotationView;
    }
    return nil;
}

-(void)viewtrans2Hidden:(UITapGestureRecognizer*)tapgesture{
    view_trans2.hidden = YES;
    offer_view.hidden = YES;
}

-(void)viewTransparentHidden:(UITapGestureRecognizer*)tapgesture{
    view_transparent.hidden = YES;
}


- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock

{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ( !error )
                               {
                                   UIImage *image = [[UIImage alloc] initWithData:data];
                                   completionBlock(YES,image);
                               } else{
                                   completionBlock(NO,nil);
                               }
                           }];
}

- (void)createUIForController:(NSDictionary *)jsonData
{
    NSDictionary *eventDict = [[jsonData objectForKey:@"events"] objectAtIndex:0];
    self.event.malePrice = [[eventDict objectForKey:@"ev_price_male"] intValue];
    self.event.femalePrice = [[eventDict objectForKey:@"ev_price_female"] intValue];
    self.event.couplePrice = [[eventDict objectForKey:@"ev_price_couple"] intValue];
    self.event.name = [eventDict objectForKey:@"event_name"];
    self.event.address = [eventDict objectForKey:@"address"];
    self.event.startTime = [eventDict objectForKey:@"event_start"];
    self.event.eventDescription = [eventDict objectForKey:@"event_desc"];
    self.event.venue = [eventDict objectForKey:@"venue"];
    self.event.atmosphere = [eventDict objectForKey:@"atmosphere"];
    self.event.genreOfMusic = [eventDict objectForKey:@"genre_of_music"];
    self.event.sliderImages = [eventDict objectForKey:@"slider_images"];
    self.event.terms = [eventDict objectForKey:@"event_terms"];
    
    [self.event.offers removeAllObjects];
    NSArray *arr = [eventDict objectForKey:@"offers"];
    if (arr.count) {
        for (NSDictionary *dict in arr) {
            Offer *offer = [[Offer alloc] init];
            
            offer.offerDescription = [dict objectForKey:@"offer_description"];
            offer.ID = [dict objectForKey:@"offer_id"];
            offer.terms = [dict objectForKey:@"offer_terms"];
            offer.offerTitle = [dict objectForKey:@"title"];
            offer.value = [[dict objectForKey:@"value"] integerValue];
            
            [self.event.offers addObject:offer];
        }
    }else {
        Offer *offer = [[Offer alloc] init];
        
        offer.offerDescription = @"offer_description";
        offer.ID = @"offer_id";
        offer.terms = @"offer_terms";
        offer.offerTitle = @"No Offers Are Available";
        offer.value = 0;
        offer.isValid = NO;
        
        [self.event.offers addObject:offer];
    }
    
    [self.offersCollectionView reloadData];
    
    [self downloadEventImages];

    if([eventDict objectForKey:@"discounts"]) {
        NSArray *local_array = [eventDict objectForKey:@"discounts"];
        self.event.discountValue = [[[local_array objectAtIndex:0] objectForKey:@"value"] intValue];
        self.event.discountTitle = [[local_array objectAtIndex:0] objectForKey:@"title"];
    }
    
    NSString *status_check = [NSString stringWithFormat:@"%@",[eventDict objectForKey:@"entry_exists_for"]];
    if(status_check.length > 0){
        NSArray* foo = [status_check componentsSeparatedByString: @","];

        for (int i = 0; i < foo.count; i++) {
            
            if([[foo objectAtIndex:i] isEqualToString:@"M"]){
                self.event.entryExistsForMale = YES;
            }else if([[foo objectAtIndex:i] isEqualToString:@"F"]){
                self.event.entryExistsForFemale = YES;
            }else{
                self.event.entryExistsForCouple = YES;
            }
        }
    }
    
    self.gettimeDatelabel.text = self.event.startTime;
    self.getDetailLabel.text = self.event.eventDescription;
    self.getLocationLabel.text = self.event.address;
    self.atmospherelLabel.text = self.event.atmosphere;
    self.musicLabel.text = self.event.genreOfMusic;
    self.eventName.text = [self.event.name uppercaseString];
    self.eventVenue.text = self.event.venue;
    
    CLGeocoder *geocoders = [[CLGeocoder alloc] init];
    [geocoders geocodeAddressString:self.event.address completionHandler:^(NSArray* placemarks, NSError* error){
        
        
        for (CLPlacemark* aPlacemark in placemarks)
        {
            
            NSString *latDest1 = [NSString stringWithFormat:@"%.4f",aPlacemark.location.coordinate.latitude];
            
            NSString *lngDest1 = [NSString stringWithFormat:@"%.4f",aPlacemark.location.coordinate.longitude];
            //NSLog(@"latitude %@",latDest1);
            //NSLog(@"longitude %@",lngDest1);
            str_temp_lat=[latDest1 floatValue];
            str_temp_long=[lngDest1 floatValue];
        }
//        NSString *temp_address =@"http://maps.google.com/maps/api/geocode/json?address=%22+";

            MKPointAnnotation *annotation= [[MKPointAnnotation alloc]init];
        
            
        
            CLLocationCoordinate2D Coordinate = CLLocationCoordinate2DMake(str_temp_lat,str_temp_long);
            annotation.coordinate = Coordinate;
        
        
        self.mapview.centerCoordinate = annotation.coordinate; //focusing on marker
        
            [self.mapview addAnnotation:annotation];
            
            
            MKCoordinateSpan span;
            span.latitudeDelta=0.3;
            span.longitudeDelta=0.3;
            MKCoordinateRegion region;
            
        self.mapview.delegate = self;
        
                CLLocationCoordinate2D Coordinate1 = CLLocationCoordinate2DMake(str_temp_lat,str_temp_long);
                
                
                region.center = Coordinate1;
                             region.span=span;
                
        
    }];

    NSArray *frames = [[NSArray alloc]init];
    UIImageView *animatedIMvw = [[UIImageView alloc] init];
    animatedIMvw.animationImages = frames;
    [animatedIMvw startAnimating];
    
    
    ////  Here call Google Map
    //[self mapurl:_address];
  }


#pragma mark MapView Delegate

//- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
//{
//    // If it's the user location, just return nil.
//    if ([annotation isKindOfClass:[MKUserLocation class]])
//        return nil;
//    
//    // Handle any custom annotations.
//    if ([annotation isKindOfClass:[MKPointAnnotation class]])
//    {
//        // Try to dequeue an existing pin view first.
//        MKAnnotationView *pinView = (MKAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
//        if (!pinView)
//        {
//            
//            pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomPinAnnotationView"];
//            pinView.canShowCallout = YES;
//            pinView.image = [UIImage imageNamed:@"location_cle.png"];
//            
//            pinView.calloutOffset = CGPointMake(0, 32);
//            
//            // Add a detail disclosure button to the callout.
//            UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//                      // Add an image to the left callout.
//              
//            UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"location_cle.png"]];
//            
//          
//            
//            
//            
//            
//            pinView.leftCalloutAccessoryView = iconView;
//        } else {
//            pinView.annotation = annotation;
//        }
//        return pinView;
//    }
//    
//    return nil;
//}
//

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    showLocation = [locations objectAtIndex:0];
    [locationmanager stopUpdatingLocation];

      //NSLog(@"Detected Location : %f, %f", showLocation.coordinate.latitude, showLocation.coordinate.longitude);
    CLGeocoder *geocoders = [[CLGeocoder alloc] init] ;
    [geocoders reverseGeocodeLocation:showLocation
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       if (error){
                           //NSLog(@"Geocode failed with error: %@", error);
                           return;
                       }
                       CLPlacemark *placemark = [placemarks objectAtIndex:0];
                       NSLog(@"placemark.ISOcountryCode %@",placemark.ISOcountryCode);
                       
                   }];
}


- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)rsvpbtnAction:(id)sender {
    if ([[SharedPreferences sharedInstance] isLogin]) {
        [self performSegueWithIdentifier:@"seguePayment" sender:nil];
    }else {
        [Utility showAlertWithTitle:@"JNT" message:@"Unable to book event without login" okAction:YES okTitle:@"Login" okBlock:^{[self performSegueWithIdentifier:@"segueRSVPLogin" sender:nil];} cancelAction:YES cancelBlock:nil presenter:[[[[UIApplication sharedApplication] delegate] window] rootViewController]];
    }
}

- (IBAction)moreBtnAction:(id)sender {
    if ([self.moreBtn.titleLabel.text isEqualToString:@"MORE"]) {
        float height = [Utility heightOfString:_getDetailLabel.text forWidth:_getDetailLabel.bounds.size.width font:_getDetailLabel.font];
        self.detailLblHeightConstraint.constant = height;
        [self.moreBtn setTitle:@"LESS" forState:UIControlStateNormal];
        self.scrollViewChildContainerHeightConstraint.constant = 650 - 35 + height;
    }else {
        self.detailLblHeightConstraint.constant = 35;
        [self.moreBtn setTitle:@"MORE" forState:UIControlStateNormal];
        self.scrollViewChildContainerHeightConstraint.constant = 650;
    }
    
    [self.view layoutIfNeeded];
    
}

- (IBAction)callBtnAction:(id)sender {
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://"]] ){
    
        NSString *phoneNumber = @"+917381476718"; // dynamically assigned
        NSString *phoneURLString = [NSString stringWithFormat:@"tel:%@", phoneNumber];
        NSURL *phoneURL = [NSURL URLWithString:phoneURLString];
        if (phoneURL) {
            [[UIApplication sharedApplication] openURL:phoneURL];
        }else{
            [[SharedPreferences sharedInstance] showCommonAlertWithMessage:@"Your device doesn't support this feature." withObject:self];
        }
        
    } else {
        [[SharedPreferences sharedInstance] showCommonAlertWithMessage:@"Your device doesn't support this feature." withObject:self];
    }
}

- (IBAction)googleMapBtnAction:(id)sender {
    
    
    CLLocationCoordinate2D start = { 28.6139, 77.2090 };
    CLLocationCoordinate2D destination = { 27.1750, 78.0419 };

    NSString *googleMapsURLString = [NSString stringWithFormat:@"http://maps.google.com/?saddr=%1.6f,%1.6f&daddr=%1.6f,%1.6f",
                                     start.latitude, start.longitude, destination.latitude, destination.longitude];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:googleMapsURLString]];
    [self mapurl:self.event.address];
    
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    MKOverlayView* overlayView = nil;
    
    return overlayView; 
}

-(IBAction)offer_button:(id)sender
{
    if (offer_view.hidden) {
        view_trans2.hidden=NO;
        offer_view.hidden=NO;
    }
    else
        offer_view.hidden =YES;
    view_trans2.hidden=NO;
}

- (void)sliderImageTapped:(UITapGestureRecognizer*)gesture {
    if (self.pageDatalist.count) {
        [self performSegueWithIdentifier:@"segueSliderFullPage" sender:nil];
    }
}

- (NSMutableArray*)pageDatalist {
    if (!_pageDatalist) {
        _pageDatalist = [[NSMutableArray alloc] init];
    }
    return _pageDatalist;
}

- (void)viewDidAppear:(BOOL)animated {
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:8 target:self selector:@selector(timerCalled) userInfo:nil repeats:YES];
    
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sliderImageTapped:)];
    self.tapGesture.numberOfTapsRequired = 1;
    [self.sliderImageContainer addGestureRecognizer:self.tapGesture];
}

- (void)viewWillDisappear:(BOOL)animated {
    [_timer invalidate];
    _timer = nil;
    [_sliderImageContainer removeGestureRecognizer:_tapGesture];
    _tapGesture = nil;
}



#pragma marks UICollection View Delegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.event.offers.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    OffersCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"reuseOffersCollectionCell" forIndexPath:indexPath];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout*)collectionView.collectionViewLayout;
    layout.itemSize = CGSizeMake(collectionView.bounds.size.width, collectionView.bounds.size.height);
    
    Offer *offer = [self.event.offers objectAtIndex:indexPath.row];
    cell.offerLbl.text = offer.offerTitle;
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    _selectedOffer = [self.event.offers objectAtIndex:indexPath.row];
    if (_selectedOffer.isValid) {
        self.offerDescLbl.text = _selectedOffer.offerDescription;
        self.offerTermsLbl.text = _selectedOffer.terms;
        self.offerPopUpContainer.hidden = NO;
        [self.view bringSubviewToFront:self.offerPopUpContainer];
    }
}

- (IBAction)offerDescMoreBtnAction:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"MORE"]) {
        float height = [Utility heightOfString:self.offerDescLbl.text forWidth:self.offerDescLbl.bounds.size.width font:self.offerDescLbl.font];
        self.offerDescLblHeightConstraint.constant = height;
        [sender setTitle:@"LESS" forState:UIControlStateNormal];
        self.offerAgreementContainerHeightConstraint.constant = 310 - 34 + height;
    }else {
        self.detailLblHeightConstraint.constant = 34;
        [sender setTitle:@"MORE" forState:UIControlStateNormal];
        self.offerAgreementContainerHeightConstraint.constant = 310;
    }
    
    [self.view layoutIfNeeded];
}

- (IBAction)offerTermsMoreBtnAction:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"MORE"]) {
        float height = [Utility heightOfString:self.offerTermsLbl.text forWidth:self.offerTermsLbl.bounds.size.width font:self.offerTermsLbl.font];
        self.offerTermsLblHeightConstraint.constant = height;
        [sender setTitle:@"LESS" forState:UIControlStateNormal];
        self.offerAgreementContainerHeightConstraint.constant = 310 - 34 + height;
    }else {
        self.offerTermsLblHeightConstraint.constant = 34;
        [sender setTitle:@"MORE" forState:UIControlStateNormal];
        self.offerAgreementContainerHeightConstraint.constant = 310;
    }
    
    [self.view layoutIfNeeded];
}

- (IBAction)offerAgreeBtnAction:(id)sender {
    
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    [paramDict setObject:[[SharedPreferences sharedInstance] getUserID] forKey:@"user_id"];
    [paramDict setObject:self.event.ID forKey:@"event_id"];
    [paramDict setObject:_selectedOffer.ID forKey:@"offer_id"];
    [paramDict setObject:_selectedOffer.offerTitle forKey:@"offer_title"];
    [paramDict setObject:[NSString stringWithFormat:@"%ld",(long)_selectedOffer.value] forKey:@"offer_value"];
    [paramDict setObject:[NSString stringWithFormat:@"%ld",(long)_selectedOffer.value] forKey:@"total_amount"];
    [paramDict setObject:@"Cash" forKey:@"payment_method"];
    [paramDict setObject:[NSString stringWithFormat:@"%ld",(long)_selectedOffer.value] forKey:@"sub_total"];
    [paramDict setObject:@"4545.7765.767" forKey:@"mac_addr"];
    
    [NetworkManager bookOffer:paramDict withComplitionBlock:^(id result, NSError *err) {
        NSLog(@"%@",result);
        NSString *message = nil;
        if (result && [[result objectForKey:@"status"] isEqualToString:@"Success"]) {
            message = [NSString stringWithFormat:@"%@.\nYour offer booking number is %@",[result objectForKey:@"message"],[result objectForKey:@"booking_number"]];
            [[SharedPreferences sharedInstance] showCommonAlertWithMessage:message withObject:self];
            [self hideOfferPopUpContainer:nil];
        }else{
            message = [NSString stringWithFormat:@"%@.",[result objectForKey:@"message"]];
        }
        [[SharedPreferences sharedInstance] showCommonAlertWithMessage:message withObject:self];

    }];

}

- (IBAction)offerDisagreeBtnAction:(id)sender {
    [self hideOfferPopUpContainer:nil];
}
- (IBAction)hideOfferPopUpContainer:(id)sender {
    self.offerPopUpContainer.hidden = YES;
}
@end
