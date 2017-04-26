//
//  MailFoldersTableViewController.m
//  uWurk2
//
//  Created by Avery Bonner on 11/5/15.
//  Copyright (c) 2015 Michael Brown. All rights reserved.
//  Copyright (c) 2017 Jim Bonner. All rights reserved.
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44.0; // set to whatever your "average" cell height is
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    AFHTTPRequestOperationManager *manager = [self getManager];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    
        [manager GET:@"http://uwurk.tscserver.com/api/v1/folders" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            self.json2 = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"folders"]];
            self.json = [[NSMutableArray alloc] init];

            if([[self.appDelegate.user objectForKey:@"user_type"] isEqualToString:@"user"]) {
                [self.json addObject:@{@"id":@"0",@"name":@"From user"}];
                [self.json addObject:@{@"id":@"1",@"name":@"From uWurk"}];
            }
            else {
                [self.json addObject:@{@"id":@"0|yes",@"name":@"Yes"}];
                [self.json addObject:@{@"id":@"0|no",@"name":@"No"}];
            }
            
            [manager GET:@"http://uwurk.tscserver.com/api/v1/notifications" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {

                self.countDict = [responseObject objectForKey:@"notifications"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MailFolderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MailFolderViewCell" forIndexPath:indexPath];
    NSDictionary *paramdic;
    if (indexPath.section == 0) {
        paramdic = [self.json objectAtIndex:indexPath.row];
    }
    else {
        paramdic = [self.json2 objectAtIndex:indexPath.row];
    }
    cell.lblFolderName.text = [NSString stringWithFormat:@"%@ %@",[paramdic objectForKey:@"name"],[self.countDict objectForKey:[paramdic objectForKey:@"id"]] == nil ? @"" : [NSString stringWithFormat:@"(%@)",[self.countDict objectForKey:[paramdic objectForKey:@"id"]]]];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NSDictionary *dict = [self.json objectAtIndex:indexPath.row];
        MailMessagesTableViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"MailMessages"];
        [myController setMailFolderDict:dict];
        [self.navigationController pushViewController:myController animated:TRUE];
    }
    else {
        NSDictionary *dict = [self.json2 objectAtIndex:indexPath.row];
        MailMessagesTableViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"MailMessages"];
        [myController setMailFolderDict:dict];
        [self.navigationController pushViewController:myController animated:TRUE];
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section)
    {
        case 0:
            sectionName = @"My Messages";
            break;
        case 1:
            sectionName = @"My Folders";
            break;
            // ...
        default:
            sectionName = @"";
            break;
    }
    return sectionName;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        return NO;
    }
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Oops!"
                                     message:@"Are you sure you want to delete this folder?"
                                     preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                                 AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
                                 manager.requestSerializer = [AFHTTPRequestSerializer serializer];
                                 
                                 NSDictionary *dict = [self.json2 objectAtIndex:indexPath.row];
                                 
                                 NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
                                 
                                 [self updateParamDict:params value:@"delete_folder" key:@"action"];
                                 [self updateParamDict:params value:[dict objectForKey:@"id"] key:@"id"];
                                 
                                 [manager POST:@"http://uwurk.tscserver.com/msgfolder" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                     [manager GET:@"http://uwurk.tscserver.com/api/v1/folders" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                         self.json2 = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"folders"]];
                                         self.json = [[NSMutableArray alloc] init];
                                         
                                         if([[self.appDelegate.user objectForKey:@"user_type"] isEqualToString:@"user"]) {
                                             [self.json addObject:@{@"id":@"0",@"name":@"From user"}];
                                             [self.json addObject:@{@"id":@"1",@"name":@"From uWurk"}];
                                         }
                                         else {
                                             [self.json addObject:@{@"id":@"0|yes",@"name":@"Yes"}];
                                             [self.json addObject:@{@"id":@"0|no",@"name":@"No"}];
                                         }
                                         dispatch_async(dispatch_get_main_queue(), ^{
                                             [self.tableView reloadData];
                                         });
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
        
    }
}


@end
