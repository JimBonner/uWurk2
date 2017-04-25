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

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"\nIntro:\n%@",self.appDelegate.user);
    
    if(([self getUserDefault:@"api_auth_token"] != nil) &&
       ([[self.appDelegate.user objectForKey:@"register_complete"] isEqualToString:@"1"])) {
        LoginViewController *myController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [self.navigationController pushViewController:myController animated:FALSE];
    }
    else {
        [self.navigationController setNavigationBarHidden:TRUE];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
