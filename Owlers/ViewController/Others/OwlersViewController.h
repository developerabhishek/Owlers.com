//
//  OwlersViewController.h
//  Owlers
//
//  Created by Biprajit Biswas on 01/10/15.
//  Copyright (c) 2015 JNT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "Annotation.h"
#import "MapPoint.h"
#import "LoginViewController.h"
#import "Event.h"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface OwlersViewController : UIViewController<UIScrollViewDelegate,CLLocationManagerDelegate,NSURLConnectionDataDelegate,NSURLConnectionDelegate,MKMapViewDelegate, UIPageViewControllerDataSource, UICollectionViewDataSource, UICollectionViewDelegate>

{
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    
    NSString *addressString;
    BOOL firstLaunch;

    CLLocationCoordinate2D currentCentre;
    int currenDist;
    
    IBOutlet UIScrollView *scrollview;
    IBOutlet UIImageView *imageview;
    IBOutlet UIScrollView *scroll1;
    IBOutlet UIScrollView *scroll2;
    CLLocationManager *locationmanager;
    CLLocation *showLocation;
    NSArray *array;
    UIView *subview;
    BOOL uiview_check;
    BOOL check_slider;
    
    IBOutlet UIButton *offer_button;
        
    float str_temp_lat;
    float str_temp_long;
    
    IBOutlet UIView *view_transparent;
    IBOutlet UIView *view_trans2;
    IBOutlet UIScrollView *scroll_offer;
    
    int viewwidth;
    
    IBOutlet UIView *offer_view;
        
}

@property (strong ,nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (strong, nonatomic) IBOutlet UILabel *gettimeDatelabel;
@property (strong, nonatomic) IBOutlet UILabel *getDetailLabel;
@property (strong, nonatomic) NSArray *temp_slaiderimages;
@property (strong, nonatomic) IBOutlet UILabel *offerLabel;
@property (strong, nonatomic) IBOutlet UILabel *getLocationLabel;
@property (strong, nonatomic) IBOutlet UILabel *atmospherelLabel;
@property (strong, nonatomic) IBOutlet UILabel *musicLabel;
@property (strong, nonatomic) IBOutlet MKMapView *mapview;
@property (strong, nonatomic) MKPointAnnotation *annotation;
@property (strong, nonatomic) Event *event;
@property (weak, nonatomic) IBOutlet UILabel *eventName;
@property (weak, nonatomic) IBOutlet UILabel *eventVenue;

- (IBAction)moreBtnAction:(id)sender;
- (IBAction)googleMapBtnAction:(id)sender;
- (IBAction)backBtnAction:(id)sender;
- (IBAction)rsvpbtnAction:(id)sender;
- (IBAction)offer_button:(id)sender;

@end
