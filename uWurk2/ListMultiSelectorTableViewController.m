//
//  ListSelectorTableViewController.m
//  uWurk2
//
//  Created by Avery Bonner on 9/8/15.
//  Copyright (c) 2015 Michael Brown. All rights reserved.
//

#import "ListMultiSelectorTableViewController.h"

@interface ListMultiSelectorTableViewController ()
@property (nonatomic, retain) NSMutableArray *json;
@end

@implementation ListMultiSelectorTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    self.idDict = [[NSMutableDictionary alloc]init];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    if(self.bPost) {
        [manager POST:self.url parameters:self.parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            self.json = [NSMutableArray arrayWithArray:[responseObject objectForKey:self.jsonGroup]];
            [self.json removeObjectAtIndex:0];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    }
    else {
        [manager GET:self.url parameters:self.parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            self.json = [NSMutableArray arrayWithArray:[responseObject objectForKey:self.jsonGroup]];
            [self.json removeObjectAtIndex:0];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.json count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LookupCellMultiple"];
    if(cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LookupCellMultiple"];
    
    if(self.bUseArray) {
        NSArray *row = [self.json objectAtIndex:indexPath.row];
        cell.textLabel.text = [row objectAtIndex:1];
    }
    else {
        NSDictionary *row = [self.json objectAtIndex:indexPath.row];
        if([self.idDict objectForKey:[row objectForKey:@"id"]])
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        else
            cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.text = [row objectForKey:self.display];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSDictionary *row = [self.json objectAtIndex:indexPath.row];
    if([self.idDict objectForKey:[row objectForKey:@"id"]]) {
        [self.idDict removeObjectForKey:[row objectForKey:@"id"]];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else {
        [self.idDict setObject:[row objectForKey:self.display] forKey:[row objectForKey:@"id"]];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    NSString *displayString = @"";
    for(NSString *key in self.idDict) {
        if([displayString length] >0)
            displayString = [displayString stringByAppendingString:@", "];
        displayString = [displayString stringByAppendingString:[self.idDict objectForKey:key]];
    }
    
    if([self.delegate respondsToSelector:@selector(SelectionMade:withDict:displayString:)])
    {
        [self.delegate SelectionMade:self.user withDict:self.idDict displayString:displayString];
    }
}

@end
