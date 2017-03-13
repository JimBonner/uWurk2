//
//  EmployerStep0ViewController.m
//  uWurk2
//
//  Created by Avery Bonner on 1/6/16.
//  Copyright © 2016 Michael Brown. All rights reserved.
//

#import "EmployerStep0ViewController.h"

@interface EmployerStep0ViewController ()

@end

@implementation EmployerStep0ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pressGo:(id)sender {
    UIViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"EmployerProfileSetup1"];
    [self.navigationController pushViewController:myController animated:TRUE];
}


@end
