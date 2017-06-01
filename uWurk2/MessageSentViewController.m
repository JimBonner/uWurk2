//
//  MessageSentViewController.m
//  
//
//  Created by Avery Bonner on 11/23/15.
//
//

#import "MessageSentViewController.h"
#import "SearchResultsTableViewController.h"

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
    SearchResultsTableViewController *myController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"employeeListID"];
    
    [myController setUrl:@"http://uwurk.tscserver.com/api/v1/search"];
    [myController setSearchParameters:[NSMutableDictionary dictionaryWithDictionary:self.searchParams]];

    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
    UIViewController *searchViewController = [viewControllers objectAtIndex:0];

    [viewControllers removeAllObjects];
    [viewControllers addObject:searchViewController];
    [viewControllers addObject:myController];
    
    [self.navigationController setViewControllers:viewControllers animated:TRUE];
}

@end
