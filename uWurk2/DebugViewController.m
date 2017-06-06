//
//  DebugViewController.m
//  uWurk2
//
//  Created by Jim Bonner on 6/6/17.
//  Copyright © 2017 Michael Brown. All rights reserved.
//

#import "DebugViewController.h"

@interface DebugViewController ()

@end

@implementation DebugViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self
                                                     action:@selector(handleTapGesture:)];
    
    [self.view addGestureRecognizer:tapRecognizer];
    
    NSString *className = NSStringFromClass([self.viewController class]);
    NSString *storyName = [self.viewController.storyboard valueForKey:@"name"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)handleTapGesture:(UIGestureRecognizer *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
