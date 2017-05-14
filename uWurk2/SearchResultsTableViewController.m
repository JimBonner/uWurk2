//
//  SearchResultsTableViewController.m
//  uWurk2
//
//  Created by Avery Bonner on 9/23/15.
//  Copyright (c) 2015 Michael Brown. All rights reserved.
//  Copyright (c) 2017 Jim Bonner. All rights reserved.
//

#import "SearchResultsTableViewController.h"
#import "SearchResultTableViewCell.h"
#import "SearchResultProfileViewController.h"
#import "UrlImageRequest.h"
#import "SaveSearchViewController.h"
#import "RefineSearchViewController.h"


@interface SearchResultsTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel  *lblResultNumber;
@property (weak, nonatomic) IBOutlet UIButton *btnFavorite;
@property (strong, nonatomic) NSArray *json;
@property (strong, nonatomic) NSMutableDictionary *additionalJSON;
@property (strong, nonatomic) NSArray *favorites;
@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) NSString *searchID;

@property BOOL performInit;

@end

@implementation SearchResultsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 77.0;
    self.performInit = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if(self.performInit == NO) {
        [self.searchParameters setObject:self.searchID forKey:@"search_id"];
    }
    self.performInit = NO;
    AFHTTPRequestOperationManager *manager = [self getManager];
    [manager POST:self.url parameters:self.searchParameters
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.json = [responseObject objectForKey:@"rows"];
        self.searchID = [responseObject objectForKey:@"search_id"];
        self.favorites = [responseObject objectForKey:@"favorites"];
        self.additionalJSON = [NSMutableDictionary dictionaryWithDictionary:responseObject];
        [self.additionalJSON removeObjectForKey:@"rows"];
        NSUInteger er = [self.json count];
        [self.tableView reloadData];
        self.lblResultNumber.text = [NSString stringWithFormat:@"(%lu)", (unsigned long)er];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
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
    SearchResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchResultCell" forIndexPath:indexPath];
    cell.searchViewController = self;
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
    cell.searchID = [self.additionalJSON objectForKey:@"search_id"];
    cell.profileID = [dict objectForKey:@"id"];
    
    BOOL is_favorite = NO;
    for(NSDictionary *dict in self.favorites) {
        if([[dict objectForKey:@"id"]integerValue] == [cell.profileID integerValue]) {
            is_favorite = YES;
            break;
        }
    }
    cell.btnFavorite.selected = is_favorite;
    
    NSString *tip;
    NSString *jobstatus;
    if ([[dict objectForKey:@"job_status"] intValue] == 1) {
        jobstatus = @"Current";
    } else {
        jobstatus = @"Previous";
    }
    if ([[dict objectForKey:@"tipped_position"] intValue] == 1) {
        tip = @"or Tips";
    } else {
        tip = @"";
    }
    cell.line2.text = [NSString stringWithFormat:@"Age: %@ | $%@/hr %@",[dict objectForKey:@"age"], [dict objectForKey:@"hourly_wage"],tip];
    if ([dict objectForKey:@"experience"] == (id)[NSNull null] || [[dict objectForKey:@"experience"]length] == 0 ) {
        cell.line3.text = [NSString stringWithFormat:@"Education: %@",[dict objectForKey:@"education"]];
        cell.line4.text = @"";
    } else {
        cell.line3.text = [NSString stringWithFormat:@"%@: %@",jobstatus,[dict objectForKey:@"experience"]];
        cell.line4.text = [NSString stringWithFormat:@"Education: %@",[dict objectForKey:@"education"]];
    }
    
    [cell layoutIfNeeded];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dict = [self.json objectAtIndex:indexPath.row];
    NSString *userID = [dict objectForKey:@"id"];
    self.userID = userID;
    SearchResultProfileViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileSearchResult"];
    [myController setProfileID:self.userID];
    [myController setSearchID:self.searchID];
    [myController setSearchedUserDict:dict];
    [myController setParamHolder:self.searchParameters];
    
    [self.navigationController pushViewController:myController animated:TRUE];
}

- (IBAction)pressUpdateSearch:(id)sender
{
    RefineSearchViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"UpdateSearchViewController"];
    [self.navigationController pushViewController:myController animated:YES];
    [myController setSearchparms:self.searchParameters];
}

- (IBAction)pressSaveSearch:(id)sender
{
    self.definesPresentationContext = YES;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"GeneralViews" bundle:nil];
    SaveSearchViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"SaveSearchViewController"];
    
    vc.view.backgroundColor = [UIColor clearColor];
    vc.saveID = [self.additionalJSON objectForKey:@"search_id"];
    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
    vc.view.backgroundColor = [UIColor clearColor];
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;

    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)pressFavorite:(SearchResultTableViewCell *)cell
{
    AFHTTPRequestOperationManager *manager = [self getManager];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:cell.searchID forKey:@"search_id"];
    [params setObject:cell.profileID forKey:@"user_id"];
    if (self.btnFavorite.selected == NO) {
        if([params count]) {
            [manager POST:@"http://uwurk.tscserver.com/api/v1/add_favorite_employee" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"\nAdd Favorite - Json Response: \n%@", responseObject);
                cell.btnFavorite.selected = YES;
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                [self handleErrorAccessError:error];
            }];
        }
    } else {
        if([params count]){
            [manager POST:@"http://uwurk.tscserver.com/api/v1/remove_favorite_employee" parameters:params
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      NSLog(@"\nRemove Favorite - Json Response: \n%@", responseObject);
                      cell.btnFavorite.selected = NO;
                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      NSLog(@"Error: %@", error);
                      [self handleErrorAccessError:error];
                  }
             ];
        }
    }
}


- (void)handleErrorAccessError:(NSError *)error
{
    NSString *message = [NSString stringWithFormat:@"Access error:\n\n%@",[error localizedDescription]];
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Oops!"
                                 message:message
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction
                      actionWithTitle:@"OK"
                      style:UIAlertActionStyleDefault
                      handler:^(UIAlertAction *action)
                      {
                      }]];
    [self presentViewController:alert animated:TRUE completion:nil];
}

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
//}

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

@end
