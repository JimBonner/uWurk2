//
//  MailFoldersTableViewController.m
//  uWurk2
//
//  Created by Avery Bonner on 11/5/15.
//  Copyright (c) 2015 Michael Brown. All rights reserved.
//

#import "MailFoldersViewController.h"
#import "MailFolderTableViewCell.h"
#import "MailMessagesTableViewController.h"

@interface MailFoldersViewController ()
@property (strong, nonatomic) NSMutableArray *json;
@property (strong, nonatomic) NSMutableArray *json2;
@property (strong, nonatomic) NSDictionary *countDict;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MailFoldersViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44.0; // set to whatever your "average" cell height is
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    AFHTTPRequestOperationManager *manager = [self getManager];
    [manager GET:@"http://uwurk.tscserver.com/api/v1/folders" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.json2 = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"folders"]];
        self.json = [[NSMutableArray alloc] init];

        if([[self.appDelegate.user objectForKey:@"user_type"] isEqualToString:@"employee"]) {
            [self.json addObject:@{@"id":@"0",@"fromEmployer":@"From Employer"}];
            [self.json addObject:@{@"id":@"1",@"fromUwurk":@"From uWurk"}];
        } else {
            [self.json addObject:@{@"id":@"0|yes",@"name":@"Yes"}];
            [self.json addObject:@{@"id":@"1|no",@"name":@"No"}];
            [self.json addObject:@{@"id":@"2|pending",@"name":@"Pending"}];
            [self.json addObject:@{@"id":@"3|fromUwurk",@"name":@"From uWurk"}];
        }
        
        [manager GET:@"http://uwurk.tscserver.com/api/v1/notifications" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {

            self.countDict = [responseObject objectForKey:@"notifications"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            [self handleErrorAccessError:@"Mail Folders" withError:error];
        }];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [self handleErrorAccessError:@"Mail Folders" withError:error];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return [self.json count];
            break;
        case 1:
            return [self.json2 count];
            break;
        default:
             return 0;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 28.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 28.0)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 18)];
    [label setFont:[UIFont boldSystemFontOfSize:16]];
    [label setTextColor:[UIColor whiteColor]];
    [label setTextAlignment:NSTextAlignmentCenter];
    if(section == 0) {
        label.text = @"My Messages";
    } else {
        label.text = @"My Folders";
    }
    [view addSubview:label];
    [view setBackgroundColor:[UIColor blackColor]];
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MailFolderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MailFolderViewCell" forIndexPath:indexPath];
    NSDictionary *paramdic;
    if (indexPath.section == 0) {
        paramdic = [self.json objectAtIndex:indexPath.row];
    } else {
        paramdic = [self.json2 objectAtIndex:indexPath.row];
    }
    cell.lblFolderName.text = [NSString stringWithFormat:@"%@ %@",[paramdic objectForKey:@"name"],[self.countDict objectForKey:[paramdic objectForKey:@"id"]] == nil ? @"" : [NSString stringWithFormat:@"(%@)",[self.countDict objectForKey:[paramdic objectForKey:@"id"]]]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NSDictionary *dict = [self.json objectAtIndex:indexPath.row];
        MailMessagesTableViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"MailMessages"];
        [myController setMailFolderDict:dict];
        [self.navigationController pushViewController:myController animated:TRUE];
    } else {
        NSDictionary *dict = [self.json2 objectAtIndex:indexPath.row];
        MailMessagesTableViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"MailMessages"];
        [myController setMailFolderDict:dict];
        [self.navigationController pushViewController:myController animated:TRUE];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0) {
        return NO;
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIAlertController * alert =  [UIAlertController
                                      alertControllerWithTitle:@"Confirm"
                                      message:@"Are you sure you want to delete this folder?"
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                                 AFHTTPRequestOperationManager *manager = [self getManager];
                                 
                                 NSDictionary *dict = [self.json2 objectAtIndex:indexPath.row];
                                 
                                 NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
                                 
                                 [self updateParamDict:params value:@"delete_folder" key:@"action"];
                                 [self updateParamDict:params value:[dict objectForKey:@"id"] key:@"id"];
                                 
                                 [manager POST:@"http://uwurk.tscserver.com/msgfolder" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                     [manager GET:@"http://uwurk.tscserver.com/api/v1/folders" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                         self.json2 = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"folders"]];
                                         self.json = [[NSMutableArray alloc] init];
                                         
                                         if([[self.appDelegate.user objectForKey:@"user_type"] isEqualToString:@"employee"]) {
                                             [self.json addObject:@{@"id":@"0",@"name":@"From Employer"}];
                                             [self.json addObject:@{@"id":@"1",@"name":@"From uWurk"}];
                                         } else {
                                             [self.json addObject:@{@"id":@"0|yes",@"name":@"Yes"}];
                                             [self.json addObject:@{@"id":@"1|no",@"name":@"No"}];
                                             [self.json addObject:@{@"id":@"2|pending",@"name":@"Pending"}];
                                             [self.json addObject:@{@"id":@"3|fromUwurk",@"name":@"From uWurk"}];
                                         }
                                         dispatch_async(dispatch_get_main_queue(), ^{
                                             [self.tableView reloadData];
                                         });
                                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         NSLog(@"Error: %@", error);
                                         [self handleErrorAccessError:@"Mail Folders" withError:error];
                                         return;
                                     }];
                                     
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"Error: %@", error);
                                     [self handleErrorAccessError:@"Mail Folders" withError:error];
                                     return;
                                 }];
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 return;
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
    }
}

@end
