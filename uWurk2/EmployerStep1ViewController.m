//
//  EmployerStep1ViewController.m
//  uWurk2
//
//  Created by Avery Bonner on 9/4/15.
//  Copyright (c) 2015 Michael Brown. All rights reserved.
//  Copyright (c) 2017 Jim Bonner. All rights reserved.
//

#import "EmployerStep1ViewController.h"

@interface EmployerStep1ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtVerifyPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtFirstName;
@property (weak, nonatomic) IBOutlet UITextField *txtLastName;

@end

@implementation EmployerStep1ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"\nEmployer Step 1 Init:\n%@",self.appDelegate.user);
    
    [self assignValue:[self getUserDefault:@"email"] control:self.txtEmail];
    [self.txtEmail setAlpha:0.2];
    [self.txtEmail setEnabled:NO];
    [self assignValue:@"" control:self.txtPassword];
    [self assignValue:@"" control:self.txtVerifyPassword];
    [self assignValue:[self.appDelegate.user objectForKey:@"first_name"] control:self.txtFirstName];
    [self assignValue:[self.appDelegate.user objectForKey:@"last_name"] control:self.txtLastName];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)nextPress:(id)sender
{
    AFHTTPRequestOperationManager *manager = [self getManager];
    NSMutableString *Error = [[NSMutableString alloc] init];
    [Error appendString:@"To continue, complete the missing information:"];
    if (self.txtEmail.text.length == 0) {
        [Error appendString:@"\n\nEmail"];
    }
    if (self.txtPassword.text.length == 0) {
        [Error appendString:@"\n\nModify Password"];
    }
    if (self.txtVerifyPassword.text.length == 0) {
        [Error appendString:@"\n\nVerify Password"];
    }
    if (self.txtFirstName.text.length == 0) {
        [Error appendString:@"\n\nFirst Name"];
    }
    if (self.txtLastName.text.length == 0) {
        [Error appendString:@"\n\nLast Name"];
    }
    if ((Error.length) > 50) {
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Oops!"
                                     message:Error
                                     preferredStyle:UIAlertControllerStyleActionSheet];
        [alert addAction:[UIAlertAction
                          actionWithTitle:@"OK"
                          style:UIAlertActionStyleDefault
                          handler:^(UIAlertAction *action)
                          {
                          }]];
        [self presentViewController:alert animated:TRUE completion:nil];
    } else {
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [self updateParamDict:params value:self.txtEmail.text key:@"email"];
        [self updateParamDict:params value:self.txtPassword.text key:@"password"];
        [self updateParamDict:params value:self.txtFirstName.text key:@"first_name"];
        [self updateParamDict:params value:self.txtLastName.text key:@"last_name"];
        if([params count]){
            [manager POST:@"http://uwurk.tscserver.com/api/v1/profile" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"\nEmployer Step 1 - Response: %@", responseObject);
                if([self validateResponse:responseObject]){
                    UIViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"EmployerProfileSetup2"];
                    [self.navigationController setViewControllers:@[myController] animated:YES];
                    
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
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
                [self presentViewController:alert animated:TRUE completion:nil];
            }];
        } else {
            UIViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"EmployerProfileSetup2"];
            [self.navigationController setViewControllers:@[myController] animated:YES];
        }
    }
}

@end
