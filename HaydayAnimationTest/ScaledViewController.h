//
//  ScalableViewController.h
//  HaydayAnimationTest2
//
//  Created by Adithya H Bhat on 02/06/14.
//  Copyright (c) 2014 Robosoft Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScaledViewController : UIViewController

- (id)initWithInitialDefaultViewHeight:(CGFloat)height;

- (void)updateViewFrameForScrollContentOffsetY:(CGFloat)value;
- (void)updateViewFrameForScrollContentOffsetY:(CGFloat)value animated:(BOOL)animated;

@end
