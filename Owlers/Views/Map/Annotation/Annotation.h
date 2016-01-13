//
//  Annotation.h
//  Owlers
//
//  Created by Biprajit Biswas on 05/10/15.
//  Copyright (c) 2015 JNT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OwlersViewController.h"
#import <MapKit/MapKit.h>
@interface MapViewAnnotation : NSObject<MKAnnotation>

@property (nonatomic,copy) NSString *title;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

-(id) initWithTitle:(NSString *) title AndCoordinate:(CLLocationCoordinate2D)coordinate;

-(MKAnnotationView *)annotationView;

@end
