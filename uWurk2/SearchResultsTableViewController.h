//
//  SearchResultsTableViewController.h
//  uWurk2
//
//  Created by Avery Bonner on 9/23/15.
//  Copyright (c) 2015 Michael Brown. All rights reserved.
//  Copyright (c) 2017 Jim Bonner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "AFNetworking.h"
#import "BaseTableViewController.h"



@interface SearchResultsTableViewController : BaseTableViewController

@property (nonatomic, retain) NSString *jsonGroup;
@property (nonatomic, retain) NSString *display;
@property (nonatomic, retain) NSString *key;
@property (nonatomic, retain) NSMutableDictionary *parameters;
@property (nonatomic, retain) NSString *url;
@property(nonatomic,assign)id delegate;
@property (nonatomic, retain) UIButton *sender;

@end
