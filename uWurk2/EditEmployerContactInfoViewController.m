//
//  EditEmployerContactInfoViewController.m
//  uWurk2
//
//  Created by Avery Bonner on 2/19/16.
//  Copyright (c) 2016 Michael Brown. All rights reserved.
//  Copyright (c) 2017 Jim Bonner. All rights reserved.
//

#import "EditEmployerContactInfoViewController.h"

@interface EditEmployerContactInfoViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtChangePassword;
@property (weak, nonatomic) IBOutlet UITextField *txtVerifyPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtFirstName;
@property (weak, nonatomic) IBOutlet UITextField *txtLastName;
@property (weak, nonatomic) IBOutlet UITextField *txtPhone;
@property (weak, nonatomic) IBOutlet UIView *viewCommunication;
@property (weak, nonatomic) IBOutlet UIButton *btnPosText;
@property (weak, nonatomic) IBOutlet UIButton *btnPosEmail;
@property (weak, nonatomic) IBOutlet UIButton *btnPosWebsite;
@property (weak, nonatomic) IBOutlet UIButton *btnNegText;
@property (weak, nonatomic) IBOutlet UIButton *btnNegEmail;
@property (weak, nonatomic) IBOutlet UIButton *btnNegWebsite;
@property (weak, nonatomic) IBOutlet UIButton *btnOtherText;
@property (weak, nonatomic) IBOutlet UIButton *btnOtherEmail;
@property (weak, nonatomic) IBOutlet UIButton *btnOtherWebsite;

@end

@implementation EditEmployerContactInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"\nEmployer Edit Contact:\n%@",self.appDelegate.user);
        
    self.viewCommunication.layer.cornerRadius = 10;
    [self assignValue:[self.appDelegate.user objectForKey:@"email"] control:self.txtEmail];
    [self assignValue:[self.appDelegate.user objectForKey:@"first_name"] control:self.txtFirstName];
    [self assignValue:[self.appDelegate.user objectForKey:@"last_name"] control:self.txtLastName];
    [self assignValue:[self.appDelegate.user objectForKey:@"cell_phone"] control:self.txtPhone];
    if([[self.appDelegate.user objectForKey:@"pos_replies_text"] intValue] == 1) {
        
    }
    if([[self.appDelegate.user objectForKey:@"pos_replies_email"] intValue] == 1) {
        
    }
    if([[self.appDelegate.user objectForKey:@"pos_replies_text"] intValue] == 1) {
        
    }
    if([[self.appDelegate.user objectForKey:@"pos_replies_text"] intValue] == 1) {
        
    }
    if([[self.appDelegate.user objectForKey:@"neg_replies_email"] intValue] == 1) {
        
    }
    if([[self.appDelegate.user objectForKey:@"pos_replies_text"] intValue] == 1) {
        
    }
    if([[self.appDelegate.user objectForKey:@"pos_replies_text"] intValue] == 1) {
        
    }
    if([[self.appDelegate.user objectForKey:@"pos_replies_text"] intValue] == 1) {
        
    }
    if([[self.appDelegate.user objectForKey:@"pos_replies_text"] intValue] == 1) {
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changeCheckBox:(UIButton *)sender {
    [sender setSelected:!sender.selected];
}
- (IBAction)pressSaveChanges:(id)sender {
    // Did data get updated?
    
    AFHTTPRequestOperationManager *manager = [self getManager];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [self updateParamDict:params value:self.txtEmail.text key:@"email"];
    if (self.txtChangePassword.text == self.txtVerifyPassword.text) {
    [self updateParamDict:params value:self.txtPhone.text key:@"password"];
    [self updateParamDict:params value:self.txtPhone.text key:@"password_confirmation"];
    }
    [self updateParamDict:params value:self.txtFirstName.text key:@"first_name"];
    [self updateParamDict:params value:self.txtLastName.text key:@"last_name"];
    [self updateParamDict:params value:self.txtPhone.text key:@"cell_phone"];
    if (self.btnPosText.selected == TRUE) {
        [params setValue:@"1" forKey:@"pos_replies_text"];
    }
    if (self.btnPosEmail.selected == TRUE) {
        [params setValue:@"1" forKey:@"pos_replies_email"];
    }
    if (self.btnPosWebsite.selected == TRUE) {
        [params setValue:@"1" forKey:@"pos_replies_website"];
    }
    if (self.btnNegText.selected == TRUE) {
        [params setValue:@"1" forKey:@"neg_replies_text"];
    }
    if (self.btnNegEmail.selected == TRUE) {
        [params setValue:@"1" forKey:@"neg_replies_email"];
    }
    if (self.btnNegWebsite.selected == TRUE) {
        [params setValue:@"1" forKey:@"neg_replies_website"];
    }
    if (self.btnOtherText.selected == TRUE) {
        [params setValue:@"1" forKey:@"other_msgs_text"];
    }
    if (self.btnOtherEmail.selected == TRUE) {
        [params setValue:@"1" forKey:@"other_msgs_email"];
    }
    if (self.btnOtherWebsite.selected == TRUE) {
        [params setValue:@"1" forKey:@"other_msgs_website"];
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
    if (self.txtChangePassword.text != self.txtVerifyPassword.text) {
        [Error appendString:@"\n\nPasswords Do Not Match"];
    }
    if ((self.btnPosText.selected == TRUE && self.txtPhone.text.length == 0) || (self.btnNegText.selected == TRUE && self.txtPhone.text.length == 0) || (self.btnOtherText.selected == TRUE && self.txtPhone.text.length == 0)) {
        [Error appendString:@"\n\nPhone Number"];
    }
    if ((Error.length) > 50) {
        [self handleErrorWithMessage:Error];
    } else {
        if([params count]){
            [manager POST:@"http://uwurk.tscserver.com/api/v1/profile" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"JSON: %@", responseObject);
                if([self validateResponse:responseObject]){
                    
                    // Update the user object
                    
                    
                    UIViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"EmployeeProfileSetup2"];
                    [self.navigationController pushViewController:myController animated:TRUE];
                    
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                [self handleServerErrorUnableToContact];
            }];
        }
        else{
            UIViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"EmployeeProfileSetup2"];
            [self.navigationController pushViewController:myController animated:TRUE];
        }
    }
}

@end
