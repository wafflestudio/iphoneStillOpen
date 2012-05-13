//
//  storeAnnotation.m
//  stillOpen
//
//  Created by Jae Ho Jeon on 3/19/12.
//  Copyright (c) 2012 Seoul National University. All rights reserved.
//

#import "storeAnnotation.h"


@implementation storeAnnotation

@synthesize coordinate,title,subtitle;
@synthesize Opentime, Closetime, imageURL;
@synthesize isUserAddedAnnotation;


-(storeAnnotation * ) init
{
    self = [super init];
    if (self)
    {
        isUserAddedAnnotation = NO;
    }
    return self;
    
}

@end
