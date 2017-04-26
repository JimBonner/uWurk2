//
//  EmployeeDashboardMenuTableViewController.m
//  uWurk
//
//  Created by Rob Bonner on 5/9/15.
//  Copyright (c) 2015 Blueplate Software. All rights reserved.
//

#import "DashboardMenuTableViewController.h"

@interface DashboardMenuTableViewController ()
@property (nonatomic, strong) NSArray *menuArray;
@end

@implementation DashboardMenuTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:self.menuFileName ofType:@"plist"];
    self.menuArray = [[NSArray alloc] initWithContentsOfFile:filePath];
    
    [self.tableView reloadData];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"\nDashboard Menu:\n%@",self.appDelegate.user);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.menuArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ddd"];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ddd"];
        cell.textLabel.font = [UIFont systemFontOfSize:10];
    }
    
    NSDictionary *d = [self.menuArray objectAtIndex:indexPath.row];
    if(![d objectForKey:@"ViewController"]){
        cell.textLabel.font = [self boldFontFromFont:cell.textLabel.font];
        cell.textLabel.text = [d objectForKey:@"MenuText"];
    }
    else{
        cell.textLabel.text = [@"   " stringByAppendingString:[d objectForKey:@"MenuText"]];
        
    }
    // Configure the cell...
    
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    
///    NSDictionary *d = [self.menuArray objectAtIndex:indexPath.row];
    
//    Class v = NSClassFromString([d objectForKey:@"ViewController"]);
//    UIViewController *childViewControllerNew = nil;
//    childViewControllerNew = [[v alloc] initWithNibName:[d objectForKey:@"ViewController"] bundle:nil];
//    
//    [self.navigationController pushViewController:childViewControllerNew animated:TRUE];

    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"MenuNotification"
     object:[self.menuArray objectAtIndex:indexPath.row]];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35;
    
}

@end
