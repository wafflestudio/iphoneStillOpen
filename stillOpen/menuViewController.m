//
//  menuViewController.m
//  stillOpen
//
//  Created by Jae Ho Jeon on 3/25/12.
//  Copyright (c) 2012 Seoul National University. All rights reserved.
//

#import "menuViewController.h"

@implementation menuViewController

@synthesize addStoreMenu, toggleCurrentOpenMenu, helpMenu, firstDividerBlock, secondDividerBlock, menuTag;

- (id)initWithParentViewController:(ViewController *) inputParentViewController
{
    if (self = [super init])
    {
        isClosed = YES;
        parentViewController = inputParentViewController;
        
        self.view = [[UIView alloc] initWithFrame:CGRectMake(-menuWidth, 480 - menuHeight- 20, menuWidth + menuTagWidth, menuHeight)];
        self.view.userInteractionEnabled = YES;

        UIPanGestureRecognizer * menuPanRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(menuSwipe:)];
        [self.view addGestureRecognizer:menuPanRecognizer];
        
        [self.view setBackgroundColor:[UIColor blackColor]];
        [self.view setAlpha:0.8];
        
        
        // 316px / 3 = 105, ( 105 - 40 ) = 32
        
        
        
        //첫번째 메뉴바 추가 -------------------------------------------------
        
        UIImage * addStoreImage = [UIImage imageNamed:@"plusIcon.png"];
        addStoreMenu = [[UIImageView alloc] initWithFrame:CGRectMake(32, 10, 40, 40)];
        [addStoreMenu setImage:addStoreImage];

        
        addStoreMenu.userInteractionEnabled = YES;        
        UITapGestureRecognizer * addStoreRecognizer = [[UITapGestureRecognizer alloc] 
                                                       initWithTarget:self 
                                                       action:@selector(addStore)];
        
        [addStoreMenu addGestureRecognizer:addStoreRecognizer];
        [self.view addSubview:addStoreMenu];
        
        // ----------------------------------------------------------------
        
        

        //두번째 메뉴바 추가 -------------------------------------------------

        UIImage * toggleCurrentOpenImage = [UIImage imageNamed:@"clockIcon.png"];
        toggleCurrentOpenMenu = [[UIImageView alloc] initWithFrame:CGRectMake(139, 10, 40, 40)];
        [toggleCurrentOpenMenu setImage:toggleCurrentOpenImage];
        [self.view addSubview:toggleCurrentOpenMenu];
        
        // ----------------------------------------------------------------
        
        
        
        //세번째 메뉴바 추가 -------------------------------------------------        
      
        UIImage * helpImage = [UIImage imageNamed:@"questionIcon.png"];
        helpMenu = [[UIImageView alloc] initWithFrame:CGRectMake(245, 10, 40, 40)];
        [helpMenu setImage:helpImage];
        [self.view addSubview:helpMenu];
        
        // ----------------------------------------------------------------
    
        
        
        firstDividerBlock = [[UILabel alloc] initWithFrame:CGRectMake(107, 15, 2, 30)];
        firstDividerBlock.backgroundColor = [UIColor whiteColor];
        [firstDividerBlock setAlpha:0.6];
        
        [self.view addSubview:firstDividerBlock];
        
        secondDividerBlock = [[UILabel alloc] initWithFrame:CGRectMake(210, 15, 2, 30)];
        secondDividerBlock.backgroundColor = [UIColor whiteColor];
        [secondDividerBlock setAlpha:0.6];
        
        [self.view addSubview:secondDividerBlock];
        
        
        
        menuTag = [[UILabel alloc] initWithFrame:CGRectMake(menuWidth, 0, menuTagWidth, menuHeight)];
        //  menuTag.backgroundColor = [UIColor colorWithRed:169 green:137 blue:181 alpha:0.5];
        menuTag.backgroundColor = RGBA(169, 137, 181, 1);
        
        
        menuTag.text = @"M\nE\nN\nU";
        menuTag.font = [UIFont fontWithName:@"Futura" size:11.5];
        menuTag.numberOfLines = 0;
        
        [self.view addSubview:menuTag];
        
    }
    
    return self;
}


-(void) addStore
{
    [parentViewController.helpBar setHidden:NO];
    [parentViewController.view addSubview:parentViewController.helpBar];
    
    
    [parentViewController setPlusMenuToggled:YES];
    [parentViewController checkAndAddStore:parentViewController.mapView];
    [self hideMenu];
}


- (void) menuSwipe:(UIPanGestureRecognizer * ) recognizer
{
    // 3. ...or maybe the interaction already _ENDED_?
	if (UIGestureRecognizerStateEnded == [recognizer state])
	{
        
        NSLog(@"WOW!");
		// Case a): Quick finger flick fast enough to cause instant change:
		if (fabs([recognizer velocityInView:self.view].x) > VELOCITY_REQUIRED_FOR_QUICK_FLICK)
		{
			if ([recognizer velocityInView:self.view].x > 0.0f)
			{	
                NSLog(@"%f", [recognizer velocityInView:self.view].x);
				[self showMenu];
			}
			else
			{
				[self hideMenu];
			}
		}
        
        
		// Case b) Slow pan/drag ended:
		else
		{
			float dynamicTriggerLevel = isClosed ? REVEAL_VIEW_TRIGGER_LEVEL_LEFT : REVEAL_VIEW_TRIGGER_LEVEL_RIGHT;
			
			if ([self getConvertedOriginX] >= dynamicTriggerLevel && [self getConvertedOriginX] != REVEAL_EDGE)
			{
				[self showMenu];
			}
			else if ([self getConvertedOriginX] < dynamicTriggerLevel && [self getConvertedOriginX] != 0.0f)
			{
				[self hideMenu];
			}
		}
		
		// Now adjust the current state enum.
		if ([self getConvertedOriginX] == 0.0f)
		{
            isClosed = YES;
		}
		else
		{
            isClosed = NO;
		}
		
		return;
        
	}

    
    
    if (isClosed)
	{
		if ([recognizer translationInView:self.view].x < 0.0f)
		{
//			self.frontView.frame = CGRectMake(0.0f, 0.0f, self.frontView.frame.size.width, self.frontView.frame.size.height);
		}
		else
		{
			float offset = [self _calculateOffsetForTranslationInView:[recognizer translationInView:self.view].x];
            CGRect frame = self.view.frame;
            frame.origin.x = offset - menuWidth;
            self.view.frame = frame;
		}
	}
	else
	{
		if ([recognizer translationInView:self.view].x > 0.0f)
		{
			float offset = [self _calculateOffsetForTranslationInView:([recognizer translationInView:self.view].x+REVEAL_EDGE)];
            CGRect frame = self.view.frame;
            frame.origin.x = offset - menuWidth;
            self.view.frame = frame;
		}
		else if ([recognizer translationInView:self.view].x > -REVEAL_EDGE)
		{
            CGRect frame = self.view.frame;
            frame.origin.x = [recognizer translationInView:self.view].x+REVEAL_EDGE - menuWidth;
            self.view.frame = frame;
		}
		else
		{
//			self.frontView.frame = CGRectMake(0.0f, 0.0f, self.frontView.frame.size.width, self.frontView.frame.size.height);
		}
	}
    
}

- (float) getConvertedOriginX
{
    return self.view.frame.origin.x + menuWidth;
}

- (CGFloat)_calculateOffsetForTranslationInView:(CGFloat)x
{
	CGFloat result;
	
	if (x <= REVEAL_EDGE)
	{
		// Translate linearly.
		result = x;
	}
	else if (x <= REVEAL_EDGE+(M_PI*REVEAL_EDGE_OVERDRAW/2.0f))
	{
		// and eventually slow translation slowly.
		result = REVEAL_EDGE_OVERDRAW*sin((x-REVEAL_EDGE)/REVEAL_EDGE_OVERDRAW)+REVEAL_EDGE;
	}
	else
	{
		// ...until we hit the limit.
		result = REVEAL_EDGE+REVEAL_EDGE_OVERDRAW;
	}
	
	return result;
}



- (void)showMenu
{
    CGRect frame = self.view.frame;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:popOutDuration];
    
    frame.origin.x = 0;
    self.view.frame = frame;
    
    [UIView commitAnimations];    
}

- (void) hideMenu
{
    CGRect frame = self.view.frame;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:popOutDuration];
    
    frame.origin.x = -menuWidth;
    self.view.frame = frame;
    
    [UIView commitAnimations];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView
 {
 }
 */

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end