//
//  EmployeeStepSetupViewController.m
//  uWurk2
//
//  Created by Avery Bonner on 10/18/15.
//  Copyright (c) 2015 Michael Brown. All rights reserved.
//  Copyright (c) 2017 Jim Bonner. All rights reserved.
//

#import "EmployeeStepSetupViewController.h"

@interface EmployeeStepSetupViewController ()
@property (weak, nonatomic) IBOutlet UIView *viewSteps;

@end

@implementation EmployeeStepSetupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.viewSteps.layer.shadowColor = [UIColor blackColor].CGColor;
    self.viewSteps.layer.shadowOffset = CGSizeMake(0, 0);
    self.viewSteps.layer.shadowOpacity = 1;
    self.viewSteps.layer.shadowRadius = 1.0;
    self.viewSteps.layer.cornerRadius = 5;
//    self.viewSteps.layer.masksToBounds = YES;
}

- (IBAction)pressGo:(id)sender {
    UIViewController *myController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]  instantiateViewControllerWithIdentifier:@"EmployeeProfileSetup1"];
    [self.navigationController pushViewController:myController animated:TRUE];
}

@end
