//
//  EmployeeStep1ViewController.m
//  uWurk2
//
//  Created by Avery Bonner on 9/2/15.
//  Copyright (c) 2015 Michael Brown. All rights reserved.
//  Copyright (c) 2017 Jim Bonner. All rights reserved.
//

#import "EmployeeStep1ViewController.h"
#import "RadioButton.h"

@interface EmployeeStep1ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtVerifyPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtFirstName;
@property (weak, nonatomic) IBOutlet UITextField *txtLastName;
@property (weak, nonatomic) IBOutlet UITextField *txtBirthDate;
@property (weak, nonatomic) IBOutlet UITextField *txtPhone;
@property (weak, nonatomic) IBOutlet RadioButton *btnGenderMale;
@property (weak, nonatomic) IBOutlet RadioButton *btnGenderFemale;
@property (weak, nonatomic) IBOutlet UIButton *btnEmail;
@property (weak, nonatomic) IBOutlet UIButton *btnText;
@property (weak, nonatomic) IBOutlet UIView *viewTip;
@property (weak, nonatomic) IBOutlet UIView *viewCommunication;

@end

@implementation EmployeeStep1ViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self saveStepNumber:1 completion:^(NSInteger result) { }];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.viewCommunication.layer.cornerRadius = 10;
    
    NSLog(@"\nEmployee Step 1 - Init:\n%@",self.appDelegate.user);
    
    [self assignValue:[self.appDelegate.user objectForKey:@"email"] control:self.txtEmail];
    [self.txtEmail setAlpha:0.2];
    [self.txtEmail setEnabled:NO];
    
    if([[self.appDelegate.user objectForKey:@"first_name"] isEqualToString:@""]) return;

    [self assignValue:@"" control:self.txtPassword];
    [self assignValue:@"" control:self.txtVerifyPassword];
    [self assignValue:[self.appDelegate.user objectForKey:@"first_name"] control:self.txtFirstName];
    [self assignValue:[self.appDelegate.user objectForKey:@"last_name"] control:self.txtLastName];
    [self assignValue:[self.appDelegate.user objectForKey:@"birthdate"] control:self.txtBirthDate];
    [self assignValue:[self.appDelegate.user objectForKey:@"cell_phone"] control:self.txtPhone];
    if([[self.appDelegate.user objectForKey:@"gender"] isEqualToString:@"m"]) {
        self.btnGenderMale.selected = TRUE;
        self.btnGenderFemale.selected = FALSE;
    } else {
        self.btnGenderMale.selected = FALSE;
        self.btnGenderFemale.selected = TRUE;
    }
    self.btnEmail.selected = FALSE;
    self.btnText.selected  = FALSE;
    NSUInteger contact = [[self.appDelegate.user objectForKey:@"contact_method_id"]intValue];
    if(contact == 1) {
        self.btnText.selected  = TRUE;
        self.btnEmail.selected = FALSE;
    } else if(contact == 2) {
        self.btnText.selected  = FALSE;
        self.btnEmail.selected = TRUE;
    } else if(contact == 3) {
        self.btnEmail.selected = TRUE;
        self.btnText.selected  = TRUE;
    }
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (IBAction)changeCheckBox:(UIButton *)sender
{
    [sender setSelected:!sender.selected];
}

- (IBAction)nextPress:(id)sender
{
    NSMutableString *Error = [[NSMutableString alloc] init];
    [Error appendString:@"To continue, complete the missing information:"];
    if (self.txtEmail.text.length == 0) {
        [Error appendString:@"\n\nEmail Address"];
    }
    if (self.txtPassword.text.length == 0) {
        [Error appendString:@"\n\nChange Password"];
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
    if (self.txtBirthDate.text.length == 0) {
        [Error appendString:@"\n\nBirth Date"];
    }
    if (self.btnGenderFemale.selected == NO && self.btnGenderMale.selected == NO) {
        [Error appendString:@"\n\nSelect Gender"];
    }
    if (self.txtPhone.text.length == 0) {
        [Error appendString:@"\n\nPhone Number"];
    }
    if ((Error.length) > 50) {
        [self handleErrorWithMessage:Error];
    } else {
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [self updateParamDict:params value:self.txtEmail.text key:@"email"];
        [self updateParamDict:params value:self.txtPassword.text key:@"password"];
        [self updateParamDict:params value:self.txtFirstName.text key:@"first_name"];
        [self updateParamDict:params value:self.txtLastName.text key:@"last_name"];
        [self updateParamDict:params value:self.txtBirthDate.text key:@"birthdate"];
        [self updateParamDict:params value:self.txtPhone.text key:@"cell_phone"];
        [self updateParamDict:params value:self.btnGenderMale.selected ? @"m" : @"f" key:@"gender"];
        NSUInteger contact = 0;
        if(self.btnText.selected) {
            contact = contact | 1;
        }
        if(self.btnEmail.selected) {
            contact = contact | 2;
        }
        [self updateParamDict:params value:[[NSNumber numberWithInteger:contact]stringValue]  key:@"contact_method_id"];
        if([params count]) {
            AFHTTPRequestOperationManager *manager = [self getManager];
            [manager POST:@"http://uwurk.tscserver.com/api/v1/profile" parameters:params
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      NSLog(@"\nEmployee Step 1 - Json Response: %@", responseObject);
                      if([self validateResponse:responseObject])
                      {
                          UIViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"EmployeeProfileSetup2"];
                          [self.navigationController pushViewController:myController animated:TRUE];
                      } else {
                          [self handleErrorJsonResponse:@"EmployeeStep1"];
                      }
                  }
                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      NSLog(@"Error: %@", error);
                      [self handleServerErrorUnableToContact];
                 }
             ];
        } else {
            UIViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"EmployeeProfileSetup2"];
            [self.navigationController pushViewController:myController animated:TRUE];
        }
    }
}

@end
