//
//  RegisterThanksViewController.m
//  uWurk2
//
//  Created by Jim Bonner on 4/23/17.
//  Copyright (c) 2017 Jim Bonner. All rights reserved.
//

#import "RegisterThanksViewController.h"

@interface RegisterThanksViewController ()

@property (weak,nonatomic) IBOutlet UIButton *btnReEnter;
@property (weak,nonatomic) IBOutlet UIButton *btnTryAgain;
@property (weak,nonatomic) IBOutlet UIButton *btnLogout;
@property (weak,nonatomic) UILabel  *lblEmail;

@end

@implementation RegisterThanksViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.lblEmail setText:[self.appDelegate.user objectForKey:@"email"]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    NSLog(@"\nRegister Thanks:\n%@",self.appDelegate.user);
}

- (IBAction)pressReEnter:(id)sender
{
    NSString *storyBoardId;
    if([[self.appDelegate.user objectForKey:@"user_type"] isEqualToString:@"employee"]) {
        storyBoardId = @"IntroEmployee";
    } else {
        storyBoardId = @"IntroEmployer";
    }
    UIViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:storyBoardId];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController pushViewController:myController animated:TRUE];
}

- (IBAction)pressTryAgain:(id)sender
{
    [self getProfileDataFromDbmsWithCompletion:^(NSInteger result) {
        if(result == 1) {
            if([[self.appDelegate.user objectForKey:@"status"]integerValue] == 1) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }}}];
}

- (IBAction)pressLogout:(id)sender
{
    [self logout];
}

@end
