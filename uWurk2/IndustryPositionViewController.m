//
//  IndustryPositionViewController.m
//  uWurk2
//
//  Created by Rob Bonner on 1/29/16.
//  Copyright (c) 2016 Michael Brown. All rights reserved.
//  Copyright (c) 2017 Jim Bonner. All rights reserved.
//

#import "IndustryPositionViewController.h"

@interface IndustryPositionViewController ()

@end

@implementation IndustryPositionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"\nIndustry Position:\n%@",self.appDelegate.user);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
