//
//  EmployeeSendMessageViewController.m
//  
//
//  Created by Avery Bonner on 11/24/15.
//
//

#import "EmployeeSendMessageViewController.h"
#import "EmployeeMessageDetailLeftTableViewCell.h"
#import "EmployeeMessageDetailRightTableViewCell.h"

@interface EmployeeSendMessageViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblPosition;
@property (weak, nonatomic) IBOutlet UILabel *lblLocation;
@property (weak, nonatomic) IBOutlet UILabel *lblWage;
@property (weak, nonatomic) IBOutlet UITextView *textViewMessage;
@property (weak, nonatomic) IBOutlet UILabel *lblMessageSent;
@property (weak, nonatomic) IBOutlet UILabel *lblNotify;
@property (weak, nonatomic) IBOutlet UITableView *tblView;
@property (strong, nonatomic) NSString *userID;
@property (weak, nonatomic) IBOutlet UIButton *btnSend;

@property (strong, nonatomic) NSMutableArray *json;

@end

@implementation EmployeeSendMessageViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"\nEmployee Send Message:\n%@",self.appDelegate.user);
    
    self.tblView.separatorColor = [UIColor clearColor];
    self.userID = [[self.appDelegate user] objectForKey:@"id"];
    
    self.tblView.rowHeight = UITableViewAutomaticDimension;
    self.tblView.estimatedRowHeight = 44.0; // set to whatever your "average" cell height is

    self.lblName.text = [NSString stringWithFormat:@"%@ %@",[self.MailMessagedict objectForKey:@"to_first_name"],[self.MailMessagedict objectForKey:@"to_last_name"]];
    self.lblPosition.text = [self.MailMessagedict objectForKey:@"position"];
    NSString *string = @"";
    if([[self.MailMessagedict objectForKey:@"hours"]integerValue] == 1) {
        string = @" - Full Time";
    } else if([[self.MailMessagedict objectForKey:@"hours"]integerValue] == 2) {
        string = @" - Part Time";
    } else if([[self.MailMessagedict objectForKey:@"hours"]integerValue] == 3) {
        string = @" - Temporary";
    } else {
        string = @" - Hours not available";
    }
    self.lblPosition.text = [self.lblPosition.text stringByAppendingString:string];
    self.lblLocation.text = [self.MailMessagedict objectForKey:@"location"];
    self.lblWage.text = [self.MailMessagedict objectForKey:@"wage"];
    if([self.lblWage.text isEqualToString:@""]){
        self.lblWage.text = [self.lblWage.text stringByAppendingString:@"Wage not available"];
    }
    self.textViewMessage.layer.borderWidth = 1;
    self.textViewMessage.layer.borderColor = [UIColor blackColor].CGColor;
    
    self.lblNotify.text = [NSString stringWithFormat:@"We will notify you when %@ responds.", [self.MailMessagedict objectForKey:@"to_first_name"]];

    self.lblNotify.alpha = [[self.MailMessagedict objectForKey:@"replied"] isEqual:@1];
    self.lblMessageSent.alpha = self.lblNotify.alpha;
    
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
        [self handleErrorAccessError:@"Employee Send Message" withError:error];
    }];

 }

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.json count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *itemDict = [self.json objectAtIndex:indexPath.row];

    if([itemDict objectForKey:@"from_user_id"] == self.userID) {
        EmployeeMessageDetailRightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EmployeeMessageDetailRightTableViewCell" forIndexPath:indexPath];
        cell.textBubbleView.layer.cornerRadius = 3;
        cell.textBubbleView.layer.masksToBounds = YES;
        NSDictionary *itemDict = [self.json objectAtIndex:indexPath.row];
        cell.lblText.text = [itemDict objectForKey:@"message"];
        return cell;
    } else {
        EmployeeMessageDetailLeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EmployeeMessageDetailLeftTableViewCell" forIndexPath:indexPath];
        cell.textBubbleView.layer.cornerRadius = 3;
        cell.textBubbleView.layer.masksToBounds = YES;
        NSDictionary *itemDict = [self.json objectAtIndex:indexPath.row];
        cell.lblText.text = [itemDict objectForKey:@"message"];
        return cell;
    }
}

- (IBAction)pressProfile:(id)sender
{
    
}

- (IBAction)pressSend:(id)sender
{
    AFHTTPRequestOperationManager *manager = [self getManager];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[self.MailMessagedict objectForKey:@"discussion_id"] forKey:@"discussion_id"];
    [params setObject:[self.MailMessagedict objectForKey:@"id"] forKey:@"view_msg_id"];
    [params setObject:self.textViewMessage.text forKey:@"message"];
    
    if ([params count]) {
        
        [manager POST:@"http://uwurk.tscserver.com/api/v1/post_message" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self.tblView reloadData];
            [self.btnSend setEnabled:FALSE];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            [self handleErrorAccessError:@"Employee Send Message" withError:error];
        }];
    }
}

@end
