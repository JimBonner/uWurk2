//
//  JobInterestViewController.m
//  
//
//  Created by Avery Bonner on 11/23/15.
//
//

#import "JobInterestViewController.h"
#import "RadioButton.h"

@interface JobInterestViewController ()
@property (weak, nonatomic) IBOutlet RadioButton *btnReplyYes;
@property (weak, nonatomic) IBOutlet RadioButton *btnReplyNo;
@property (weak, nonatomic) IBOutlet UILabel *lblEmployer;
@property (weak, nonatomic) IBOutlet UILabel *lblPosition;
@property (weak, nonatomic) IBOutlet UILabel *lblLocation;
@property (weak, nonatomic) IBOutlet UILabel *lblWage;

@end

@implementation JobInterestViewController

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"\nJob Interest:\n%@",self.appDelegate.user);
    
    self.lblEmployer.text = [self.MailMessagedict objectForKey:@"company"];
    self.lblPosition.text = [self.MailMessagedict objectForKey:@"position"];
    self.lblLocation.text = [self.MailMessagedict objectForKey:@"location"];
    self.lblWage.text = [self.MailMessagedict objectForKey:@"wage"];
}

- (IBAction)pressReply:(UIButton *)sender {
    AFHTTPRequestOperationManager *manager = [self getManager];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[self.MailMessagedict objectForKey:@"discussion_id"] forKey:@"discussion_id"];
    [params setObject:[self.MailMessagedict objectForKey:@"id"] forKey:@"view_msg_id"];
    [params setObject:@"1" forKey:@"contact_req"];
    [params setObject:@"" forKey:@"message"];
    if (self.btnReplyNo.isSelected == TRUE) {
        [params setObject:@"0" forKey:@"interest"];
    }
    if (self.btnReplyYes.isSelected == TRUE) {
        [params setObject:@"1" forKey:@"interest"];
    }
    
    if ([params count]) {
        
    [manager POST:@"http://uwurk.tscserver.com/api/v1/post_message" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        UIViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"ReplySentView"];
        [self.navigationController setViewControllers:@[myController] animated:TRUE];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Oops!"
                                     message:@"Unable to contact server"
                                     preferredStyle:UIAlertControllerStyleActionSheet];
        [alert addAction:[UIAlertAction
                          actionWithTitle:@"OK"
                          style:UIAlertActionStyleDefault
                          handler:^(UIAlertAction *action)
                          {
                          }]];
        [self presentViewController:alert animated:TRUE completion:nil];
        return;
    }];
    }
    else{
    UIViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"ReplySentView"];
    [self.navigationController setViewControllers:@[myController] animated:TRUE];
    }
}

@end
