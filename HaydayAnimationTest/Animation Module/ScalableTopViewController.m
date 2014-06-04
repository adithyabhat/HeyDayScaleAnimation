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

@implementation ScalableTopViewController
{
    ScaledViewController *scalableController;
}

#pragma mark - Table view data source

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor lightGrayColor];
    
    [self setUpTableViewAndScalableView];
    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark - Private helper methods

BOOL isScreen4Inch()
{
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    return CGRectGetHeight(screenBounds) / CGRectGetWidth(screenBounds) > 1.5;
}

- (void)setUpTableViewAndScalableView
{
    scalableController = [[ScaledViewController alloc] initWithInitialDefaultViewHeight:SSHeaderViewIntialHeight];
    [scalableController willMoveToParentViewController:self];
    [self.view addSubview:scalableController.view];
    scalableController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
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

- (void)exitFullScreenMode
{
    self.tableView.scrollEnabled = YES;
    self.tableView.bounces = YES;
    self.tableView.userInteractionEnabled = !(scalableController.view.userInteractionEnabled = NO);
    
    [self callDelegateWithMessage:@"viewWillExitFullScreen"];
    [UIView animateWithDuration:SSFullScreenToPartialAnimationDuration
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self.tableView setContentOffset:CGPointMake(self.tableView.contentOffset.x, -SSHeaderViewIntialHeight)];
                     }
                     completion:^(BOOL finished) {
                         [self callDelegateWithMessage:@"viewDidExitFullScreen"];
                     }];
}

- (void)callDelegateWithMessage:(NSString *)messageString
{
    SEL selector = NSSelectorFromString(messageString);
    if ([scalableController respondsToSelector:selector])
    {
        objc_msgSend(scalableController, selector, NULL);
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
        self.tableView.bounces = NO;
        self.tableView.userInteractionEnabled = !(scalableController.view.userInteractionEnabled = YES);
        
        [self callDelegateWithMessage:@"viewWillEnterFullScreen"];
        [UIView animateWithDuration:SSPartialToFullscreenAnimationDuration
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [self.tableView setContentOffset:CGPointMake(scrollView.contentOffset.x,
                                                                          -CGRectGetHeight(self.view.bounds))];
                         }
                         completion:^(BOOL finished) {
                             [self callDelegateWithMessage:@"viewDidEnterFullScreen"];
                         }];
        
        *targetContentOffset = CGPointMake(self.tableView.contentOffset.x, -CGRectGetHeight(self.view.bounds));
    }
}


@end
