//
//  BaseViewController.h
//  uWurk2
//
//  Created by Avery Bonner on 9/7/15.
//  Copyright (c) 2015 Michael Brown. All rights reserved.
//  Copyright (c) 2017 Jim Bonner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "AppDelegate.h"


@interface BaseTableViewController : UITableViewController
@property (nonatomic, retain) AppDelegate *appDelegate;

-(void)saveUserDefault:(NSString*)object Key:(NSString*)key;
-(NSString*)getUserDefault:(NSString*)key;
-(BOOL) validateResponse:(NSDictionary*)response;
-(AFHTTPRequestOperationManager*)getManager;
-(AFHTTPRequestOperationManager*)getManagerNoAuth;
-(void)setupUXforUser;
-(void)assignValue:(NSString*)value control:(UITextField*)control;
-(NSMutableDictionary*)updateParamDict:(NSMutableDictionary*)paramDict value:(NSString*)value key:(NSString*)key;
-(NSMutableDictionary*)updateParamDictDefault:(NSMutableDictionary*)paramDict value:(NSString*)value key:(NSString*)key def:(NSString*)def;
-(void)handleErrorUnableToContact;

@end
