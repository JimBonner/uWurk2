//
//  IntroEmployerViewController.m
//  uWurk2
//
//  Created by Avery Bonner on 9/2/15.
//  Copyright (c) 2015 Michael Brown. All rights reserved.
//  Copyright (c) 2017 Jim Bonner. All rights reserved.
//

#import "IntroEmployerViewController.h"
#import "EmployerRegisterThanksViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "EmployerStep1ViewController.h"


@interface IntroEmployerViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailText;

@end

@implementation IntroEmployerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:false];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"\nEmployer Intro - Init:\n%@",self.appDelegate.user);
    
    if(![[self getUserDefault:@"user_type"] isEqualToString:@"employer"]) {
        [self saveUserDefault:@"employer" Key:@"type"];
        [self saveUserDefault:nil Key:@"email"];
        [self saveUserDefault:nil Key:@"api_auth_token"];
    }
    [self.emailText setText:[self getUserDefault:@"email"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (IBAction)pressEmailRegister:(id)sender
{
    AFHTTPRequestOperationManager *manager = [self getManager];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:self.emailText.text forKey:@"email"];
    [params setObject:@"employer" forKey:@"type"];
    if([params count])
    {
         [manager POST:@"http://uwurk.tscserver.com/api/v1/register" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
        {
            NSLog(@"\nEmployer Email Register - Json Response:\n%@", responseObject);
            if([self validateResponse:responseObject]){
                if(([self getUserDefault:@"email"] == nil) &&
                   ([self getUserDefault:@"api_auth_token"] == nil))
                {
                    [self saveUserDefault:@"employer" Key:@"user_type"];
                    [self saveUserDefault:[self.emailText text] Key:@"email"];
                    [self saveUserDefault:[responseObject objectForKey:@"api_auth_token"] Key:@"api_auth_token"];
                    [self getProfileDataFromDbmsWithCompletion:^(NSInteger result) {
                        if(result == 1) {
                            EmployerStep1ViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"EmployerStep1ViewController"];
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
                
                if([self getUserDefault:@"email"] &&
                   [self getUserDefault:@"api_auth_token"] &&
                   [message containsString:@"email"] &&
                   [message containsString:@"taken"])
                {
                    UIAlertAction *ok = [UIAlertAction
                                         actionWithTitle:@"Continue"
                                         style:UIAlertActionStyleDefault                                         handler:^(UIAlertAction * action)
                                         {
                                             [alert dismissViewControllerAnimated:YES completion:nil];
                                             [self getProfileDataFromDbmsWithCompletion:^(NSInteger result) {
                                                 if(result == 1) {
                                                     EmployerStep1ViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"EmployerStep1ViewController"];
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
            [self handleErrorAccessError:error];
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
                                          message:@"Something went wrong.  Please try again."
                                          preferredStyle:UIAlertControllerStyleActionSheet];
             [alert addAction:[UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                               }]];
             [self presentViewController:alert animated:TRUE completion:nil];
             return;
         } else if (result.isCancelled) {
             UIAlertController * alert = [UIAlertController
                                          alertControllerWithTitle:@"Oops!"
                                          message:@"Facebook login was cancelled."
                                          preferredStyle:UIAlertControllerStyleActionSheet];
             [alert addAction:[UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                               }]];
             [self presentViewController:alert animated:TRUE completion:nil];
             return;
             DLog(@"Cancelled");
         } else {
             DLog(@"Logged in");
             
             NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
             [parameters setValue:@"id,first_name,last_name,email,gender" forKey:@"fields"];
             
             [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters]
              startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                           id result, NSError *error) {
                  
                  if ([FBSDKAccessToken currentAccessToken])
                  {
                      
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
                      [parameters setObject:@"employer" forKey:@"type"];
                      [parameters setObject:@1 forKey:@"facebook"];
                      
                      [manager POST:@"http://uwurk.tscserver.com/api/v1/register" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
                      {
                          NSLog(@"\nEmployer Facebook Register - Json Response:\n%@", responseObject);
                          if([self validateResponse:responseObject] &&
                             [((NSDictionary*)responseObject) valueForKey:@"api_auth_token"] != nil)
                          {
                              [self saveUserDefault:[((NSDictionary*)responseObject) valueForKey:@"api_auth_token"] Key:@"api_auth_token"];
                              
                              EmployerStep1ViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"EmployerStep1ViewController"];
                              
                              UINavigationController *nav = self.navigationController;
                              [nav popToRootViewControllerAnimated:FALSE];
                              [nav pushViewController:myController animated:TRUE];
                          } else {
                              [self handleErrorWithMessage:[responseObject objectForKey:@"message"]];
                          }
                      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          NSLog(@"Error: %@", error);
                          [self handleErrorValidateLogin];
                      }];
                  }
              }];
         }
     }];
}



@end
