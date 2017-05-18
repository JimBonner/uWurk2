//
//  ProfileStepEdit3ViewController.h
//  uWurk2
//
//  Created by Avery Bonner on 9/16/15.
//  Copyright (c) 2015 Michael Brown. All rights reserved.
//  Copyright (c) 2017 Jim Bonner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "ListMultiSelectorTableViewController.h"

@interface ProfileEditStep3ViewController : BaseViewController <ListMultiSelectorTableViewControllerProtocol>

@property (nonatomic, strong) NSMutableDictionary *langDict;

@end
