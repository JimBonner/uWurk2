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

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)changeCheckBox:(UIButton *)sender
{
    [sender setSelected:!sender.selected];
}

- (IBAction)pressNext:(id)sender
{
    MessageSentViewController *myController = [[UIStoryboard storyboardWithName:@"Mail" bundle:nil] instantiateViewControllerWithIdentifier:@"MessageSentView"];
    [myController setSearchUserDict:self.searchUserDict];
    [self.navigationController pushViewController:myController animated:YES];
}

@end
