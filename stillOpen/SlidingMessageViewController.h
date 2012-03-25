#define boxHeight 110
#define animationDuration 0.45

#import <UIKit/UIKit.h>
#import "storeAnnotation.h"


@interface SlidingMessageViewController : UIViewController
{
}

@property (nonatomic, assign) storeAnnotation * annotation;
@property (nonatomic, copy) UILabel * msgLabel;
@property (nonatomic, copy) UILabel * titleLabel;
@property (nonatomic, copy) UILabel * distanceLabel;



-(id)initWithAnnotation:(storeAnnotation *)inputAnnotation;
- (void)hideMsg;
- (void)showMsg;
- (void)showMsgWithDelay:(int)delay;

@end
