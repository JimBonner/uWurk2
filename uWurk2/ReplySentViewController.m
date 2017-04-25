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
    
    NSLog(@"\nReply Sent:\n%@",self.appDelegate.user);
}

- (IBAction)pressReturn:(UIButton *)sender {
    UIViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"EmployeeLanding"];
    [self.navigationController setViewControllers:@[myController] animated:TRUE];
}

@end
