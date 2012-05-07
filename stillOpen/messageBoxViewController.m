//
//  messageBoxViewController.m
//  stillOpen
//
//  Created by Jae Ho Jeon on 5/6/12.
//  Copyright (c) 2012 Seoul National University. All rights reserved.
//

#import "messageBoxViewController.h"
#define messageBoxHeight 80
#define cancelLabelHeight 22

@implementation messageBoxViewController

-(id) initWithParentViewController:(ViewController *)pVC
{
    if (self = [super initBoxWithWidth:320 height:messageBoxHeight color:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7] animationDuration:0.25 fastAnimationDuration:0.1 fromX:0 fromY:-messageBoxHeight toX:0 toY:0])
    {
        
        parentViewController = pVC;
        cancelRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelMessageBox)];
        
        messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, messageBoxHeight)];
        messageLabel.textAlignment = UITextAlignmentCenter;
        messageLabel.textColor = [UIColor whiteColor];
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.font = [UIFont fontWithName:@"Futura" size:18];
        messageLabel.numberOfLines = 0;
        
        [self.view addSubview:messageLabel];
        
        
        cancelLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, messageBoxHeight - cancelLabelHeight, 320, cancelLabelHeight)];
        cancelLabel.backgroundColor = [UIColor clearColor];
        cancelLabel.font = [UIFont boldSystemFontOfSize:12.5];
        cancelLabel.textAlignment = UITextAlignmentCenter;
        cancelLabel.textColor = [UIColor redColor];
        cancelLabel.text = @"취소하려면 여기를 누르세요";
        [cancelLabel setHidden:YES];
        
        [self.view addSubview:cancelLabel];
        
    }
    return self;
    
}

-(void) setWithMessage:(NSString * ) messageStr
{
    [messageLabel setText:messageStr];
}

-(void) showCancelMessage
{
    CGRect frame = messageLabel.frame;
    frame.origin.y = - cancelLabelHeight / 3.5;
    messageLabel.frame = frame;
    [cancelLabel setHidden:NO];
    
    [self.view addGestureRecognizer:cancelRecognizer];
}

-(void) hideCancelMessage
{
    CGRect frame = messageLabel.frame;
    frame.origin.y = 0;
    messageLabel.frame = frame;
    [cancelLabel setHidden:YES];
    
    [self.view removeGestureRecognizer:cancelRecognizer];
}

-(void) showMessageForDuration:(int) duration
{
    [self showBox];
    [self performSelector:@selector(hideBox) withObject:nil afterDelay:duration];
}

-(void) cancelMessageBox
{
    [self hideBox];
    [parentViewController setPlusMenuToggled:NO];
}


@end
