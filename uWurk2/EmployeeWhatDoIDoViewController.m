//
//  EmployeeWhatDoIDoViewController.m
//  uWurk2
//
//  Created by Avery Bonner on 11/30/15.
//  Copyright © 2015 Michael Brown. All rights reserved.
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)pressProfile:(id)sender {
    UIViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"EmployeeLanding"];
    [self.navigationController pushViewController:myController animated:YES];
}
- (IBAction)pressRefer:(id)sender {
    UIViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"ReferralProgram"];
    [self.navigationController pushViewController:myController animated:YES];
}
- (IBAction)pressLogOut:(id)sender {
//    AFHTTPRequestOperationManager *manager = [self getManager];
//        [manager POST:@"http://uwurk.tscserver.com/api/v1/logout" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                UIViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"InitialView"];
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
