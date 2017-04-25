//
//  ContactProfileNotifyViewController.m
//  uWurk2
//
//  Created by Avery Bonner on 11/30/15.
//  Copyright (c) 2015 Michael Brown. All rights reserved.
//  Copyright (c) 2017 Jim Bonner. All rights reserved.
//

#import "ContactProfileNotifyViewController.h"
#import "MessageSentViewController.h"

@interface ContactProfileNotifyViewController ()

@end

@implementation ContactProfileNotifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    NSLog(@"\nContact Profile Notify:\n%@",self.appDelegate.user);
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
- (IBAction)changeCheckBox:(UIButton *)sender {
    [sender setSelected:!sender.selected];
}
- (IBAction)pressNext:(id)sender {
    MessageSentViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"MessageSentView"];
    [self.navigationController setViewControllers:@[myController] animated:TRUE];
    [myController setSearchUserDict:self.searchUserDict];
}

@end
