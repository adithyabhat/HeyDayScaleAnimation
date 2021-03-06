//
//  AppDelegate.m
//  HeydayScaleAnimation
//
//  Created by Adithya H Bhat on 02/06/14.
//

#import "AppDelegate.h"
#import "HomeTableViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    HomeTableViewController *controller = [[HomeTableViewController alloc] init];
    [self.window setRootViewController:controller];
    
    [self.window makeKeyAndVisible];
    return YES;
}

@end
