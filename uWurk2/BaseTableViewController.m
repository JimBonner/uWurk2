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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

    
    self.appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [self.appDelegate setDocumentsDirectory:[self.appDelegate getDocumentsDirectory]];
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)assignValue:(NSString*)value control:(UITextField*)control {
    if(![value isEqual:[NSNull null]]){
        control.text = value;
    }
}

-(void)dismissKeyboard {
    [self.view endEditing:TRUE];
}

-(AFHTTPRequestOperationManager*)getManager{
    AFHTTPRequestOperationManager *manager = [self getManagerNoAuth];
    [manager.requestSerializer setValue:[self getUserDefault:@"api_auth_token"] forHTTPHeaderField:@"API-AUTH"];
    return manager;
}

-(AFHTTPRequestOperationManager*)getManagerNoAuth{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    //    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    return manager;
}

-(NSMutableDictionary*)updateParamDict:(NSMutableDictionary*)paramDict value:(NSString*)value key:(NSString*)key{
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

-(BOOL) validateResponse:(NSDictionary*)response{
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

-(void)setupUXforUser{
    
    return;
    
//    // Decision time
//    if([[[self.appDelegate user] objectForKey:@"user_type"] isEqualToString:@"user"]){
//        //        if((long)[[self.appDelegate user] objectForKey:@"profile_complete"] >= 0)
//        if(TRUE)
//        {
//            // Load up the tabs here
//            
//            self.appDelegate.tabBarController = [[UITabBarController alloc] init];
//            
//            
//            
//            SearchViewController *vc1 = [[SearchViewController alloc] init];
//            UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:vc1];
//            nav1.navigationBar.barStyle  = UIBarStyleBlack;
//            
//            //            MessagesViewController *vc2 = [[MessagesViewController alloc] init];
//            //            [vc2 setTitle:@"Messages"];
//            //            [vc2.tabBarItem setImage:[UIImage imageNamed:@"chat.png"]];
//            //            UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:vc2];
//            //
//            //            EmployerDashboardMenuViewController *vc3 = [[EmployerDashboardMenuViewController alloc] init];
//            //            [vc3 setTitle:@"Settings"];
//            //            [vc3.tabBarItem setImage:[UIImage imageNamed:@"sliders.png"]];
//            //            UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:vc3];
//            //
//            //            self.appDelegate.tabBarController.viewControllers = [NSArray arrayWithObjects:nav1, nav2, nav3 ,nil];
//            self.appDelegate.window.rootViewController = nav1;
//            
//        }
//        else{
//            NSMutableArray *controllers = [[NSMutableArray alloc] init];
//            //            id l = [[self.appDelegate user] objectForKey:@"setup_step"];
//            // Profile steps
//            
//            
//            // DEMO
//            [controllers addObject:[[EmployerStep1ViewController alloc] init]];
//            
//            //            if([[[self.appDelegate user] objectForKey:@"setup_step"] isEqualToString:@"1"] || [[[self.appDelegate user] objectForKey:@"setup_step"] isEqualToString:@"0"]  ){
//            //                [controllers addObject:[[EmployerStep1ViewController alloc] init]];
//            //            }
//            //            else if([[[self.appDelegate user] objectForKey:@"setup_step"] isEqualToString:@"2"]){
//            //                [controllers addObject:[[EmployerStep1ViewController alloc] init]];
//            //                [controllers addObject:[[EmployerStep2ViewController alloc] init]];
//            //            }
//            
//            for(int i=0; i<[controllers count]; ++i){
//                UIViewController *c = [controllers objectAtIndex:i];
//                [self.navigationController pushViewController:c animated:i==[controllers count]-1?TRUE:FALSE];
//            }
//        }
//        
//        //  self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:(26.0f/255.0f) green:(103.0f/255.0f) blue:(159.0f/255.0f) alpha:1.0f];
//        
//        
//    }
//    else{
//        
//        //if((long)[[self.appDelegate user] objectForKey:@"profile_complete"] >= 0)
//        if(true)
//        {
//            // Load up the tabs here
//            
//            //            self.appDelegate.tabBarController = [[UITabBarController alloc] init];
//            
//            EmployeeLandingViewController *vc1 = [[EmployeeLandingViewController alloc] init];
//            [vc1.tabBarItem setImage:[UIImage imageNamed:@"search.png"]];
//            UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:vc1];
//            nav1.navigationBar.barStyle  = UIBarStyleBlack;
//            
//            //            MessagesViewController *vc2 = [[MessagesViewController alloc] init];
//            //            [vc2 setTitle:@"Messages"];
//            //            [vc2.tabBarItem setImage:[UIImage imageNamed:@"chat.png"]];
//            
//            //            EmployeeLandingViewController *vc1 = [[EmployeeLandingViewController alloc] init];
//            //            [vc1.tabBarItem setImage:[UIImage imageNamed:@"search.png"]];
//            //            UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:vc1];
//            //            nav1.navigationBar.barStyle  = UIBarStyleBlack;
//            //
//            //
//            //            MessagesViewController *vc2 = [[MessagesViewController alloc] init];
//            //            [vc2 setTitle:@"Messages"];
//            //            [vc2.tabBarItem setImage:[UIImage imageNamed:@"chat.png"]];
//            //            UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:vc2];
//            //
//            ///            DashboardMenuTableViewController *vc3 = [[DashboardMenuTableViewController alloc] init];
//            //
//            
//            
//            self.appDelegate.window.rootViewController = nav1;
//            
//        }
//        else{
//            NSMutableArray *controllers = [[NSMutableArray alloc] init];
//            [controllers addObject:[[EmployeeStep1ViewController alloc] init]];
//            
//            //            id l = [[self.appDelegate user] objectForKey:@"setup_step"];
//            // Profile steps
//            //            if([[[self.appDelegate user] objectForKey:@"setup_step"] isEqualToString:@"1"] || [[[self.appDelegate user] objectForKey:@"setup_step"] isEqualToString:@"0"]  ){
//            //                [controllers addObject:[[EmployeeStep1ViewController alloc] init]];
//            //            }
//            //            else if([[[self.appDelegate user] objectForKey:@"setup_step"] isEqualToString:@"2"]){
//            //                [controllers addObject:[[EmployeeStep1ViewController alloc] init]];
//            //                [controllers addObject:[[EmployeeStep2ViewController alloc] init]];
//            //            }
//            //            else if([[[self.appDelegate user] objectForKey:@"setup_step"] isEqualToString:@"3"]){
//            //                [controllers addObject:[[EmployeeStep1ViewController alloc] init]];
//            //                [controllers addObject:[[EmployeeStep2ViewController alloc] init]];
//            //                [controllers addObject:[[EmployeeStep3ViewController alloc] init]];
//            //            }
//            //            else if([[[self.appDelegate user] objectForKey:@"setup_step"] isEqualToString:@"4"]){
//            //                [controllers addObject:[[EmployeeStep1ViewController alloc] init]];
//            //                [controllers addObject:[[EmployeeStep2ViewController alloc] init]];
//            //                [controllers addObject:[[EmployeeStep3ViewController alloc] init]];
//            //                [controllers addObject:[[EmployeeStep4ViewController alloc] init]];
//            //            }
//            //            else if([[[self.appDelegate user] objectForKey:@"setup_step"] isEqualToString:@"5"]){
//            //                [controllers addObject:[[EmployeeStep1ViewController alloc] init]];
//            //                [controllers addObject:[[EmployeeStep2ViewController alloc] init]];
//            //                [controllers addObject:[[EmployeeStep3ViewController alloc] init]];
//            //                [controllers addObject:[[EmployeeStep4ViewController alloc] init]];
//            //                [controllers addObject:[[EmployeeStep5ViewController alloc] init]];
//            //            }
//            
//            for(int i=0; i<[controllers count]; ++i){
//                UIViewController *c = [controllers objectAtIndex:i];
//                [self.navigationController pushViewController:c animated:i==[controllers count]-1?TRUE:FALSE];
//            }
//        }
//        
//        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:(26.0f/255.0f) green:(103.0f/255.0f) blue:(159.0f/255.0f) alpha:1.0f];
//        
//    }
//    
//    
    
}

-(void)setFrame:(UIView*)frameToMove basedOnView:(UIView*)basedOnView offset:(float)offset{
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

- (void)handleServerErrorUnableToContact
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
