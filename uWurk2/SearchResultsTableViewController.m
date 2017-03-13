//
//  SearchResultsTableViewController.m
//  uWurk2
//
//  Created by Avery Bonner on 9/23/15.
//  Copyright (c) 2015 Michael Brown. All rights reserved.
//

#import "SearchResultsTableViewController.h"
#import "SearchResultTableViewCell.h"
#import "SearchResultProfileViewController.h"
#import "UrlImageRequest.h"
#import "SaveSearchViewController.h"
#import "RefineSearchViewController.h"


@interface SearchResultsTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lblResultNumber;
@property (weak, nonatomic) IBOutlet UIButton *btnFavorite;
@property (strong, nonatomic) NSArray *json;
@property (strong, nonatomic) NSMutableDictionary *additionalJSON;
@property (strong, nonatomic) NSString *searchID;

@end

@implementation SearchResultsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 77.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    AFHTTPRequestOperationManager *manager = [self getManager];
    //manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    
    [manager POST:self.url parameters:self.parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.json = [responseObject objectForKey:@"rows"];
        self.searchID = [responseObject objectForKey:@"search_id"];
        self.additionalJSON = [NSMutableDictionary dictionaryWithDictionary:responseObject];
        [self.additionalJSON removeObjectForKey:@"rows"];
        [self.tableView reloadData];
        NSUInteger er =[self.json count];
        self.lblResultNumber.text = [NSString stringWithFormat:@"(%lu)", (unsigned long)er];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.json count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchResultCell" forIndexPath:indexPath];
    NSDictionary *dict = [self.json objectAtIndex:indexPath.row];
    if([dict objectForKey:@"photo_url"]) {
    
            NSURL *photoURL =[NSURL URLWithString:[NSString stringWithFormat:@"http://uwurk.tscserver.com%@",[dict objectForKey:@"photo_url"]]];
            UrlImageRequest *photoRequest = [[UrlImageRequest alloc]initWithURL:photoURL];
            [photoRequest startWithCompletion:^(UIImage *newImage, NSError *error) {
                if(newImage) {
                    cell.imageProfile.image = newImage;
                }
            }];
    }
    cell.lblName.text = [NSString stringWithFormat:@"%@ %@",[dict objectForKey:@"first_name"],[dict objectForKey:@"last_name"]];
    // Use attrib strings for the rest
    cell.searchID = [_additionalJSON objectForKey:@"search_id"];
    cell.profileID = [dict objectForKey:@"id"];

    [cell.btnFavorite setSelected: [[dict objectForKey:@"is_favorite"]   intValue] == 1];
    NSString *tip;
    NSString *jobstatus;
    if ([[dict objectForKey:@"job_status"]  intValue] == 1){
        jobstatus = @"Current";
    }
    else
        jobstatus = @"Previous";
    if ([[dict objectForKey:@"tipped_position"]  intValue] == 1){
        tip = @"or Tips";
    }
    else
        tip = @"";
    cell.line2.text = [NSString stringWithFormat:@"Age: %@ | $%@/hr %@",[dict objectForKey:@"age"], [dict objectForKey:@"hourly_wage"],tip];
    if ([dict objectForKey:@"experience"] == (id)[NSNull null] || [[dict objectForKey:@"experience"]length] == 0 ) {
        cell.line3.text = [NSString stringWithFormat:@"Education: %@",[dict objectForKey:@"education"]];
        cell.line4.text = @"";
    }
    else {
    cell.line3.text = [NSString stringWithFormat:@"%@: %@",jobstatus,[dict objectForKey:@"experience"]];
    
    cell.line4.text = [NSString stringWithFormat:@"Education: %@",[dict objectForKey:@"education"]];
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    
    NSDictionary *dict = [self.json objectAtIndex:indexPath.row];
    NSString *userID = [dict objectForKey:@"id"];
    SearchResultProfileViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileSearchResult"];
    [myController setProfileID:userID];
    [myController setSearchedUserDict:dict];
    [myController setParamholder:self.parameters];
    [myController setSearchID:self.searchID];
    
    [self.navigationController pushViewController:myController animated:TRUE];
    
    //    Class v = NSClassFromString([d objectForKey:@"ViewController"]);
    //    UIViewController *childViewControllerNew = nil;
    //    childViewControllerNew = [[v alloc] initWithNibName:[d objectForKey:@"ViewController"] bundle:nil];
    //
    //    [self.navigationController pushViewController:childViewControllerNew animated:TRUE];
    
    
}
- (IBAction)pressUpdateSearch:(id)sender {
    RefineSearchViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"UpdateSearchViewController"];
    [self.navigationController pushViewController:myController animated:YES];
    [myController setSearchparms:self.parameters];
}
- (IBAction)pressSaveSearch:(id)sender {
    self.definesPresentationContext = YES; //self is presenting view controller
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"GeneralViews" bundle:nil];
    SaveSearchViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"SaveSearchViewController"];
    
    vc.view.backgroundColor = [UIColor clearColor];
    vc.saveID = [self.additionalJSON objectForKey:@"search_id"];
    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
    
    vc.view.backgroundColor = [UIColor clearColor];
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;

    [self presentViewController:vc animated:YES completion:nil];
    
//    
//    UIAlertController *alertController = [UIAlertController
//                                          alertControllerWithTitle:@"SAVE SEARCH"
//                                          message:@"Enter a description for this search:"
//                                          preferredStyle:UIAlertControllerStyleAlert];
//    
//    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
//     {
//         textField.placeholder = NSLocalizedString(@"Search description", nil);
//     }];
//
//    UIAlertAction *cancelAction = [UIAlertAction
//                                   actionWithTitle:NSLocalizedString(@"CANCEL", @"Cancel action")
//                                   style:UIAlertActionStyleCancel
//                                   handler:^(UIAlertAction *action)
//                                   {
//                                       NSLog(@"Cancel action");
//                                   }];
//    
//    UIAlertAction *okAction = [UIAlertAction
//                               actionWithTitle:NSLocalizedString(@"SAVE", @"OK action")
//                               style:UIAlertActionStyleDefault
//                               handler:^(UIAlertAction *action)
//                               {
//                                   
//                                   
//                                   NSLog(@"Save action");
//                               }];
//    
//    [alertController addAction:cancelAction];
//    [alertController addAction:okAction];
    
//    [self presentViewController:alertController animated:YES completion:nil];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
