//
//  EmailVerification.m
//  uWurk2
//
//  Created by Jim Bonner on 4/23/17.
//  Copyright (c) 2017 Jim Bonner. All rights reserved.
//

#import "EmailVerification.h"

@interface EmailVerification ()

@property (weak,nonatomic) IBOutlet UIButton *btnTryAgain;
@property (weak,nonatomic) IBOutlet UIButton *btnLogout;
@property (weak,nonatomic) id nextViewController;

@end

@implementation EmailVerification

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

@end
