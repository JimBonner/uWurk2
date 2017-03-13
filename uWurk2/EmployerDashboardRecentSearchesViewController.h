//
//  EmployerDashboardSavedSearchesViewController.h
//  uWurk2
//
//  Created by Rob Bonner on 1/17/16.
//  Copyright © 2016 Michael Brown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@protocol EmployerDashboardRecentSearchesViewControllerProtocol <NSObject>
-(void)SelectionMade:(NSMutableDictionary*)dict;
@end


@interface EmployerDashboardRecentSearchesViewController : BaseViewController
@property (weak, nonatomic) id<EmployerDashboardRecentSearchesViewControllerProtocol>delegate;

@end
