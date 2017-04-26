
//
//  ProfileEditPreferencesViewController.m
//  uWurk2
//
//  Created by Avery Bonner on 9/17/15.
//  Copyright (c) 2015 Michael Brown. All rights reserved.
//  Copyright (c) 2017 Jim Bonner. All rights reserved.
//

#import "ProfileEditPreferencesViewController.h"

@interface ProfileEditPreferencesViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnSaveChanges;
@property (weak, nonatomic) IBOutlet UIButton *btnPrefRemoveJob;
@property (weak, nonatomic) IBOutlet UIButton *btnPrefRemoveSchool;

@property (weak, nonatomic) IBOutlet UIButton *btnPrefRemovePhoto;
@end

@implementation ProfileEditPreferencesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.btnSaveChanges.enabled = NO;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"\nEmployee Profile Edit Preferences:\n%@",self.appDelegate.user);
}

- (IBAction)pressRemoveJob:(id)sender {
    
}
- (IBAction)pressRemoveSchool:(id)sender {

}
- (IBAction)pressRemovePhoto:(id)sender {

}

- (IBAction)changeCheckBox:(UIButton *)sender {
    [sender setSelected:!sender.selected];
    self.btnSaveChanges.enabled = YES;
}
- (IBAction)pressSave:(id)sender {
    [self saveUserDefault: self.btnPrefRemoveJob.isSelected?@"1":@"" Key:@"prefRemoveJob"];
    [self saveUserDefault:self.btnPrefRemoveSchool.isSelected?@"1":@"" Key:@"prefRemoveSchool"];
    [self saveUserDefault:self.btnPrefRemovePhoto.isSelected?@"1":@"" Key:@"prefRemovePhoto"];
    
    UIViewController *myController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"EmployeeLanding"];
    [self.navigationController setViewControllers:@[myController] animated:TRUE];
}

@end
