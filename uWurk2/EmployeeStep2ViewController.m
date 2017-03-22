//
//  EmployyeStep2ViewController.m
//  uWurk2
//
//  Created by Avery Bonner on 9/4/15.
//  Copyright (c) 2015 Michael Brown. All rights reserved.
//

#import "EmployeeStep2ViewController.h"
@interface EmployeeStep2ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txtMiles;
@property (weak, nonatomic) IBOutlet UITextField *txtZip;
@property (weak, nonatomic) IBOutlet UITextField *txtHourly;
@property (weak, nonatomic) IBOutlet UIButton *btnTips;
@property (weak, nonatomic) IBOutlet UIButton *btnHourly;

@end

@implementation EmployeeStep2ViewController

-(NSMutableArray *)availabiltyArray1:(NSArray *)array
{
    return [NSMutableArray arrayWithArray:array];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSArray *availabilityArray = [self.appDelegate.user objectForKey:@"availability"];
    if([availabilityArray count] > 0) {
        NSDictionary *firstAvailabilityItem = [availabilityArray objectAtIndex:0];
        [self assignValue:[[firstAvailabilityItem objectForKey:@"miles"] stringValue] control:self.txtMiles];
        [self assignValue:[firstAvailabilityItem objectForKey:@"zip"] control:self.txtZip];
    }
    [self assignValue:[self.appDelegate.user objectForKey:@"hourly_wage"] control:self.txtHourly];
    
    if ([self.appDelegate.user objectForKey:@"hourly_wage"] == (id)[NSNull null] || [[self.appDelegate.user objectForKey:@"hourly_wage"]length] == 0 ) {
        self.btnHourly.selected = FALSE;
    }
    else {
        self.btnHourly.selected = TRUE;
    }
    
    if([[self.appDelegate.user objectForKey:@"tipped_position"]  intValue] == 0)
        self.btnTips.selected = FALSE;

    else if([[self.appDelegate.user objectForKey:@"tipped_position"]  intValue] == 1)
        self.btnTips.selected = TRUE;
}

- (IBAction)changeCheckBox:(UIButton *)sender {
    [sender setSelected:!sender.selected];
}
- (IBAction)pressHere:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.ncsl.org/research/labor-and-employment/state-minimum-wage-chart.aspx"]];
}

- (IBAction)nextPress:(id)sender {
    // Did data get updated?
    
    AFHTTPRequestOperationManager *manager = [self getManager];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[self.txtMiles text] forKey:@"miles"];
    [params setObject:[self.txtZip text] forKey:@"zip"];
    [params setObject:self.txtHourly.text forKey:@"hourly_wage"];
///    [params setObject:@"tips" forKey:@"wage_type"];
    [self updateParamDict:params value:self.btnTips.selected ? @"1" : @"0" key:@"tipped_position"];
    NSMutableString *Error = [[NSMutableString alloc] init];
    [Error appendString:@"To continue, complete the missing information:"];
    if (self.txtMiles.text.length ==0) {
        [Error appendString:@"\n\nMiles"];
    }
    if (self.txtZip.text.length ==0) {
        [Error appendString:@"\n\nZip Code"];
    }
    if (self.btnHourly.selected == YES && self.txtHourly.text.length ==0) {
        [Error appendString:@"\n\nHourly Wage"];
    }
    if (self.btnHourly.selected == NO && self.btnTips.selected == NO) {
        [Error appendString:@"\n\nSelect Wage Type"];
    }
    if ((Error.length) > 50) {
        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"OOPS!"
                                                         message:Error
                                                        delegate:self
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles: nil];
        [alert show];
    }
    else
    {
        if([params count])
        {
            NSMutableArray *availabilityArray = [[NSMutableArray alloc]init];
            NSMutableDictionary *firstAvailabilityItem = [[NSMutableDictionary alloc]init];
            [firstAvailabilityItem setObject:[self.txtMiles text] forKey:@"miles"];
            [firstAvailabilityItem setObject:[self.txtZip text] forKey:@"zip"];
            [availabilityArray setObject:firstAvailabilityItem atIndexedSubscript:0];
            [self.appDelegate.user setObject:availabilityArray forKey:@"availability"];
            [self.appDelegate.user setObject:[self.txtHourly text] forKey:@"hourly_wage"];
            if(!self.btnTips.selected) {
                [self.appDelegate.user setObject:@"0" forKey:@"tips"];
            } else {
                [self.appDelegate.user setObject:@"1" forKey:@"tips"];
            }
            
            [manager POST:@"http://uwurk.tscserver.com/api/v1/profile" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"JSON: %@", responseObject);
                if([self validateResponse:responseObject]){
                     UIViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"EmployeeProfileSetup3"];
                    [self.navigationController pushViewController:myController animated:TRUE];
                    
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
        else
        {
            UIViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"EmployeeProfileSetup3"];
            [self.navigationController pushViewController:myController animated:TRUE];
        }
    }
}

@end
