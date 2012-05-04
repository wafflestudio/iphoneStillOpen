//
//  ViewController.h
//  stillOpen
//
//  Created by Jae Ho Jeon on 3/19/12.
//  Copyright (c) 2012 Seoul National University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <AddressBookUI/AddressBookUI.h>
#import "storeAnnotation.h"
#import "SlidingMessageViewController.h"
#import "menuViewController.h"
#import "requestHTTP.h"

@class menuViewController;




@interface ViewController : UIViewController<MKMapViewDelegate, CLLocationManagerDelegate>
{ 
    NSTimer * annotationUpdateTimer;
    menuViewController * menuView;
}

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIView *helpBar;
@property (strong, nonatomic) IBOutlet UILongPressGestureRecognizer *longPress;
@property (weak, nonatomic) IBOutlet UILabel *helpLabel;
@property (nonatomic, copy) storeAnnotation * userAnnotation;
@property (nonatomic, copy) storeAnnotation * currentAnnotation;

@property (nonatomic, retain) SlidingMessageViewController * callOutView;
@property (nonatomic, copy) NSString * address;

@property (nonatomic) BOOL plusMenuToggled;




-(void) setAllAnnotations;
-(void) initializeMap;
-(int) timeGetter;


-(NSString * ) minToHuman:(NSInteger) inputMin;
-(int) checkOpenClosed:(storeAnnotation * ) annotation;
-(NSString *) makeSubtitle:(storeAnnotation *) annotation;

-(void) receivedLongPress:(id) inputObject;
-(void) annotationUpdater:(NSTimer * ) timer;
-(NSString * ) getDistanceFromCurrentLocation:(storeAnnotation *) annotation;
- (void)makeJsonStringWithAnnotation:(storeAnnotation * ) inputAnn;
- (void) checkAndAddStore: (MKMapView * ) mV;



@end
