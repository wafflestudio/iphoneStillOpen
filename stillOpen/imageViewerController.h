//
//  imageViewerController.h
//  stillOpen
//
//  Created by Jae Ho Jeon on 5/14/12.
//  Copyright (c) 2012 Seoul National University. All rights reserved.
//

#import "SlidingMessageViewController.h"

@interface imageViewerController : UIViewController <UIScrollViewDelegate> 
{
    UIScrollView * imageScrollView;
    UIImageView * imageView;    
}

@property (nonatomic, retain) IBOutlet UIScrollView * imageScrollView;
@property (nonatomic, retain) IBOutlet UIImageView * imageView;


- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center;

@end
