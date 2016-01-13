//
//  OwlersViewController.m
//  Owlers
//
//  Created by Biprajit Biswas on 01/10/15.
//  Copyright (c) 2015 JNT. All rights reserved.
//

#import "OwlersViewController.h"
#import "ProductViewController.h"
#import "Header.h"
#import "LoginViewController.h"
#import "Connectionmanager.h"
#import "SharedPreferences.h"
#import "APPChildViewController.h"
#import "SplashChildPageData.h"

@interface OwlersViewController ()
-(id) imageWithName:(NSArray *)arr;
@property (strong,nonatomic) IBOutlet UIView *subview;

@property (strong, nonatomic) UIPageViewController *pageController;
@property (strong, nonatomic) NSMutableArray *pageDatalist;
@property (strong, nonatomic) NSTimer *timer;

@end

@implementation OwlersViewController


NSString *UserId, *_address, *discount_value = @"0";


bool male_status = YES,female_status = YES,couple_status = YES;

int currentPageIndex = 0;
@synthesize mapview;




-(void)mapurl:(NSString*)address
{
    NSLog(@"11  11111");
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
        NSLog(@"33   3333333");
        NSString *mapsURL = [NSString stringWithFormat:@"http://maps.google.com/maps?q=%@", [address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSLog(@"my url =%@",mapsURL);
}
}
-(void)offermethodcall{
    if (array_offers.count>0) {
        scroll_offer.backgroundColor = [UIColor yellowColor];
        scroll_offer.frame = CGRectMake(10, scroll_offer.frame.origin.y, 320*6, 50);
        scroll_offer.scrollEnabled = YES;
        scroll_offer.pagingEnabled=NO;
        scroll_offer.contentSize = CGSizeMake(420*3, 0);
        
        for (int i =0; i<=array_offers.count; i++) {
            
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(i*self.view.frame.size.width, 0, self.view.frame.size.width, 50)];
            if (i%2==0) {
                view.backgroundColor = [UIColor greenColor];
            }else
                view.backgroundColor = [UIColor blueColor];
            
            UIButton *btn_call = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, 30, 30)];
            
            [btn_call setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            
            UIView *viewInside = [[UIView alloc] initWithFrame:CGRectMake(i*self.view.frame.size.width, 0, self.view.frame.size.width, 50)];
            UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 30, 30)];
            
            UILabel *label = [[ UILabel alloc] initWithFrame:CGRectMake(40, 15, self.view.frame.size.width-50, 20)];
            
           // NSDictionary *tempdic = [array_offers objectAtIndex:i];
            
           // label.text = [tempdic objectForKey:@"title"];
            label.textColor = [UIColor blackColor];
            label.font = [UIFont systemFontOfSize:15];
            [viewInside addSubview:image];
            [viewInside addSubview:label];
            [view addSubview:btn_call];
            [view addSubview:viewInside];
            
            [scroll_offer addSubview:view];
            
            
        }
        
    }
    
    
    
}

-(void)timerCalled
{
    if(currentPageIndex <= 3 || currentPageIndex >= 0){
        if(currentPageIndex==3){
            
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
    [childViewController showMessage:NO];
    childViewController.index = index;
    childViewController.data = (SplashChildPageData*)[self.pageDatalist objectAtIndex:index];
    
    return childViewController;
}

- (void)viewDidLoad {
    
    self.activity.hidden =YES;
    
    [super viewDidLoad];
    
    APPChildViewController *initialViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
//    
//    locationmanager = [[CLLocationManager alloc] init];
//    self.mapview.delegate = self;
//    locationmanager.delegate = self;
//    locationmanager.desiredAccuracy = kCLLocationAccuracyBest;
//    [locationmanager startUpdatingLocation];
//    geocoder = [[CLGeocoder alloc] init];
//    
//    
//    array_offers = [[NSMutableArray alloc]init];
//    
//    /*****[TAP RECOGNIZER GESTURE]****/
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTransparentHidden:)];
//     UITapGestureRecognizer *tapping = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewtrans2Hidden:)];
//    [view_trans2 addGestureRecognizer:tapping];
//    [view_transparent addGestureRecognizer:tap];
//  
//    
//    view_rsvp.layer.borderColor = [UIColor colorWithRed:252.0f/255 green:180.0f/255 blue:0.0f/255 alpha:1].CGColor;
//    offer_view.layer.borderColor =[UIColor colorWithRed:252.0f/255 green:180.0f/255 blue:0.0f/255 alpha:1].CGColor;
//    offer_view.layer.borderWidth =1.0f;
//    view_rsvp.layer.borderWidth = 1.0f;
//    txt_female.layer.borderColor = [UIColor colorWithRed:252.0f/255 green:180.0f/255 blue:0.0f/255 alpha:1].CGColor;
//    txt_male.layer.borderColor = [UIColor colorWithRed:252.0f/255 green:180.0f/255 blue:0.0f/255 alpha:1].CGColor;
//    txt_male.layer.borderWidth = 1.0f;
//    txt_female.layer.borderWidth = 1.0f;
//    txt_female.backgroundColor = [UIColor whiteColor];
//    txt_male.backgroundColor = [UIColor whiteColor];
//    
//    
//   mapview.delegate = self;  
//    varcouple =0;
//    varfemale = 0;
//    varmale = 0;
//    vartotal = 0;
//    
//    
//    view_rsvp.hidden =YES;
//    offer_view.hidden=YES;
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    UserId= [defaults objectForKey:@"userID"];
//       
//    scrollview.delegate=self;
//    [scrollview setScrollEnabled:YES];
//    [scrollview setContentSize:CGSizeMake(320,690)];
//    
//    array_slider = [[NSArray alloc]init];
//    serverdata =[[NSMutableData alloc]init];
//    
//    
//    
//    NSString *urlstring =[NSString stringWithFormat:@"%@/event_details.php?event_id=%@",BaseUrl,self.event_id];
//    NSURL *url=[[NSURL alloc]initWithString:urlstring];
//    NSURLRequest *request=[[NSURLRequest alloc]initWithURL:url];
//    NSURLConnection *connection=[[NSURLConnection alloc]initWithRequest:request delegate:self];
//    [connection start];
//    firstLaunch=YES;
//
//    
//    NSTimer *_timer;
//    _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timer) userInfo:nil repeats:YES];
//
//    
//    
//    
//    /*******[ACTIVITY INDICATOR]********/
//    CGRect frame = CGRectMake (120.0, 200.0, 100, 100);
//    self.activity = [[UIActivityIndicatorView alloc] initWithFrame:frame];
//    activity.layer.cornerRadius = 05;
//    activity.opaque = NO;
//    activity.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.6f];
//    activity.center = self.view.center;
//    activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
//    [activity setColor:[UIColor colorWithRed:0.6 green:0.8 blue:1.0 alpha:1.0]];
//    
//    /*********[GOOGLE MAP VIEW]**********/
////    mapview = [[MKMapView alloc] initWithFrame:self.view.frame];
////    [self.view addSubview:mapview];
//    
//    
//    
//    
//    
//    [self.view addSubview:self.activity];
//    
//    [self.activity startAnimating];
//    
//    
//    
   }



- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
   

    if (currentLocation != nil) {
        locationmanager = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        locationmanager = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
    }
    
    // Reverse Geocoding
    NSLog(@"Resolving the Address");
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
            locationmanager = [NSString stringWithFormat:@"%@ %@\n%@ %@\n%@\n%@",
                                 placemark.subThoroughfare, placemark.thoroughfare,
                                 placemark.postalCode, placemark.locality,
                                 placemark.administrativeArea,
                                 placemark.country];
        } else {
            NSLog(@"%@", error.debugDescription);
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
    NSLog(@"Google Data: %@", places);
    [self plotPositions:places];

}
-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    //Get the east and west points on the map so you can calculate the distance (zoom level) of the current map view.
    MKMapRect mRect = self.mapview.visibleMapRect;
    MKMapPoint eastMapPoint = MKMapPointMake(MKMapRectGetMinX(mRect), MKMapRectGetMidY(mRect));
    MKMapPoint westMapPoint = MKMapPointMake(MKMapRectGetMaxX(mRect), MKMapRectGetMidY(mRect));
    self.annotation.coordinate = mapview.centerCoordinate;

    //Set your current distance instance variable.
    currenDist = MKMetersBetweenMapPoints(eastMapPoint, westMapPoint);
    
    //Set your current center point on the map instance variable.
    currentCentre = self.mapview.centerCoordinate;
}

-(void)plotPositions:(NSArray *)data {
    // 1 - Remove any existing custom annotations but not the user location blue dot.
    for (id<MKAnnotation> annotation in mapview.annotations) {
        if ([annotation isKindOfClass:[MapPoint class]]) {
            [mapview removeAnnotation:annotation];
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
        [mapview addAnnotation:placeObject];
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

-(void)viewWillLayoutSubviews{

    
}
-(void)viewtrans2Hidden:(UITapGestureRecognizer*)tapgesture{
    
    
    
    view_trans2.hidden = YES;
    
    offer_view.hidden = YES;
    
    
}
-(void)viewTransparentHidden:(UITapGestureRecognizer*)tapgesture{
    
    

    view_transparent.hidden = YES;
    
        view_rsvp.hidden = YES;
    

}

#pragma mark IBAction methods

-(IBAction)male_minus_action:(id)sender{
    
    NSString *get_male_count = txt_male.text;
    if([get_male_count intValue] <= 0){
        //Do nothing if male count 0 or less than 0
    }else{
        int total_male = [get_male_count intValue] - 1;
        [txt_male setText:[NSString stringWithFormat:@"%d",total_male]];
        /****[REMOVE COUPLE]*****/
        if([lb_couple.text intValue] > 0 && [lb_male.text intValue] == 0){
            NSString *get_female_counts = lb_female.text;
            int total_females = [get_female_counts intValue];
            int bbb = total_females + 1;
            [lb_female setText:[NSString stringWithFormat:@"%d", bbb]];
            int c = [lb_couple.text intValue] - 1;
            [lb_couple setText:[NSString stringWithFormat:@"%d",c]];
            /***************************[PRICE CALCULATION START]*****************************/
            int only_male_prc = [lb_male.text intValue] * [lab_TopMale.text intValue];
            int only_female_prc = [lb_female.text intValue] * [lab_TopFeMale.text intValue];
            int only_couple_prc = [lb_couple.text intValue] * [lab_TopCouple.text intValue];
            
            [lb_male_rupee setText:[NSString stringWithFormat:@"%d",only_male_prc]];
            [lb_female_rupee setText:[NSString stringWithFormat:@"%d", only_female_prc]];
            [lb_couple_rupee setText:[NSString stringWithFormat:@"%d",only_couple_prc]];
            
            int total_prc = [lb_male_rupee.text intValue] + [lb_female_rupee.text intValue] + [lb_couple_rupee.text intValue];
            [lb_Total_rupee setText:[NSString stringWithFormat:@"%d",total_prc]];
            
            [without_payment setText:[NSString stringWithFormat:@"%d",total_prc]];
            int aaaa = 0;
            if([discount_value intValue] > 0){
                float per = total_prc * [discount_value intValue] / 100;
                float per2 = total_prc - per;
                aaaa = roundf(per2);
                [pay_now setText:[NSString stringWithFormat:@"%d",aaaa]];
            }else{
                [pay_now setText:[NSString stringWithFormat:@"%d",total_prc]];
            }
            /***************************[PRICE CALCULATION END]*****************************/
        }else if([lb_couple.text intValue] > 0 && [lb_male.text intValue] > 0){
            NSString *get_male_counts = lb_male.text;
            int total_males = [get_male_counts intValue];
            int aaa = total_males - 1;
            [lb_male setText:[NSString stringWithFormat:@"%d",aaa]];
            /***************************[PRICE CALCULATION START]*****************************/
            int only_male_prc = [lb_male.text intValue] * [lab_TopMale.text intValue];
            int only_female_prc = [lb_female.text intValue] * [lab_TopFeMale.text intValue];
            int only_couple_prc = [lb_couple.text intValue] * [lab_TopCouple.text intValue];
            
            [lb_male_rupee setText:[NSString stringWithFormat:@"%d",only_male_prc]];
            [lb_female_rupee setText:[NSString stringWithFormat:@"%d", only_female_prc]];
            [lb_couple_rupee setText:[NSString stringWithFormat:@"%d", only_couple_prc]];
            
            int total_prc = [lb_male_rupee.text intValue] + [lb_female_rupee.text intValue] + [lb_couple_rupee.text intValue];
            [lb_Total_rupee setText:[NSString stringWithFormat:@"%d",total_prc]];
            
            [without_payment setText:[NSString stringWithFormat:@"%d",total_prc]];
            int aaaa = 0;
            if([discount_value intValue] > 0){
                float per = total_prc * [discount_value intValue]/100;
                float per2 = total_prc - per;
                aaaa = roundf(per2);
                [pay_now setText:[NSString stringWithFormat:@"%d",aaaa]];
            }else{
                [pay_now setText:[NSString stringWithFormat:@"%d",total_prc]];
            }
            /***************************[PRICE CALCULATION END]*****************************/
        }else if([lb_couple.text intValue] == 0 && [lb_male.text intValue] > 0){
            NSString *get_male_counts = txt_male.text;
            int total_males = [get_male_counts intValue];
            int aaa = total_males - 1;
            [lb_male setText:[NSString stringWithFormat:@"%d",aaa]];
            /***************************[PRICE CALCULATION START]*****************************/
            int only_male_prc = [lb_male.text intValue] * [lab_TopMale.text intValue];
            int only_female_prc = [lb_female.text intValue] * [lab_TopFeMale.text intValue];
            int only_couple_prc = [lb_couple_rupee.text intValue] * [lab_TopCouple.text intValue];
            
            [lb_male_rupee setText:[NSString stringWithFormat:@"%d",only_male_prc]];
            [lb_female_rupee setText:[NSString stringWithFormat:@"%d", only_female_prc]];
            [lb_couple_rupee setText:[NSString stringWithFormat:@"%d", only_couple_prc]];
            
            int total_prc = [lb_male_rupee.text intValue] + [lb_female_rupee.text intValue] + [lb_couple_rupee.text intValue];
            
            [lb_Total_rupee setText:[NSString stringWithFormat:@"%d",total_prc]];
            
            [without_payment setText:[NSString stringWithFormat:@"%d", total_prc]];
            int aaaa = 0;
            if([discount_value intValue] > 0){
                float per = total_prc * [discount_value intValue]/100;
                float per2  = total_prc - per;
                aaaa =  roundf(per2);
                [pay_now setText:[NSString stringWithFormat:@"%d",aaaa]];
            }else{
                [pay_now setText:[NSString stringWithFormat:@"%d",total_prc]];
            }
            /***************************[PRICE CALCULATION END]*****************************/
        }else{
            //Do nothing
        }
    }
}

-(IBAction)male_plus_action:(id)sender{
    
    NSString *get_male_count = txt_male.text;
    int total_male = [get_male_count intValue] + 1;
    [txt_male setText:[NSString stringWithFormat:@"%d", total_male]];
    
    NSString *get_male_counts = lb_male.text;
    int total_males = [get_male_counts intValue];
    int aaa = total_males + 1;
    [lb_male setText:[NSString stringWithFormat:@"%d",aaa]];
    /*********[MAKE COUPLE]*********/
    if([lb_male.text intValue] <= [lb_female.text intValue]){
        int m = [lb_male.text intValue];
        int f = [lb_female.text intValue];
        [lb_male setText:[NSString stringWithFormat:@"%d",m - 1]];
        [lb_female setText:[NSString stringWithFormat:@"%d",f - 1]];
        
        int c = [lb_couple.text intValue] + 1;
        [lb_couple setText:[NSString stringWithFormat:@"%d",c]];
    }
    /*********[END MAKE COUPLE]*********/
    
    /***************************[PRICE CALCULATION START]*****************************/
    int only_male_prc = [lb_male.text intValue] * [lab_TopMale.text intValue];
    int only_female_prc = [lb_female.text intValue] * [lab_TopFeMale.text intValue];
    int only_couple_prc = [lb_couple.text intValue] * [lab_TopCouple.text intValue];
    
    [lb_male_rupee setText:[NSString stringWithFormat:@"%d",only_male_prc]];
    [lb_female_rupee setText:[NSString stringWithFormat:@"%d",only_female_prc]];
    [lb_couple_rupee setText:[NSString stringWithFormat:@"%d", only_couple_prc]];
    
    int total_prc = [lb_male_rupee.text intValue] + [lb_female_rupee.text intValue] +[lb_couple_rupee.text intValue];
    
    [lb_Total_rupee setText:[NSString stringWithFormat:@"%d",total_prc]];
    [without_payment setText:[NSString stringWithFormat:@"%d",total_prc]];
    
    int aaaa = 0;
    if([discount_value intValue] > 0){
        float per = total_prc * [discount_value intValue] / 100;
        float per2 = total_prc - per;
        aaaa = roundf(per2);
        [pay_now setText:[NSString stringWithFormat:@"%d",aaaa]];
    }else{
        [pay_now setText:[NSString stringWithFormat:@"%d",total_prc]];
    }
    /***************************[PRICE CALCULATION END]*****************************/
    
}

-(IBAction)female_minus_action:(id)sender{
    
    NSString *get_female_count = txt_female.text;
    if([get_female_count intValue] <= 0){
        //Do nothing if 0
    }else{
        int total_female = [get_female_count intValue] - 1;
        [txt_female setText:[NSString stringWithFormat:@"%d",total_female]];
        /************[REMOVE COUPLE]************/
        if([lb_couple.text intValue] > 0 && [lb_female.text intValue] == 0){
            NSString *get_male_counts = lb_male.text;
            int total_males = [get_male_counts intValue];
            int bbb = total_males + 1;
            [lb_male setText:[NSString stringWithFormat:@"%d",bbb]];
            
            int c = [lb_couple.text intValue] - 1;
            [lb_couple setText:[NSString stringWithFormat:@"%d",c]];
            /***************************[PRICE CALCULATION START]*****************************/
            int only_male_prc = [lb_male.text intValue] * [lab_TopMale.text intValue];
            int only_female_prc = [lb_female.text intValue] * [lab_TopFeMale.text intValue];
            int only_couple_prc = [lb_couple.text intValue] * [lab_TopCouple.text intValue];
            
            [lb_male_rupee setText:[NSString stringWithFormat:@"%d",only_male_prc]];
            [lb_female_rupee setText:[NSString stringWithFormat:@"%d", only_female_prc]];
            [lb_couple_rupee setText:[NSString stringWithFormat:@"%d",only_couple_prc]];
            
            int total_prc = [lb_male_rupee.text intValue] + [lb_female_rupee.text intValue] + [lb_couple_rupee.text intValue];
            [lb_Total_rupee setText:[NSString stringWithFormat:@"%d",total_prc]];
            
            [without_payment setText:[NSString stringWithFormat:@"%d",total_prc]];
            int aaaa = 0;
            if([discount_value intValue] > 0){
                float per = total_prc * [discount_value intValue];
                float per2 = total_prc - per;
                aaaa = roundf(per2);
                [pay_now setText:[NSString stringWithFormat:@"%d",aaaa]];
            }else{
                [pay_now setText:[NSString stringWithFormat:@"%d",total_prc]];
            }

            /***************************[PRICE CALCULATION END]*****************************/
        }else if([lb_couple.text intValue] > 0 && [lb_female.text intValue] > 0){
            NSString *get_female_counts = lb_female.text;
            int total_females =[get_female_counts intValue];
            int aaa = total_females -1;
            [lb_female setText:[NSString stringWithFormat:@"%d",aaa]];
            /***************************[PRICE CALCULATION START]*****************************/
            int only_male_prc = [lb_male.text intValue] * [lab_TopMale.text intValue];
            int only_female_prc = [lb_female.text intValue] * [lab_TopFeMale.text intValue];
            int only_couple_prc = [lb_couple.text intValue] * [lab_TopCouple.text intValue];
            
            [lb_male_rupee setText:[NSString stringWithFormat:@"%d",only_male_prc]];
            [lb_female_rupee setText:[NSString stringWithFormat:@"%d", only_female_prc]];
            [lb_couple_rupee setText:[NSString stringWithFormat:@"%d", only_couple_prc]];
            
            int total_prc = [lb_male_rupee.text intValue] + [lb_female_rupee.text intValue] + [lb_couple_rupee.text intValue];
            [lb_Total_rupee setText:[NSString stringWithFormat:@"%d",total_prc]];
            
            [without_payment setText:[NSString stringWithFormat:@"%d",total_prc]];
            int aaaa = 0;
            if([discount_value intValue] > 0){
                float per = total_prc * [discount_value intValue]/100;
                float per2 = total_prc - per;
                aaaa = roundf(per2);
                [pay_now setText:[NSString stringWithFormat:@"%d",aaaa]];
            }else{
                [pay_now setText:[NSString stringWithFormat:@"%d",total_prc]];
            }

            /***************************[PRICE CALCULATION END]*****************************/
        }else if([lb_couple.text intValue] == 0 && [lb_female.text intValue] > 0){
            NSString *get_female_counts = lb_female.text;
            int total_females = [get_female_counts intValue];
            int aaa = total_females - 1;
            [lb_female setText:[NSString stringWithFormat:@"%d",aaa]];
            /***************************[PRICE CALCULATION START]*****************************/
            int only_male_prc = [lb_male.text intValue] * [lab_TopMale.text intValue];
            int only_female_prc = [lb_female.text intValue] * [lab_TopFeMale.text intValue];
            int only_couple_prc = [lb_couple_rupee.text intValue] * [lab_TopCouple.text intValue];
            
            [lb_male_rupee setText:[NSString stringWithFormat:@"%d",only_male_prc]];
            [lb_female_rupee setText:[NSString stringWithFormat:@"%d", only_female_prc]];
            [lb_couple_rupee setText:[NSString stringWithFormat:@"%d", only_couple_prc]];
            
            int total_prc = [lb_male_rupee.text intValue] + [lb_female_rupee.text intValue] + [lb_couple_rupee.text intValue];
            
            [lb_Total_rupee setText:[NSString stringWithFormat:@"%d",total_prc]];
            
            [without_payment setText:[NSString stringWithFormat:@"%d", total_prc]];
            int aaaa = 0;
            if([discount_value intValue] > 0){
                float per = total_prc * [discount_value intValue]/100;
                float per2  = total_prc - per;
                aaaa =  roundf(per2);
                [pay_now setText:[NSString stringWithFormat:@"%d",aaaa]];
            }else{
                [pay_now setText:[NSString stringWithFormat:@"%d",total_prc]];
            }
            /***************************[PRICE CALCULATION END]*****************************/
        }else{
            // Do nothing in else case
        }
    }
}

-(IBAction)female_plus_action:(id)sender{
    NSString *get_female_count = txt_female.text;
    int total_female = [get_female_count intValue] + 1;
    [txt_female setText:[NSString stringWithFormat:@"%d", total_female]];
    
    NSString * get_female_counts = lb_female.text;
    int total_females = [get_female_counts intValue];
    int aaa = total_females + 1;
    [lb_female setText:[NSString stringWithFormat:@"%d",aaa]];
    
    /*********[MAKE COUPLE]********/
    if([lb_female.text intValue] <= [lb_male.text intValue]){
        int m = [lb_male.text intValue];
        int f = [lb_female.text intValue];
        [lb_male setText:[NSString stringWithFormat:@"%d", m-1]];
        [lb_female setText:[NSString stringWithFormat:@"%d", f-1]];
        int c = [lb_couple.text intValue] + 1;
        [lb_couple setText:[NSString stringWithFormat:@"%d",c]];
    }
    /***************************[PRICE CALCULATION START]*****************************/
    int only_male_prc = [lb_male.text intValue] * [lab_TopMale.text intValue];
    int only_female_prc = [lb_female.text intValue] * [lab_TopFeMale.text intValue];
    int only_couple_prc = [lb_couple.text intValue] * [lab_TopCouple.text intValue];
    [lb_male_rupee setText:[NSString stringWithFormat:@"%d",only_male_prc]];
    [lb_female_rupee setText:[NSString stringWithFormat:@"%d",only_female_prc]];
    [lb_couple_rupee setText:[NSString stringWithFormat:@"%d", only_couple_prc]];
    int total_prc = [lb_male_rupee.text intValue] + [lb_female_rupee.text intValue] +[lb_couple_rupee.text intValue];
    [lb_Total_rupee setText:[NSString stringWithFormat:@"%d",total_prc]];
    [without_payment setText:[NSString stringWithFormat:@"%d",total_prc]];
    int aaaa = 0;
    if([discount_value intValue] > 0){
        float per = total_prc * [discount_value intValue] / 100;
        float per2 = total_prc - per;
        aaaa = roundf(per2);
        [pay_now setText:[NSString stringWithFormat:@"%d",total_prc]];
    }
    /***************************[PRICE CALCULATION END]*****************************/
    
}

-(IBAction)continue_pay_action:(id)sender{
    if ([[ConnectionManager getSharedInstance] isConnectionAvailable])
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            
            
            NSString *urlString = [NSString stringWithFormat:@"%@/book_event.php?event_id=70&user_id=44&total_amount=450&no_of_males=3&no_of_females=1&no_of_couples=2&sub_total=500&discount_percent=10&payment_method=online&event_description=hi",BaseUrl];
            NSURL *url = [[NSURL alloc]initWithString:urlString];
            NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
            
            [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
             {
                 dispatch_async(dispatch_get_main_queue(), ^(void){
                     if (data.length > 0)
                     {
                         NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                         
                         NSLog(@"parsedObject =%@",parsedObject);
                         
                         NSString* message = [parsedObject  objectForKey:@"message"];
                         NSLog(@"message   =%@",message);

                         UIAlertView  *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Event successfully booked" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                         [alertView show];
                         
                     }
                     
                 });
             }];
        });
    }
    

    
}

-(IBAction)without_pay_action:(id)sender{
    
    if ([[ConnectionManager getSharedInstance] isConnectionAvailable])
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            
            
            NSString *urlString = [NSString stringWithFormat:@"%@/book_event.php?event_id=70&user_id=44&total_amount=450&no_of_males=3&no_of_females=1&no_of_couples=2&sub_total=500&discount_percent=10&payment_method=cash&event_description=hi",BaseUrl];
            NSURL *url = [[NSURL alloc]initWithString:urlString];
            NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
            
            [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
             {
                 dispatch_async(dispatch_get_main_queue(), ^(void){
                     if (data.length > 0)
                     {
                         NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                         
                         NSLog(@"parsedObject =%@",parsedObject);
                         
                         NSString* message = [parsedObject  objectForKey:@"message"];
                         NSLog(@"message   =%@",message);
                         
                         UIAlertView  *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Event successfully booked" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                         [alertView show];
                         
                     }
                     
                 });
             }];
        });
    }
    
}



-(void)timer{
    
    if (check_slider) {
        [ scroll1 setContentOffset:CGPointMake(scroll1.contentOffset.x-self.view.frame.size.width, 0)];
        if (scroll1.contentOffset.x ==0) {
            check_slider=NO;
        }
    }
    else{
        [ scroll1 setContentOffset:CGPointMake(scroll1.contentOffset.x+self.view.frame.size.width, 0)];
        if (scroll1.contentOffset.x == self.view.frame.size.width*(array_slider.count-1)) {
            check_slider=YES;
        }
    }
}

-(void)viewDidLayoutSubviews{
    viewwidth  = self.view.frame.size.width;
    
    /*****[TOP IMAGE HORIZONTAL SLIDER]*****/
    scroll1.scrollEnabled=YES;
    [scroll1 setContentSize:CGSizeMake(self.view.frame.size.width*array_slider.count, 0)];
    if (array_slider.count==0) {
        return;
    }
    for (int i=0; i<=array_slider.count-1; i++) {
        UIImageView *temp_btn = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width*i, 0, self.view.frame.size.width, scroll1.frame.size.height)];
        [temp_btn setBackgroundColor:[UIColor blackColor]];
        
        temp_btn.clipsToBounds = YES;
        NSString *temp_img = @"http://owlers.com/event_images/";
        temp_img = [temp_img stringByAppendingString:[array_slider objectAtIndex:i ]];
        [self downloadImageWithURL:[NSURL URLWithString:temp_img] completionBlock:^(BOOL succeeded, UIImage *image) {
            if (succeeded) {
                temp_btn.image = image;
            }}];
        [scroll1 addSubview:temp_btn];
    }
    
    
    /*****[OWLERS MENU HORIZONTAL SLIDER]*****/
    scroll_offer.scrollEnabled=YES;
    [scroll_offer setContentSize:CGSizeMake(self.view.frame.size.width*array_offers.count, 0)];
    
    
//    scroll_offer.backgroundColor = [UIColor yellowColor];
//    scroll_offer.frame = CGRectMake(10, scroll_offer.frame.origin.y, 320*6, 50);
//    scroll_offer.scrollEnabled = YES;
//    scroll_offer.pagingEnabled=NO;
    //scroll_offer.contentSize = CGSizeMake(420*3, 0);
    
    if (array_offers.count==0) {
        return;
    }
    for (int i=0; i<array_offers.count; i++) {

        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, 50)];
        UIButton *btn_call = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, 30, 15)];
        
        [btn_call setImage:[UIImage imageNamed:@"call_icons"] forState:UIControlStateNormal];
        
        UIView *viewInside = [[UIView alloc] initWithFrame:CGRectMake(i*self.view.frame.size.width, 0, self.view.frame.size.width, 50)];
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 30, 15)];
        
        
        NSLog(@"offer Label :%@",[[array_offers objectAtIndex:i]objectForKey:@"title"]);
        
        
        
        
//        NSLog([NSString stringWithFormat:@"value of i :%d",0]);
        
      //  _offerLabel.text =[NSString stringWithFormat:@"%@",[array_offers objectAtIndex:i]objectForKey:@"title"];
      // _offerLabel.text = [[array_offers objectAtIndex:i] objectForKey:@"title"];
//        
//          _offerLabel.text =[NSString stringWithFormat:@"%@",[[[[[serverdict objectForKey:@"events"] objectAtIndex:0]objectForKey:@"offers"]objectAtIndex:0]objectForKey:@"title"]];
//        
        
        UILabel *label = [[ UILabel alloc] initWithFrame:CGRectMake(15, 5, self.view.frame.size.width, 20)];
        
        label.text = [[array_offers objectAtIndex:i] objectForKey:@"title"];
        
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:15];
        
        [viewInside addSubview:image];
        [viewInside addSubview:label];
        [view addSubview:btn_call];
        [view addSubview:viewInside];
        [scroll_offer addSubview:view];
        
      //  [self.view addSubview:scroll_offer];
      
    }
    
    
    
    
    
    
    
    
    
    
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


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Error = %@", [error localizedDescription]);
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
   
    serverdata = [[NSMutableData alloc]init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [serverdata appendData:data];
}






- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
//    self.activity.hidden =YES;
    [self.activity stopAnimating];
    serverdict = [NSJSONSerialization JSONObjectWithData:serverdata options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"serverData =%@",serverdict);
    
   
    array_slider = [[[serverdict objectForKey:@"events"] objectAtIndex:0] objectForKey:@"slider_images"];
 //[self viewDidLayoutSubviews];
    //[self offermethodcall];
//    
//    NSArray *temparr = [serverdict objectForKey:@"events"] ;
//    NSDictionary *tempdic = [temparr objectAtIndex:0];
//    NSArray *temp2 = [[tempdic objectForKey:@"offers"] objectAtIndex:0];
    
    NSArray *offer_slider_array = [[[serverdict objectForKey:@"events"]objectAtIndex:0]objectForKey:@"offers"];
    
    
    NSLog(@"OFFERS DATA : %@",offer_slider_array);
   
    array_offers = [offer_slider_array copy];
    [self viewDidLayoutSubviews];
   // [self offermethodcall];
    
    /******************************[TO BE COPIED START]**********************************/
    if([[[serverdict objectForKey:@"events"] objectAtIndex:0] objectForKey:@"discounts"]) {
        NSLog(@"Discount exists");
        NSArray *local_array = [[[serverdict objectForKey:@"events"] objectAtIndex:0] objectForKey:@"discounts"];
        discount_value = [[local_array objectAtIndex:0] objectForKey:@"value"];
        NSString *discount = [[local_array objectAtIndex:0] objectForKey:@"title"];
        NSString *dis_total = [NSString stringWithFormat:@"PAY  NOW ( %@ )",discount];

        [continue_pay_action setTitle:dis_total forState:nil];
        
    }
    else {
        NSLog(@"Discount does not exists");
    }
    
        NSString *status_check = [NSString stringWithFormat:@"%@",[[[serverdict objectForKey:@"events"] objectAtIndex:0] objectForKey:@"entry_exists_for"]];
    if([status_check  isEqual: @""]){}else{
        NSArray* foo = [status_check componentsSeparatedByString: @","];
        
        NSLog(@"FOO: %@", foo);
        
        NSLog(@"array count : %lu ",(unsigned long)foo.count);
        if(foo.count <= 0){}else{
            for (int i = 0; i < foo.count; i++) {
                
                if([[foo objectAtIndex:i] isEqualToString:@"M"]){
                    NSLog(@"male checked");
                    male_status = YES;
                }else if([[foo objectAtIndex:i] isEqualToString:@"F"]){
                    NSLog(@"female checked");
                    female_status = YES;
                }else{
                    NSLog(@"couple checked");
                    couple_status = YES;
                }
                
            }
        }
    }
    /******************************[TO BE COPIED END]**********************************/
    
    
    
    _gettimeDatelabel.text=[NSString stringWithFormat:@"%@",[[[serverdict objectForKey:@"events"] objectAtIndex:0] objectForKey:@"event_start"]];
    
    
    _getDetailLabel.text=[NSString stringWithFormat:@"%@",[[[serverdict objectForKey:@"events"] objectAtIndex:0]objectForKey:@"event_desc"]];
    
    _imageLabel1.text=[NSString stringWithFormat:@"%@",[[[serverdict objectForKey:@"events"] objectAtIndex:0]objectForKey:@"event_name"]];
    _imagelabel2.text=[NSString stringWithFormat:@"%@",[[[serverdict objectForKey:@"events"] objectAtIndex:0]objectForKey:@"venue"]];
//    _offerLabel.text =[NSString stringWithFormat:@"%@",[[[[[serverdict objectForKey:@"events"] objectAtIndex:0]objectForKey:@"offers"]objectAtIndex:0]objectForKey:@"title"]];
    
    lab_TopMale.text=[NSString stringWithFormat:@"%@", [[[serverdict objectForKey:@"events"] objectAtIndex:0]objectForKey:@"ev_price_male"]];
    lab_TopFeMale.text=[NSString stringWithFormat:@"%@", [[[serverdict objectForKey:@"events"] objectAtIndex:0]objectForKey:@"ev_price_female"]];
    lab_TopCouple.text=[NSString stringWithFormat:@"%@", [[[serverdict objectForKey:@"events"] objectAtIndex:0]objectForKey:@"ev_price_couple"]];
    NSLog(@"this is the event name : %@",[[[serverdict objectForKey:@"events"] objectAtIndex:0]objectForKey:@"event_name"]);
    eventName.text=[NSString stringWithFormat:@"%@", [[[serverdict objectForKey:@"events"] objectAtIndex:0]objectForKey:@"event_name"]];
    
    _address = [NSString stringWithFormat:@"%@",[[[serverdict objectForKey:@"events"]objectAtIndex:0]objectForKey:@"address"]];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:_address completionHandler:^(NSArray* placemarks, NSError* error){
        
        
        for (CLPlacemark* aPlacemark in placemarks)
        {
            
            NSString *latDest1 = [NSString stringWithFormat:@"%.4f",aPlacemark.location.coordinate.latitude];
            
            NSString *lngDest1 = [NSString stringWithFormat:@"%.4f",aPlacemark.location.coordinate.longitude];
            NSLog(@"latitude %@",latDest1);
            NSLog(@"longitude %@",lngDest1);
            str_temp_lat=[latDest1 floatValue];
            str_temp_long=[lngDest1 floatValue];
        }
        NSString *temp_address =@"http://maps.google.com/maps/api/geocode/json?address=%22+";

            MKPointAnnotation *annotation= [[MKPointAnnotation alloc]init];
        
            
        
            CLLocationCoordinate2D Coordinate = CLLocationCoordinate2DMake(str_temp_lat,str_temp_long);
            annotation.coordinate = Coordinate;
        
        
        mapview.centerCoordinate = annotation.coordinate; //focusing on marker
        
            [mapview addAnnotation:annotation];
            
            
            MKCoordinateSpan span;
            span.latitudeDelta=0.3;
            span.longitudeDelta=0.3;
            MKCoordinateRegion region;
            
        mapview.delegate = self;
        
                CLLocationCoordinate2D Coordinate1 = CLLocationCoordinate2DMake(str_temp_lat,str_temp_long);
                
                
                region.center = Coordinate1;
                             region.span=span;
                
        
    }];
    
    

    
    _getLocationLabel.text=[NSString stringWithFormat:@"%@", _address];
    
    _imageLabel1.text=[NSString stringWithFormat:@"%@",[[[serverdict objectForKey:@"events"]objectAtIndex:0]objectForKey:@"event_name"]];
    _atmospherelLabel.text=[NSString stringWithFormat:@"%@",[[[serverdict objectForKey:@"events"]objectAtIndex:0]objectForKey:@"atmosphere"]];
    _musicLabel.text=[NSString stringWithFormat:@"%@",[[[serverdict objectForKey:@"events"]objectAtIndex:0]objectForKey:@"genre_of_music"]];
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

      NSLog(@"Detected Location : %f, %f", showLocation.coordinate.latitude, showLocation.coordinate.longitude);
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:showLocation
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       if (error){
                           NSLog(@"Geocode failed with error: %@", error);
                           return;
                       }
                       CLPlacemark *placemark = [placemarks objectAtIndex:0];
                       NSLog(@"placemark.ISOcountryCode %@",placemark.ISOcountryCode);
                       
                   }];
}


- (IBAction)backBtnAction:(id)sender {
    
    ProductViewController *product=[[ProductViewController alloc]initWithNibName:@"ProductViewController" bundle:nil];
    UINavigationController *navController = self.navigationController;
    [navController popViewControllerAnimated:YES];

}

- (IBAction)rsvpbtnAction:(id)sender {
    
    self.loginViewController = [[LoginViewController alloc] init];
    Boolean check_login = [[SharedPreferences sharedInstance] isLogin];
    

    
    
    
    if(check_login){
        if (view_rsvp.hidden) {
            view_transparent.hidden= NO;
            view_rsvp.hidden = NO;
        }else
            view_rsvp.hidden = YES;
        view_transparent.hidden= NO;
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Status" message:@"Please login to proceed" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Login", nil];
        [alertView show];
    }
    
    
    
    
}



- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == [alertView cancelButtonIndex]){
        //cancel clicked ...do your action
    }else{

        LoginViewController*login=[[LoginViewController alloc]init];
        [self.navigationController pushViewController:login animated:YES];
    
    }
}
- (IBAction)moreBtnAction:(id)sender {
    
    //self.getDetailLabel.frame = CGRectMake(40,74,278,80);
    //[_getDetailLabel setTextColor:[UIColor blackColor]];
    
    _getDetailLabel.numberOfLines = 0;
    CGSize maxSize = CGSizeMake(_getDetailLabel.bounds.size.width, CGFLOAT_MAX);
    CGSize textSize = [_getDetailLabel.text sizeWithFont:_getDetailLabel.font constrainedToSize:maxSize];
    
    

    
    _getDetailLabel.frame = CGRectMake(10, 10, textSize.width, textSize.height);
    [moreBtn setTitle:[NSString stringWithFormat:@"Less"] forState:nil];
    
    
//    [UIView animateWithDuration:0.3 animations:^{
//        [containerView setFrame:rect];
//        [bottomView setFrame:rect2];
//    }];
    
    NSLog(@"label expanded");
}
- (IBAction)callBtnAction:(id)sender {
    
    UIDevice *device = [UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPhone"] ){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:07381476718"]]];
        
       
        NSURL *url = [NSURL URLWithString:@"telprompt://7381476718"];
        [[UIApplication  sharedApplication] openURL:url];
    
        
        NSString *phoneNumber = @"+917381476718"; // dynamically assigned
        NSString *phoneURLString = [NSString stringWithFormat:@"tel:%@", phoneNumber];
        NSURL *phoneURL = [NSURL URLWithString:phoneURLString];
        [[UIApplication sharedApplication] openURL:phoneURL];
        
    } else {
        UIAlertView *notPermitted=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Your device doesn't support this feature." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [notPermitted show];
       // [notPermitted release];
    }
}

- (IBAction)googleMapBtnAction:(id)sender {
    
    
    CLLocationCoordinate2D start = { 28.6139, 77.2090 };
    CLLocationCoordinate2D destination = { 27.1750, 78.0419 };

    NSString *googleMapsURLString = [NSString stringWithFormat:@"http://maps.google.com/?saddr=%1.6f,%1.6f&daddr=%1.6f,%1.6f",
                                     start.latitude, start.longitude, destination.latitude, destination.longitude];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:googleMapsURLString]];
    [self mapurl:_address];
    
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

- (NSMutableArray*)pageDatalist {
    if (!_pageDatalist) {
        _pageDatalist = [[NSMutableArray alloc] init];
        SplashChildPageData *data1 = [SplashChildPageData dataWithImage:[UIImage imageNamed:@"1.png"] displayText:@""];
        [_pageDatalist addObject:data1];
        SplashChildPageData *data2 = [SplashChildPageData dataWithImage:[UIImage imageNamed:@"3.png"] displayText:@"Bid for amaging offers, use them on-the-go"];
        [_pageDatalist addObject:data2];
        SplashChildPageData *data3 = [SplashChildPageData dataWithImage:[UIImage imageNamed:@"2.png"] displayText:@"Get access to the best party locations right from your phone"];
        [_pageDatalist addObject:data3];
        SplashChildPageData *data4 = [SplashChildPageData dataWithImage:[UIImage imageNamed:@"4.png"] displayText:@"Find the most exciting events in your city"];
        [_pageDatalist addObject:data4];
    }
    return _pageDatalist;
}

- (void)viewDidAppear:(BOOL)animated {
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(timerCalled) userInfo:nil repeats:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [_timer invalidate];
    _timer = nil;
}

@end
