//
//  menuViewController.h
//  stillOpen
//
//  Created by Jae Ho Jeon on 3/25/12.
//  Copyright (c) 2012 Seoul National University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@class ViewController;

#define menuHeight 60
#define menuWidth 320
#define popOutDuration 0.15
#define menuTagWidth 18
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define REVEAL_EDGE 320.0f

// 'REVEAL_EDGE_OVERDRAW' defines the maximum offset that can occur after the 'REVEAL_EDGE' has been reached.
#define REVEAL_EDGE_OVERDRAW 60.0f

// 'REVEAL_VIEW_TRIGGER_LEVEL_LEFT' defines the least amount of offset that needs to be panned until the front view snaps to the right edge.
#define REVEAL_VIEW_TRIGGER_LEVEL_LEFT 125.0f

// 'REVEAL_VIEW_TRIGGER_LEVEL_RIGHT' defines the least amount of translation that needs to be panned until the front view snaps _BACK_ to the left edge.
#define REVEAL_VIEW_TRIGGER_LEVEL_RIGHT 200.0f

// 'VELOCITY_REQUIRED_FOR_QUICK_FLICK' is the minimum speed of the finger required to instantly trigger a reveal/hide.
#define VELOCITY_REQUIRED_FOR_QUICK_FLICK 1300.0f



@interface menuViewController : UIViewController
{
    ViewController * parentViewController;
    BOOL isClosed;
}

@property (nonatomic, retain) UIImageView * addStoreMenu;
@property (nonatomic, retain) UIImageView * toggleCurrentOpenMenu;
@property (nonatomic, retain) UIImageView  * helpMenu;
@property (nonatomic, retain) UILabel * firstDividerBlock;
@property (nonatomic, retain) UILabel * secondDividerBlock;
@property (nonatomic, retain) UILabel * menuTag;




- (void) showMenu;
- (void) hideMenu;
- (void) addStore;
//- (void) menuSwipe:(UISwipeGestureRecognizer * ) inputRecoginzer;
- (void) menuSwipe:(UIPanGestureRecognizer * ) recognizer;
- (id)initWithParentViewController:(ViewController *) inputParentViewController;
- (CGFloat)_calculateOffsetForTranslationInView:(CGFloat)x;
- (float) getConvertedOriginX; 

@end


