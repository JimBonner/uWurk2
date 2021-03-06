//
//  ListSelectorTableViewController.m
//  uWurk2
//
//  Created by Avery Bonner on 9/8/15.
//  Copyright (c) 2015 Michael Brown. All rights reserved.
//  Copyright (c) 2017 Jim Bonner. All rights reserved.
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
    
    self.appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = nil;
    
    if(self.collectionViewArray) {
        ExperienceFilterItem *item = [ExperienceFilterItem new];
        if(self.bUseArray) {
            dict = [self.json objectAtIndex:indexPath.row];
            item.jobDesc = [dict objectForKey:self.display];
            item.jobID   = [dict objectForKey:self.key];
        }
        else {
            dict = [self.json objectAtIndex:indexPath.row];
            item.jobDesc = [dict objectForKey:self.display];
            item.jobID   = [dict objectForKey:self.key];
        }
        [self.collectionViewArray addObject:item];
    }
    else {
        if(self.bUseArray) {
            dict = [self.json objectAtIndex:indexPath.row];
            [self.sender setTitle:[dict objectForKey:self.display] forState:UIControlStateNormal];
            [self.sender setTag:[[dict objectForKey:self.key]intValue]];
        }
        else {
            dict = [self.json objectAtIndex:indexPath.row];
            [self.sender setTitle:[dict objectForKey:self.display] forState:UIControlStateNormal];
            [self.sender setTag:[[dict objectForKey:self.key]intValue]];
        }
    }
    
    if([self.delegate respondsToSelector:@selector(SelectionMade:withDict:displayString:)])
    {
        [self.delegate SelectionMade:self.passThru withDict:dict displayString:[dict objectForKey:self.display]];
    }

    [self.navigationController popViewControllerAnimated:TRUE];
    
}

@end
