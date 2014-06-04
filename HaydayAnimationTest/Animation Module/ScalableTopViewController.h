//
//  HomePageTableViewController.h
//  HeydayScaleAnimation
//
//  Created by Adithya H Bhat on 02/06/14.
//

/*
 This controller is resposible for implementing the pull to scale kind of animation.
 This class is to be subclassed and the necessary table view delegate methods are 
 to be implemented.
 */

#import <UIKit/UIKit.h>

@interface ScalableTopViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

- (void)exitFullScreenMode;

@end