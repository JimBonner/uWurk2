//
//  EmployeeDashboardMenuTableViewController.m
//  uWurk
//
//  Created by Rob Bonner on 5/9/15.
//  Copyright (c) 2015 Blueplate Software. All rights reserved.
//  Copyright (c) 2017 Jim Bonner. All rights reserved.
//

#import "DashboardMenuTableViewController.h"

@interface DashboardMenuTableViewController ()

@property (nonatomic, strong) NSArray *menuArray;

@end

@implementation DashboardMenuTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:self.menuFileName ofType:@"plist"];
    self.menuArray = [[NSArray alloc] initWithContentsOfFile:filePath];
    
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    return [self.menuArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ddd"];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ddd"];
        cell.textLabel.font = [UIFont systemFontOfSize:10];
    }
    
    NSDictionary *dict = [self.menuArray objectAtIndex:indexPath.row];
    if(![dict objectForKey:@"ViewController"]){
        cell.textLabel.font = [self boldFontFromFont:cell.textLabel.font];
        cell.textLabel.text = [dict objectForKey:@"MenuText"];
    } else {
        cell.textLabel.text = [@"   " stringByAppendingString:[dict objectForKey:@"MenuText"]];
    }
    
    return cell;
}

- (UIFont *)boldFontFromFont:(UIFont *)font
{
    NSString *familyName = [font familyName];
    NSArray *fontNames = [UIFont fontNamesForFamilyName:familyName];
    for (NSString *fontName in fontNames)
    {
        if ([fontName rangeOfString:@"bold" options:NSCaseInsensitiveSearch].location != NSNotFound)
        {
            UIFont *boldFont = [UIFont fontWithName:fontName size:font.pointSize];
            return boldFont;
        }
    }
    return nil;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"MenuNotification"
     object:[self.menuArray objectAtIndex:indexPath.row]];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35;
    
}

@end
