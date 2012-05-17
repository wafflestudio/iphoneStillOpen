//
//  newCafeAddWindow.m
//  stillOpen
//
//  Created by Jae Ho Jeon on 5/8/12.
//  Copyright (c) 2012 Seoul National University. All rights reserved.
//

#import "newCafeAddWindow.h"
#define newCafeAddWindowHeight 200
#define cafeAddLeftRightMargin 15
#define cafeAddTopMargin 18
#define cafeAddBottomMargin 15


@implementation newCafeAddWindow


-(id) initWithParentViewController:(id) pVC
{
    if (self = [super initBoxWithWidth:320 height:newCafeAddWindowHeight color:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.60] animationDuration:0.36 fastAnimationDuration:0.1 fromX:0 fromY:-newCafeAddWindowHeight toX:0 toY:0 setHidden:YES])
    {
        
        parent = pVC;
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, cafeAddTopMargin, 320 - cafeAddLeftRightMargin, 20)];
        titleLabel.text = @"카페를 추가해주세요";
        titleLabel.font = [UIFont systemFontOfSize:20];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = UITextAlignmentRight;
        titleLabel.backgroundColor = [UIColor clearColor];
        [self.view addSubview:titleLabel];

        
        cafeNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 60, 80, 26)];
        cafeNameLabel.text = @"카페 이름";
        cafeNameLabel.textColor = [UIColor whiteColor];
        cafeNameLabel.backgroundColor = [UIColor clearColor];
        [self.view addSubview:cafeNameLabel];
        
        
        openTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 90, 80, 26)];
        openTimeLabel.text = @"오픈시간";
        openTimeLabel.textColor = [UIColor whiteColor];
        openTimeLabel.backgroundColor = [UIColor clearColor];
        [self.view addSubview:openTimeLabel];

        openTime = [[UITextField alloc] initWithFrame:CGRectMake(120, 90, 185, 26)];
        openTime.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:openTime];
        
        closeTime = [[UITextField alloc] initWithFrame:CGRectMake(120, 120, 185, 26)];
        closeTime.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:closeTime];

        
        
        closeTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 120, 80, 26)];
        closeTimeLabel.text = @"폐점시간";
        closeTimeLabel.textColor = [UIColor whiteColor];
        closeTimeLabel.backgroundColor = [UIColor clearColor];
        [self.view addSubview:closeTimeLabel];
        
        
        
        
        cafeName = [[UITextField alloc] initWithFrame:CGRectMake(120, 60, 185, 26)];
        cafeName.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:cafeName];
        
        
        sendButton = [[UIButton alloc] initWithFrame:CGRectMake(205, 155, 100, 26)];
        sendButton.backgroundColor = [UIColor whiteColor];
        sendButton.titleLabel.font = [UIFont systemFontOfSize:14];
        
        [sendButton setTitle:@"카페 추가하기!" forState:UIControlStateNormal];
        [sendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [sendButton addTarget:self action:@selector(sendToServer) forControlEvents:UIControlEventTouchUpInside];
        [sendButton setUserInteractionEnabled:YES];
        [self.view addSubview:sendButton];
        
        [self.view setHidden:YES];
        
        
    }
    
    return self;
}


- (void) sendToServer
{
    [annotation setTitle:cafeName.text];
    [annotation setOpentime:[openTime.text intValue]];
    [annotation setClosetime:[closeTime.text intValue]];
    
    [annotation setIsUserAddedAnnotation:NO];
    
    requestHTTP * req = [[requestHTTP alloc] initWithURL:[NSURL URLWithString:@"http://mintengine.com:3000/stores.json"]];
    [req setStoreValue:annotation.title forKey:@"Name"];
    [req setStoreValue:openTime.text forKey:@"Opentime"];
    [req setStoreValue:closeTime.text forKey:@"Closetime"];
    [req setStoreValue:[NSString stringWithFormat:@"%f", annotation.coordinate.latitude] forKey:@"Latitude"];
    [req setStoreValue:[NSString stringWithFormat:@"%f", annotation.coordinate.longitude]  forKey:@"Longitude"];
    [req synchronousRequestWithPost];
    
    [cafeName resignFirstResponder];
    [openTime resignFirstResponder];
    [closeTime resignFirstResponder];

    
    [parent performSelector:@selector(completeAddingCafe:) withObject:annotation];
    

    [self hideBox];
}

- (void) setWithAnnotation:(storeAnnotation *) inputAnnotation
{
    annotation = inputAnnotation;
}

- (void) cancelCafeAdd
{
    cafeName.text = nil;
    annotation = nil;
    [cafeName resignFirstResponder];
    [self hideBox];
}

        
        
        
@end
