//
//  DebugViewController.m
//  uWurk2
//
//  Created by Jim Bonner on 6/6/17.
//  Copyright © 2017 Michael Brown. All rights reserved.
//

#import "DebugViewController.h"

@interface DebugViewController ()

@property (nonatomic,weak)IBOutlet UILabel *lblStoryName;
@property (nonatomic,weak)IBOutlet UILabel *lblClassName;

@end

@implementation DebugViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self
                                                     action:@selector(handleTapGesture:)];
    
    [self.view addGestureRecognizer:tapRecognizer];
    
    self.lblStoryName.text = [NSString stringWithFormat:@"Storyboard: %@",[self.viewController.storyboard valueForKey:@"name"]];
    self.lblClassName.text = [NSString stringWithFormat:@"Class Name: %@",NSStringFromClass([self.viewController class])];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)handleTapGesture:(UIGestureRecognizer *)sender
{
    UIApplication *appDelegate = [UIApplication sharedApplication];
    UIButton *button = [appDelegate.delegate.window viewWithTag:12321];
    button.hidden = NO;
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
