//
//  annotationDetailViewer.m
//  stillOpen
//
//  Created by Jae Ho Jeon on 5/5/12.
//  Copyright (c) 2012 Seoul National University. All rights reserved.
//

#import "annotationDetailViewer.h"

#define imageHeight 99
#define imageWidth ((imageHeight * 14) / 11)
#define topMargin 13
#define bottomMargin 14
#define leftMargin 14
#define rightMargin 12
#define annotationDetailBoxHeight (imageHeight + topMargin + bottomMargin)
#define imageAppearanceDuration 0.5

@implementation annotationDetailViewer
@synthesize distanceLabel;

-(id) init
{
    if (self = [super initBoxWithWidth:320 height:annotationDetailBoxHeight color:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.60] animationDuration:0.36 fastAnimationDuration:0.1 fromX:0 fromY:-annotationDetailBoxHeight toX:0 toY:0 setHidden:YES])
    {
        
        // 가게 이름
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 3, 320 - rightMargin, 40)];
        titleLabel.font = [UIFont fontWithName:@"Futura" size:23];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        [self.view addSubview:titleLabel];
        
        // 현재 위치로부터 거리
        distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 39, 320 - rightMargin - 1, 28)]; // 여기선 fine tuning 필요.. 
        distanceLabel.numberOfLines = 0;
        distanceLabel.font = [UIFont systemFontOfSize:11.5];
        distanceLabel.textColor = [UIColor whiteColor];
        distanceLabel.backgroundColor = [UIColor clearColor];
        distanceLabel.numberOfLines = 0;
        [self.view addSubview:distanceLabel];
        
        
        // 가게 섬네일 뷰   
        cafeThumbnail = [[UIImageView alloc] initWithFrame:CGRectMake(leftMargin, topMargin, imageWidth, imageHeight)];
        [cafeThumbnail setUserInteractionEnabled:YES];
        
        UITapGestureRecognizer * thumbnailRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImage)];
        [cafeThumbnail addGestureRecognizer:thumbnailRecognizer];
        
        [self.view addSubview:cafeThumbnail];

        
        
        // 이미지 로딩 뷰
        activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activity.frame = CGRectMake(leftMargin, topMargin, imageWidth, imageHeight);
        [self.view addSubview:activity];        
        
        //와이파이 등의 이미지..
        
        UIImage * wifiImage = [UIImage imageNamed:@"wifiWhiteIcon.png"];
        wifiAvailability = [[UIImageView alloc] initWithFrame:CGRectMake(288, 70, 16, 13)];
        [wifiAvailability setImage:wifiImage];
        [self.view addSubview:wifiAvailability];
        
        UIImage * toiletImage = [UIImage imageNamed:@"toiletIcon.png"];
        toiletAvailability= [[UIImageView alloc] initWithFrame:CGRectMake(268, 70, 16, 13)];
        [toiletAvailability setImage:toiletImage];
        [self.view addSubview:toiletAvailability];
        
        
        // 시끄러운 정도 등등
        
        quietLevel = [[UILabel alloc] initWithFrame:CGRectMake(160, 90, 145, 2)];
        quietLevel.backgroundColor = [UIColor colorWithRed:135.0/255 green:163.0/255 blue:225.0/255 alpha:1];
        [self.view addSubview:quietLevel];
        
        noiseLevel = [[UILabel alloc] initWithFrame:CGRectMake(160, 90, 55, 2)];
        noiseLevel.backgroundColor = [UIColor colorWithRed:244.0/255 green:62.0/255 blue:86.0/255 alpha:1];
        [self.view addSubview:noiseLevel];
        
        noiseLabel = [[UILabel alloc] initWithFrame:CGRectMake(159, 99, 45, 13)];        
        noiseLabel.text = @"시끌시끌";
        noiseLabel.textColor = [UIColor whiteColor];
        noiseLabel.backgroundColor = [UIColor clearColor];
        noiseLabel.font = [UIFont systemFontOfSize:12];
        
        [self.view addSubview:noiseLabel];
        
        quietLabel = [[UILabel alloc] initWithFrame:CGRectMake(263, 99, 45, 13)];
        quietLabel.text = @"조용조용";
        quietLabel.textColor = [UIColor whiteColor];
        quietLabel.backgroundColor = [UIColor clearColor];
        quietLabel.font = [UIFont systemFontOfSize:12];
        
        [self.view addSubview:quietLabel];
        
        
        [self.view setHidden:YES];

    }
    
    return self;
    
    
}


-(id)initWithAnnotation:(storeAnnotation *)inputAnnotation
{
    if (self = [self init])
    {
        [self setWithAnnotation:inputAnnotation];
    }
    
    return self;
}

-(void) setWithAnnotation:(storeAnnotation *) inputAnnotation
{
    data = nil;
    annotation = inputAnnotation;
    titleLabel.text = annotation.title;
    distanceLabel.text = @""; // distanceLabel 은 timer에서 채워주겠지..

    if([annotation isKindOfClass:[MKUserLocation class]])
    {
        titleLabel.textAlignment = UITextAlignmentCenter;
        distanceLabel.text = @"상점을 이곳에 추가하시려면 파란색 버튼을 누르세요";
        distanceLabel.textAlignment = UITextAlignmentCenter;
    }
    
    else
    {
        titleLabel.textAlignment = UITextAlignmentRight;
        distanceLabel.textAlignment = UITextAlignmentRight;
        NSString * urlStr = [NSString stringWithFormat:@"http://mintengine.com:3000/%@", inputAnnotation.imageURL];
        NSURL * imageURL = [NSURL URLWithString:urlStr];
        [cafeThumbnail setImage:nil];
        [self loadImageFromURL:imageURL];

//
//            UIImage * cafeImage = [UIImage imageNamed:@"cafe.jpeg"];        
//            [cafeThumbnail setImage:cafeImage];
//            NSLog(@"Fuck it failed");
//            NSLog(@"%@", inputAnnotation.imageURL);
        
        
    }
}




- (void)loadImageFromURL:(NSURL*)url {
    
    
    [activity startAnimating];
	NSURLRequest* request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
	connection = [[NSURLConnection alloc] initWithRequest:request delegate:self]; //notice how delegate set to self object
	//TODO error handling, what if connection is nil?
}


//the URL connection calls this repeatedly as data arrives
- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)incrementalData {
	if (data==nil) { data = [[NSMutableData alloc] initWithCapacity:2048]; } 
	[data appendData:incrementalData];
}


//the URL connection calls this once all the data has downloaded
- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection {
	//so self data now has the complete image 
    [activity stopAnimating];
	connection=nil;    
    [cafeThumbnail setImage:[UIImage imageWithData:data]];
}

- (void) showImage
{

    iV = [[imageViewer alloc] initWithImage:[UIImage imageWithData:data] andParent:self];
    
    
    //이 똥싸는거를 어떻게 좀 해야할텐데..
    

    [UIView transitionWithView:self.view
                      duration:0.5
                       options:UIViewAnimationOptionTransitionNone
                    animations:
                    ^{
                        iV.frame = CGRectMake(0, 480, 320, 480);
                        [self.view addSubview:iV];
                        [UIView beginAnimations:nil context:NULL];
                        [UIView setAnimationDuration:imageAppearanceDuration];
                        iV.frame = CGRectMake(0,0, 320, 480);
                        [UIView commitAnimations];
                    }
                    completion:^(BOOL finished)
                    {
                        [self performSelector:@selector(makeFrameBigAndHideStatusBar) withObject:nil afterDelay:imageAppearanceDuration];
                    }];
    
}

-(void) makeFrameBigAndHideStatusBar
{
    self.view.frame = CGRectMake(0, 0, 320, 480); 
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];    
}

-(void) makeFrameSmallAndRestoreStatusBar
{
     self.view.frame = CGRectMake(0, 0, 320, annotationDetailBoxHeight); 
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];  
}

-(void) closeImageView
{
    [iV removeFromSuperview];
}

@end