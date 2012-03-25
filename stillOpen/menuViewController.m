//
//  menuViewController.m
//  stillOpen
//
//  Created by Jae Ho Jeon on 3/25/12.
//  Copyright (c) 2012 Seoul National University. All rights reserved.
//

#import "menuViewController.h"

@implementation menuViewController

@synthesize addStoreMenu, secondMenu, thirdMenu, firstDividerBlock, secondDividerBlock, menuTag;

- (id)init
{
    if (self = [super init])
    {
        UISwipeGestureRecognizer * menuSwipeRecognizer;
        
        self.view = [[UIView alloc] initWithFrame:CGRectMake(-320, 480 - menuHeight- 20, 320 + menuTagWidth, menuHeight)];
        self.view.userInteractionEnabled = YES;
        

        menuSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(menuSwipe:)];
        menuSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
        [self.view addGestureRecognizer:menuSwipeRecognizer];
        
        menuSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(menuSwipe:)];
        menuSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
        [self.view addGestureRecognizer:menuSwipeRecognizer];
        
        
        // 방향마다 하나의 레코그나이저를 추가해야 한다.
        
        
        [self.view setBackgroundColor:[UIColor blackColor]];
        [self.view setAlpha:0.8];
        
        
        addStoreMenu = [[UILabel alloc] initWithFrame:CGRectMake(10,10,93,40)];
        addStoreMenu.userInteractionEnabled = YES;
        UITapGestureRecognizer * addStoreRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self 
                                                                                              action:@selector(addStore)];
        [addStoreMenu addGestureRecognizer:addStoreRecognizer];
        addStoreMenu.backgroundColor = [UIColor clearColor];
        addStoreMenu.text = @"가게 추가하기";
        addStoreMenu.font = [UIFont boldSystemFontOfSize:15];
        addStoreMenu.textAlignment = UITextAlignmentCenter;
        addStoreMenu.textColor = [UIColor whiteColor];
        
        
        
        [self.view addSubview:addStoreMenu];
        
        secondMenu = [[UILabel alloc] initWithFrame:CGRectMake(113, 10, 93, 40)];
        secondMenu.backgroundColor = [UIColor clearColor];
        
        [self.view addSubview:secondMenu];
        
        thirdMenu = [[UILabel alloc] initWithFrame:CGRectMake(216, 10, 93, 40)];
        thirdMenu.backgroundColor = [UIColor clearColor];
        
        [self.view addSubview:thirdMenu];
        
        firstDividerBlock = [[UILabel alloc] initWithFrame:CGRectMake(107, 15, 2, 30)];
        firstDividerBlock.backgroundColor = [UIColor whiteColor];
        [firstDividerBlock setAlpha:0.6];
        
        [self.view addSubview:firstDividerBlock];
        
        secondDividerBlock = [[UILabel alloc] initWithFrame:CGRectMake(210, 15, 2, 30)];
        secondDividerBlock.backgroundColor = [UIColor whiteColor];
        [secondDividerBlock setAlpha:0.6];
        
        [self.view addSubview:secondDividerBlock];
        
        menuTag = [[UILabel alloc] initWithFrame:CGRectMake(320, 0, menuTagWidth, menuHeight)];
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
    NSLog(@"Hello WOrld!");
}

- (void) menuSwipe:(UISwipeGestureRecognizer * ) inputRecoginzer
{
    if ([inputRecoginzer direction] == UISwipeGestureRecognizerDirectionLeft)
        [self hideMenu];
    else if ([inputRecoginzer direction] == UISwipeGestureRecognizerDirectionRight)
        [self showMenu];
    
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
    
    frame.origin.x = -320;
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
