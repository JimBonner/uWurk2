//
//  LoginViewController.m
//  uWurk2
//
//  Created by Avery Bonner on 8/31/15.
//  Copyright (c) 2015 Michael Brown. All rights reserved.
//  Copyright (c) 2017 Jim Bonner. All rights reserved.
//

#import "LoginViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "EmployeeStepSetupViewController.h"
#import "RegisterThanksViewController.h"
#import "Spinner.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnSend;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightForgotPass;
@property (weak, nonatomic) IBOutlet UIView *viewForgotPass;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UIView *viewForgotPassTip;
@property (weak, nonatomic) IBOutlet UITextField *txtForgotPass;

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.viewForgotPassTip.layer.cornerRadius = 10;
    self.viewForgotPass.alpha = 0;
    self.heightForgotPass.constant = 0;
    self.btnSend.layer.borderColor = [UIColor blackColor].CGColor;
    self.btnSend.layer.borderWidth = 1;
    [self.navigationController setNavigationBarHidden:false];
    
    // Do any additional setup after loading the view.
    
    UILongPressGestureRecognizer *signInLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(signInLongPress:)];
    [self.view addGestureRecognizer:signInLongPress];
    [self.view layoutIfNeeded];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"\nLogin - Init:\n%@",self.appDelegate.user);

    [self.txtEmail setText:[self getUserDefault:@"email"]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (IBAction)loginEmail:(id)sender
{
    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,10}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    if ([emailTest evaluateWithObject:self.txtEmail.text] == NO) {
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Oops!"
                                     message:@"Please enter a valid email address"
                                     preferredStyle:UIAlertControllerStyleActionSheet];
        [alert addAction:[UIAlertAction
                          actionWithTitle:@"OK"
                          style:UIAlertActionStyleDefault
                          handler:^(UIAlertAction *action)
                          {
                          }]];
        [self presentViewController:alert animated:TRUE completion:nil];
        return;
    }
    if([self.txtPassword.text length] < 6) {
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Oops!"
                                     message:@"Password must be at least 6 characters"
                                     preferredStyle:UIAlertControllerStyleActionSheet];
        [alert addAction:[UIAlertAction
                          actionWithTitle:@"OK"
                          style:UIAlertActionStyleDefault
                          handler:^(UIAlertAction *action)
                          {
                          }]];
        [self presentViewController:alert animated:TRUE completion:nil];
        return;
    }
    [self loginWithUser:self.txtEmail.text  password:self.txtPassword.text];
    
}

- (IBAction)pressClickHere:(id)sender {
    self.heightForgotPass.constant = 200;
    [UIView animateWithDuration:.3 animations:^{
        [self.view layoutIfNeeded];}
     
                     completion:^ (BOOL finished)
     {
         if (finished) {
             [UIView animateWithDuration:.3 animations:^{
                 self.viewForgotPass.alpha = 1;
                 [self.view layoutIfNeeded];}];
         }
     }];
}
- (IBAction)pressSend:(id)sender
{
    AFHTTPRequestOperationManager *manager = [self getManager];
    [manager POST:@"http://uwurk.tscserver.com/api/v1/forgot-password" parameters:self.txtForgotPass.text success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"\nLogin Json Response:\n%@", responseObject);
        if(![self validateResponse:responseObject]){
            [self handleErrorJsonResponse:@"Login"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [self handleErrorAccessError:@"Login" withError:error];
    }];
}

- (void)signInLongPress:(UILongPressGestureRecognizer*)gesture {
    if ( gesture.state == UIGestureRecognizerStateEnded ) {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Select login"
                                      message:nil
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction
                          actionWithTitle:@"user Start Setup"
                          style:UIAlertActionStyleDefault
                          handler:^(UIAlertAction * action)
                          {
                              [self loginWithUser:@"employeesetup@mailinator.com" password:@"uwurk"];
                              [alert dismissViewControllerAnimated:YES completion:nil];
                          }]];
        [alert addAction:[UIAlertAction
                          actionWithTitle:@"user Landing"
                          style:UIAlertActionStyleDefault
                          handler:^(UIAlertAction * action)
                          {
                              [self loginWithUser:@"employeelanding@mailinator.com" password:@"uwurk"];
                              [alert dismissViewControllerAnimated:YES completion:nil];
                          }]];
        [alert addAction:[UIAlertAction
                          actionWithTitle:@"user Start Setup"
                          style:UIAlertActionStyleDefault
                          handler:^(UIAlertAction * action)
                          {
                              [self loginWithUser:@"employersetup@mailinator.com" password:@"uwurk"];
                              [alert dismissViewControllerAnimated:YES completion:nil];
                          }]];
        [alert addAction:[UIAlertAction
                          actionWithTitle:@"user Landing"
                          style:UIAlertActionStyleDefault
                          handler:^(UIAlertAction * action)
                          {
                              [self loginWithUser:@"employerLanding@mailinator.com" password:@"uwurk"];
                              [alert dismissViewControllerAnimated:YES completion:nil];
                          }]];
        [alert addAction:[UIAlertAction
                          actionWithTitle:@"Cancel"
                          style:UIAlertActionStyleCancel
                          handler:^(UIAlertAction * action)
                          {
                              [alert dismissViewControllerAnimated:YES completion:nil];
                          }]];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginEmployerProfileSetup:(id)sender
{
    [self loginWithUser:@"employersetup@mailinator.com" password:@"uwurk"];
}

- (IBAction)loginEmployerLanding:(id)sender
{
    [self loginWithUser:@"employerLanding@mailinator.com" password:@"uwurk"];
}

- (IBAction)loginEmployeeProfileSetup:(id)sender
{
    [self loginWithUser:@"employeesetup@mailinator.com" password:@"uwurk"];
}

- (IBAction)loginEmployeeLanding:(id)sender {
    [self loginWithUser:@"employeelanding@mailinator.com" password:@"uwurk"];
}

- (IBAction)logoutAction {
    [self logout];
}

- (void)loginWithStoredToken
{
    AFHTTPRequestOperationManager *manager = [self getManager];
    [manager POST:@"http://uwurk.tscserver.com/api/v1/profile" parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
        NSLog(@"\nLogin Json Response:\n%@", responseObject);
        if([self validateResponse:responseObject]){
            if([[self.appDelegate.user objectForKey:@"user_type"] isEqualToString:@"employee"]) {
                if([[[self.appDelegate user] objectForKey:@"setup_step"] intValue] == -1) {
                    UIViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"EmployeeLanding"];
                    [self.navigationController setViewControllers:@[myController] animated:YES];
                } else {
                    if ([[[self.appDelegate user] objectForKey:@"setup_step"] intValue] == 0)
                    {
                        UIViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"EmployeeProfileSetup"];
                        [self.navigationController pushViewController:myController animated:FALSE];
                    }
                    if ([[[self.appDelegate user] objectForKey:@"setup_step"] intValue] == 1)
                    {
                        UIViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"EmployeeProfileSetup1"];
                        [self.navigationController pushViewController:myController animated:FALSE];
                    }
                    if ([[[self.appDelegate user] objectForKey:@"setup_step"] intValue] == 2)
                    {
                        UIViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"EmployeeProfileSetup2"];
                        [self.navigationController pushViewController:myController animated:FALSE];
                    }
                    if ([[[self.appDelegate user] objectForKey:@"setup_step"] intValue] == 3)
                    {
                        UIViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"EmployeeProfileSetup3"];
                        [self.navigationController pushViewController:myController animated:FALSE];
                    }
                    if ([[[self.appDelegate user] objectForKey:@"setup_step"] intValue] == 4)
                    {
                        UIViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"EmployeeProfileSetup4"];
                        [self.navigationController pushViewController:myController animated:FALSE];
                    }
                    if ([[[self.appDelegate user] objectForKey:@"setup_step"] intValue] == 5)
                    {
                        UIViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"EmployeeProfileSetup5"];
                        [self.navigationController pushViewController:myController animated:FALSE];
                    }
                    if ([[[self.appDelegate user] objectForKey:@"setup_step"] intValue] == 6)
                    {
                        UIViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"EmployeeProfileSetup6"];
                        [self.navigationController pushViewController:myController animated:FALSE];
                    }
//                    [self.navigationController setViewControllers:viewControllers animated:YES];
                    
                    UIBarButtonItem *logoutButton=[[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(logoutAction)];
                    self.navigationItem.rightBarButtonItem = logoutButton;
                    
                }
            } else if([[self.appDelegate.user objectForKey:@"user_type"] isEqualToString:@"employer"]) {
                if([[[self.appDelegate user] objectForKey:@"setup_step"] intValue] == -1) {
                    UIViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"EmployerLanding"];
                    [self.navigationController setViewControllers:@[myController] animated:YES];
                } else {
                    UIViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"EmployerProfileSetup0"];
                    [self.navigationController setViewControllers:@[myController] animated:YES];
                }
            } else {
                // All hell has broken loose
                UIAlertController * alert = [UIAlertController
                                             alertControllerWithTitle:@"Oops!"
                                             message:@"Unable to validate user type"
                                             preferredStyle:UIAlertControllerStyleActionSheet];
                [alert addAction:[UIAlertAction
                                  actionWithTitle:@"OK"
                                  style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction *action)
                                  {
                                  }]];
                [self presentViewController:alert animated:TRUE completion:nil];
                return;
            }
        }
    }
      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          NSLog(@"Error: %@", error);
          [self handleErrorAccessError:@"Login" withError:error];
      }];
    
}

- (void)loginWithUser:(NSString *)user password:(NSString *)password
{
    NSLog(@"\nLogin with user:\n%@",self.appDelegate.user);
    
    AFHTTPRequestOperationManager *manager = [self getManagerNoAuth];
    NSDictionary *parameters = @{@"email": user,@"password": password};
    [manager POST:@"http://uwurk.tscserver.com/api/v1/login" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"\nLogin Json Response:\n %@", responseObject);
        if(![self validateResponse:responseObject]) {
            NSString *message = [NSString stringWithFormat:@"Unable to validate login\n\n%@",[responseObject objectForKey:@"message"]];
            UIAlertController * alert = [UIAlertController
                                         alertControllerWithTitle:@"Oops!"
                                         message:message
                                         preferredStyle:UIAlertControllerStyleActionSheet];
            [alert addAction:[UIAlertAction
                              actionWithTitle:@"OK"
                              style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction *action)
                              {
                              }
                              ]];
            [self presentViewController:alert animated:TRUE completion:nil];
        }
        if([responseObject isKindOfClass:[NSDictionary class]]) {
            [self saveUserDefault:user Key:@"email"];
            if([((NSDictionary*)responseObject) valueForKey:@"api_auth_token"] != nil){
                [self saveUserDefault:[((NSDictionary*)responseObject) valueForKey:@"api_auth_token"] Key:@"api_auth_token"];
                [self loginWithStoredToken];
           } else {
               [self handleErrorValidateLogin];
           }
        } else {
            [self handleErrorValidateLogin];
        }
        
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            [self handleErrorAccessError:@"Login" withError:error];
        }];
}


- (IBAction)signInWithFacebookButtonPressed:(id)sender
{
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
             return;
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
             return;
         } else {
             DLog(@"Logged in");
             
             NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
             [parameters setValue:@"id,name,email" forKey:@"fields"];
             
             [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters]
              startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                           id result, NSError *error) {

                  if ([FBSDKAccessToken currentAccessToken]) {
                      
                      NSString *email = [result objectForKey:@"email"];
                      
                      AFHTTPRequestOperationManager *manager = [self getManagerNoAuth];
                      NSMutableDictionary *parameters = [NSMutableDictionary new];
                      [parameters setObject:[[FBSDKAccessToken currentAccessToken] tokenString ]forKey:@"access_token"];
                      [parameters setObject:email forKey:@"email"];
                      [parameters setObject:@1 forKey:@"facebook"];
                      
                      [manager POST:@"http://uwurk.tscserver.com/api/v1/login" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                          
                          NSLog(@"JSON: %@", responseObject);
                          BOOL bValid = [self validateResponse:responseObject];
                          if(!bValid) {
                              [self handleErrorJsonResponse:@"Login"];
                              return;
                          }
                          if([responseObject isKindOfClass:[NSDictionary class]]){
                              if([((NSDictionary*)responseObject) valueForKey:@"api_auth_token"] != nil){
                                  [self saveUserDefault:[((NSDictionary*)responseObject) valueForKey:@"api_auth_token"] Key:@"api_auth_token"];
                                  //                [self saveUserDefault:[((NSDictionary*)responseObject) valueForKey:@"status"] Key:@"status"];
                                  //                [self saveUserDefault:[((NSDictionary*)responseObject) valueForKey:@"user_type"] Key:@"user_type"];
                                  [self loginWithStoredToken];
                              }
                              else
                              {
                                  [self handleErrorValidateLogin];
                                  return;
                              }
                          }
                          else{
                              [self handleErrorValidateLogin];
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
