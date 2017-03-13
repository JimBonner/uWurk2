//
//  MessageSentViewController.m
//  
//
//  Created by Avery Bonner on 11/23/15.
//
//

#import "MessageSentViewController.h"

@interface MessageSentViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lblNameRespond;

@end

@implementation MessageSentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lblNameRespond.text = [NSString stringWithFormat:@"We will notify you when %@ responds.", [self.searchUserDict objectForKey:@"first_name"]];
    // Do any additional setup after loading the view.
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
- (IBAction)pressReturn:(id)sender {
    UIViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"EmployerLanding"];
    [self.navigationController pushViewController:myController animated:TRUE];
}

@end
