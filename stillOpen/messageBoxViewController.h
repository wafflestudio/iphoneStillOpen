//
//  messageBoxViewController.h
//  stillOpen
//
//  Created by Jae Ho Jeon on 5/6/12.
//  Copyright (c) 2012 Seoul National University. All rights reserved.
//

#import "SlidingMessageViewController.h"

@interface messageBoxViewController : SlidingMessageViewController
{    
    id parent;
    UILabel * messageLabel;
    UILabel * cancelLabel;
    UITapGestureRecognizer * cancelRecognizer;
}

-(id) initWithParentViewController:(id) pVC;
-(void) setWithMessage:(NSString * ) messageStr;
-(void) showMessageForDuration:(int) duration;
-(void) showCancelMessage;
-(void) hideCancelMessage;
-(void) cancelMessageBox;



@end

