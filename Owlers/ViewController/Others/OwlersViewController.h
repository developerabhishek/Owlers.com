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
//#import "ViewPagerController.h"
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface OwlersViewController : UIViewController<UIScrollViewDelegate,CLLocationManagerDelegate,NSURLConnectionDataDelegate,NSURLConnectionDelegate,MKMapViewDelegate, UIPageViewControllerDataSource>

{
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    
    NSString *addressString;
    BOOL firstLaunch;

    CLLocationCoordinate2D currentCentre;
    int currenDist;
    
    IBOutlet UIScrollView *scrollview;
    IBOutlet MKMapView *mapview;
    IBOutlet UIImageView *imageview;
    IBOutlet UIScrollView *scroll1;
    IBOutlet UIScrollView *scroll2;
    CLLocationManager *locationmanager;
    CLLocation *showLocation;
    NSMutableData *serverdata;
    NSMutableDictionary *serverdict;
    
     
    NSArray *array;
    NSArray *array_slider;
    NSArray *offer_slider;
    UIView *subview;
    BOOL uiview_check;
    BOOL check_slider;
    
    IBOutlet UILabel *without_payment;
    IBOutlet UILabel *pay_now;
    
    
    
    
    IBOutlet UIButton *offer_button;
    IBOutlet UIButton *moreBtn;
    
    IBOutlet UIActivityIndicatorView *activity;
    
    IBOutlet UILabel *lab_TopMale;
    IBOutlet UILabel *lab_TopFeMale;
    IBOutlet UILabel *lab_TopCouple;

    IBOutlet UILabel *eventName;
    
    IBOutlet UIButton *btn_male_plus;
    IBOutlet UIButton *btn_male_minus;
    IBOutlet UIButton *btn_female_plus;
    IBOutlet UIButton *btn_female_minus;
    
    
    IBOutlet UILabel *lb_male;
    IBOutlet UILabel *lb_female;
    IBOutlet UILabel *lb_couple;
 //   IBOutlet UIButton *lb_Total;
    
    IBOutlet UILabel *lb_male_rupee;
    IBOutlet UILabel *lb_female_rupee;
    IBOutlet UILabel *lb_couple_rupee;
    IBOutlet UILabel *lb_Total_rupee;

    IBOutlet UILabel *imageLabel1;
     IBOutlet UILabel *imagelabel2;
    
    IBOutlet UIView *view_rsvp;
    
    int varmale;
    int varfemale;
    int varcouple;
    int vartotal;
    
    float str_temp_lat;
    float str_temp_long;
    NSMutableArray *array_offers;
    
    IBOutlet UITextField *txt_male;
    IBOutlet UITextField *txt_female;
    IBOutlet UIButton *continue_pay_action;
    IBOutlet UIButton *without_pay_action;
    
    IBOutlet UIView *view_transparent;
    IBOutlet UIView *view_trans2;
    IBOutlet UIScrollView *scroll_offer;
    
    int viewwidth;
    
    IBOutlet UIView *offer_view;
}

@property(strong ,nonatomic)IBOutlet UIActivityIndicatorView *activity;
@property (nonatomic, strong) LoginViewController * loginViewController;
@property (strong, nonatomic) IBOutlet UILabel *label1;
@property (strong, nonatomic) IBOutlet UILabel *gettimeDatelabel;
@property (strong, nonatomic) IBOutlet UILabel *getDetailLabel;
@property (strong, nonatomic)  NSString *event_id;
- (IBAction)moreBtnAction:(id)sender;

@property(nonatomic,strong)NSArray *temp_slaiderimages;

@property (strong, nonatomic) IBOutlet UILabel *label2;
@property (strong, nonatomic) IBOutlet UILabel *offerLabel;



@property (strong, nonatomic) IBOutlet UILabel *label3;
@property (strong, nonatomic) IBOutlet UILabel *getLocationLabel;
- (IBAction)googleMapBtnAction:(id)sender;



@property (strong, nonatomic) IBOutlet UILabel *imageLabel1;
@property (strong, nonatomic) IBOutlet UILabel *imagelabel2;

@property (nonatomic,strong) IBOutlet UILabel *atmospherelLabel;
@property (nonatomic,strong) IBOutlet UILabel *musicLabel;

@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet MKMapView *mapview;
@property(nonatomic,retain)MKPointAnnotation *annotation;


-(IBAction)continue_pay_action:(id)sender;
-(IBAction)without_pay_action:(id)sender;

- (IBAction)backBtnAction:(id)sender;
- (IBAction)rsvpbtnAction:(id)sender;

-(IBAction)offer_button:(id)sender;


@end
