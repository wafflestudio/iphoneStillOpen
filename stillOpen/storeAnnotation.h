//
//  storeAnnotation.h
//  stillOpen
//
//  Created by Jae Ho Jeon on 3/19/12.
//  Copyright (c) 2012 Seoul National University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface storeAnnotation : NSObject<MKAnnotation>


@property (nonatomic) CLLocationCoordinate2D coordinate;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic) int Opentime;
@property (nonatomic) int Closetime;


@end
