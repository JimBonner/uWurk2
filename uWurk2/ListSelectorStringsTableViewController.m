//
//  ListSelectorStringsTableViewController.m
//  uWurk2
//
//  Created by Avery Bonner on 11/1/15.
//  Copyright (c) 2015 Michael Brown. All rights reserved.
//  Copyright (c) 2017 Jim Bonner. All rights reserved.
//

#import "ListSelectorStringsTableViewController.h"

@interface ListSelectorStringsTableViewController ()

@property (nonatomic, retain) NSArray *json;
@end

@implementation ListSelectorStringsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager GET:self.url parameters:self.parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.json = [responseObject objectForKey:self.jsonGroup];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LookupCellStringTable"];
    if(cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LookupCellStringTable"];
    
    NSString *row = [self.json objectAtIndex:indexPath.row];
    cell.textLabel.text = row;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *row = [self.json objectAtIndex:indexPath.row];
    
    [self.sender setTitle:row forState:UIControlStateNormal];
    
    if ([self.delegate respondsToSelector:@selector(SelectionMadeString:displayString:)])
    {
        [self.delegate SelectionMadeString:self.passThru displayString:row];
    }

    [self.navigationController popViewControllerAnimated:TRUE];
    
}

@end
