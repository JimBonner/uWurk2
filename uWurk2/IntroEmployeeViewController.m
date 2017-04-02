 //
//  IntroEmployeeViewController.m
//  uWurk2
//
//  Created by Avery Bonner on 9/2/15.
//  Copyright (c) 2015 Michael Brown. All rights reserved.
//

#import "IntroEmployeeViewController.h"
#import "EmployeeRegisterThanksViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "EmployeeStepSetupViewController.h"
#import "EmployeeStep1ViewController.h"

@interface IntroEmployeeViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailText;

@end

@implementation IntroEmployeeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:false];
    [self saveUserDefault:@"1" Key:@"register_Active"];

    NSDictionary *dict = [NSDictionary dictionaryWithDictionary:[self jsonStringToObject:[self getUserDefault:@"user_data"]]];
    [self.appDelegate setUser:[dict mutableCopy]];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.emailText setText:[self.appDelegate.user objectForKey:@"email"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self saveUserData];
}

-(void)saveUserData
{
    [self.appDelegate.user setObjectOrNil:[self.emailText text] forKey:@"email"];
    
    [self saveUserDefault:[self objectToJsonString:self.appDelegate.user]
                      Key:@"user_data"];
}

- (IBAction)pressEmailRegister:(id)sender {
    AFHTTPRequestOperationManager *manager = [self getManager];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:self.emailText.text forKey:@"email"];
    [params setObject:@"employee" forKey:@"type"];

    if([params count]){
        [manager POST:@"http://uwurk.tscserver.com/api/v1/register" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
        {
            NSLog(@"JSON: %@", responseObject);
            if([self validateResponse:responseObject])
            {
                if(([self getUserDefault:@"email"] == nil) &&
                   ([self getUserDefault:@"api_auth_token"] == nil))
                {
                    [self saveUserDefault:[self.emailText text] Key:@"email"];
                    [self saveUserDefault:[responseObject objectForKey:@"api_auth_token"] Key:@"api_auth_token"];
                    [self.appDelegate.user setObjectOrNil:[self getUserDefault:@"email"] forKey:@"email"];
                    [self.appDelegate.user setObjectOrNil:[self getUserDefault:@"api_auth_token"] forKey:@"api_auth_token"];
                }
                
                EmployeeStep1ViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"EmployeeStep1ViewController"];
                [self.navigationController pushViewController:myController animated:TRUE];
            } else {
                NSDictionary *dictionary = [responseObject objectForKey:@"messages"];
                NSArray *array = [dictionary objectForKey:@"email"];
                NSString *message = [array objectAtIndex:0];
                UIAlertController *alert = [UIAlertController
                                            alertControllerWithTitle:@"Oops"
                                                            message:message
                                                     preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancel = [UIAlertAction
                                         actionWithTitle:@"Try again"
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * action)
                                         {
                                             [alert dismissViewControllerAnimated:YES completion:nil];
                                         }];
                [alert addAction:cancel];
                
                if([self getUserDefault:@"email"] &&
                   [self getUserDefault:@"api_auth_token"] &&
                   [[self getUserDefault:@"email"] isEqualToString:[self.emailText text]])
                {
                    UIAlertAction *ok = [UIAlertAction
                                         actionWithTitle:@"Continue"
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * action)
                                         {
                                             [alert dismissViewControllerAnimated:YES completion:nil];
                                             EmployeeStep1ViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"EmployeeStep1ViewController"];
                                             [self.navigationController pushViewController:myController animated:TRUE];
                                         }];
                    [alert addAction:ok];
                }
                [self presentViewController:alert animated:YES completion:nil];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error)
        {
            NSLog(@"Error: %@", error);
            UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Oops!"
                                                             message:@"Unable to contact server"
                                                            delegate:self
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles: nil];
            [alert show];
        }];
    }
}


- (IBAction)signInWithFacebookButtonPressed:(id)sender {
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logOut];
    [login
     logInWithReadPermissions: @[@"public_profile", @"email", @"user_birthday", @"user_location"]
     fromViewController:self
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *facebookError) {
         if (facebookError) {
             DLog(@"Process error");
             [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Something went wrong. Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
         } else if (result.isCancelled) {
             [[[UIAlertView alloc] initWithTitle:@"Log In Canceled" message:@"Facebook login was canceled." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
             DLog(@"Cancelled");
         } else {
             DLog(@"Logged in");
             
             NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
             [parameters setValue:@"id,first_name,last_name,email,gender" forKey:@"fields"];
             
             [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters]
              startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                           id result, NSError *error) {
                  
                  if ([FBSDKAccessToken currentAccessToken]) {
                      
                      __block NSString *email = [result objectForKey:@"email"];
                      
                      AFHTTPRequestOperationManager *manager = [self getManagerNoAuth];
                      NSMutableDictionary *parameters = [NSMutableDictionary new];
                      
                      if([result objectForKey:@"first_name"]) {
                          [parameters setObject:[result objectForKey:@"first_name"] forKey:@"first_name"]; }
                      if([result objectForKey:@"last_name"]) {
                          [parameters setObject:[result objectForKey:@"last_name"] forKey:@"last_name"];
                      }
                      if([result objectForKey:@"gender"]) {
                          [parameters setObject:[result objectForKey:@"gender"] forKey:@"gender"];
                      }
                      [parameters setObject:[[FBSDKAccessToken currentAccessToken] userID] forKey:@"id"];
                      [parameters setObject:email forKey:@"email"];
                      [parameters setObject:@"employee" forKey:@"type"];
                      [parameters setObject:@1 forKey:@"facebook"];
                      
                      [manager POST:@"http://uwurk.tscserver.com/api/v1/register" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                          
                          NSLog(@"JSON: %@", responseObject);
///                          BOOL bValid = [self validateResponse:responseObject];
                          if([((NSDictionary*)responseObject) valueForKey:@"api_auth_token"] != nil){
                              
                              EmployeeStepSetupViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"IntroEmployee"];
                              
                              UINavigationController *nav = self.navigationController;
                              [nav popToRootViewControllerAnimated:FALSE];
                              [nav pushViewController:myController animated:TRUE];
                          }
                          else {
                              UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Oops!"
                                                                               message:[responseObject objectForKey:@"message"]
                                                                              delegate:self
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles: nil];
                              [alert show];
                              [self.navigationController popViewControllerAnimated:TRUE];

                          }
                          
                      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          NSLog(@"Error: %@", error);
                          UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Oops!"
                                                                           message:@"Unable to validate login"
                                                                          delegate:self
                                                                 cancelButtonTitle:@"OK"
                                                                 otherButtonTitles: nil];
                          [alert show];
                          
                          
                      }];
                      
                  }
                  
              }];
            
         }
     }];
}


@end
