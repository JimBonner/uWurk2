//
//  BaseViewController.h
//  uWurk2
//
//  Created by Avery Bonner on 9/7/15.
//  Copyright (c) 2015 Michael Brown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "AppDelegate.h"


@interface BaseViewController : UIViewController

@property (nonatomic, retain) AppDelegate *appDelegate;

-(void)assignValueTextView:(NSString*)value control:(UITextView*)control;
-(void)saveUserDefault:(id)object Key:(NSString*)key;
-(id)getUserDefault:(NSString*)key;
-(NSString *)objectToJsonString:(id)object;
-(id)jsonStringToObject:(NSString *)string;
-(NSMutableData *)objectToData:(id)object;
-(id)dataToObject:(NSMutableData *)data;
-(BOOL) validateResponse:(NSDictionary*)response;
-(AFHTTPRequestOperationManager*)getManager;
-(AFHTTPRequestOperationManager*)getManagerNoAuth;
-(void)setupUXforUser;
-(void)assignValue:(NSString*)value control:(UITextField*)control;
-(NSMutableDictionary*)updateParamDict:(NSMutableDictionary*)paramDict value:(NSString*)value key:(NSString*)key;
-(NSMutableDictionary*)updateParamDictDefault:(NSMutableDictionary*)paramDict value:(NSString*)value key:(NSString*)key def:(NSString*)def;
-(void)logout;


@end
