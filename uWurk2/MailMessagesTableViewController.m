//
//  MailMessagesTableViewController.m
//  uWurk2
//
//  Created by Avery Bonner on 11/5/15.
//  Copyright (c) 2015 Michael Brown. All rights reserved.
//  Copyright (c) 2017 Jim Bonner. All rights reserved.
//

#import "MailMessagesTableViewController.h"
#import "MailMessageTableViewCell.h"
#import "MoveMessageViewController.h"
#import "ViewJobMessageViewController.h"
#import "EmployerSendMessageViewController.h"
#import "EmployeeSendMessageViewController.h"

@interface MailMessagesTableViewController ()

@property (strong, nonatomic) NSArray *json;
@property (weak, nonatomic) IBOutlet UILabel *lblFolderName;

@end

@implementation MailMessagesTableViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.lblFolderName.text = [[self.mailFolderDict objectForKey:@"name"]uppercaseString];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    AFHTTPRequestOperationManager *manager = [self getManager];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[self.mailFolderDict objectForKey:@"id"] forKey:@"fid"];
    
    [manager POST:@"http://uwurk.tscserver.com/api/v1/messages" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
       self.json = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"rows"]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [self handleErrorUnableToContact];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
    MailMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MailMessageCell" forIndexPath:indexPath];
    NSDictionary *parmdic = [self.json objectAtIndex:indexPath.row];
    if ([[parmdic objectForKey:@"discussion_status"] intValue] == 1) {
        cell.lblPosition.text = @"View Position";
        cell.lblPosition.font = [UIFont fontWithName:@"RobotoCondensed-Bold" size:17];
        cell.lblSubject.text = @"NEW user!";
        cell.lblSubject.font = [UIFont fontWithName:@"RobotoCondensed-Bold" size:17];
    } else {
        cell.lblPosition.text = [parmdic objectForKey:@"position"];
        NSString *string = @"";
        if([[parmdic objectForKey:@"hours"]integerValue] == 1) {
            string = @" - Full Time";
        } else if([[parmdic objectForKey:@"hours"]integerValue] == 2) {
            string = @" - Part Time";
        } else if([[parmdic objectForKey:@"hours"]integerValue] == 3) {
            string = @" - Temporary";
        } else {
            string = @" - Hours not available";
        }
        cell.lblPosition.text = [cell.lblPosition.text stringByAppendingString:string];
        if ([[self.appDelegate.user objectForKey:@"user_type"] isEqualToString:@"user"]) {
            cell.lblSubject.text = [NSString stringWithFormat:@"%@ %@",[parmdic objectForKey:@"to_first_name"],[parmdic objectForKey:@"to_last_name"]];
        } else {
            cell.lblSubject.text = [parmdic objectForKey:@"company"];
        }
    }
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MMMM dd, yyyy"];
    format.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:[NSTimeZone localTimeZone].secondsFromGMT];
    [format setDateFormat:@"MMMM dd, yyyy hh:mm a"];
    NSString *sent = [parmdic objectForKey:@"sent_at"];
    double unixTimeStamp = [sent intValue];
    NSTimeInterval _interval=unixTimeStamp;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    format.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:[NSTimeZone localTimeZone].secondsFromGMT];
    
    cell.lblDateAndTime.text = [format stringFromDate:date];
    cell.imageReply.alpha = [[parmdic objectForKey:@"replied"] isEqual:@1];
    UIImage *imageyes = [UIImage imageNamed: @"arrow-yes-min"];
    UIImage *imageno = [UIImage imageNamed: @"arrow-no-min"];
    UIImage *imagenew = [UIImage imageNamed: @"smiley-yellow"];
    if([[[self.appDelegate user] objectForKey:@"user_type"] isEqualToString:@"user"] && [parmdic objectForKey:@"employee_interest"] == (id)[NSNull null]) {
        [cell.imageYesNo setImage:imagenew];
        cell.viewYesNoWidth.constant = 17;
    } else {
        if ([parmdic objectForKey:@"employee_interest"] != (id)[NSNull null]  && [[parmdic objectForKey:@"employee_interest"] intValue] == 1) {
            [cell.imageYesNo setImage:imageyes];
        }
        else {
            [cell.imageYesNo setImage:imageno];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.json objectAtIndex:indexPath.row];
    if ([[self.appDelegate.user objectForKey:@"user_type"]isEqualToString:@"user"]) {
        EmployerSendMessageViewController *myController = [[UIStoryboard storyboardWithName:@"Mail" bundle:nil]  instantiateViewControllerWithIdentifier:@"EmployerSendMessage"];
        [myController setMailMessagedict:dict];
        [self.navigationController pushViewController:myController animated:TRUE];
    } else {
        if ([[dict objectForKey:@"discussion_status"] intValue] == 1) {
            ViewJobMessageViewController *myController = [[UIStoryboard storyboardWithName:@"Mail" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewJobMessage"];
            [myController setMailMessagedict:dict];
            [self.navigationController pushViewController:myController animated:TRUE];
        } else {
            EmployeeSendMessageViewController *myController = [[UIStoryboard storyboardWithName:@"Mail" bundle:nil]  instantiateViewControllerWithIdentifier:@"EmployeeSendMessage"];
            [myController setMailMessagedict:dict];
            [self.navigationController pushViewController:myController animated:TRUE];
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __block NSDictionary *dict = [self.json objectAtIndex:indexPath.row];
    
    UITableViewRowAction *move = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Move" handler:^(UITableViewRowAction *action, NSIndexPath *ip)
                                  {
                                      [self moveMessage:dict];
                                  }];
    move.backgroundColor = [UIColor greenColor];
    
    UITableViewRowAction *delete = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Delete" handler:^(UITableViewRowAction *action, NSIndexPath *ip)
                                  {
                                      UIAlertController * alert = [UIAlertController
                                                                   alertControllerWithTitle:@"Oops!"
                                                                   message:@"Are you sure you want to delete this message"
                                                                   preferredStyle:UIAlertControllerStyleActionSheet];
                                      [alert addAction:[UIAlertAction
                                                        actionWithTitle:@"OK"
                                                        style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action)
                                                        {
                                                        }]];
                                      UIAlertAction* ok = [UIAlertAction
                                                           actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action)
                                                           {
                                                               
                                                               [alert dismissViewControllerAnimated:YES completion:nil];

                                                               
                                                               AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
                                                               manager.requestSerializer = [AFHTTPRequestSerializer serializer];
                                                               
                                                               
                                                               NSDictionary *dict = [self.json objectAtIndex:indexPath.row];
                                                               NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
                                                               
                                                               [self updateParamDict:params value:@"delete_disc" key:@"action"];
                                                               [self updateParamDict:params value:[dict objectForKey:@"id"] key:@"id"];
                                                               
                                                               [manager POST:@"http://uwurk.tscserver.com/api/v1//messages" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                                   
                                                                   
                                                                   
                                                                   AFHTTPRequestOperationManager *manager = [self getManager];
                                                                   NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
                                                                   [params setObject:[self.mailFolderDict objectForKey:@"id"] forKey:@"fid"];
                                                                   
                                                                   
                                                                   [manager POST:@"http://uwurk.tscserver.com/api/v1/messages" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                                       self.json = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"rows"]];
                                                                       dispatch_async(dispatch_get_main_queue(), ^{
                                                                           [self.tableView reloadData];
                                                                       });
                                                                   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                       NSLog(@"Error: %@", error);
                                                                       UIAlertController * alert = [UIAlertController
                                                                                                    alertControllerWithTitle:@"Oops!"
                                                                                                    message:@"Unable to contact server."
                                                                                                    preferredStyle:UIAlertControllerStyleActionSheet];
                                                                       [alert addAction:[UIAlertAction
                                                                                         actionWithTitle:@"OK"
                                                                                         style:UIAlertActionStyleDefault
                                                                                         handler:^(UIAlertAction *action)
                                                                                         {
                                                                                         }]];
                                                                       [self presentViewController:alert animated:TRUE completion:nil];

                                                                   }];
                                                                   
                                                                   
                                                                   
                                                                   
                                                               } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                   NSLog(@"Error: %@", error);
                                                               }];
                                                               
                                                               
                                                               [alert dismissViewControllerAnimated:YES completion:nil];
                                                               
                                                           }];
                                      UIAlertAction* cancel = [UIAlertAction
                                                               actionWithTitle:@"Cancel"
                                                               style:UIAlertActionStyleCancel
                                                               handler:^(UIAlertAction * action)
                                                               {
                                                                   [alert dismissViewControllerAnimated:YES completion:nil];
                                                                   
                                                               }];
                                      
                                      [alert addAction:ok];
                                      [alert addAction:cancel];
                                      
                                      [self presentViewController:alert animated:YES completion:nil];

                                      
                                      
                    
                                  }];
    delete.backgroundColor = [UIColor redColor];
    
    
    return @[delete, move];
}

-(void) moveMessage:(NSDictionary*)dict
{
    MoveMessageViewController *myController = [[UIStoryboard storyboardWithName:@"Mail" bundle:nil] instantiateViewControllerWithIdentifier:@"MoveMessageView"];
    [myController setDict:dict];
    [self.navigationController pushViewController:myController animated:TRUE];
}




@end
