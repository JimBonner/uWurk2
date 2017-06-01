//
//  ContactProfileViewController.m
//  
//
//  Created by Avery Bonner on 11/23/15.
//  Copyright (c) 2017 Jim Bonner. All rights reserved.
//

#import "ContactProfileViewController.h"
#import "ContactProfileNotifyViewController.h"
#import "UrlImageRequest.h"

@interface ContactProfileViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel     *lblEmployeeName;
@property (weak, nonatomic) IBOutlet UILabel     *lblEmployer;
@property (weak, nonatomic) IBOutlet UILabel     *lblPosition;
@property (weak, nonatomic) IBOutlet UILabel     *lblLocation;
@property (weak, nonatomic) IBOutlet UILabel     *lblWage;
@property (weak, nonatomic) IBOutlet UILabel     *lblNameInterest;
@property (weak, nonatomic) IBOutlet UIButton    *btnSend;

@end

@implementation ContactProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"\nContact Profile:\n%@",self.appDelegate.user);
    
    NSURL *photoURL =[NSURL URLWithString:[NSString stringWithFormat:@"http://uwurk.tscserver.com%@",[self.searchUserDict objectForKey:@"photo_url"]]];
    UrlImageRequest *photoRequest = [[UrlImageRequest alloc]initWithURL:photoURL];
    [photoRequest startWithCompletion:^(UIImage *newImage, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.imgView setImage:newImage];
        });
    }];
     
    self.lblEmployeeName.text = [NSString stringWithFormat:@"Below are the job details you will be sending to %@.",[self.searchUserDict objectForKey:@"first_name"]];
    self.lblEmployer.text = [self.appDelegate.user objectForKey:@"company"];
    NSString *jobType = @"Full Time";
    if([[self.searchParams objectForKey:@"hours"]integerValue] == 1) {
        jobType = @"Full Time";
    } else if([[self.searchParams objectForKey:@"hours"]integerValue] == 2) {
        jobType = @"Part Time";
    } else  if ([[self.searchParams objectForKey:@"hours"]integerValue] == 3) {
        jobType = @"Temporary";
    }
    self.lblPosition.text = [NSString stringWithFormat:@"%@ - %@",
                             [self.otherParams objectForKey:@"position"],
                             jobType];
    self.lblLocation.text = [NSString stringWithFormat:@"%@ %@",
                             [self.otherParams objectForKey:@"location"],
                             [self.searchParams objectForKey:@"zip"]];
    
    NSString *wage = @"";
    if([[self.searchParams objectForKey:@"hourly_wage"]floatValue] > 0.0) {
        wage = [NSString stringWithFormat:@"$%@ per hour",[self.searchParams objectForKey:@"hourly_wage"]];
    }
    if([[self.searchParams objectForKey:@"wage_type_tipped"]integerValue] == 1) {
        if([wage length] == 0) {
            wage = [wage stringByAppendingString:@"Tips only"];
        } else {
            wage = [wage stringByAppendingString:@" plus Tips"];
        }
    }
    self.lblWage.text     = wage;
    self.lblNameInterest.text = [NSString stringWithFormat:@"Based on %@'s interest in this position, you will receive a YES or NO reply.",[self.searchUserDict objectForKey:@"first_name"]];
}

- (IBAction)pressSend:(UIButton *)sender
{
    AFHTTPRequestOperationManager *manager = [self getManager];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[self.searchParams objectForKey:@"position"] forKey:@"position_id"];
    [params setObject:[self.searchUserDict objectForKey:@"id"] forKey:@"contact_id"];
    [params setObject:[self.searchParams objectForKey:@"hours"] forKey:@"hours"];
    [params setObject:[self.searchParams objectForKey:@"zip"] forKey:@"zip"];
    [params setObject:@"" forKey:@"message"];
    
    if ([params count]) {
        [manager POST:@"http://uwurk.tscserver.com/api/v1/contact" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"\nContact Profile - Json Response:\n%@",responseObject);
            ContactProfileNotifyViewController *myController = [[UIStoryboard storyboardWithName:@"Mail" bundle:nil] instantiateViewControllerWithIdentifier:@"ContactProfileNotifyView"];
            [myController setSearchUserDict:self.searchUserDict];
            [myController setSearchParams:self.searchParams];
            [self.navigationController pushViewController:myController animated:TRUE];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            [self handleErrorAccessError:@"Contact Profile" withError:error];
        }];
    } else {
        ContactProfileNotifyViewController *myController = [[UIStoryboard storyboardWithName:@"Mail" bundle:nil]  instantiateViewControllerWithIdentifier:@"ContactProfileNotifyView"];
        [myController setSearchUserDict:self.searchUserDict];
        [myController setSearchParams:self.searchParams];
        [self.navigationController setViewControllers:@[myController] animated:TRUE];
    }
}

@end
