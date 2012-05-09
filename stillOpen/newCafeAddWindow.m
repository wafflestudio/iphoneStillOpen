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


-(id) init
{
    if (self = [super initBoxWithWidth:320 height:newCafeAddWindowHeight color:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.60] animationDuration:0.36 fastAnimationDuration:0.1 fromX:0 fromY:-newCafeAddWindowHeight toX:0 toY:0])
    {
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, cafeAddTopMargin, 320 - cafeAddLeftRightMargin, 20)];
        titleLabel.text = @"카페를 추가해주세요";
        titleLabel.font = [UIFont systemFontOfSize:20];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = UITextAlignmentRight;
        
        titleLabel.backgroundColor = [UIColor clearColor];
        [self.view addSubview:titleLabel];
        
        
    }
    
    return self;
}

- (void) setWithAnnotation:(storeAnnotation *) inputAnnotation
{
    
}

        
        
        
@end
