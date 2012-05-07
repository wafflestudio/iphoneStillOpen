//
//  annotationDetailViewer.m
//  stillOpen
//
//  Created by Jae Ho Jeon on 5/5/12.
//  Copyright (c) 2012 Seoul National University. All rights reserved.
//

#import "annotationDetailViewer.h"
#define annotationDetailBoxHeight 125

@implementation annotationDetailViewer
@synthesize distanceLabel;

-(id) init
{
    if (self = [super initBoxWithWidth:320 height:annotationDetailBoxHeight color:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.60] animationDuration:0.36 fastAnimationDuration:0.1 fromX:0 fromY:-annotationDetailBoxHeight toX:0 toY:0])
    {
        
        // 가게 이름
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 4, 308, 40)];
        titleLabel.font = [UIFont fontWithName:@"Futura" size:23];
        titleLabel.textAlignment = UITextAlignmentRight;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        [self.view addSubview:titleLabel];
        
        
//        // 가게 설명
//        msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 285, 90)];
//        msgLabel.font = [UIFont fontWithName:@"Futura" size:13];
//        msgLabel.textAlignment = UITextAlignmentRight;
//        msgLabel.textColor = [UIColor whiteColor];
//        msgLabel.backgroundColor = [UIColor clearColor];
//        [self.view addSubview:msgLabel];
        
        
        // 현재 위치로부터 거리
        distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 39, 307, 28)];
        distanceLabel.numberOfLines = 0;
        distanceLabel.font = [UIFont systemFontOfSize:11.5];
        distanceLabel.textAlignment = UITextAlignmentRight;
        distanceLabel.textColor = [UIColor whiteColor];
        distanceLabel.backgroundColor = [UIColor clearColor];
        distanceLabel.numberOfLines = 0;
        [self.view addSubview:distanceLabel];
        
        
        // 가게 섬네일 뷰
        UIImage * cafeImage = [UIImage imageNamed:@"cafe.jpeg"];        
        cafeThumbnail = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12, 132, 99)];
        [cafeThumbnail setImage:cafeImage];
        [self.view addSubview:cafeThumbnail];
        
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
        
        quietLevel = [[UILabel alloc] initWithFrame:CGRectMake(155, 92, 150, 2)];
        quietLevel.backgroundColor = [UIColor colorWithRed:135.0/255 green:163.0/255 blue:225.0/255 alpha:1];
        [self.view addSubview:quietLevel];
        
        noiseLevel = [[UILabel alloc] initWithFrame:CGRectMake(155, 92, 60, 2)];
        noiseLevel.backgroundColor = [UIColor colorWithRed:244.0/255 green:62.0/255 blue:86.0/255 alpha:1];
        [self.view addSubview:noiseLevel];
        
        quietLabel = [[UILabel alloc] initWithFrame:CGRectMake(269, 100, 45, 10)];
        quietLabel.text = @"조용해요";
        quietLabel.textColor = [UIColor whiteColor];
        quietLabel.backgroundColor = [UIColor clearColor];
        quietLabel.font = [UIFont systemFontOfSize:10];
        
        [self.view addSubview:quietLabel];
        
        noiseLabel = [[UILabel alloc] initWithFrame:CGRectMake(155, 100, 45, 10)];        
        noiseLabel.text = @"시끄러워요";
        noiseLabel.textColor = [UIColor whiteColor];
        noiseLabel.backgroundColor = [UIColor clearColor];
        noiseLabel.font = [UIFont systemFontOfSize:10];
        
        [self.view addSubview:noiseLabel];
        

        
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
    annotation = inputAnnotation;
    titleLabel.text = annotation.title;
    msgLabel.text = annotation.description;
    distanceLabel.text = @"";

    if([annotation isKindOfClass:[MKUserLocation class]])
    {
        titleLabel.textAlignment = UITextAlignmentCenter;
        msgLabel.text = nil;
        distanceLabel.text = @"상점을 이곳에 추가하시려면 파란색 버튼을 누르세요";
        distanceLabel.textAlignment = UITextAlignmentCenter;
    }

}




@end