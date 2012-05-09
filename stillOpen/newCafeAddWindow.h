//
//  newCafeAddWindow.h
//  stillOpen
//
//  Created by Jae Ho Jeon on 5/8/12.
//  Copyright (c) 2012 Seoul National University. All rights reserved.
//

#import "SlidingMessageViewController.h"

@interface newCafeAddWindow : SlidingMessageViewController
{
    UILabel * titleLabel;
    
}

- (void) setWithAnnotation:(storeAnnotation *) inputAnnotation;

@end
