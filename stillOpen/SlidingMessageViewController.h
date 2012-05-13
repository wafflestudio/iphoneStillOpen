
#import <UIKit/UIKit.h>
#import "storeAnnotation.h"
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

// 'REVEAL_EDGE_OVERDRAW' defines the maximum offset that can occur after the 'REVEAL_EDGE' has been reached.
// 'REVEAL_VIEW_TRIGGER_LEVEL_LEFT' defines the least amount of offset that needs to be panned until the front view snaps to the right edge.
// 'REVEAL_VIEW_TRIGGER_LEVEL_RIGHT' defines the least amount of translation that needs to be panned until the front view snaps _BACK_ to the left edge.
// 'VELOCITY_REQUIRED_FOR_QUICK_FLICK' is the minimum speed of the finger required to instantly trigger a reveal/hide.

@interface SlidingMessageViewController : UIViewController
{
    int boxWidth;
    int boxHeight;
    CGFloat animationDuration;
    CGFloat fastAnimationDuration;
    UIColor * boxColor;
    BOOL setHidden;
    
    int fromX;
    int fromY;
    int toX;
    int toY;
    int isClosed;
    
    // ------------------- // 이 아래로 draggable box
    
    CGFloat REVEAL_EDGE;
    CGFloat REVEAL_EDGE_OVERDRAW;
    CGFloat REVEAL_VIEW_TRIGGER_LEVEL_LEFT_OR_TOP;
    CGFloat REVEAL_VIEW_TRIGGER_LEVEL_RIGHT_OR_BOTTOM;
    CGFloat VELOCITY_REQUIRED_FOR_QUICK_FLICK;
}


- (id)initBoxWithWidth:(int)width height:(int)height color:(UIColor * ) cl animationDuration:(CGFloat)duration fastAnimationDuration:(CGFloat)duration2 fromX:(int) fX fromY:(int) fY toX:(int) tX toY:(int) tY setHidden:(BOOL) hd;

- (id)initDraggableBoxWithWidth:(int)width height:(int)height color:(UIColor * ) cl animationDuration:(CGFloat)duration fastAnimationDuration:(CGFloat)duration2 fromX:(int) fX fromY:(int) fY toX:(int) tX toY:(int) tY setHidden:(BOOL) hd revealEdge:(CGFloat) rE overdraw:(CGFloat) overdraw leftTopTrigger:(CGFloat) lTT rightBottomTrigger:(CGFloat) rBT quickFlickVelocity:(CGFloat) qFV;

- (void)showBox;
- (void)showBoxFast;
- (void)hideBox;
- (void)hideBoxFast;
- (void) makeInvisible;

- (CGFloat) getConvertedOriginX;
- (CGFloat)calculateOffsetForTranslationInView:(CGFloat)x;

@end
