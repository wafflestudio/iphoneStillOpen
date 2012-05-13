#import "SlidingMessageViewController.h"


@implementation SlidingMessageViewController



- (id)initBoxWithWidth:(int)width height:(int)height color:(UIColor * ) cl animationDuration:(CGFloat)duration fastAnimationDuration:(CGFloat)duration2 fromX:(int) fX fromY:(int) fY toX:(int) tX toY:(int) tY setHidden:(BOOL) hd
{
    
    if (self = [super init])
    {
        isClosed = YES;
        
        boxWidth = width;
        boxHeight = height;
        
        boxColor = cl;
        
        animationDuration = duration;
        fastAnimationDuration = duration2;
        
        fromX = fX;
        fromY = fY;
        toX = tX;
        toY = tY;
        setHidden = hd;
        
        
        self.view = [[UIView alloc] initWithFrame:CGRectMake(fromX, fromY, boxWidth, boxHeight)];
        [self.view setBackgroundColor:boxColor];        
        self.view.userInteractionEnabled = YES;

    }
    
    return self;
}

- (id)initDraggableBoxWithWidth:(int)width height:(int)height color:(UIColor * ) cl animationDuration:(CGFloat)duration fastAnimationDuration:(CGFloat)duration2 fromX:(int) fX fromY:(int) fY toX:(int) tX toY:(int) tY setHidden:(BOOL) hd revealEdge:(CGFloat) rE overdraw:(CGFloat) overdraw leftTopTrigger:(CGFloat) lTT rightBottomTrigger:(CGFloat) rBT quickFlickVelocity:(CGFloat) qFV
{
    if (self = [self initBoxWithWidth:width height:height color:cl animationDuration:duration fastAnimationDuration:duration2 fromX:fX fromY:fY toX:tX toY:tY setHidden:hd])
    {
        REVEAL_EDGE = rE;
        REVEAL_EDGE_OVERDRAW = overdraw;
        REVEAL_VIEW_TRIGGER_LEVEL_LEFT_OR_TOP = lTT;
        REVEAL_VIEW_TRIGGER_LEVEL_RIGHT_OR_BOTTOM = rBT;
        VELOCITY_REQUIRED_FOR_QUICK_FLICK = qFV;
        
        UIPanGestureRecognizer * boxPanRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(boxPan:)];
        [self.view addGestureRecognizer:boxPanRecognizer];
    }
    
    return self;
}


- (void)showBox
{
    [self.view setHidden:NO];
    
    CGRect frame = self.view.frame;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
    frame.origin.x = toX;
    frame.origin.y = toY;
    
    self.view.frame = frame;  
    [UIView commitAnimations];
    isClosed = NO;

}

- (void)showBoxFast
{
    [self.view setHidden:NO];

    CGRect frame = self.view.frame;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:fastAnimationDuration];
    
    frame.origin.x = toX;
    frame.origin.y = toY;
    
    self.view.frame = frame;  
    [UIView commitAnimations];
    isClosed = NO;
    
}

- (void)hideBox;
{
    CGRect frame = self.view.frame;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];    
    
    frame.origin.x = fromX;
    frame.origin.y = fromY;
    
    self.view.frame = frame;  
    [UIView commitAnimations];
    isClosed = YES;
    
    if (setHidden)
        [self performSelector:@selector(makeInvisible) withObject:nil afterDelay:animationDuration];
}


- (void)hideBoxFast
{
    CGRect frame = self.view.frame;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:fastAnimationDuration];
    
    frame.origin.x = fromX;
    frame.origin.y = fromY;
    
    self.view.frame = frame;  
    [UIView commitAnimations];
    isClosed = YES;
    
    if (setHidden)
        [self performSelector:@selector(makeInvisible) withObject:nil afterDelay:fastAnimationDuration];
}

- (void) makeInvisible
{
    [self.view setHidden:YES];
}

-(void) boxPan:(UIPanGestureRecognizer * ) recognizer
{
	if (UIGestureRecognizerStateEnded == [recognizer state])
	{
        
		// Case a): Quick finger flick fast enough to cause instant change:
		if (fabs([recognizer velocityInView:self.view].x) > VELOCITY_REQUIRED_FOR_QUICK_FLICK)
		{
			if ([recognizer velocityInView:self.view].x > 0.0f)
				[self showBoxFast];
			else
				[self hideBoxFast];
		}
        
        
		// Case b) Slow pan/drag ended:
		else
		{
			float dynamicTriggerLevel = isClosed ? REVEAL_VIEW_TRIGGER_LEVEL_LEFT_OR_TOP : REVEAL_VIEW_TRIGGER_LEVEL_RIGHT_OR_BOTTOM;
			
			if ([self getConvertedOriginX] >= dynamicTriggerLevel && [self getConvertedOriginX] != REVEAL_EDGE)
				[self showBox];
			else if ([self getConvertedOriginX] < dynamicTriggerLevel && [self getConvertedOriginX] != 0.0f)
				[self hideBox];
		}
		
		// Now adjust the current state enum.
		if ([self getConvertedOriginX] == 0.0f)
            isClosed = YES;
		else
            isClosed = NO;
		
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
			float offset = [self calculateOffsetForTranslationInView:[recognizer translationInView:self.view].x];
            CGRect frame = self.view.frame;
            frame.origin.x = offset - abs(fromX);
            self.view.frame = frame;
		}
	}
    
	else
	{
		if ([recognizer translationInView:self.view].x > 0.0f)
		{
			float offset = [self calculateOffsetForTranslationInView:([recognizer translationInView:self.view].x+REVEAL_EDGE)];
            CGRect frame = self.view.frame;
            frame.origin.x = offset - abs(fromX);
            self.view.frame = frame;
		}
		else if ([recognizer translationInView:self.view].x > -REVEAL_EDGE)
		{
            CGRect frame = self.view.frame;
            frame.origin.x = [recognizer translationInView:self.view].x+REVEAL_EDGE - abs(fromX);
            self.view.frame = frame;
		}
		else
		{
            //			self.frontView.frame = CGRectMake(0.0f, 0.0f, self.frontView.frame.size.width, self.frontView.frame.size.height);
		}
	}
    

}

- (CGFloat) getConvertedOriginX
{
    return self.view.frame.origin.x + abs(fromX);
    
    //나중에 다시 구현.. 
}

- (CGFloat)calculateOffsetForTranslationInView:(CGFloat)x
{
	CGFloat result;
	
	if (x <= REVEAL_EDGE)
		result = x;
    else if (x <= 2 * REVEAL_EDGE )
        result = REVEAL_EDGE + (x - REVEAL_EDGE) / 5;
	else
		result = REVEAL_EDGE+REVEAL_EDGE_OVERDRAW;
	
	return result;
}


@end