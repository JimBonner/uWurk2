//
//  SaveSearchViewController.m
//  uWurk2
//
//  Created by Rob Bonner on 1/17/16.
//  Copyright (c) 2016 Michael Brown. All rights reserved.
//  Copyright (c) 2017 Jim Bonner. All rights reserved.
//

#import "SaveSearchViewController.h"
#import "ColorUtils.h"

@interface SaveSearchViewController ()
@property (weak, nonatomic) IBOutlet UIView *saveSearchView;
@property (weak, nonatomic) IBOutlet UITextField *txtDescription;
@end

@implementation SaveSearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.saveSearchView.layer.borderColor = [UIColor colorWithString:@"0x1A1A1A"].CGColor;
    self.saveSearchView.layer.borderWidth = 1.0f;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (IBAction)savePress:(id)sender
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:self.saveID forKey:@"id"];
    [params setObject:self.txtDescription.text forKey:@"description"];
    
    if([params count]){
        AFHTTPRequestOperationManager *manager = [self getManager];
        [manager POST:@"http://uwurk.tscserver.com/api/v1/save_search" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            if([self validateResponse:responseObject]){
                [self dismissViewControllerAnimated:YES completion:nil];
            } else {
                [self handleErrorJsonResponse:@"SaveSearch"];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            [self handleErrorUnableToSaveData:@"Search"];
        }];
    }
}

- (IBAction)cancelPress:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
