//
//  HomePageTableViewController.h
//  HaydayAnimationTest
//
//  Created by Adithya H Bhat on 02/06/14.
//  Copyright (c) 2014 Robosoft Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScalableTopViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

- (void)exitFullScreenMode;

@end
