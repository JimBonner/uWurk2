//
//  ProfileEditWorkExperienceViewController.m
//  uWurk2
//
//  Created by Avery Bonner on 9/22/15.
//  Copyright (c) 2015 Michael Brown. All rights reserved.
//  Copyright (c) 2017 Jim Bonner. All rights reserved.
//

#import "ProfileEditWorkExperienceViewController.h"
#import "ProfileEditStep5ViewController.h"

@interface ProfileEditWorkExperienceViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lblExperience1;
@property (weak, nonatomic) IBOutlet UILabel *lblExperience2;
@property (weak, nonatomic) IBOutlet UILabel *lblExperience3;
@property (weak, nonatomic) IBOutlet UILabel *lblExperience4;
@property (weak, nonatomic) IBOutlet UILabel *lblExperience5;
@property (weak, nonatomic) IBOutlet UIView *viewExp1;
@property (weak, nonatomic) IBOutlet UIView *viewExp2;
@property (weak, nonatomic) IBOutlet UIView *viewExp3;
@property (weak, nonatomic) IBOutlet UIView *viewExp4;
@property (weak, nonatomic) IBOutlet UIView *viewExp5;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *exp1Height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *exp2Height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *exp3Height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *exp4Height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *exp5Height;
@property (weak, nonatomic) IBOutlet UIView *viewExpTip;
@property (strong, nonatomic) NSMutableDictionary *params;
@property (strong, nonatomic) NSString *experienceCount;
@property (weak, nonatomic) IBOutlet UIButton *btnAddExp;



@end

@implementation ProfileEditWorkExperienceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"\nEmployee Profile Edit Experience:\n%@",self.appDelegate.user);
    
    self.params = [[NSMutableDictionary alloc] init];
    self.viewExpTip.layer.cornerRadius = 10;
    NSString *JobLength1;
    NSString *JobLength2;
    NSString *JobLength3;
    NSString *JobLength4;
    NSString *JobLength5;
    NSString *JobStatus1;
    NSString *JobStatus2;
    NSString *JobStatus3;
    NSString *JobStatus4;
    NSString *JobStatus5;
    NSArray *expArray = [self.appDelegate.user objectForKey:@"experience"];
    if([expArray count] >=1) {
        self.experienceCount = @"1";
        NSDictionary *firstExpItem = [expArray objectAtIndex:0];
        if ([[firstExpItem objectForKey:@"job_length"] intValue] == 1) {
            JobLength1 = @"Under 1 Year";
        }
        if ([[firstExpItem objectForKey:@"job_length"] intValue] == 2) {
            JobLength1 = @"1-2 Years";
        }
        if ([[firstExpItem objectForKey:@"job_length"] intValue] == 3) {
            JobLength1 = @"Over 2 Years";
        }
        if ([[firstExpItem objectForKey:@"status"] intValue] == 1) {
            JobStatus1 = @"Current";
        }
        if ([[firstExpItem objectForKey:@"status"] intValue] == 2) {
            JobStatus1 = @"Previous";
        }
        [self.params setObject:[firstExpItem objectForKey:@"id"] forKey:@"exp_id[0]"];
        [self.params setObject:[firstExpItem objectForKey:@"company"] forKey:@"company[0]"];
        [self.params setObject:[firstExpItem objectForKey:@"status"] forKey:@"status[0]"];
        [self.params setObject:[firstExpItem objectForKey:@"industry_id"] forKey:@"industry[0]"];
        [self.params setObject:[firstExpItem objectForKey:@"position_id"] forKey:@"position[0]"];
        [self.params setObject:@"" forKey:@"position2[0]"];
        [self.params setObject:@"" forKey:@"other_position[0]"];
        [self.params setObject:[firstExpItem objectForKey:@"job_length"] forKey:@"job_length[0]"];
        [self.params setObject:@"0" forKey:@"remove[0]"];
        self.lblExperience1.text = [NSString stringWithFormat:@"%@: %@, %@", JobStatus1, [firstExpItem objectForKey:@"company"], [firstExpItem objectForKey:@"position"]];
    }
    else {
        self.experienceCount = @"0";
        self.exp1Height.constant = 0;
        self.viewExp1.alpha = 0;
        
    }
    if([expArray count] >=2) {
        self.experienceCount = @"2";
        NSDictionary *secondExpItem = [expArray objectAtIndex:1];
        if ([[secondExpItem objectForKey:@"job_length"] intValue] == 1) {
            JobLength2 = @"Under 1 Year";
        }
        if ([[secondExpItem objectForKey:@"job_length"] intValue] == 2) {
            JobLength2 = @"1-2 Years";
        }
        if ([[secondExpItem objectForKey:@"job_length"] intValue] == 3) {
            JobLength2 = @"Over 2 Years";
        }
        if ([[secondExpItem objectForKey:@"status"] intValue] == 1) {
            JobStatus2 = @"Current";
        }
        if ([[secondExpItem
              objectForKey:@"status"] intValue] == 2) {
            JobStatus2 = @"Previous";
        }
        [self.params setObject:[secondExpItem objectForKey:@"id"] forKey:@"exp_id[1]"];
        [self.params setObject:[secondExpItem objectForKey:@"company"] forKey:@"company[1]"];
        [self.params setObject:[secondExpItem objectForKey:@"status"] forKey:@"status[1]"];
        [self.params setObject:[secondExpItem objectForKey:@"industry_id"] forKey:@"industry[1]"];
        [self.params setObject:[secondExpItem objectForKey:@"position_id"] forKey:@"position[1]"];
        [self.params setObject:@"" forKey:@"position2[1]"];
        [self.params setObject:@"" forKey:@"other_position[1]"];
        [self.params setObject:[secondExpItem objectForKey:@"job_length"] forKey:@"job_length[1]"];
        [self.params setObject:@"0" forKey:@"remove[1]"];
        self.lblExperience2.text = [NSString stringWithFormat:@"%@: %@, %@", JobStatus2, [secondExpItem objectForKey:@"company"], [secondExpItem objectForKey:@"position"]];
    }
    else {
        self.exp2Height.constant = 0;
        self.viewExp2.alpha = 0;
    }
    if([expArray count] >=3) {
        self.experienceCount = @"3";
        NSDictionary *thirdExpItem = [expArray objectAtIndex:2];
        if ([[thirdExpItem objectForKey:@"job_length"] intValue] == 1) {
            JobLength3 = @"Under 1 Year";
        }
        if ([[thirdExpItem objectForKey:@"job_length"] intValue] == 2) {
            JobLength3 = @"1-2 Years";
        }
        if ([[thirdExpItem objectForKey:@"job_length"] intValue] == 3) {
            JobLength3 = @"Over 2 Years";
        }
        if ([[thirdExpItem objectForKey:@"status"] intValue] == 1) {
            JobStatus3 = @"Current";
        }
        if ([[thirdExpItem objectForKey:@"status"] intValue] == 2) {
            JobStatus3 = @"Previous";
        }
        [self.params setObject:[thirdExpItem objectForKey:@"id"] forKey:@"exp_id[2]"];
        [self.params setObject:[thirdExpItem objectForKey:@"company"] forKey:@"company[2]"];
        [self.params setObject:[thirdExpItem objectForKey:@"status"] forKey:@"status[2]"];
        [self.params setObject:[thirdExpItem objectForKey:@"industry_id"] forKey:@"industry[2]"];
        [self.params setObject:[thirdExpItem objectForKey:@"position_id"] forKey:@"position[2]"];
        [self.params setObject:@"" forKey:@"position2[2]"];
        [self.params setObject:@"" forKey:@"other_position[2]"];
        [self.params setObject:[thirdExpItem objectForKey:@"job_length"] forKey:@"job_length[2]"];
        [self.params setObject:@"0" forKey:@"remove[2]"];
        self.lblExperience3.text = [NSString stringWithFormat:@"%@: %@, %@", JobStatus3, [thirdExpItem objectForKey:@"company"], [thirdExpItem objectForKey:@"position"]];
    }
    else {
        self.exp3Height.constant = 0;
        self.viewExp3.alpha = 0;
    }
    if([expArray count] >=4) {
        self.experienceCount = @"4";
        NSDictionary *fourthExpItem = [expArray objectAtIndex:3];
        if ([[fourthExpItem objectForKey:@"job_length"] intValue] == 1) {
            JobLength4 = @"Under 1 Year";
        }
        if ([[fourthExpItem objectForKey:@"job_length"] intValue] == 2) {
            JobLength4 = @"1-2 Years";
        }
        if ([[fourthExpItem objectForKey:@"job_length"] intValue] == 3) {
            JobLength4 = @"Over 2 Years";
        }
        if ([[fourthExpItem objectForKey:@"status"] intValue] == 1) {
            JobStatus4 = @"Current";
        }
        if ([[fourthExpItem objectForKey:@"status"] intValue] == 2) {
            JobStatus4 = @"Previous";
        }
        [self.params setObject:[fourthExpItem objectForKey:@"id"] forKey:@"exp_id[3]"];
        [self.params setObject:[fourthExpItem objectForKey:@"company"] forKey:@"company[3]"];
        [self.params setObject:[fourthExpItem objectForKey:@"status"] forKey:@"status[3]"];
        [self.params setObject:[fourthExpItem objectForKey:@"industry_id"] forKey:@"industry[3]"];
        [self.params setObject:[fourthExpItem objectForKey:@"position_id"] forKey:@"position[3]"];
        [self.params setObject:@"" forKey:@"position2[3]"];
        [self.params setObject:@"" forKey:@"other_position[3]"];
        [self.params setObject:[fourthExpItem objectForKey:@"job_length"] forKey:@"job_length[3]"];
        [self.params setObject:@"0" forKey:@"remove[3]"];
        self.lblExperience4.text = [NSString stringWithFormat:@"%@: %@, %@", JobStatus4, [fourthExpItem objectForKey:@"company"], [fourthExpItem objectForKey:@"position"]];
    }
    else {
        self.exp4Height.constant = 0;
        self.viewExp4.alpha = 0;
    }
    if([expArray count] >=5) {
        self.btnAddExp.enabled = NO;
        NSDictionary *fifthExpItem = [expArray objectAtIndex:4];
        if ([[fifthExpItem objectForKey:@"job_length"] intValue] == 1) {
            JobLength5 = @"Under 1 Year";
        }
        if ([[fifthExpItem objectForKey:@"job_length"] intValue] == 2) {
            JobLength5 = @"1-2 Years";
        }
        if ([[fifthExpItem objectForKey:@"job_length"] intValue] == 3) {
            JobLength5 = @"Over 2 Years";
        }
        if ([[fifthExpItem objectForKey:@"status"] intValue] == 1) {
            JobStatus5 = @"Current";
        }
        if ([[fifthExpItem objectForKey:@"status"] intValue] == 2) {
            JobStatus5 = @"Previous";
        }
        [self.params setObject:[fifthExpItem objectForKey:@"id"] forKey:@"exp_id[4]"];
        [self.params setObject:[fifthExpItem objectForKey:@"company"] forKey:@"company[4]"];
        [self.params setObject:[fifthExpItem objectForKey:@"status"] forKey:@"status[4]"];
        [self.params setObject:[fifthExpItem objectForKey:@"industry_id"] forKey:@"industry[4]"];
        [self.params setObject:[fifthExpItem objectForKey:@"position_id"] forKey:@"position[4]"];
        [self.params setObject:@"" forKey:@"position2[4]"];
        [self.params setObject:@"" forKey:@"other_position[4]"];
        [self.params setObject:[fifthExpItem objectForKey:@"job_length"] forKey:@"job_length[4]"];
        [self.params setObject:@"0" forKey:@"remove[4]"];
        self.lblExperience5.text = [NSString stringWithFormat:@"%@: %@, %@", JobStatus5, [fifthExpItem objectForKey:@"company"], [fifthExpItem objectForKey:@"position"]];
    }
    
    else {
        self.exp5Height.constant = 0;
        self.viewExp5.alpha = 0;
    }
    
    [self.view layoutIfNeeded];
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)btnAddExperience:(id)sender {
    ProfileEditStep5ViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileEditAddExperience"];
    [self.navigationController pushViewController:myController animated:TRUE];
    [myController setExpCount:self.experienceCount];
}
- (IBAction)pressRemove:(UIButton *)sender {
    if (sender.tag == 0) {
        [self.params setObject:@"1" forKey:@"remove[0]"];
        [UIView animateWithDuration:.3 animations:^{
            self.viewExp1.alpha = 0;
        }
         
                         completion:^ (BOOL finished)
         {
             if (finished) {
                 [UIView animateWithDuration:.3 animations:^{
                     self.exp1Height.constant = 0;
                     [self.view layoutIfNeeded];}];
             }
         }];
    }
    if (sender.tag == 1) {
        [self.params setObject:@"1" forKey:@"remove[1]"];
        [UIView animateWithDuration:.3 animations:^{
            self.viewExp2.alpha = 0;
        }
         
                         completion:^ (BOOL finished)
         {
             if (finished) {
                 [UIView animateWithDuration:.3 animations:^{
                     self.exp2Height.constant = 0;
                     [self.view layoutIfNeeded];}];
             }
         }];
    }
    if (sender.tag == 2) {
        [self.params setObject:@"1" forKey:@"remove[2]"];
        [UIView animateWithDuration:.3 animations:^{
            self.viewExp3.alpha = 0;
        }
         
                         completion:^ (BOOL finished)
         {
             if (finished) {
                 [UIView animateWithDuration:.3 animations:^{
                     self.exp3Height.constant = 0;
                     [self.view layoutIfNeeded];}];
             }
         }];
    }
    if (sender.tag == 3) {
        [self.params setObject:@"1" forKey:@"remove[3]"];
        [UIView animateWithDuration:.3 animations:^{
            self.viewExp4.alpha = 0;
        }
         
                         completion:^ (BOOL finished)
         {
             if (finished) {
                 [UIView animateWithDuration:.3 animations:^{
                     self.exp4Height.constant = 0;
                     [self.view layoutIfNeeded];}];
             }
         }];
    }
    if (sender.tag == 4) {
        [self.params setObject:@"1" forKey:@"remove[4]"];
        [UIView animateWithDuration:.3 animations:^{
            self.viewExp5.alpha = 0;
        }
         
                         completion:^ (BOOL finished)
         {
             if (finished) {
                 [UIView animateWithDuration:.3 animations:^{
                     self.exp5Height.constant = 0;
                     [self.view layoutIfNeeded];}];
             }
         }];
    }
}
- (IBAction)pressEdit:(UIButton *)sender {
    if (sender.tag == 0)
    {
        ProfileEditStep5ViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileEditAddExperience"];
        [self.navigationController pushViewController:myController animated:TRUE];
        [myController setExpEditCount:@"0"];
    }
    if (sender.tag == 1)
    {
        ProfileEditStep5ViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileEditAddExperience"];
        [self.navigationController pushViewController:myController animated:TRUE];
        [myController setExpEditCount:@"1"];
    }
    if (sender.tag == 2)
    {
        ProfileEditStep5ViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileEditAddExperience"];
        [self.navigationController pushViewController:myController animated:TRUE];
        [myController setExpEditCount:@"2"];
    }
    if (sender.tag == 3)
    {
        ProfileEditStep5ViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileEditAddExperience"];
        [self.navigationController pushViewController:myController animated:TRUE];
        [myController setExpEditCount:@"3"];
    }
    if (sender.tag == 4)
    {
        ProfileEditStep5ViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileEditAddExperience"];
        [self.navigationController pushViewController:myController animated:TRUE];
        [myController setExpEditCount:@"4"];
    }
}
- (IBAction)nextPress:(id)sender {
    AFHTTPRequestOperationManager *manager = [self getManager];
    if([self.params count]){
        [manager POST:@"http://uwurk.tscserver.com/api/v1/profile" parameters:self.params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            if([self validateResponse:responseObject]){
                
                // Update the user object
                
                
                UIViewController *myController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"EmployeeLanding"];
                [self.navigationController setViewControllers:@[myController] animated:TRUE];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Oops!"
                                                             message:@"Unable to contact server"
                                                            delegate:self
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles: nil];
            [alert show];
        }];
    }
    else{
        UIViewController *myController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"EmployeeLanding"];
        [self.navigationController setViewControllers:@[myController] animated:TRUE];
    }

}

@end

