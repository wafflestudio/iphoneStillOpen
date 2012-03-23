//
//  ViewController.h
//  stillOpen
//
//  Created by Jae Ho Jeon on 3/19/12.
//  Copyright (c) 2012 Seoul National University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "storeAnnotation.h"
#import "callOutView.h"



@interface ViewController : UIViewController<MKMapViewDelegate, CLLocationManagerDelegate>
{ 
    NSTimer * annotationUpdateTimer;
    bool gpsUpdatedOnce;
}

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIView *helpBar;
@property (weak, nonatomic) IBOutlet UIButton *timeButton;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (strong, nonatomic) IBOutlet UILongPressGestureRecognizer *longPress;
@property (nonatomic, copy) storeAnnotation * userAnnotation;
@property (weak, nonatomic) IBOutlet UILabel *helpLabel;
@property (strong, nonatomic) UIViewController * annotationCallOut;


-(void) setAllAnnotations;
-(void) initializeMap;
-(int) timeGetter;

-(NSString * ) minToHuman:(NSInteger) inputMin;
-(int) checkOpenClosed:(storeAnnotation * ) annotation;
-(NSString *) makeSubtitle:(storeAnnotation *) annotation;

-(void) receivedLongPress:(id) inputObject;
-(void) annotationUpdater:(NSTimer * ) timer;




@end
