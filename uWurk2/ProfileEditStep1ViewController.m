//
//  ProfileEditStep1ViewController.m
//  uWurk2
//
//  Created by Avery Bonner on 9/16/15.
//  Copyright (c) 2015 Michael Brown. All rights reserved.
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
@property (weak, nonatomic) IBOutlet UIButton *btnEmail;
@property (weak, nonatomic) IBOutlet UIButton *btnText;
@property (weak, nonatomic) IBOutlet UIView   *viewTip;
@property (weak, nonatomic) IBOutlet UIView   *viewCommunication;
@property (weak, nonatomic) IBOutlet UIButton *btnSaveChanges;

@end

@implementation ProfileEditStep1ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.btnSaveChanges.enabled = NO;
    self.viewTip.layer.cornerRadius = 5;
    self.viewCommunication.layer.cornerRadius = 5;
    
    [self assignValue:[self.appDelegate.user objectForKey:@"email"] control:self.txtEmail];
    [self assignValue:[self.appDelegate.user objectForKey:@"first_name"] control:self.txtFirstName];
    [self assignValue:[self.appDelegate.user objectForKey:@"last_name"] control:self.txtLastName];
    [self assignValue:[self.appDelegate.user objectForKey:@"birthdate"] control:self.txtBirthDate];
    [self assignValue:[self.appDelegate.user objectForKey:@"cell_phone"] control:self.txtPhone];
    if([[self.appDelegate.user objectForKey:@"gender"] isEqualToString:@"m"])
        self.btnGenderMale.selected = TRUE;
    else if([[self.appDelegate.user objectForKey:@"gender"] isEqualToString:@"f"])
        self.btnGenderFemale.selected = TRUE;
    if([[self.appDelegate.user objectForKey:@"contact_method_id"] intValue] == 0)
    {
        self.btnEmail.selected = FALSE;
        self.btnText.selected = FALSE;
    }
    else if([[self.appDelegate.user objectForKey:@"contact_method_id"] intValue] == 1)
    {
        self.btnEmail.selected = TRUE;
        self.btnText.selected = FALSE;
    }
    if([[self.appDelegate.user objectForKey:@"contact_method_id"] intValue] == 2)
    {
        self.btnText.selected = TRUE;
        self.btnEmail.selected = FALSE;
    }
    else if([[self.appDelegate.user objectForKey:@"contact_method_id"] intValue] == 3)
    {
        self.btnEmail.selected = TRUE;
        self.btnText.selected = TRUE;
    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (IBAction)changeSave:(id)sender {
    self.btnSaveChanges.enabled = YES;
}
- (IBAction)changeCheckBox:(UIButton *)sender {
    [sender setSelected:!sender.selected];
    self.btnSaveChanges.enabled = YES;
}
- (IBAction)nextPress:(id)sender {
    // Did data get updated?
    
    AFHTTPRequestOperationManager *manager = [self getManager];
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
        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"OOPS!"
                                                         message:Error
                                                        delegate:self
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles: nil];
        [alert show];
    }
    else {
    if([params count]){
        [manager POST:@"http://uwurk.tscserver.com/api/v1/profile" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            if([self validateResponse:responseObject]){
                
                // Update the user object
                
                
                UIViewController *myController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"EmployeeLanding"];
                [self.navigationController setViewControllers:@[myController] animated:TRUE];
                
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Error"
                                                             message:@"Unable to contact server"
                                                            delegate:self
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles: nil];
            [alert show];
        }];
    }
    else{
        UIViewController *myController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"EmployeeLanding"];
        [self.navigationController setViewControllers:@[myController] animated:TRUE];
    }
}
}

@end
