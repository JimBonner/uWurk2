//
//  EmployerSendMessageViewController.m
//  
//
//  Created by Avery Bonner on 11/24/15.
//
//

#import "EmployerSendMessageViewController.h"
#import "SearchResultProfileViewController.h"
#import "EmployerMessageDetailLeftTableViewCell.h"
#import "EmployerMessageDetailRightTableViewCell.h"

@interface EmployerSendMessageViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblPosition;
@property (weak, nonatomic) IBOutlet UILabel *lblLocation;
@property (weak, nonatomic) IBOutlet UILabel *lblWage;
@property (weak, nonatomic) IBOutlet UITextView *textViewMessage;
@property (weak, nonatomic) IBOutlet UILabel *lblInterested;
@property (weak, nonatomic) IBOutlet UILabel *lblIntroduction;
@property (weak, nonatomic) IBOutlet UIView *viewInterest;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cnstrntIntroHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cnstrntInterestHeight;
@property (weak, nonatomic) IBOutlet UILabel *lblNotify;
@property (weak, nonatomic) IBOutlet UILabel *lblMessageSent;
@property (weak, nonatomic) IBOutlet UIButton *btnSend;
@property (weak, nonatomic) IBOutlet UITableView *tblView;
@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) NSMutableArray *json;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightTableView;

@end

@implementation EmployerSendMessageViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"\nEmployer Send Message:\n%@",self.appDelegate.user);
    
    self.tblView.separatorColor = [UIColor clearColor];
    self.userID = [[self.appDelegate user] objectForKey:@"id"];
    self.tblView.rowHeight = UITableViewAutomaticDimension;
    self.tblView.estimatedRowHeight = 44.0;
    
    self.lblNotify.alpha = 0;
    self.lblMessageSent.alpha = 0;
    self.lblNotify.text = [NSString stringWithFormat:@"We will notify you when %@ responds.", [self.MailMessagedict objectForKey:@"to_first_name"]];
    if ([[self.MailMessagedict objectForKey:@"discussion_status"]isEqualToString:@"2"]) {
        self.lblIntroduction.text = [NSString stringWithFormat:@"Send a message to %@ introducing yourself and explaing the next step in your hiring process. We'll notify you when he responds.", [self.MailMessagedict objectForKey:@"to_first_name"]];
        self.lblInterested.text = [NSString stringWithFormat:@"%@ IS INTERESTED", [[self.MailMessagedict objectForKey:@"to_first_name"]uppercaseString]];
        self.heightTableView.constant = 0;
        self.tblView.alpha = 0;
    }
    else {
        self.lblIntroduction.alpha = 0;
        self.viewInterest.alpha = 0;
        self.cnstrntInterestHeight.constant = 0;
        self.cnstrntIntroHeight.constant = 0;
    }
    self.lblNotify.alpha = [[self.MailMessagedict objectForKey:@"replied"] isEqual:@1];
    self.lblMessageSent.alpha = self.lblNotify.alpha;
    
    self.lblName.text = [NSString stringWithFormat:@"%@ %@",[self.MailMessagedict objectForKey:@"to_first_name"],[self.MailMessagedict objectForKey:@"to_last_name"]];
    self.lblPosition.text = [self.MailMessagedict objectForKey:@"position"];
    self.lblLocation.text = [self.MailMessagedict objectForKey:@"location"];
    self.lblWage.text = [self.MailMessagedict objectForKey:@"wage"];
    self.textViewMessage.layer.borderWidth = 1;
    self.textViewMessage.layer.borderColor = [UIColor blackColor].CGColor;
    AFHTTPRequestOperationManager *manager = [self getManager];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [self updateParamDict:params value:[self.MailMessagedict objectForKey:@"discussion_id"] key:@"id"];
    
    self.json = [NSMutableArray new];
    
    
    [manager POST:@"http://uwurk.tscserver.com/api/v1/discussion" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        self.json = [[responseObject objectForKey:@"discussion"] objectForKey:@"rows"];
        [self.tblView reloadData];
        
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //            [self.tableView reloadData];
        //        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [self handleServerErrorUnableToContact];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)pressProfile:(id)sender {
    SearchResultProfileViewController *myController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ProfileSearchResult"];
    [self.navigationController pushViewController:myController animated:TRUE];
    [myController setProfileID:[self.MailMessagedict objectForKey:@"to_user_id"]];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.json count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSDictionary *itemDict = [self.json objectAtIndex:indexPath.row];
    
    
    if([[itemDict objectForKey:@"from_user_id"] isEqualToString:self.userID]) {
        EmployerMessageDetailRightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EmployerMessageDetailRightTableViewCell" forIndexPath:indexPath];
        cell.textBubbleView.layer.cornerRadius = 3;
        cell.textBubbleView.layer.masksToBounds = YES;
        NSDictionary *itemDict = [self.json objectAtIndex:indexPath.row];
        cell.lblText.text = [itemDict objectForKey:@"message"];
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"MMMM dd, yyyy"];
        format.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:[NSTimeZone localTimeZone].secondsFromGMT];
        [format setDateFormat:@"MMMM dd, yyyy hh:mm a"];
        NSString *sent = [itemDict objectForKey:@"sent_at"];
        double unixTimeStamp = [sent intValue];
        NSTimeInterval _interval=unixTimeStamp;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
        format.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:[NSTimeZone localTimeZone].secondsFromGMT];
        cell.lblTime.text = [format stringFromDate:date];
        return cell;
    }
    else {
        EmployerMessageDetailLeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EmployerMessageDetailLeftTableViewCell" forIndexPath:indexPath];
        cell.textBubbleView.layer.cornerRadius = 3;
        cell.textBubbleView.layer.masksToBounds = YES;
        NSDictionary *itemDict = [self.json objectAtIndex:indexPath.row];
        cell.lblText.text = [itemDict objectForKey:@"message"];
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"MMMM dd, yyyy"];
        format.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:[NSTimeZone localTimeZone].secondsFromGMT];
        [format setDateFormat:@"MMMM dd, yyyy hh:mm a"];
        NSString *sent = [itemDict objectForKey:@"sent_at"];
        double unixTimeStamp = [sent intValue];
        NSTimeInterval _interval=unixTimeStamp;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
        format.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:[NSTimeZone localTimeZone].secondsFromGMT];
        cell.lblTime.text = [format stringFromDate:date];
        return cell;
    }
}

- (IBAction)pressSend:(id)sender {
    AFHTTPRequestOperationManager *manager = [self getManager];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[self.MailMessagedict objectForKey:@"discussion_id"] forKey:@"discussion_id"];
    [params setObject:[self.MailMessagedict objectForKey:@"id"] forKey:@"view_msg_id"];
    [params setObject:self.textViewMessage.text forKey:@"message"];
    
    if ([params count]) {
        
        [manager POST:@"http://uwurk.tscserver.com/api/v1/post_message" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self.tblView reloadData];
            [self.btnSend setEnabled:FALSE];
            [UIView animateWithDuration:1.0 animations:^{
                self.lblMessageSent.alpha = 1;
                self.lblNotify.alpha = 1;
                self.heightTableView.constant = 251;
                self.tblView.alpha = 1;
                [self.view layoutIfNeeded];
            }];
//            UIViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"EmployerSendMessage"];
//            [self.navigationController setViewControllers:@[myController] animated:TRUE];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            [self handleServerErrorUnableToContact];
        }];
    }
    else {
        return;
    }
}

@end
