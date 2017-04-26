//
//  EditEmployerPreferencesViewController.m
//  uWurk2
//
//  Created by Avery Bonner on 2/19/16.
//  Copyright (c) 2016 Michael Brown. All rights reserved.
//  Copyright (c) 2017 Jim Bonner. All rights reserved.
//

#import "EditEmployerPreferencesViewController.h"

@interface EditEmployerPreferencesViewController ()

@end

@implementation EditEmployerPreferencesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"\nEmployer Edit Preferences:\n%@",self.appDelegate.user);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pressRemoveEmployeeFav:(id)sender {
}

- (IBAction)pressRemoveContact:(id)sender {
}

- (IBAction)pressRemovePhoto:(id)sender {
}

- (IBAction)pressRemoveSavedSearch:(id)sender {
}

- (IBAction)changeCheckBox:(UIButton *)sender {
    [sender setSelected:!sender.selected];
}

@end
