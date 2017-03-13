//
//  SaveSearchViewController.m
//  uWurk2
//
//  Created by Rob Bonner on 1/17/16.
//  Copyright © 2016 Michael Brown. All rights reserved.
//

#import "SaveSearchViewController.h"
#import "ColorUtils.h"

@interface SaveSearchViewController ()
@property (weak, nonatomic) IBOutlet UIView *saveSearchView;
@property (weak, nonatomic) IBOutlet UITextField *txtDescription;
@end

@implementation SaveSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.saveSearchView.layer.borderColor = [UIColor colorWithString:@"0x1A1A1A"].CGColor;
    self.saveSearchView.layer.borderWidth = 1.0f;
}

- (IBAction)savePress:(id)sender {
    
    AFHTTPRequestOperationManager *manager = [self getManager];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:self.saveID forKey:@"id"];
    [params setObject:self.txtDescription.text forKey:@"description"];
    
    if([params count]){
        [manager POST:@"http://uwurk.tscserver.com/api/v1/save_search" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            if([self validateResponse:responseObject]){
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Error"
                                                             message:@"Unable to save search"
                                                            delegate:self
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles: nil];
            [alert show];
        }];
    }
   
}

- (IBAction)cancelPress:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
