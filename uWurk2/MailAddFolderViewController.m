//
//  MailAddFolderViewController.m
//  uWurk2
//
//  Created by Rob Bonner on 11/22/15.
//  Copyright (c) 2015 Michael Brown. All rights reserved.
//  Copyright (c) 2017 Jim Bonner. All rights reserved.
//

#import "MailAddFolderViewController.h"

@interface MailAddFolderViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txtName;

@end

@implementation MailAddFolderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)addFolder:(id)sender {
    AFHTTPRequestOperationManager *manager = [self getManager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [self updateParamDict:params value:@"create" key:@"action"];
    [self updateParamDict:params value:self.txtName.text key:@"name"];
    
    [manager POST:@"http://uwurk.tscserver.com/msgfolder" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.navigationController popViewControllerAnimated:TRUE];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
