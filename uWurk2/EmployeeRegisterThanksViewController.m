//
//  EmployeeRegisterThanksViewController.m
//  uWurk2
//
//  Created by Avery Bonner on 1/9/16.
//  Copyright (c) 2016 Michael Brown. All rights reserved.
//  Copyright (c) 2017 Jim Bonner. All rights reserved.
//

#import "EmployeeRegisterThanksViewController.h"

@interface EmployeeRegisterThanksViewController ()

@property (weak, nonatomic) IBOutlet UILabel  *lblEmail;
@property (weak, nonatomic) IBOutlet UIButton *btnTryAgain;
@property (weak, nonatomic) IBOutlet UIButton *btlLogout;

@end

@implementation EmployeeRegisterThanksViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.lblEmail.text = [NSString stringWithFormat:@"%@",self.Email];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pressReenter:(id)sender
{
    UIViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"IntroEmployer"];
    [self.navigationController pushViewController:myController animated:TRUE];
}

- (IBAction)pressTryAgain:(id)sender
{
    
}

- (IBAction)pressLogout:(id)sender
{
    
}

@end
