//
//  EmployerDashboardSavedSearchesViewController.h
//  uWurk2
//
//  Created by Rob Bonner on 1/17/16.
//  Copyright © 2016 Michael Brown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@protocol EmployerDashboardSavedSearchesViewControllerProtocol <NSObject>
-(void)SelectionMade:(NSMutableDictionary*)dict;
@end


@interface EmployerDashboardSavedSearchesViewController : BaseViewController
@property (weak, nonatomic) id<EmployerDashboardSavedSearchesViewControllerProtocol>delegate;

@end
