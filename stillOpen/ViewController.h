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
#import "menuViewController.h"
#import "annotationDetailViewer.h"
#import "messageBoxViewController.h"
#import "newCafeAddWindow.h"
#import "imageViewer.h"
#import "mapviewGestureRecognizer.h"


@class messageBoxViewController;



@interface ViewController : UIViewController<MKMapViewDelegate, CLLocationManagerDelegate>
{ 
    NSTimer * annotationUpdateTimer;
    menuViewController * menuView;
    annotationDetailViewer * callOutView;
    annotationDetailViewer * hiddenCallOutView;
    UILongPressGestureRecognizer * longPress;
    storeAnnotation * userAnnotation;
    storeAnnotation * currentAnnotation;
    messageBoxViewController * messageBox;
    newCafeAddWindow * cafeAddBox;
    MKMapView * mapView;
    BOOL plusMenuToggled;
}

-(void) setAllAnnotations;
-(void) initializeMap;
-(int) timeGetter;


-(NSString * ) minToHuman:(NSInteger) inputMin;
-(int) checkOpenClosed:(storeAnnotation * ) annotation;
-(NSString *) makeSubtitle:(storeAnnotation *) annotation;


-(void) moveMapWithHeight:(int) height;
-(void) plusMenuOff;
-(void) plusMenuOn;
-(void) receivedLongPress:(id) inputObject;
-(void) annotationUpdater:(NSTimer * ) timer;
-(NSString * ) getDistanceFromCurrentLocation:(storeAnnotation *) annotation;
-(void) checkAndAddStore;
-(void) hideCalloutView;
-(void) completeAddingCafe:(storeAnnotation * ) ann;

-(void) hideMenuBar;


@end

