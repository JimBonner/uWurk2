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
    
    [self saveStepNumber:1 completion:^(NSInteger result) { }];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"\nEmployer Step 1 - Init:\n%@",self.appDelegate.user);
    
    [self assignValue:[self.appDelegate.user objectForKey:@"email"] control:self.txtEmail];
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
    if (![self.txtPassword.text isEqualToString:self.txtVerifyPassword.text]) {
        [Error appendString:@"\n\nPasswords Do Not Match"];
    }
    if (self.txtFirstName.text.length == 0) {
        [Error appendString:@"\n\nFirst Name"];
    }
    if (self.txtLastName.text.length == 0) {
        [Error appendString:@"\n\nLast Name"];
    }
    if ((Error.length) > 50) {
        [self handleErrorWithMessage:Error];
    } else {
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [self updateParamDict:params value:self.txtEmail.text key:@"email"];
        [self updateParamDict:params value:self.txtPassword.text key:@"password"];
        [self updateParamDict:params value:self.txtFirstName.text key:@"first_name"];
        [self updateParamDict:params value:self.txtLastName.text key:@"last_name"];
        [self updateParamDict:params value:@"1" key:@"setup_step"];
        if([params count]){
            [manager POST:@"http://uwurk.tscserver.com/api/v1/profile" parameters:params
                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSLog(@"\nEmployer Step 1 - Json Response: %@", responseObject);
                    if([self validateResponse:responseObject]) {
                        UIViewController *myController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]  instantiateViewControllerWithIdentifier:@"EmployerProfileSetup2"];
                        [self.navigationController pushViewController:myController animated:YES];
                    } else {
                        [self handleErrorUnableToSaveData:@"Employer Step 1"];
                    }
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                    [self handleErrorAccessError:@"Employer Step 1" withError:error];
            }];
        } else {
            UIViewController *myController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]  instantiateViewControllerWithIdentifier:@"EmployerProfileSetup2"];
            [self.navigationController pushViewController:myController animated:YES];
        }
    }
}

@end
