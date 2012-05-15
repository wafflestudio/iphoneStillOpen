//
//  imageViewer.h
//  stillOpen
//
//  Created by Jae Ho Jeon on 5/13/12.
//  Copyright (c) 2012 Seoul National University. All rights reserved.
//

#import "SlidingMessageViewController.h"

@interface imageViewer : UIScrollView <UIScrollViewDelegate>
{
    UIImageView * imageView;
    UIImage * imageToDisplay;
    UIView * navigationBar;
    BOOL statusAndNavigation; // YES가 보이는것..
    CGFloat doubleClickZoomScale;
    id parent;
}

-(id) initWithImage:(UIImage * ) img andParent:(id) parentViewController;
-(void) toggleStatusAndNavigationBar;
-(void) hideNavigationBar;
-(void) closeView;

@end
