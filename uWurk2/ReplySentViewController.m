//
//  ReplySentViewController.m
//  
//
//  Created by Avery Bonner on 11/23/15.
//
//

#import "ReplySentViewController.h"

@interface ReplySentViewController ()

@end

@implementation ReplySentViewController

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (IBAction)pressReturn:(UIButton *)sender {
    UIViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"EmployeeLanding"];
    [self.navigationController setViewControllers:@[myController] animated:TRUE];
}

@end
