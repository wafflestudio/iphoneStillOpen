//
//  annotationDetailViewer.h
//  stillOpen
//
//  Created by Jae Ho Jeon on 5/5/12.
//  Copyright (c) 2012 Seoul National University. All rights reserved.
//


#import "SlidingMessageViewController.h"

@interface annotationDetailViewer : SlidingMessageViewController
{
    storeAnnotation * annotation;
    UILabel * msgLabel;
    UILabel * titleLabel;
    UIImageView * cafeThumbnail;
    UIImageView * wifiAvailability;
    UIImageView * toiletAvailability;
    UILabel * noiseLevel;
    UILabel * quietLevel;
    UILabel * noiseLabel;
    UILabel * quietLabel;    
    
}

@property (nonatomic, copy) UILabel * distanceLabel;


-(id)initWithAnnotation:(storeAnnotation *)inputAnnotation;
-(void) setWithAnnotation:(storeAnnotation *) inputAnnotation;

@end
