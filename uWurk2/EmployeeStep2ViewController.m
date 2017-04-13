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

@property (weak, nonatomic) NSString *saveHourly;

@end

@implementation EmployeeStep2ViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"%@",self.appDelegate.user);
    
    NSArray *array = [self.appDelegate.user objectForKey:@"availability"];
    if([array count] <= 0) {
        self.txtHourly.enabled = NO;
        return;
    }
    NSDictionary *availability = array[0];
    [self assignValue:[[NSNumber numberWithInteger:[[availability objectForKey:@"miles"]intValue]]stringValue] control:self.txtMiles];
    [self assignValue:[availability objectForKey:@"zip"] control:self.txtZip];
    [self assignValue:[self.appDelegate.user objectForKey:@"hourly_wage"] control:self.txtHourly];
    if([[self.appDelegate.user objectForKey:@"hourly_wage"]isEqualToString:@"0.0"]) {
        [self.btnHourly setSelected:NO];
    } else {
        [self.btnHourly setSelected:YES];
    }
    if([[[NSNumber numberWithInteger:[[self.appDelegate.user objectForKey:@"tipped_position"]intValue]]stringValue]isEqualToString:@"1"]) {
        [self.btnTips setSelected:YES];
    } else {
        [self.btnTips setSelected:NO];
    }
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (IBAction)changeCheckBox:(UIButton *)sender {
    [sender setSelected:!sender.selected];
}

- (IBAction)hourlyBoxSelected:(UIButton *)sender
{
    [self changeCheckBox:(sender)];
    if(sender.selected) {
        self.txtHourly.text = self.saveHourly;
        self.txtHourly.enabled = YES;
    } else {
        self.txtHourly.enabled = NO;
        self.saveHourly = self.txtHourly.text;
        self.txtHourly.text = @"0.0";
    }
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
    if(self.btnTips.selected) {
        [params setObject:@"1" forKey:@"tipped_position"];
    } else {
        [params setObject:@"0" forKey:@"tipped_position"];
    }
    NSMutableArray *wageArray = [[NSMutableArray alloc]init];
    if(self.btnHourly.selected) {
        [wageArray addObject:@"hourly"];
        [params setObject:self.txtHourly.text forKey:@"hourly_wage"];
    } else {
        [params setObject:@"" forKey:@"hourly_wage"];
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
            [manager POST:@"http://uwurk.tscserver.com/api/v1/profile" parameters:params
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
                  }
            ];
        }
        else
        {
            UIViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"EmployeeProfileSetup3"];
            [self.navigationController pushViewController:myController animated:TRUE];
        }
    }
}

@end
