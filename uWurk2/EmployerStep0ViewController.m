//
//  EmployerStep0ViewController.m
//  uWurk2
//
//  Created by Avery Bonner on 1/6/16.
//  Copyright (c) 2016 Michael Brown. All rights reserved.
//  Copyright (c) 2017 Jim Bonner. All rights reserved.
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
    UIViewController *myController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]  instantiateViewControllerWithIdentifier:@"EmployerProfileSetup1"];
    [self.navigationController pushViewController:myController animated:TRUE];
}


@end
