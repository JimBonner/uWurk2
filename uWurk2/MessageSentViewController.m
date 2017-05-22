//
//  MessageSentViewController.m
//  
//
//  Created by Avery Bonner on 11/23/15.
//
//

#import "MessageSentViewController.h"

@interface MessageSentViewController ()
@property (weak, nonatomic) IBOutlet UILabel  *lblNameRespond;
@property (weak, nonatomic) IBOutlet UIButton *btnReturn;

@end

@implementation MessageSentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.lblNameRespond.text = [NSString stringWithFormat:@"We will notify you when %@ responds.", [self.searchUserDict objectForKey:@"first_name"]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)pressReturn:(id)sender
{
    UIViewController *myController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"EmployerLanding"];
    [self.navigationController pushViewController:myController animated:TRUE];
}

@end
