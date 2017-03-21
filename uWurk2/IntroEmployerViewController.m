//
//  IntroEmployerViewController.m
//  uWurk2
//
//  Created by Avery Bonner on 9/2/15.
//  Copyright (c) 2015 Michael Brown. All rights reserved.
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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:false];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
                UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Error"
                                                                 message:[responseObject objectForKey:@"message"]
                                                                delegate:self
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles: nil];
                [alert show];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error)
        {
            NSLog(@"Error: %@", error);
            UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Error"
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
                              UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Error"
                                                                               message:[responseObject objectForKey:@"message"]
                                                                              delegate:self
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles: nil];
                              [alert show];
                              [self.navigationController popViewControllerAnimated:TRUE];
                              
                          }
                      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          NSLog(@"Error: %@", error);
                          UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Error"
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
