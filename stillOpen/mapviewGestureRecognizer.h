//
//  mapviewGestureRecognizer.h
//  stillOpen
//
//  Created by Jae Ho Jeon on 5/16/12.
//  Copyright (c) 2012 Seoul National University. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^TouchesEventBlock)(NSSet * touches, UIEvent * event);

@interface mapviewGestureRecognizer : UIGestureRecognizer
{
    TouchesEventBlock touchesBeganCallback;
    BOOL mapMoved;
}

@property (copy) TouchesEventBlock touchesBeganCallback;

@end
