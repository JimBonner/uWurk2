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
#import "EmployerStep0ViewController.h"


@interface IntroEmployerViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailText;

@end

@implementation IntroEmployerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:false];
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
    AFHTTPRequestOperationManager *manager = [self getManager];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:self.emailText.text forKey:@"email"];
    [params setObject:@"employer" forKey:@"type"];
    if([params count])
    {
        [manager POST:@"http://uwurk.tscserver.com/api/v1/register" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            if([self validateResponse:responseObject]){
                
                // Update the user object
                
                EmployerRegisterThanksViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"EmployerRegisterThanksView"];
                [myController setEmail:self.emailText.text];
                [self.navigationController pushViewController:myController animated:TRUE];
            }
            else
            {
                UIAlertController * alert = [UIAlertController
                                             alertControllerWithTitle:@"Oops!"
                                             message:[responseObject objectForKey:@"message"]
                                             preferredStyle:UIAlertControllerStyleActionSheet];
                [alert addAction:[UIAlertAction
                                  actionWithTitle:@"OK"
                                  style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction *action)
                                  {
                                  }]];
                [self.navigationController popViewControllerAnimated:TRUE];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error)
        {
            NSLog(@"Error: %@", error);
            UIAlertController * alert = [UIAlertController
                                         alertControllerWithTitle:@"Oops!"
                                         message:@"Unable to contact server"
                                         preferredStyle:UIAlertControllerStyleActionSheet];
            [alert addAction:[UIAlertAction
                              actionWithTitle:@"OK"
                              style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction *action)
                              {
                              }]];
            [self.navigationController popViewControllerAnimated:TRUE];
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
             [self.navigationController popViewControllerAnimated:TRUE];
         } else if (result.isCancelled) {
             UIAlertController * alert = [UIAlertController
                                          alertControllerWithTitle:@"Oops!"
                                          message:@"Facebood login was cancelled."
                                          preferredStyle:UIAlertControllerStyleActionSheet];
             [alert addAction:[UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                               }]];
             [self.navigationController popViewControllerAnimated:TRUE];
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
                          NSLog(@"JSON: %@", responseObject);
                          if([self validateResponse:responseObject] &&
                             [((NSDictionary*)responseObject) valueForKey:@"api_auth_token"] != nil)
                          {
                              [self saveUserDefault:[((NSDictionary*)responseObject) valueForKey:@"api_auth_token"] Key:@"api_auth_token"];
                              
                              EmployerStep0ViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"IntroEmployer"];
                              
                              UINavigationController *nav = self.navigationController;
                              [nav popToRootViewControllerAnimated:FALSE];
                              [nav pushViewController:myController animated:TRUE];
                          }
                          else
                          {
                              UIAlertController * alert = [UIAlertController
                                                           alertControllerWithTitle:@"Oops!"
                                                           message:[responseObject objectForKey:@"message"]
                                                           preferredStyle:UIAlertControllerStyleActionSheet];
                              [alert addAction:[UIAlertAction
                                                actionWithTitle:@"OK"
                                                style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *action)
                                                {
                                                }]];
                              [self.navigationController popViewControllerAnimated:TRUE];
                          }
                      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          NSLog(@"Error: %@", error);
                          UIAlertController * alert = [UIAlertController
                                                       alertControllerWithTitle:@"Oops!"
                                                       message:@"Unable to validate login"
                                                       preferredStyle:UIAlertControllerStyleActionSheet];
                          [alert addAction:[UIAlertAction
                                            actionWithTitle:@"OK"
                                            style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction *action)
                                            {
                                            }]];
                      }];
                  }
              }];
         }
     }];
}



@end
