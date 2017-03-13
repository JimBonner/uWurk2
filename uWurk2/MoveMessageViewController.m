//
//  MoveMessageViewController.m
//  
//
//  Created by Avery Bonner on 11/23/15.
//
//

#import "MoveMessageViewController.h"
#import "MailFolderTableViewCell.h"

@interface MoveMessageViewController ()
@property (strong, nonatomic) NSMutableArray *json;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation MoveMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44.0; // set to whatever your "average" cell height is

    // Do any additional setup after loading the view.
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [self updateParamDict:params value:@"list" key:@"action"];
    [manager POST:@"http://uwurk.tscserver.com/msgfolder" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.json = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"folders"]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.json count];
  }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MailFolderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MailMoveToFolderCell" forIndexPath:indexPath];

    NSDictionary *paramdic = [self.json objectAtIndex:indexPath.row];
    cell.lblFolderName.text = [paramdic objectForKey:@"name"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *paramdic = [self.json objectAtIndex:indexPath.row];

    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [self updateParamDict:params value:@"move_disc" key:@"action"];
    [self updateParamDict:params value:[paramdic objectForKey:@"id"]  key:@"folder_id"];
    [self updateParamDict:params value:[self.dict objectForKey:@"discussion_id"] key:@"id"];
    
    [manager POST:@"http://uwurk.tscserver.com/msgfolder" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.json = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"folders"]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

}


@end
