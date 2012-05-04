#import "SlidingMessageViewController.h"



@implementation SlidingMessageViewController
@synthesize annotation, titleLabel, msgLabel, distanceLabel;



- (void)hideMsg;
{
    CGRect frame = self.view.frame;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
    frame.origin.y = -boxHeight;
    self.view.frame = frame;
    
    [UIView commitAnimations];
}
- (void)hideMsgFast
{
    CGRect frame = self.view.frame;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.1];
    
    frame.origin.y = -boxHeight;
    self.view.frame = frame;
    
    [UIView commitAnimations];
    
}


-(id)initWithAnnotation:(storeAnnotation *)inputAnnotation
{
    if (self = [super init]) 
    {   
        annotation = inputAnnotation;
        
  
        
        self.view = [[UIView alloc] initWithFrame:CGRectMake(0, -boxHeight, 320, boxHeight)];
        [self.view setBackgroundColor:[UIColor blackColor]];
        [self.view setAlpha:.70];
        
        // 가게 이름
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 4, 285, 40)];

//        titleLabel.font = [UIFont boldSystemFontOfSize:27];
        titleLabel.font = [UIFont fontWithName:@"Futura" size:28];
        titleLabel.text = annotation.title;
        titleLabel.textAlignment = UITextAlignmentRight;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        [self.view addSubview:titleLabel];
        
        
        // 가게 설명
        msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 285, 90)];
//        msgLabel.font = [UIFont systemFontOfSize:14];
        msgLabel.font = [UIFont fontWithName:@"Futura" size:13];
        msgLabel.text = annotation.description;
        msgLabel.textAlignment = UITextAlignmentRight;
        msgLabel.textColor = [UIColor whiteColor];
        msgLabel.backgroundColor = [UIColor clearColor];
        [self.view addSubview:msgLabel];
        
        
        // 현재 위치로부터 거리
        
        distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 3, 285, 150)];
        distanceLabel.numberOfLines = 0;
        distanceLabel.font = [UIFont systemFontOfSize:14];
//        distanceLabel.font = [UIFont boldSystemFontOfSize:15];
        distanceLabel.text = @"";
        distanceLabel.textAlignment = UITextAlignmentRight;
        distanceLabel.textColor = [UIColor whiteColor];
        distanceLabel.backgroundColor = [UIColor clearColor];
        [self.view addSubview:distanceLabel];
        
        
        
        if([annotation isKindOfClass:[MKUserLocation class]])
        {
            titleLabel.textAlignment = UITextAlignmentCenter;
            
            msgLabel.text = nil;
            
            distanceLabel.text = @"상점을 이곳에 추가하시려면 파란색 버튼을 누르세요";
            distanceLabel.textAlignment = UITextAlignmentCenter;
            
        
        }
        
        
    }
    
    return self;
}

- (void)showMsg
{
    CGRect frame = self.view.frame;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
    frame.origin.y = 0;
    self.view.frame = frame;
    
    [UIView commitAnimations];    
}

- (void)showMsgWithDelay:(int)delay
{
    //  UIView *view = self.view;
    CGRect frame = self.view.frame;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
    // Slide up based on y axis
    // A better solution over a hard-coded value would be to
    // determine the size of the title and msg labels and 
    // set this value accordingly
    frame.origin.y = 0;
    self.view.frame = frame;
    
    [UIView commitAnimations];
    
    // Hide the view after the requested delay
    [self performSelector:@selector(hideMsg) withObject:nil afterDelay:delay];
    
}

@end