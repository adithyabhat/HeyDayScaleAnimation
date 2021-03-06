//
//  ScalableViewController.m
//  HeydayScaleAnimation
//
//  Created by Adithya H Bhat on 02/06/14.
//

#import "ScaledViewController.h"
#import "ScalableTopViewController.h"

@interface ScaledViewController () <ScalableTopViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *tempImageView;

@end

@implementation ScaledViewController
{
    CGFloat defaultHeight;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Resize view to default height
    CGRect viewFrame = self.view.frame;
    viewFrame.size.height = defaultHeight;
    self.view.frame = viewFrame;
}

#pragma mark - Public methods

- (id)initWithInitialDefaultViewHeight:(CGFloat)height
{
    if ([super init])
    {
        defaultHeight = height;
    }
    return self;
}

- (void)updateViewFrameForScrollContentOffsetY:(CGFloat)value
{
    CGRect viewFrame = self.view.frame;
    
    //Check if view is not visible
    if (value < 0)
    {
        if (value <= -defaultHeight)
        {
            //View is pulled down; Height is to be increased
            viewFrame.origin.y = 0;
            viewFrame.size.height = ABS(value);
            self.view.frame = viewFrame;
        }
        else
        {
            //View is pushed up
            viewFrame.origin.y = -(defaultHeight + value);
            self.view.frame = viewFrame;
        }
    }
    else
    {
        //View is completely hidden
        viewFrame.origin.y = -defaultHeight;
        self.view.frame = viewFrame;
    }
}

- (void)updateViewFrameForScrollContentOffsetY:(CGFloat)value animated:(BOOL)animated
{
    [UIView animateWithDuration:animated ? 0.2f : 0.0f
                     animations:^{
                         [self updateViewFrameForScrollContentOffsetY:value];
                     }];
}

#pragma mark - Delegate methods

- (void)viewWillEnterFullScreen
{
    NSLog(@"viewWillEnterFullScreen");
}

- (void)viewWillExitFullScreen
{
    NSLog(@"viewWillExitFullScreen");
}

- (void)handleLongPressWithGestureRecognizer:(UILongPressGestureRecognizer *)longPressGesturerecognizer
{
    NSLog(@"Long press");
}

- (void)handlePanWithGestureRecognizer:(UIPanGestureRecognizer *)panGesturerecognizer
{
    NSLog(@"Pan");
}

- (void)handleSwipeWithGestureRecognizer:(UISwipeGestureRecognizer *)swipeGesturerecognizer
{
    NSLog(@"swiped");
}

@end
