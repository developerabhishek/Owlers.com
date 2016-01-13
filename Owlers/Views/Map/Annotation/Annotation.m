//
//  Annotation.m
//  Owlers
//
//  Created by Biprajit Biswas on 05/10/15.
//  Copyright (c) 2015 JNT. All rights reserved.
//

#import "annotation.h"

@implementation MapViewAnnotation

@synthesize coordinate=_coordinate;
@synthesize title=_title;

-(id) initWithTitle:(NSString *) title AndCoordinate:(CLLocationCoordinate2D)coordinate
{
    self = [super init];
    _title = title;
    _coordinate = coordinate;
    return self;
}

-(MKAnnotationView *)annotationView
{
    MKPinAnnotationView *annotationView = [[MKPinAnnotationView alloc]initWithAnnotation:self reuseIdentifier:nil];
    [annotationView setPinColor:MKPinAnnotationColorRed];
    
    annotationView.enabled = YES;
    
    annotationView.canShowCallout = YES;
    
    //annotationView.image = [UIImage imageNamed:@"you_are_here_106_37.png"];  // we want to add another image than pin  . . . it is not used for show popUpBaloon
    
    return annotationView;
}

@end



