//
//  newCafeAddWindow.h
//  stillOpen
//
//  Created by Jae Ho Jeon on 5/8/12.
//  Copyright (c) 2012 Seoul National University. All rights reserved.
//

#import "SlidingMessageViewController.h"
#import "requestHTTP.h"

@interface newCafeAddWindow : SlidingMessageViewController
{
    UILabel * titleLabel;
    UILabel * cafeNameLabel;
    UILabel * openTimeLabel;
    UILabel * closeTimeLabel;
    UITextField * cafeName;
    UITextField * openTime;
    UITextField * closeTime;
    
    id parent;
    
    
    UIButton * sendButton;
    
    storeAnnotation * annotation;
    
}

- (id) initWithParentViewController:(id) pVC;
- (void) setWithAnnotation:(storeAnnotation *) inputAnnotation;
- (void) sendToServer;
- (void) cancelCafeAdd;

@end
