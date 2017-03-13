//
//  EditEmployerPreferencesViewController.m
//  uWurk2
//
//  Created by Avery Bonner on 2/19/16.
//  Copyright © 2016 Michael Brown. All rights reserved.
//

#import "EditEmployerPreferencesViewController.h"

@interface EditEmployerPreferencesViewController ()

@end

@implementation EditEmployerPreferencesViewController

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
