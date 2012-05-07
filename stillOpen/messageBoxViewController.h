//
//  messageBoxViewController.h
//  stillOpen
//
//  Created by Jae Ho Jeon on 5/6/12.
//  Copyright (c) 2012 Seoul National University. All rights reserved.
//


#import "SlidingMessageViewController.h"
#import "ViewController.h"
@class ViewController;

@interface messageBoxViewController : SlidingMessageViewController
{    
    UILabel * messageLabel;
    UILabel * cancelLabel;
    UITapGestureRecognizer * cancelRecognizer;
    ViewController * parentViewController;
}

-(id) initWithParentViewController:(ViewController * ) pVC;
-(void) setWithMessage:(NSString * ) messageStr;
-(void) showMessageForDuration:(int) duration;
-(void) showCancelMessage;
-(void) hideCancelMessage;
-(void) cancelMessageBox;

@end
