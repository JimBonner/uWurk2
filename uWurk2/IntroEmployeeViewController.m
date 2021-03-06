 //
//  IntroEmployeeViewController.m
//  uWurk2
//
//  Created by Avery Bonner on 9/2/15.
//  Copyright (c) 2015 Michael Brown. All rights reserved.
//  Copyright (c) 2017 Jim Bonner. All rights reserved.
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
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"\nEmployee Intro - Init:\n%@",self.appDelegate.user);
    
    if(![[self getUserDefault:@"user_type"] isEqualToString:@"employee"]) {
        [self saveUserDefault:@"employee" Key:@"user_type"];
        [self saveUserDefault:nil Key:@"email"];
        [self saveUserDefault:nil Key:@"api_auth_token"];
    }
    [self.emailText setText:[self getUserDefault:@"email"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (IBAction)pressEmailRegister:(id)sender
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:self.emailText.text forKey:@"email"];
    [params setObject:@"employee" forKey:@"type"];
    if([params count]){
        AFHTTPRequestOperationManager *manager = [self getManager];
        [manager POST:@"http://uwurk.tscserver.com/api/v1/register" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
        {
            NSLog(@"\nEmployee Email Register - Json Response:\n%@", responseObject);
            if([self validateResponse:responseObject])
            {
                if(([self getUserDefault:@"email"] == nil) &&
                   ([self getUserDefault:@"api_auth_token"] == nil))
                {
                    [self saveUserDefault:@"employee" Key:@"user_type"];
                    [self saveUserDefault:[self.emailText text] Key:@"email"];
                    [self saveUserDefault:[responseObject objectForKey:@"api_auth_token"] Key:@"api_auth_token"];
                    [self getProfileDataFromDbmsWithCompletion:^(NSInteger result) {
                        if(result == 1) {
                            EmployeeStep1ViewController *myController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"EmployeeStep1ViewController"];
                            [self.navigationController pushViewController:myController animated:TRUE];
                        }}];
                }
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
                
                if([self getUserDefault:@"email"] && DEVELOPMENT &&
                   [self getUserDefault:@"api_auth_token"] &&
                   [message containsString:@"email"] &&
                   [message containsString:@"taken"])
                {
                    UIAlertAction *ok = [UIAlertAction
                                         actionWithTitle:@"Continue"
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * action)
                                         {
                                             [alert dismissViewControllerAnimated:YES completion:nil];
                                             [self getProfileDataFromDbmsWithCompletion:^(NSInteger result) {
                                                 if(result == 1) {
                                                     EmployeeStep1ViewController *myController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"EmployeeStep1ViewController"];
                                                     [self.navigationController pushViewController:myController animated:TRUE];
                                                 }}];
                                         }];
                    [alert addAction:ok];
                }
                [self presentViewController:alert animated:YES completion:nil];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error)
        {
            NSLog(@"Error: %@", error);
            [self handleErrorAccessError:@"Intro Employee" withError:error];
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
             UIAlertController * alert = [UIAlertController
                                          alertControllerWithTitle:@"Oops!"
                                          message:@"Something went wrong. Please try again."
                                          preferredStyle:UIAlertControllerStyleActionSheet];
             [alert addAction:[UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                               }]];
             [self presentViewController:alert animated:TRUE completion:nil];
         } else if (result.isCancelled) {
             UIAlertController * alert = [UIAlertController
                                          alertControllerWithTitle:@"Oops!"
                                          message:@"Facebook login was canceled."
                                          preferredStyle:UIAlertControllerStyleActionSheet];
             [alert addAction:[UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                               }]];
             [self presentViewController:alert animated:TRUE completion:nil];
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
                      [manager POST:@"http://uwurk.tscserver.com/api/v1/register" parameters:parameters
                            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                NSLog(@"\nEmployee Facebook Register - Json Response:\n%@", responseObject);
                                if([self validateResponse:responseObject]) {
                                    if([((NSDictionary*)responseObject) valueForKey:@"api_auth_token"] != nil){
                                        EmployeeStepSetupViewController *myController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]  instantiateViewControllerWithIdentifier:@"IntroEmployee"];
                                        UINavigationController *nav = self.navigationController;
                                        [nav popToRootViewControllerAnimated:FALSE];
                                        [nav pushViewController:myController animated:TRUE];
                                    } else {
                                        [self handleErrorWithMessage:[responseObject objectForKey:@"message"]];
                                    }}}
                            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                NSLog(@"Error: %@", error);
                                [self handleErrorValidateLogin];
                      }];
                  }
              }];
         }
     }];
}


@end
