//
//  ScalableViewController.h
//  HeydayScaleAnimation
//
//  Created by Adithya H Bhat on 02/06/14.
//

/*
 This is the controller, whose view is scaled in the ScalableTopViewController. 
 
 For every update of table views (in the ScalableTopViewController instance) scroll content offset Y,
 updateViewFrameForScrollContentOffsetY method will be called. Perform the necessary view updates
 based on the offset value.
 */

#import <UIKit/UIKit.h>

@interface ScaledViewController : UIViewController

- (id)initWithInitialDefaultViewHeight:(CGFloat)height;

- (void)updateViewFrameForScrollContentOffsetY:(CGFloat)value;
- (void)updateViewFrameForScrollContentOffsetY:(CGFloat)value animated:(BOOL)animated;

@end
