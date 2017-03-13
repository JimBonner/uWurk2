//
//  ListSelectorTableViewController.h
//  uWurk2
//
//  Created by Avery Bonner on 9/8/15.
//  Copyright (c) 2015 Michael Brown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "AppDelegate.h"

@protocol ListMultiSelectorTableViewControllerProtocol <NSObject>
    -(void)SelectionMade:(NSMutableDictionary*)dict displayString:(NSString*)displayString;
@end

@interface ListMultiSelectorTableViewController : UITableViewController

@property (nonatomic, retain) NSString *jsonGroup;
@property (nonatomic, retain) NSString *display;
@property (nonatomic, retain) NSString *key;
@property (nonatomic, retain) NSDictionary *parameters;
@property (nonatomic, retain) NSString *url;
@property(nonatomic,assign)id delegate;
@property (nonatomic, retain) UILabel *displayLbl;
@property (nonatomic, retain) NSMutableDictionary *idDict;
@property (assign) BOOL bPost;
@property (assign) BOOL bUseArray;


@end
