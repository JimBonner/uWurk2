//
//  BaseViewController.m
//  uWurk2
//
//  Created by Avery Bonner on 9/7/15.
//  Copyright (c) 2015 Michael Brown. All rights reserved.
//  Copyright (c) 2017 Jim Bonner. All rights reserved.
//

#import "BaseViewController.h"
#import "IntroViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIImage* logoImage = [UIImage imageNamed:@"UWURK-header-logo"];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:logoImage];
    
    self.appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if ([[self.parentViewController parentViewController] isKindOfClass:[UITabBarController class]]) {
        [self.parentViewController.navigationController setNavigationBarHidden:YES];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                                 initWithImage:[UIImage imageNamed:@"BackArrow_LgWhite"]
                                                         style:UIBarButtonItemStylePlain
                                                        target:self
                                                        action:@selector(goBack)];
    } else {
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]
                                                 initWithTitle:@""
                                                         style:self.navigationItem.backBarButtonItem.style
                                                        target:nil
                                                        action:nil];
        self.navigationItem.hidesBackButton = NO;
//        [self.navigationController.navigationBar setBackIndicatorImage:[UIImage imageNamed:@"Back Arrow White"]];
//        [self.navigationController.navigationBar setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"BackArrow_LgWhite"]];
    }

}

-(void)assignValue:(NSString*)value control:(UITextField *)control {
    if(![value isEqual:[NSNull null]]){
        control.text = value;
    }
}

-(void)assignValueTextView:(NSString*)value control:(UITextView*)control {
    if(![value isEqual:[NSNull null]]){
        control.text = value;
    }
}

-(void)dismissKeyboard {
    [self.view endEditing:TRUE];
}

- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
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
    NSString *string = [NSString stringWithFormat:@"%@",value];
    NSString *trimmedValue = [string stringByTrimmingCharactersInSet:
                              [NSCharacterSet whitespaceCharacterSet]];
    if([trimmedValue length] > 0)
    {
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

-(BOOL) validateResponse:(NSDictionary *)response
{
    if([response isKindOfClass:[NSDictionary class]])
    {
        NSLog(@"%@",response);
        id n = [response valueForKey:@"result"];
        if([n isKindOfClass:[NSNumber class]])
        {
            if([((NSNumber*)n) isEqual:@1])
            {
                if([response objectForKey:@"user"])
                {
                    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
                    for (NSString* key in [response objectForKey:@"user"])
                    {
                        id value = [[response objectForKey:@"user"] objectForKey:key];
                        if(![value isEqual:[NSNull null]])
                            [tempDict setObject:value forKey:key];
                    }
                    [self.appDelegate setUser:tempDict];
                    return TRUE;
                }
                return TRUE;
            }
        }
    }
    return FALSE;
}

- (void)logout
{
    [self saveUserDefault:@"" Key:@"api_auth_token"];
    IntroViewController *introViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"InitialView"];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:introViewController];
    self.view.window.rootViewController = nav;
}

-(void)setFrame:(UIView*)frameToMove basedOnView:(UIView*)basedOnView offset:(float)offset
{
    CGRect frame = frameToMove.frame;
    frame.origin.y = basedOnView.frame.origin.y + basedOnView.frame.size.height + offset;
    frameToMove.frame = frame;
}

#pragma mark -
#pragma mark User Defaults

-(void)saveUserDefault:(id)object Key:(NSString *)key
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if(object == nil)
        [prefs setObject:nil forKey:key];
    else
        [prefs setObject:object forKey:key];
    
    [prefs synchronize];
}

-(id)getUserDefault:(NSString *)key
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    return [prefs objectForKey:key];
}

- (void)postUserDefaults
{
//    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
//    for(id pref in prefs) {
//        int k = 0;
//    }
}

#pragma mark -
#pragma mark Object & Data Conversion Using NSMutableData

-(NSMutableData *)objectToData:(id)object
{
    NSMutableData *data = [[NSMutableData alloc]initWithBytes:(const void *)object length:sizeof(object)];
    return data;
}

-(id)dataToObject:(NSMutableData *)data
{
    id object = [data bytes];
    return object;
}

#pragma mark -
#pragma mark Object & String Conversion(s) Using Json

- (NSString *)objectToJsonString:(id)object
{
    NSError *err;
    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                        options:NSJSONWritingPrettyPrinted
                                                          error:&err];
    NSString *string = [[NSString alloc] initWithData:jsonData
                                             encoding:NSUTF8StringEncoding];
    return string;
}

- (id)jsonStringToObject:(NSString *)string
{
    NSError *err;
    NSData  *jsonData =[string dataUsingEncoding:NSUTF8StringEncoding];
    id object = nil;
    if(jsonData!= nil){
        object = (id)[NSJSONSerialization JSONObjectWithData:jsonData
                                                     options:NSJSONReadingMutableContainers
                                                       error:&err];
    }
    
    return object;
}

#pragma -
#pragma User Data File Handling

- (void)saveUserDataToDocumentsFile
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [self.appDelegate.documentsDirectory stringByAppendingPathComponent:                        [NSString stringWithFormat:@"%@.%@",[self getUserDefault:@"email"],@".user_data.json"]];
    
    if([fileManager fileExistsAtPath:filePath]) {
        [fileManager removeItemAtPath:filePath error:nil];
    }
    NSString *string = [self objectToJsonString:self.appDelegate.user];
    [string writeToFile:filePath atomically:NO
               encoding:NSUTF8StringEncoding
                  error:nil];
}

- (void)getUserDataFromDocumentsFile
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [self.appDelegate.documentsDirectory stringByAppendingPathComponent:                          [NSString stringWithFormat:@"%@.%@",[self getUserDefault:@"email"],@".user_data.json"]];
    if([fileManager fileExistsAtPath:filePath]) {
        NSString *string = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        [self.appDelegate setUser:[self jsonStringToObject:string]];
    }
}

-(NSURL *)serverUrlWith:(NSString *)postfix;
{
    NSURL *serverURL =[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", self.appDelegate.serverAddress,postfix]];
    
    return serverURL;
}

- (void)getProfileDataFromDbmsWithCompletion:(void(^)(NSInteger result))completion
{
    AFHTTPRequestOperationManager *manager = [self getManager];
    [manager POST:@"http://uwurk.tscserver.com/api/v1/profile" parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"Latest JSON: %@", responseObject);
              if([self validateResponse:responseObject]) {
                  completion(1);
              } else {
                  completion(0);
                  [self handleServerErrorUnableToGetData];
              }}
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              completion(0);
              [self handleServerErrorUnableToGetData];
          }
     ];
}

- (void)saveStepNumber:(NSInteger)stepNum completion:(void(^)(NSInteger result))completion
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:[@(stepNum)stringValue] forKey:@"setup_step"];
    AFHTTPRequestOperationManager *manager = [self getManager];
    [manager POST:@"http://uwurk.tscserver.com/api/v1/profile" parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"JSON Response: %@", responseObject);
              if([self validateResponse:responseObject]) {
                  completion(1);
              } else {
                  completion(0);
                  [self handleServerErrorUnableToPutData];
              }}
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              completion(0);
              [self handleServerErrorUnableToPutData];
          }
     ];
}

- (void)saveProfileComplete:(void(^)(NSInteger result))completion
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:@"1" forKey:@"profile_complete"];
    AFHTTPRequestOperationManager *manager = [self getManager];
    [manager POST:@"http://uwurk.tscserver.com/api/v1/profile" parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"JSON Response: %@", responseObject);
              if([self validateResponse:responseObject]) {
                  completion(1);
              } else {
                  completion(0);
                  [self handleServerErrorUnableToSaveData:@"Profile Complete"];
              }}
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              completion(0);
              [self handleServerErrorUnableToSaveData:@"Profile Complete"];
          }
     ];
}

#pragma mark -
#pragma mark Common Error Messsages

- (void)handleServerErrorUnableToGetData
{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Oops!"
                                 message:@"Unable to get data from server"
                                 preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction
                      actionWithTitle:@"OK"
                      style:UIAlertActionStyleDefault
                      handler:^(UIAlertAction *action)
                      {
                      }]];
    [self presentViewController:alert animated:TRUE completion:nil];
}

- (void)handleServerErrorUnableToPutData
{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Oops!"
                                 message:@"Unable to save data to server"
                                 preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction
                      actionWithTitle:@"OK"
                      style:UIAlertActionStyleDefault
                      handler:^(UIAlertAction *action)
                      {
                      }]];
    [self presentViewController:alert animated:TRUE completion:nil];
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

- (void)handleServerErrorUnableToSaveData:(NSString *)what
{
    NSString *message = [NSString stringWithFormat:@"Unable to save %@ data",what];
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Oops!"
                                 message:message
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction
                      actionWithTitle:@"OK"
                      style:UIAlertActionStyleDefault
                      handler:^(UIAlertAction *action)
                      {
                      }]];
    [self presentViewController:alert animated:TRUE completion:nil];
}

- (void)handleErrorWithMessage:(NSString *)message
{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Oops!"
                                 message:message
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction
                      actionWithTitle:@"OK"
                      style:UIAlertActionStyleDefault
                      handler:^(UIAlertAction *action)
                      {
                      }]];
    [self presentViewController:alert animated:TRUE completion:nil];
}

- (void)handleErrorJsonResponse:(NSString *)who
{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Oops!"
                                 message:@"%@ Json response data validation error."
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction
                      actionWithTitle:@"OK"
                      style:UIAlertActionStyleDefault
                      handler:^(UIAlertAction *action)
                      {
                      }]];
    [self presentViewController:alert animated:TRUE completion:nil];
}

- (void)handleErrorCountExceeded:(NSInteger)count
{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Oops!"
                                 message:[NSString stringWithFormat:@"You are only allowed to have %ld entrys.",(long)count]
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction
                      actionWithTitle:@"OK"
                      style:UIAlertActionStyleDefault
                      handler:^(UIAlertAction *action)
                      {
                      }]];
    [self presentViewController:alert animated:TRUE completion:nil];
}

- (void)handleErrorValidateLogin
{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Oops!"
                                 message:[NSString stringWithFormat:@"Unable to validate login"]
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction
                      actionWithTitle:@"OK"
                      style:UIAlertActionStyleDefault
                      handler:^(UIAlertAction *action)
                      {
                      }]];
    [self presentViewController:alert animated:TRUE completion:nil];
}

//-(void)setupUXforUser{
//
//    return;
//
//    // Decision time
//    if([[[self.appDelegate user] objectForKey:@"user_type"] isEqualToString:@"employee"]){
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
//    
//}

@end
