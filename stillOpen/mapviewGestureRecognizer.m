//
//  mapviewGestureRecognizer.m
//  stillOpen
//
//  Created by Jae Ho Jeon on 5/16/12.
//  Copyright (c) 2012 Seoul National University. All rights reserved.
//

#import "mapviewGestureRecognizer.h"

@implementation mapviewGestureRecognizer
@synthesize touchesBeganCallback;

-(id) init{
    if (self = [super init])
    {
        self.cancelsTouchesInView = NO;
    }
    
    return self;
    
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
//    if (touchesBeganCallback)
//        touchesBeganCallback(touches, event);

    mapMoved = NO;
    
}

-(void) touchesCancelled:(NSSet * ) touches withEvent:(UIEvent *)event
{
}

-(void) touchesMoved:(NSSet * ) touches withEvent:(UIEvent *)event
{
    mapMoved = YES;
}

-(void) touchesEnded:(NSSet * ) touches withEvent:(UIEvent *)event
{
    if (touchesBeganCallback && mapMoved == NO)
        touchesBeganCallback(touches, event);

}

- (void) reset
{
}

- (void) ignoreTouch:(UITouch * ) touch forEvent: (UIEvent * ) event
{
}

- ( BOOL) canBePreventedByGestureRecognizer:(UIGestureRecognizer * ) preventingGestureRecognizer
{
    return NO;
}

-(BOOL) canPreventGestureRecognizer:(UIGestureRecognizer * ) preventedGestureRecognizer
{
    return NO;
}

@end