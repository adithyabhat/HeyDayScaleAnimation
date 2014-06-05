//
//  HomePageTableViewController.m
//  HeydayScaleAnimation
//
//  Created by Adithya H Bhat on 02/06/14.
//

#import "ScalableTopViewController.h"
#import "ScaledViewController.h"
#import <objc/message.h>

static CGFloat SSHeaderViewIntialHeight = 200.0f;
static CGFloat SSPartialToFullscreenAnimationDuration = 0.6f;
static CGFloat SSFullScreenToPartialAnimationDuration = 0.6f;
static CGFloat SSPullToFullscreeThresholdValue_4_Screen = 285.0f;
static CGFloat SSPullToFullscreeThresholdValue_3_5_Screen = 250.0f;

@interface ScalableTopViewController () <UIGestureRecognizerDelegate>

@end

@implementation ScalableTopViewController
{
    ScaledViewController *scalableController;
    BOOL fullScreenMode;
}

#pragma mark - Table view data source

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUpTableViewAndScalableView];
    [self addGestureRecognizers];
    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark - Public methods

- (void)exitFullScreenMode
{
    self.tableView.scrollEnabled = YES;
    fullScreenMode = NO;
    
    [self callDelegateWithMessage:@"viewWillExitFullScreen" withObject:NULL];
    [UIView animateWithDuration:SSFullScreenToPartialAnimationDuration
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self.tableView setContentOffset:CGPointMake(self.tableView.contentOffset.x, -SSHeaderViewIntialHeight)];
                     }
                     completion:^(BOOL finished) {
                         [self callDelegateWithMessage:@"viewDidExitFullScreen" withObject:NULL];
                     }];
}

#pragma mark - Private helper methods

BOOL isScreen4Inch()
{
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    return CGRectGetHeight(screenBounds) / CGRectGetWidth(screenBounds) > 1.5;
}

- (void)addGestureRecognizers
{
    //Gestures on tableview
    UISwipeGestureRecognizer *leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    
    UISwipeGestureRecognizer *rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    
    UILongPressGestureRecognizer *longPressGestureRecognier = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    panGestureRecognizer.delegate = self;
    
    self.tableView.gestureRecognizers = [self.tableView.gestureRecognizers arrayByAddingObjectsFromArray:@[leftSwipeGestureRecognizer,
                                                                                                           rightSwipeGestureRecognizer,
                                                                                                           longPressGestureRecognier,
                                                                                                           panGestureRecognizer]];
}

- (void)setUpTableViewAndScalableView
{
    scalableController = [[ScaledViewController alloc] initWithInitialDefaultViewHeight:SSHeaderViewIntialHeight];
    [scalableController willMoveToParentViewController:self];
    [self.view addSubview:scalableController.view];
    scalableController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    scalableController.view.userInteractionEnabled = NO;
    [self addChildViewController:scalableController];
    [scalableController didMoveToParentViewController:self];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    UIEdgeInsets tableViewInsets = self.tableView.contentInset;
    tableViewInsets.top += SSHeaderViewIntialHeight;
    self.tableView.contentInset = tableViewInsets;
    
    [self.view addSubview:self.tableView];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(UITableView *)tableView change:(NSDictionary *)change context:(void *)context
{
    [scalableController updateViewFrameForScrollContentOffsetY:tableView.contentOffset.y];
}

//Method validates if the receiver responds to selector or not; message is not sent if receiver doesn't.
- (void)callDelegateWithMessage:(NSString *)messageString withObject:(id)object
{
    SEL selector = NSSelectorFromString(messageString);
    if ([scalableController respondsToSelector:selector])
    {
        objc_msgSend(scalableController, selector, object);
    }
}

- (BOOL)isExitFullScreenGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
{
    BOOL returnValue = NO;
    if (fullScreenMode && [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]])
    {
        CGPoint velocity = [(UIPanGestureRecognizer *)gestureRecognizer velocityInView:scalableController.view];
        returnValue = (fabs(velocity.y) > fabs(velocity.x)) && (velocity.y < 0);
    }
    return returnValue;
}

- (BOOL)canPassToScalableViewGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
{
    return [scalableController.view pointInside:[gestureRecognizer locationInView:scalableController.view] withEvent:nil];
}

#pragma mark - Gesture recognizers

- (void)handleGesture:(UIGestureRecognizer *)gestureRecognizer
{
    static NSDictionary *delegateMethodNameForGestureRecognizer;
    if (!delegateMethodNameForGestureRecognizer)
    {
        delegateMethodNameForGestureRecognizer = @{@"UISwipeGestureRecognizer" : @"handleSwipeWithGestureRecognizer:",
                                                   @"UIPanGestureRecognizer" : @"handlePanWithGestureRecognizer:",
                                                   @"UILongPressGestureRecognizer" : @"handleLongPressWithGestureRecognizer:"};
    }
    
    if ([self canPassToScalableViewGestureRecognizer:gestureRecognizer])
    {
        [self isExitFullScreenGestureRecognizer:gestureRecognizer] ?
        [self exitFullScreenMode] :
        [self callDelegateWithMessage:delegateMethodNameForGestureRecognizer[NSStringFromClass([gestureRecognizer class])]
                           withObject:gestureRecognizer];
    }
}

#pragma mark - Tableview datasource and delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //Subclass should override this and return expected values
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //Subclass should override this and return expected values
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Subclass should override this and return expected values
    return nil;
}

#pragma mark - Scrollview delegate

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                     withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (self.tableView.contentOffset.y < -(isScreen4Inch() ? SSPullToFullscreeThresholdValue_4_Screen : SSPullToFullscreeThresholdValue_3_5_Screen))
    {
        self.tableView.scrollEnabled = NO;
        fullScreenMode = YES;
        
        [self callDelegateWithMessage:@"viewWillEnterFullScreen" withObject:NULL];
        
        *targetContentOffset = CGPointMake(scrollView.contentOffset.x, -CGRectGetHeight(self.view.bounds));

        [UIView animateWithDuration:SSPartialToFullscreenAnimationDuration
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [self.tableView setContentOffset:*targetContentOffset];
                         }
                         completion:^(BOOL finished) {
                             [self callDelegateWithMessage:@"viewDidEnterFullScreen" withObject:NULL];
                         }];
    }
}

#pragma mark - Gesture delegates

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]])
    {
        return YES;
    }
    return NO;
}

@end
