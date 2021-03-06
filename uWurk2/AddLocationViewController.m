//
//  AddLocationViewController.m
//  uWurk2
//
//  Created by Avery Bonner on 11/19/15.
//  Copyright (c) 2015 Michael Brown. All rights reserved.
//  Copyright (c) 2017 Jim Bonner. All rights reserved.
//

#import "AddLocationViewController.h"

@interface AddLocationViewController ()
@property (weak, nonatomic) IBOutlet UITextField  *txtMiles;
@property (weak, nonatomic) IBOutlet UITextField  *txtZipCode;
@property (weak, nonatomic) IBOutlet UIButton     *btnSaveChanges;
@property (retain, nonatomic) NSMutableDictionary *params;

@end

@implementation AddLocationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.params = [[NSMutableDictionary alloc] init];
    self.btnSaveChanges.enabled = NO;
    NSArray *availabilityArray = [self.appDelegate.user objectForKey:@"availability"];
    if ([self.miles isEqualToString:@"miles[1]"]) {
        NSDictionary *firstAvailabilityItem = [availabilityArray objectAtIndex:0];
        [self.params setObject:[firstAvailabilityItem objectForKey:@"miles"] forKey:@"miles[0]"];
        [self.params setObject:[firstAvailabilityItem objectForKey:@"zip"] forKey:@"zip[0]"];
    }
    if ([self.miles isEqualToString:@"miles[2]"]) {
        NSDictionary *firstAvailabilityItem = [availabilityArray objectAtIndex:0];
        [self.params setObject:[firstAvailabilityItem objectForKey:@"miles"] forKey:@"miles[0]"];
        [self.params setObject:[firstAvailabilityItem objectForKey:@"zip"] forKey:@"zip[0]"];
        NSDictionary *secondAvailabilityItem = [availabilityArray objectAtIndex:1];
        [self.params setObject:[secondAvailabilityItem objectForKey:@"miles"] forKey:@"miles[1]"];
        [self.params setObject:[secondAvailabilityItem objectForKey:@"zip"] forKey:@"zip[1]"];
    }
    if ([self.miles isEqualToString:@"miles[3]"]) {
        NSDictionary *firstAvailabilityItem = [availabilityArray objectAtIndex:0];
        [self.params setObject:[firstAvailabilityItem objectForKey:@"miles"] forKey:@"miles[0]"];
        [self.params setObject:[firstAvailabilityItem objectForKey:@"zip"] forKey:@"zip[0]"];
        NSDictionary *secondAvailabilityItem = [availabilityArray objectAtIndex:1];
        [self.params setObject:[secondAvailabilityItem objectForKey:@"miles"] forKey:@"miles[1]"];
        [self.params setObject:[secondAvailabilityItem objectForKey:@"zip"] forKey:@"zip[1]"];
        NSDictionary *thirdAvailabilityItem = [availabilityArray objectAtIndex:2];
        [self.params setObject:[thirdAvailabilityItem objectForKey:@"miles"] forKey:@"miles[2]"];
        [self.params setObject:[thirdAvailabilityItem objectForKey:@"zip"] forKey:@"zip[2]"];
    }
    if ([self.miles isEqualToString:@"miles[4]"]) {
        NSDictionary *firstAvailabilityItem = [availabilityArray objectAtIndex:0];
        [self.params setObject:[firstAvailabilityItem objectForKey:@"miles"] forKey:@"miles[0]"];
        [self.params setObject:[firstAvailabilityItem objectForKey:@"zip"] forKey:@"zip[0]"];
        NSDictionary *secondAvailabilityItem = [availabilityArray objectAtIndex:1];
        [self.params setObject:[secondAvailabilityItem objectForKey:@"miles"] forKey:@"miles[1]"];
        [self.params setObject:[secondAvailabilityItem objectForKey:@"zip"] forKey:@"zip[1]"];
        NSDictionary *thirdAvailabilityItem = [availabilityArray objectAtIndex:2];
        [self.params setObject:[thirdAvailabilityItem objectForKey:@"miles"] forKey:@"miles[2]"];
        [self.params setObject:[thirdAvailabilityItem objectForKey:@"zip"] forKey:@"zip[2]"];
        NSDictionary *fourthAvailabilityItem = [availabilityArray objectAtIndex:3];
        [self.params setObject:[fourthAvailabilityItem objectForKey:@"miles"] forKey:@"miles[3]"];
        [self.params setObject:[fourthAvailabilityItem objectForKey:@"zip"] forKey:@"zip[3]"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)changeSave:(id)sender
{
    self.btnSaveChanges.enabled = YES;
}

- (IBAction)nextPress:(id)sender
{
    [self.params setObject:self.txtMiles.text forKey:self.miles];
    [self.params setObject:self.txtZipCode.text forKey:self.zipCode];
    
    if([self.params count]){
        AFHTTPRequestOperationManager *manager = [self getManager];
        [manager POST:@"http://uwurk.tscserver.com/api/v1/profile" parameters:self.params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            if([self validateResponse:responseObject]){
                UIViewController *myController = [[UIStoryboard storyboardWithName:@"EmployeeProfile" bundle:nil]  instantiateViewControllerWithIdentifier:@"ProfileEditStep2"];
                [self.navigationController setViewControllers:@[myController] animated:TRUE];
            } else {
                [self handleErrorJsonResponse:@"Add Location"];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            [self handleErrorAccessError:@"Add Location" withError:error];
        }];
    } else {
        UIViewController *myController = [[UIStoryboard storyboardWithName:@"EmployeeProfile" bundle:nil]  instantiateViewControllerWithIdentifier:@"ProfileEditStep2"];
        [self.navigationController setViewControllers:@[myController] animated:TRUE];
    }
}

@end
