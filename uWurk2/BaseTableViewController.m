//
//  BaseViewController.m
//  uWurk2
//
//  Created by Avery Bonner on 9/7/15.
//  Copyright (c) 2015 Michael Brown. All rights reserved.
//  Copyright (c) 2017 Jim Bonner. All rights reserved.
//

#import "BaseTableViewController.h"

@interface BaseTableViewController ()

@end

@implementation BaseTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    UIImage* logoImage = [UIImage imageNamed:@"UWURK-header-logo"];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:logoImage];
    
    if ([[self.parentViewController parentViewController] isKindOfClass:[UITabBarController class]]) {
        [self.parentViewController.navigationController setNavigationBarHidden:YES];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"BackArrow_LgWhite"]
                                                                                 style:UIBarButtonItemStylePlain
                                                                                target:self action:@selector(goBack)];
    } else {
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                                 style:self.navigationItem.backBarButtonItem.style
                                                                                target:nil action:nil];
        [self.navigationController.navigationBar setBackIndicatorImage:[UIImage imageNamed:@"Back Arrow White"]];
        [self.navigationController.navigationBar setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"BackArrow_LgWhite"]];
    }

    [self.appDelegate setDocumentsDirectory:[self.appDelegate getDocumentsDirectory]];
}

- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)assignValue:(NSString*)value control:(UITextField*)control
{
    if(![value isEqual:[NSNull null]]){
        control.text = value;
    }
}

-(void)dismissKeyboard
{
    [self.view endEditing:TRUE];
}

-(AFHTTPRequestOperationManager*)getManager
{
    AFHTTPRequestOperationManager *manager = [self getManagerNoAuth];
    [manager.requestSerializer setValue:[self getUserDefault:@"api_auth_token"] forHTTPHeaderField:@"API-AUTH"];
    return manager;
}

-(AFHTTPRequestOperationManager*)getManagerNoAuth
{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    //    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    return manager;
}

-(NSMutableDictionary*)updateParamDict:(NSMutableDictionary*)paramDict value:(NSString*)value key:(NSString*)key
{
    NSString *trimmedValue = [value stringByTrimmingCharactersInSet:
                              [NSCharacterSet whitespaceCharacterSet]];
    if([trimmedValue length]>0){
        if(![value isEqualToString:[self.appDelegate.user objectForKey:key]])
            [paramDict setObject:value forKey:key];
    }
    return paramDict;
}

-(NSMutableDictionary*)updateParamDictDefault:(NSMutableDictionary*)paramDict value:(NSString*)value key:(NSString*)key def:(NSString*)def
{
    if([value isEqualToString:def])
        return paramDict;
    if(![value isEqual:[NSNull null]] && [value length]>0){
        if(![value isEqualToString:[self.appDelegate.user objectForKey:key]])
            [paramDict setObject:value forKey:key];
    }
    return paramDict;
}

-(BOOL) validateResponse:(NSDictionary*)response
{
    if([response isKindOfClass:[NSDictionary class]]){
        NSLog(@"%@",response);
        
        id n = [response valueForKey:@"result"];
        if([n isKindOfClass:[NSNumber class]]){
            if([((NSNumber*)n) isEqual:@1]){
                if([response objectForKey:@"user"]){
                    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
                    // Clean up this null nonsense
                    for (NSString* key in [response objectForKey:@"user"]) {
                        id value = [[response objectForKey:@"user"] objectForKey:key];
                        if(![value isEqual:[NSNull null]])
                            [tempDict setObject:value forKey:key];
                    }
                    [self.appDelegate setUser:tempDict];
                }
                return TRUE;
            }
        }
    }
    else
        return FALSE;
    
    return TRUE;
}

-(void)setupUXforUser
{
    
    return;
}

-(void)setFrame:(UIView*)frameToMove basedOnView:(UIView*)basedOnView offset:(float)offset
{
    CGRect frame = frameToMove.frame;
    frame.origin.y = basedOnView.frame.origin.y + basedOnView.frame.size.height + offset;
    frameToMove.frame = frame;
}


#pragma mark -
#pragma mark User Defaults

-(void)saveUserDefault:(NSString*)object Key:(NSString*)key
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if([object length] == 0)
        [prefs setObject:nil forKey:key];
    else
        [prefs setObject:object forKey:key];
    
    [prefs synchronize];
}

-(NSString*)getUserDefault:(NSString*)key
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    return [prefs stringForKey:key];
}

- (void)handleErrorUnableToContact
{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Oops!"
                                 message:@"Unable to contact server"
                                 preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction
                      actionWithTitle:@"OK"
                      style:UIAlertActionStyleDefault
                      handler:^(UIAlertAction *action)
                      {
                      }]];
    [self presentViewController:alert animated:TRUE completion:nil];
}

@end
