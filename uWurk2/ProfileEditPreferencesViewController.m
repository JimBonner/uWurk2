
//
//  ProfileEditPreferencesViewController.m
//  uWurk2
//
//  Created by Avery Bonner on 9/17/15.
//  Copyright (c) 2015 Michael Brown. All rights reserved.
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
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
