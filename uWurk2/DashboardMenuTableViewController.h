//
//  EmployeeDashboardMenuTableViewController.h
//  uWurk
//
//  Created by Rob Bonner on 5/9/15.
//  Copyright (c) 2015 Blueplate Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DashboardMenuTableViewController : UITableViewController

@property (nonatomic, retain) UINavigationController *delegateNavigationController;
@property (nonatomic, retain) NSString *menuFileName;

@end
