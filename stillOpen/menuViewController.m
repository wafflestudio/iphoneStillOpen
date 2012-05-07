//
//  menuViewController.m
//  stillOpen
//
//  Created by Jae Ho Jeon on 3/25/12.
//  Copyright (c) 2012 Seoul National University. All rights reserved.
//

#import "menuViewController.h"

@implementation menuViewController


- (id)initWithParentViewController:(ViewController *) inputParentViewController
{
    if (self = [super initDraggableBoxWithWidth:320 + menuTagWidth height:60 color:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5] animationDuration:0.36 fastAnimationDuration:0.17 fromX:-320 fromY:400 toX:0 tY:400 revealEdge:320 overdraw:50 leftTopTrigger:50 rightBottomTrigger:270 quickFlickVelocity:1300])
    {
        
        parentViewController = inputParentViewController;
        
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
        
        
        
        menuTag = [[UILabel alloc] initWithFrame:CGRectMake(320, 0, menuTagWidth, 60)];
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
    [parentViewController setPlusMenuToggled:YES];
    [parentViewController checkAndAddStore:parentViewController.mapView];
    [parentViewController hideCalloutView];
    [self hideBox];
}


@end



