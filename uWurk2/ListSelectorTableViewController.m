//
//  ListSelectorTableViewController.m
//  uWurk2
//
//  Created by Avery Bonner on 9/8/15.
//  Copyright (c) 2015 Michael Brown. All rights reserved.
//

#import "ListSelectorTableViewController.h"
#import "SearchViewController.h"

@interface ListSelectorTableViewController ()
@property (nonatomic, retain) NSMutableArray *json;
@end

@implementation ListSelectorTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    if(self.bPost) {
        [manager POST:self.url parameters:self.parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            self.json = [NSMutableArray arrayWithArray:[responseObject objectForKey:self.jsonGroup]];
            [self.tableView reloadData];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    }
    else {
        [manager GET:self.url parameters:self.parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            self.json = [NSMutableArray arrayWithArray:[responseObject objectForKey:self.jsonGroup]];
            [self.tableView reloadData];
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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LookupCellTable"];
    if(cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LookupCellTable"];
    
    if(self.bUseArray) {
        NSDictionary *row = [self.json objectAtIndex:indexPath.row];
        cell.textLabel.text = [row objectForKey:self.display];
    }
    else {
        NSDictionary *row = [self.json objectAtIndex:indexPath.row];
        cell.textLabel.text = [row objectForKey:self.display];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if(self.collectionViewArray) {
        ExperienceFilterItem *item = [ExperienceFilterItem new];
        if(self.bUseArray) {
            NSDictionary *row = [self.json objectAtIndex:indexPath.row];
            item.jobDesc = [row objectForKey:self.display];
            item.jobID   = [row objectForKey:self.key];
        }
        else {
            NSDictionary *row = [self.json objectAtIndex:indexPath.row];
            item.jobDesc = [row objectForKey:self.display];
            item.jobID   = [row objectForKey:self.key];
        }
        [self.collectionViewArray addObject:item];
    }
    else {
        if(self.bUseArray) {
            NSDictionary *row = [self.json objectAtIndex:indexPath.row];
            [self.sender setTitle:[row objectForKey:self.display] forState:UIControlStateNormal];
            [self.sender setTitle:[row objectForKey:self.display] forState:UIControlStateHighlighted];
            [self.sender setTitle:[row objectForKey:self.key] forState:UIControlStateSelected];
;
        }
        else {
            NSDictionary *row = [self.json objectAtIndex:indexPath.row];
            [self.sender setTitle:[row objectForKey:self.display] forState:UIControlStateNormal];
            [self.sender setTitle:[row objectForKey:self.display] forState:UIControlStateHighlighted];
            [self.sender setTitle:[row objectForKey:self.key] forState:UIControlStateSelected];
        }
        
        if ( [self.delegate respondsToSelector:@selector(SelectionMade)])
            [self.delegate SelectionMade];
    }
    [self.navigationController popViewControllerAnimated:TRUE];
    
}

@end
