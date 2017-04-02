//
//  ContactProfileViewController.m
//  
//
//  Created by Avery Bonner on 11/23/15.
//
//

#import "ContactProfileViewController.h"
#import "ContactProfileNotifyViewController.h"

@interface ContactProfileViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lblEmployer;
@property (weak, nonatomic) IBOutlet UILabel *lblPosition;
@property (weak, nonatomic) IBOutlet UILabel *lblLocation;
@property (weak, nonatomic) IBOutlet UILabel *lblWage;
@property (weak, nonatomic) IBOutlet UILabel *lblNameInterest;
@property (weak, nonatomic) IBOutlet UILabel *lblEmployeeName;

@end

@implementation ContactProfileViewController

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
///    NSString *tips;
///    NSString *time;
    self.lblEmployeeName.text = [NSString stringWithFormat:@"%@:",[self.searchUserDict objectForKey:@"first_name"]];
    self.lblNameInterest.text = [NSString stringWithFormat:@"Based on %@'s interest in this position, you will receive a YES or NO reply.",[self.searchUserDict objectForKey:@"first_name"]];
    self.lblEmployer.text = [self.appDelegate.user objectForKey:@"company"];
    self.lblPosition.text = [self.paramholder objectForKey:@"position"];
    self.lblLocation.text = [self.paramholder objectForKey:@"location"];
    self.lblWage.text = [self.paramholder objectForKey:@"wage_type_tipped"];
}

- (IBAction)pressReply:(UIButton *)sender {
    AFHTTPRequestOperationManager *manager = [self getManager];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[self.paramholder objectForKey:@"position"] forKey:@"position_id"];
    [params setObject:[self.searchUserDict objectForKey:@"id"] forKey:@"contact_id"];
    [params setObject:[self.paramholder objectForKey:@"hours"] forKey:@"hours"];
    [params setObject:[self.paramholder objectForKey:@"zip"] forKey:@"zip"];
    [params setObject:@"" forKey:@"message"];
    
    
    if ([params count]) {
        
        [manager POST:@"http://uwurk.tscserver.com/api/v1/contact" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            UIViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"ContactProfileNotifyView"];
            [self.navigationController setViewControllers:@[myController] animated:TRUE];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Oops!"
                                                             message:@"Unable to contact server"
                                                            delegate:self
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles: nil];
            [alert show];
        }];
    }
    else{
        ContactProfileNotifyViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"ContactProfileNotifyView"];
        [self.navigationController setViewControllers:@[myController] animated:TRUE];
        [myController setSearchUserDict:self.searchUserDict];
    }
}

@end
