//
//  EmployerDashboardSavedSearchesViewController.m
//  uWurk2
//
//  Created by Rob Bonner on 1/17/16.
//  Copyright (c) 2016 Michael Brown. All rights reserved.
//  Copyright (c) 2017 Jim Bonner. All rights reserved.
//

#import "EmployerDashboardRecentSearchesViewController.h"
#import "AFNetworking.h"

@interface EmployerDashboardRecentSearchesViewController ()

@property (nonatomic, retain) NSMutableArray *json;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation EmployerDashboardRecentSearchesViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    AFHTTPRequestOperationManager *manager = [self getManager];
    
    [manager GET:@"http://uwurk.tscserver.com/api/v1/recent_searches" parameters: nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.json = [responseObject objectForKey:@"rows"];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [self handleErrorAccessError:@"Dashboard Recent Searches" withError:error];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LookupCell"];
    if(cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LookupCell"];
    
    NSDictionary *dict = [self.json objectAtIndex:indexPath.row];
    cell.textLabel.text = [dict objectForKey:@"name"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.json objectAtIndex:indexPath.row];
    NSString *searchID = [[dict objectForKey:@"id"]stringValue];
    NSString *paramString = [dict objectForKey:@"params"];
    NSString *newStr = [paramString substringWithRange:NSMakeRange(1, [paramString length]-2)];
    newStr = [[@"{" stringByAppendingString:newStr] stringByAppendingString:@"}"];
    NSString *decodedString = [NSString stringWithUTF8String:[newStr cStringUsingEncoding:[NSString defaultCStringEncoding]]];
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[decodedString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
    NSMutableDictionary *querryParams = [[NSMutableDictionary alloc]initWithDictionary:[dictionary objectForKey:@"query_params"]];
    [querryParams setValue:searchID forKey:@"search_id"];
    if([self.delegate respondsToSelector:@selector(SelectionMade:)])
        [self.delegate SelectionMade:querryParams];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Confirm"
                                      message:@"Are you sure you want to delete this search?"
                                      preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 AFHTTPRequestOperationManager *manager = [self getManager];
                                 NSDictionary *dict = [self.json objectAtIndex:indexPath.row];
                                 NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
                                 [self updateParamDict:params value:[dict objectForKey:@"id"] key:@"id"];
                                 [manager GET:@"http://uwurk.tscserver.com/api/v1/delete_search" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                     [manager GET:@"http://uwurk.tscserver.com/api/v1/recent_searches" parameters: nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                         self.json = [responseObject objectForKey:@"rows"];
                                         [self.tableView reloadData];
                                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         NSLog(@"Error: %@", error);
                                         [self handleErrorAccessError:@"Dashboard Recent Searches" withError:error];
                                     }];
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"Error: %@", error);
                                     [self handleErrorAccessError:@"Dashboard Recent Searches" withError:error];
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
