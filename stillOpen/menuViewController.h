//
//  menuViewController.h
//  stillOpen
//
//  Created by Jae Ho Jeon on 3/25/12.
//  Copyright (c) 2012 Seoul National University. All rights reserved.
//


#define menuTagWidth 18

#import "SlidingMessageViewController.h"

@interface menuViewController : SlidingMessageViewController
{
    id parent;
    UIImageView * addStoreMenu;
    UIImageView * toggleCurrentOpenMenu;
    UIImageView  * helpMenu;
    UILabel * firstDividerBlock;
    UILabel * secondDividerBlock;
    UILabel * menuTag;
}

- (id)initWithParentViewController:(id) inputParentViewController;

@end


