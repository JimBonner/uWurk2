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

- (void)viewDidLoad
{
    [super viewDidLoad];
}
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"\nEdit Employer Contact Info:\n%@",self.appDelegate.user);
        
    self.viewCommunication.layer.cornerRadius = 10;
    [self assignValue:[self.appDelegate.user objectForKey:@"email"] control:self.txtEmail];
    [self assignValue:[self.appDelegate.user objectForKey:@"first_name"] control:self.txtFirstName];
    [self assignValue:[self.appDelegate.user objectForKey:@"last_name"] control:self.txtLastName];
    [self assignValue:[self.appDelegate.user objectForKey:@"cell_phone"] control:self.txtPhone];
    
    self.btnPosText.selected = NO;
    if(([[self.appDelegate.user objectForKey:@"pos_replies_cmid"]intValue] & 1) == 1) {
        self.btnPosText.selected = YES;
    }
    self.btnPosEmail.selected = NO;
    if(([[self.appDelegate.user objectForKey:@"pos_replies_cmid"]intValue] & 2) == 2) {
        self.btnPosEmail.selected = YES;
    }
    self.btnNegText.selected = NO;
    if(([[self.appDelegate.user objectForKey:@"neg_replies_cmid"]intValue] & 1) == 1) {
        self.btnNegText.selected = YES;
    }
    self.btnNegEmail.selected = NO;
    if(([[self.appDelegate.user objectForKey:@"neg_replies_cmid"]intValue] & 2) == 2) {
        self.btnNegEmail.selected = YES;
    }
    self.btnOtherText.selected = NO;
    if(([[self.appDelegate.user objectForKey:@"other_msgs_cmid"]intValue] & 1) == 1) {
        self.btnOtherText.selected = YES;
    }
    self.btnOtherEmail.selected = NO;
    if(([[self.appDelegate.user objectForKey:@"other_msgs_cmid"]intValue] & 2) == 2) {
        self.btnOtherEmail.selected = YES;
    }
    self.btnPosWebsite.selected = YES;
    self.btnPosWebsite.userInteractionEnabled = NO;
    self.btnPosWebsite.alpha = 0.3;
    self.btnNegWebsite.selected = YES;
    self.btnNegWebsite.userInteractionEnabled = NO;
    self.btnNegWebsite.alpha = 0.3;
    self.btnOtherWebsite.selected = YES;
    self.btnOtherWebsite.userInteractionEnabled = NO;
    self.btnOtherWebsite.alpha = 0.3;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)changeCheckBox:(UIButton *)sender
{
    [sender setSelected:!sender.selected];
}

- (IBAction)pressSaveChanges:(id)sender
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
    if ((self.btnPosText.selected == TRUE && self.txtPhone.text.length == 0) || (self.btnNegText.selected == TRUE && self.txtPhone.text.length == 0) || (self.btnOtherText.selected == TRUE && self.txtPhone.text.length == 0)) {
        [Error appendString:@"\n\nPhone Number"];
    }
    if ((Error.length) > 50) {
        [self handleErrorWithMessage:Error];
    } else {
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [self updateParamDict:params value:self.txtEmail.text key:@"email"];
        [self updateParamDict:params value:self.txtFirstName.text key:@"first_name"];
        [self updateParamDict:params value:self.txtLastName.text key:@"last_name"];
        [self updateParamDict:params value:self.txtPhone.text key:@"cell_phone"];
        if (self.btnPosText.selected == YES) {
            [params setValue:@"1" forKey:@"pos_replies_text"];
        }
        if (self.btnPosEmail.selected == YES) {
            [params setValue:@"1" forKey:@"pos_replies_email"];
        }
        if (self.btnNegText.selected == YES) {
            [params setValue:@"1" forKey:@"neg_replies_text"];
        }
        if (self.btnNegEmail.selected == YES) {
            [params setValue:@"1" forKey:@"neg_replies_email"];
        }
        if (self.btnOtherText.selected == YES) {
            [params setValue:@"1" forKey:@"other_msgs_text"];
        }
        if (self.btnOtherEmail.selected == YES) {
            [params setValue:@"1" forKey:@"other_msgs_email"];
        }
        if([params count]){
            AFHTTPRequestOperationManager *manager = [self getManager];
            [manager POST:@"http://uwurk.tscserver.com/api/v1/profile" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"\nEdit Employer Contact Info - Json:\n%@", responseObject);
                if([self validateResponse:responseObject]) {
                    [self.navigationController popViewControllerAnimated:TRUE];
                } else {
                    [self handleErrorJsonResponse:@"Edit Employee Contact Info"];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                [self handleErrorAccessError:@"Edit Employee Contact Info" withError:error];
            }];
        } else {
            [self.navigationController popViewControllerAnimated:TRUE];
        }
    }
}

@end
