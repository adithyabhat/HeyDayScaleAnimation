//
//  HomeTableViewController.m
//  HeydayScaleAnimation
//
//  Created by Adithya H Bhat on 02/06/14.
//

#import "HomeTableViewController.h"
#import "OtherTableViewCell.h"

@implementation HomeTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"OtherTableViewCell" bundle:nil] forCellReuseIdentifier:@"OtherTableViewCell"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OtherTableViewCell *cell = (OtherTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"OtherTableViewCell" forIndexPath:indexPath];
    cell.label.text = [NSString stringWithFormat:@"Cell %d",indexPath.row + 1];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150.0f;
}

@end
