//
//  EmployeeWhatDoIDoViewController.m
//  uWurk2
//
//  Created by Avery Bonner on 11/30/15.
//  Copyright (c) 2015 Michael Brown. All rights reserved.
//  Copyright (c) 2017 Jim Bonner. All rights reserved.
//

#import "EmployeeWhatDoIDoViewController.h"

@interface EmployeeWhatDoIDoViewController ()

@end

@implementation EmployeeWhatDoIDoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pressProfile:(id)sender {
    UIViewController *myController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"EmployeeLanding"];
    [self.navigationController pushViewController:myController animated:YES];
}
- (IBAction)pressRefer:(id)sender {
    UIViewController *myController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ReferralProgram"];
    [self.navigationController pushViewController:myController animated:YES];
}
- (IBAction)pressLogOut:(id)sender {
//    AFHTTPRequestOperationManager *manager = [self getManager];
//        [manager POST:@"http://uwurk.tscserver.com/api/v1/logout" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                UIViewController *myController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]  instantiateViewControllerWithIdentifier:@"InitialView"];
//                [self.navigationController pushViewController:myController animated:YES];
//            }
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            NSLog(@"Error: %@", error);
//    UIAlertController * alert = [UIAlertController
//                                 alertControllerWithTitle:@"Oops!"
//                                 message:@"Unable to contact server"
//                                 preferredStyle:UIAlertControllerStyleActionSheet];
//    [alert addAction:[UIAlertAction
//                      actionWithTitle:@"OK"
//                      style:UIAlertActionStyleDefault
//                      handler:^(UIAlertAction *action)
//                      {
//                      }]];
//    [self presentViewController:alert animated:TRUE completion:nil];
//        }];
    }

@end
