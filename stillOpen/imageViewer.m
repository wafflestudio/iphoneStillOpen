//
//  imageViewer.m
//  stillOpen
//
//  Created by Jae Ho Jeon on 5/13/12.
//  Copyright (c) 2012 Seoul National University. All rights reserved.
//

#import "imageViewer.h"
#define animationDuration 0.3
#define ZOOM_STEP 1.5
#define ZOOM_VIEW_TAG 100

@implementation imageViewer



-(id) initWithImage:(UIImage * ) img andParent:(id) parentViewController
{
    
    if (self = [super initWithFrame:CGRectMake(0,0, 320, 480)])
    {
        
        parent = parentViewController;
        self.backgroundColor = [UIColor blackColor];
        
        imageToDisplay = img;
        imageView = [[UIImageView alloc] initWithImage:imageToDisplay];        
        [self addSubview:imageView];
        
        
        
        // add gesture recognizers to the image view
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        
        [singleTap setNumberOfTapsRequired:1];
        [doubleTap setNumberOfTapsRequired:2];
        [singleTap requireGestureRecognizerToFail:doubleTap];
        
        
        [imageView addGestureRecognizer:singleTap];
        [imageView addGestureRecognizer:doubleTap];
        [imageView setUserInteractionEnabled:YES];
        
        
        CGSize imageSize = imageView.image.size;
        CGSize maxSize = self.frame.size;
        CGFloat widthRatio = maxSize.width / imageSize.width;
        CGFloat heightRatio = maxSize.height / imageSize.height;
        CGFloat initialZoom = (widthRatio > heightRatio ) ? heightRatio : widthRatio;
        
        self.delegate = self;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.minimumZoomScale = initialZoom;
        self.maximumZoomScale = 1.0f;
        doubleClickZoomScale = 0.5f;
        self.contentSize = imageSize;
        self.zoomScale = initialZoom;
        
        navigationBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        [navigationBar setBackgroundColor:[UIColor whiteColor]];
        [navigationBar setHidden:YES];
        [navigationBar setUserInteractionEnabled:YES];
        UITapGestureRecognizer * navTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeView)];
        [navigationBar addGestureRecognizer:navTap];
        
        [self addSubview:navigationBar];
        
    }   
    
    return self;
}

-(UIView * ) viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imageView;
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    navigationBar.frame = CGRectMake(0 + scrollView.contentOffset.x, 0 + scrollView.contentOffset.y, 320, 40);
    //  이거다..!!!
}

-(void) layoutSubviews
{
    [super layoutSubviews];
    
    CGSize boundsSize = self.bounds.size;
    CGRect imageFrameToCenter = imageView.frame;
    
    if (imageFrameToCenter.size.width < boundsSize.width) 
    {
        imageFrameToCenter.origin.x = (boundsSize.width - imageFrameToCenter.size.width) / 2;
    }
    else 
    {
        imageFrameToCenter.origin.x = 0;
    }
    
    if (imageFrameToCenter.size.height < boundsSize.height)
    {
        imageFrameToCenter.origin.y = (boundsSize.height - imageFrameToCenter.size.height) / 2;
    }
    else
    {   
        imageFrameToCenter.origin.y = 0;
    }
    imageView.frame = imageFrameToCenter;
}


- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer {

    [self toggleStatusAndNavigationBar];
    
}

- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer {

    
        if (self.zoomScale == self.minimumZoomScale)
            [self setZoomScale:doubleClickZoomScale animated:YES];
        else if (self.zoomScale == doubleClickZoomScale)
            [self setZoomScale:self.minimumZoomScale animated:YES];
        else
            [self setZoomScale:doubleClickZoomScale animated:YES];
    
}


//- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
//    return [self viewWithTag:ZOOM_VIEW_TAG];
//}

-(void) toggleStatusAndNavigationBar
{
    if (statusAndNavigation)
    {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
        
        [UIView transitionWithView:self
                          duration:animationDuration
                           options:UIViewAnimationTransitionNone
                        animations:
                                 ^{
                                     
                                     [UIView beginAnimations:nil context:NULL];
                                     [UIView setAnimationDuration:0.5];
                                     [navigationBar setAlpha:0];
                                     [UIView commitAnimations];
                                     [self performSelector:@selector(hideNavigationBar) withObject:nil afterDelay:animationDuration];
                                 }
                        completion:nil];
        

        statusAndNavigation = NO;
    }
    else 
    {
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
        [navigationBar setHidden:NO];
        [UIView transitionWithView:self
                          duration:animationDuration
                           options:UIViewAnimationTransitionNone
                        animations:
         ^{
             
             [UIView beginAnimations:nil context:NULL];
             [UIView setAnimationDuration:animationDuration];
             [navigationBar setAlpha:1];
             [UIView commitAnimations];
         }
                        completion:nil];
        
        statusAndNavigation = YES;        
    }
}

-(void) hideNavigationBar
{
    [navigationBar setHidden:YES];
}


-(void) closeView
{
    [parent performSelector:@selector(makeFrameSmallAndRestoreStatusBar)];
    [navigationBar setHidden:YES];
    
    [UIView transitionWithView:self
                      duration:0.5
                       options:UIViewAnimationOptionTransitionNone
                    animations:
     ^{
         [UIView beginAnimations:nil context:NULL];
         [UIView setAnimationDuration:0.5];
         self.frame = CGRectMake(0,480, 320, 480);
         [UIView commitAnimations];
     }
                    completion:^(BOOL finished)
     {
         [parent performSelector:@selector(closeImageView) withObject:nil afterDelay:0.5];
     }];

}


@end
