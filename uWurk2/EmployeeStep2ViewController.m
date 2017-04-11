//
//  EmployyeStep2ViewController.m
//  uWurk2
//
//  Created by Avery Bonner on 9/4/15.
//  Copyright (c) 2015 Michael Brown. All rights reserved.
//  Copyright (c) 2017 Jim Bonner. All rights reserved.
//

#import "EmployeeStep2ViewController.h"

@interface EmployeeStep2ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txtMiles;
@property (weak, nonatomic) IBOutlet UITextField *txtZip;
@property (weak, nonatomic) IBOutlet UITextField *txtHourly;
@property (weak, nonatomic) IBOutlet UIButton    *btnTips;
@property (weak, nonatomic) IBOutlet UIButton    *btnHourly;

@end

@implementation EmployeeStep2ViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self assignValue:[self.appDelegate.user objectForKey:@"miles(0)"] control:self.txtMiles];
    [self assignValue:[self.appDelegate.user objectForKey:@"zip(0)"] control:self.txtZip];
    [self assignValue:[self.appDelegate.user objectForKey:@"hourly_wage"] control:self.txtHourly];
    if([[self.appDelegate.user objectForKey:@"hourlySelected"] isEqualToString:@"1"]) {
        [self.btnHourly setSelected:TRUE];
    } else {
        [self.btnHourly setSelected:FALSE];
    }
    if([[self.appDelegate.user objectForKey:@"tipsSelected"] isEqualToString:@"1"]) {
        [self.btnTips setSelected:TRUE];
    } else {
        [self.btnTips setSelected:FALSE];
    }
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self saveUserData];
}

-(void) saveUserData
{
    [self.appDelegate.user setObjectOrNil:[self.txtMiles text] forKey:@"miles(0)"];
    [self.appDelegate.user setObjectOrNil:[self.txtZip   text] forKey:@"zip(0)"];
    [self.appDelegate.user setObjectOrNil:[self.txtHourly text] forKey:@"hourly_wage"];
    [self.appDelegate.user setObjectOrNil:self.btnHourly.selected ? @"1" : @"0" forKey:@"hourlySelected"];
    [self.appDelegate.user setObjectOrNil:self.btnTips.selected ? @"1" : @"0" forKey:@"tipsSelected"];
    
    [self saveUserDefault:[self objectToJsonString:self.appDelegate.user]
                      Key:@"user_data"];
}

- (IBAction)changeCheckBox:(UIButton *)sender {
    [sender setSelected:!sender.selected];
}
- (IBAction)pressHere:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.ncsl.org/research/labor-and-employment/state-minimum-wage-chart.aspx"]];
}

- (IBAction)nextPress:(id)sender
{
    AFHTTPRequestOperationManager *manager = [self getManager];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[self.txtMiles text] forKey:@"miles[0]"];
    [params setObject:[self.txtZip text] forKey:@"zip[0]"];
    NSMutableArray *wageArray = [[NSMutableArray alloc]init];
    if(self.btnHourly.selected) {
        [wageArray addObject:@"hourly"];
        [params setObject:self.txtHourly.text forKey:@"hourly_wage"];
    }
    if(self.btnTips.selected) {
        [wageArray addObject:@"tips"];
    }
    if([wageArray count]) {
        [params setObject:wageArray forKey:@"wage_type"];
    }
    
    NSMutableString *Error = [[NSMutableString alloc] init];
    [Error appendString:@"To continue, complete the missing information:"];
    if (self.txtMiles.text.length ==0) {
        [Error appendString:@"\n\nMiles"];
    }
    if (self.txtZip.text.length ==0) {
        [Error appendString:@"\n\nZip Code"];
    }
    if (self.btnHourly.selected == YES && self.txtHourly.text.length == 0) {
        [Error appendString:@"\n\nHourly Wage"];
    }
    if (self.btnHourly.selected == NO && self.btnTips.selected == NO) {
        [Error appendString:@"\n\nSelect Wage Type"];
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
    }
    else
    {
        if([params count])
        {
            [manager POST:@"http://uwurk.tscserver.com/api/v1/profile" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"JSON: %@", responseObject);
                if([self validateResponse:responseObject]){
                     UIViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"EmployeeProfileSetup3"];
                    [self.navigationController pushViewController:myController animated:TRUE];
                    
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
        }
        else
        {
            UIViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"EmployeeProfileSetup3"];
            [self.navigationController pushViewController:myController animated:TRUE];
        }
    }
}

@end
