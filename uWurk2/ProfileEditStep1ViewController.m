//
//  ProfileEditStep1ViewController.m
//  uWurk2
//
//  Created by Avery Bonner on 9/16/15.
//  Copyright (c) 2015 Michael Brown. All rights reserved.
//  Copyright (c) 2017 Jim Bonner. All rights reserved.
//

#import "ProfileEditStep1ViewController.h"
#import "RadioButton.h"

@interface ProfileEditStep1ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtFirstName;
@property (weak, nonatomic) IBOutlet UITextField *txtLastName;
@property (weak, nonatomic) IBOutlet UITextField *txtBirthDate;
@property (weak, nonatomic) IBOutlet UITextField *txtPhone;
@property (weak, nonatomic) IBOutlet RadioButton *btnGenderMale;
@property (weak, nonatomic) IBOutlet RadioButton *btnGenderFemale;
@property (weak, nonatomic) IBOutlet UIButton    *btnEmail;
@property (weak, nonatomic) IBOutlet UIButton    *btnText;
@property (weak, nonatomic) IBOutlet UIView      *viewTip;
@property (weak, nonatomic) IBOutlet UIView      *viewCommunication;
@property (weak, nonatomic) IBOutlet UIButton    *btnSaveChanges;

@end

@implementation ProfileEditStep1ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.btnSaveChanges.enabled = NO;
    self.viewTip.layer.cornerRadius = 5;
    self.viewCommunication.layer.cornerRadius = 10;
    
    NSLog(@"\nEmployee Profile Edit Step 1:\n%@",self.appDelegate.user);
    
    [self assignValue:[self.appDelegate.user objectForKey:@"email"] control:self.txtEmail];
    [self.txtEmail setAlpha:0.2];
    [self.txtEmail setEnabled:NO];
    
    [self assignValue:[self.appDelegate.user objectForKey:@"first_name"] control:self.txtFirstName];
    [self assignValue:[self.appDelegate.user objectForKey:@"last_name"] control:self.txtLastName];
    [self assignValue:[self.appDelegate.user objectForKey:@"birthdate"] control:self.txtBirthDate];
    [self assignValue:[self.appDelegate.user objectForKey:@"cell_phone"] control:self.txtPhone];
    if([[self.appDelegate.user objectForKey:@"gender"] isEqualToString:@"m"])
    {
        self.btnGenderMale.selected = TRUE;
    } else if([[self.appDelegate.user objectForKey:@"gender"] isEqualToString:@"f"])
    {
        self.btnGenderFemale.selected = TRUE;
    }
    self.btnEmail.selected = FALSE;
    self.btnText.selected  = FALSE;
    if(([[self.appDelegate.user objectForKey:@"contact_method_id"] intValue] & 1) == 1)
    {
        self.btnEmail.selected = TRUE;
    }
    if(([[self.appDelegate.user objectForKey:@"contact_method_id"] intValue] & 2 ) == 2)
    {
        self.btnText.selected = TRUE;
    }
}

- (IBAction)changeSave:(id)sender
{
    self.btnSaveChanges.enabled = YES;
}

- (IBAction)changeCheckBox:(UIButton *)sender {
    [sender setSelected:!sender.selected];
    self.btnSaveChanges.enabled = YES;
}
- (IBAction)nextPress:(id)sender
{
    NSMutableString *Error = [[NSMutableString alloc] init];
    [Error appendString:@"To continue, complete the missing information:"];
    if (self.txtEmail.text.length == 0) {
        [Error appendString:@"\n\nEmail Address"];
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
        [self updateParamDict:params value:self.txtFirstName.text key:@"first_name"];
        [self updateParamDict:params value:self.txtLastName.text key:@"last_name"];
        [self updateParamDict:params value:self.txtEmail.text key:@"email"];
        [self updateParamDict:params value:self.txtBirthDate.text key:@"birthdate"];
        [self updateParamDict:params value:self.txtPhone.text key:@"cell_phone"];
        [self updateParamDict:params value:self.btnGenderMale.selected ? @"m" : @"f" key:@"gender"];
        if(self.btnEmail.isSelected && self.btnText.isSelected) {
            [self updateParamDict:params value:@"3" key:@"contact_method_id"];
        }
        else if(self.btnText.isSelected) {
            [self updateParamDict:params value:@"2" key:@"contact_method_id"];
        }
        else if(self.btnEmail.isSelected) {
            [self updateParamDict:params value:@"1" key:@"contact_method_id"];
        }
        else {
            [self updateParamDict:params value:@"0" key:@"contact_method_id"];
        }
    if([params count]){
        AFHTTPRequestOperationManager *manager = [self getManager];
        [manager POST:@"http://uwurk.tscserver.com/api/v1/profile" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            if([self validateResponse:responseObject])
            {
                UIViewController *myController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"EmployeeLanding"];
                [self.navigationController setViewControllers:@[myController] animated:TRUE];
            } else {
                [self handleErrorJsonResponse:@"ProfileEditStep1"];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            [self handleErrorAccessError:error];
        }];
    }
    else{
        UIViewController *myController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"EmployeeLanding"];
        [self.navigationController setViewControllers:@[myController] animated:TRUE];
    }
}
}

@end
