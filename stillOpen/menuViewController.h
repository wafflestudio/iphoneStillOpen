//
//  menuViewController.h
//  stillOpen
//
//  Created by Jae Ho Jeon on 3/25/12.
//  Copyright (c) 2012 Seoul National University. All rights reserved.
//

#import <UIKit/UIKit.h>
#define menuHeight 60
#define popOutDuration 0.45
#define menuTagWidth 18
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]


@interface menuViewController : UIViewController

@property (nonatomic, retain) UILabel * addStoreMenu;
@property (nonatomic, retain) UILabel * secondMenu;
@property (nonatomic, retain) UILabel * thirdMenu;
@property (nonatomic, retain) UILabel * firstDividerBlock;
@property (nonatomic, retain) UILabel * secondDividerBlock;
@property (nonatomic, retain) UILabel * menuTag;



- (void) showMenu;
- (void) hideMenu;
- (void) addStore;
- (void) menuSwipe:(UISwipeGestureRecognizer * ) inputRecoginzer;


@end


