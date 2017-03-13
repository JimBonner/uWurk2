//
//  IntroViewController.m
//  uWurk2
//
//  Created by Avery Bonner on 8/31/15.
//  Copyright (c) 2015 Michael Brown. All rights reserved.
//

#import "IntroViewController.h"
#import "LoginViewController.h"

@interface IntroViewController ()

@end

@implementation IntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if([self getUserDefault:@"api_auth_token"] != nil) {
        LoginViewController *myController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [self.navigationController pushViewController:myController animated:FALSE];
    }
    else {
        [self.navigationController setNavigationBarHidden:TRUE];
    }
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
@end
