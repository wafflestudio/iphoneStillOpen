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
    UILabel * titleLabel;
    UIImageView * cafeThumbnail;
    UIImageView * wifiAvailability;
    UIImageView * toiletAvailability;
    UILabel * noiseLevel;
    UILabel * quietLevel;
    UILabel * noiseLabel;
    UILabel * quietLabel;

    NSURLConnection* connection; //keep a reference to the connection so we can cancel download in dealloc
	NSMutableData* data; //keep reference to the data so we can collect it as it downloads

    UIActivityIndicatorView *activity;

}

@property (nonatomic, copy) UILabel * distanceLabel;


- (id)initWithAnnotation:(storeAnnotation *)inputAnnotation;
- (void) setWithAnnotation:(storeAnnotation *) inputAnnotation;
- (void)loadImageFromURL:(NSURL*)url;

@end
