//
//  ListSelectorStringsTableViewController.h
//  uWurk2
//
//  Created by Avery Bonner on 11/1/15.
//  Copyright (c) 2015 Michael Brown. All rights reserved.
//  Copyright (c) 2017 Jim Bonner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "AppDelegate.h"

@protocol ListSelectorStringsTableViewControllerProtocol <NSObject>
-(void)SelectionMadeString:(NSString *)passThru displayString:(NSString *)displayString;
@end

@interface ListSelectorStringsTableViewController : UITableViewController

@property (nonatomic, retain) NSString *jsonGroup;
@property (nonatomic, retain) NSString *display;
@property (nonatomic, retain) NSString *key;
@property (nonatomic, retain) NSDictionary *parameters;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) UIButton *sender;
@property (nonatomic, retain) NSString *passThru;

@end
