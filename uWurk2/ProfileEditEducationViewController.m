//
//  ProfileEditEducationViewController.m
//  uWurk2
//
//  Created by Avery Bonner on 9/21/15.
//  Copyright (c) 2015 Michael Brown. All rights reserved.
//  Copyright (c) 2017 Jim Bonner. All rights reserved.
//

#import "ProfileEditEducationViewController.h"
#import "ProfileEditStep4ViewController.h"

@interface ProfileEditEducationViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cnstrntAddView;
@property (weak, nonatomic) IBOutlet UILabel *lblEducation1;
@property (weak, nonatomic) IBOutlet UILabel *lblEducation2;
@property (weak, nonatomic) IBOutlet UILabel *lblEducation3;
@property (weak, nonatomic) IBOutlet UILabel *lblEducation4;
@property (weak, nonatomic) IBOutlet UILabel *lblEducation5;
@property (weak, nonatomic) IBOutlet UIView *viewEdu1;
@property (weak, nonatomic) IBOutlet UIView *viewEdu2;
@property (weak, nonatomic) IBOutlet UIView *viewEdu3;
@property (weak, nonatomic) IBOutlet UIView *viewEdu4;
@property (weak, nonatomic) IBOutlet UIView *viewEdu5;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *edu1Height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *edu2Height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *edu3Height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *edu4Height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *edu5Height;
@property (weak, nonatomic) IBOutlet UIView *viewEduTip;
@property (strong, nonatomic) NSString *educationCount;
@property (weak, nonatomic) IBOutlet UIButton *btnAddSchool;
@property (strong, nonatomic) NSMutableDictionary *params;

@end

@implementation ProfileEditEducationViewController

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
    
    NSLog(@"\nEmployee Profile Edit Education:\n%@",self.appDelegate.user);
    
    self.params = [[NSMutableDictionary alloc] init];
    self.viewEduTip.layer.cornerRadius = 10;
    NSString *SchoolStatus1;
    NSString *SchoolStatus2;
    NSString *SchoolStatus3;
    NSString *SchoolStatus4;
    NSString *SchoolStatus5;
    NSArray  *eduArray = [self.appDelegate.user objectForKey:@"education"];
    if([eduArray count] >=1) {
        self.educationCount = @"2";
        NSDictionary *firstEduItem = [eduArray objectAtIndex:0];
        if ([[firstEduItem objectForKey:@"school_status_id"] intValue] == 1) {
            SchoolStatus1 = @"Enrolled";
        }
        if ([[firstEduItem objectForKey:@"school_status_id"] intValue] == 2) {
            SchoolStatus1 = @"Graduated";
        }
        if ([[firstEduItem objectForKey:@"school_status_id"] intValue] == 3) {
            SchoolStatus1 = @"Attended";
        }
        [self.params setObject:[firstEduItem objectForKey:@"id"] forKey:@"edu_id[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"school"] forKey:@"school_level[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"school_status_id"] forKey:@"status[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"state_id"] forKey:@"state[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"other_location"] forKey:@"other_location[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"city"] forKey:@"town[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"school_id"] forKey:@"school[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"other_school"] forKey:@"other_school[0]"];
        [self.params setObject:@"0" forKey:@"remove[0]"];
        self.lblEducation1.text = [NSString stringWithFormat:@"%@: %@", SchoolStatus1, [firstEduItem objectForKey:@"school"]];
        
    }
    else{
        self.educationCount = @"1";
        self.edu1Height.constant = 0;
        self.viewEdu1.alpha = 0;
    }
    if([eduArray count] >=2) {
        self.educationCount = @"3";
        NSDictionary *secondEduItem = [eduArray objectAtIndex:1];
        if ([[secondEduItem objectForKey:@"school_status_id"] intValue] == 1) {
            SchoolStatus2 = @"Enrolled";
        }
        if ([[secondEduItem objectForKey:@"school_status_id"] intValue] == 2) {
            SchoolStatus2 = @"Graduated";
        }
        if ([[secondEduItem objectForKey:@"school_status_id"] intValue] == 3) {
            SchoolStatus2 = @"Attended";
        }
        [self.params setObject:[secondEduItem objectForKey:@"id"] forKey:@"edu_id[1]"];
        [self.params setObject:[secondEduItem objectForKey:@"school"] forKey:@"school_level[1]"];
        [self.params setObject:[secondEduItem objectForKey:@"school_status_id"] forKey:@"status[1]"];
        [self.params setObject:[secondEduItem objectForKey:@"state_id"] forKey:@"state[1]"];
        [self.params setObject:[secondEduItem objectForKey:@"other_location"] forKey:@"other_location[1]"];
        [self.params setObject:[secondEduItem objectForKey:@"city"] forKey:@"town[1]"];
        [self.params setObject:[secondEduItem objectForKey:@"school_id"] forKey:@"school[1]"];
        [self.params setObject:[secondEduItem objectForKey:@"other_school"] forKey:@"other_school[1]"];
        [self.params setObject:@"0" forKey:@"remove[1]"];
        self.lblEducation2.text = [NSString stringWithFormat:@"%@: %@", SchoolStatus2, [secondEduItem objectForKey:@"school"]];
        
    }
    else{
        self.edu2Height.constant = 0;
       self.viewEdu2.alpha = 0;
    }
    if([eduArray count] >=3) {
        self.educationCount = @"4";
        NSDictionary *thirdEduItem = [eduArray objectAtIndex:2];
        if ([[thirdEduItem objectForKey:@"school_status_id"] intValue] == 1) {
            SchoolStatus3 = @"Enrolled";
        }
        if ([[thirdEduItem objectForKey:@"school_status_id"] intValue] == 2) {
            SchoolStatus3 = @"Graduated";
        }
        if ([[thirdEduItem objectForKey:@"school_status_id"] intValue] == 3) {
            SchoolStatus3 = @"Attended";
        }
        [self.params setObject:[thirdEduItem objectForKey:@"id"] forKey:@"edu_id[2]"];
        [self.params setObject:[thirdEduItem objectForKey:@"school"] forKey:@"school_level[2]"];
        [self.params setObject:[thirdEduItem objectForKey:@"school_status_id"] forKey:@"status[2]"];
        [self.params setObject:[thirdEduItem objectForKey:@"state_id"] forKey:@"state[2]"];
        [self.params setObject:[thirdEduItem objectForKey:@"other_location"] forKey:@"other_location[2]"];
        [self.params setObject:[thirdEduItem objectForKey:@"city"] forKey:@"town[2]"];
        [self.params setObject:[thirdEduItem objectForKey:@"school_id"] forKey:@"school[2]"];
        [self.params setObject:[thirdEduItem objectForKey:@"other_school"] forKey:@"other_school[2]"];
        [self.params setObject:@"0" forKey:@"remove[2]"];
        self.lblEducation3.text = [NSString stringWithFormat:@"%@: %@", SchoolStatus3, [thirdEduItem objectForKey:@"school"]];
        
    }
    else{
        self.edu3Height.constant = 0;
        self.viewEdu3.alpha = 0;
    }
    if([eduArray count] >=4) {
        self.educationCount = @"5";
        NSDictionary *fourthEduItem = [eduArray objectAtIndex:3];
        if ([[fourthEduItem objectForKey:@"school_status_id"] intValue] == 1) {
            SchoolStatus4 = @"Enrolled";
        }
        if ([[fourthEduItem objectForKey:@"school_status_id"] intValue] == 2) {
            SchoolStatus4 = @"Graduated";
        }
        if ([[fourthEduItem objectForKey:@"school_status_id"] intValue] == 3) {
            SchoolStatus4 = @"Attended";
        }
        [self.params setObject:[fourthEduItem objectForKey:@"id"] forKey:@"edu_id[3]"];
        [self.params setObject:[fourthEduItem objectForKey:@"school"] forKey:@"school_level[3]"];
        [self.params setObject:[fourthEduItem objectForKey:@"school_status_id"] forKey:@"status[3]"];
        [self.params setObject:[fourthEduItem objectForKey:@"state_id"] forKey:@"state[3]"];
        [self.params setObject:[fourthEduItem objectForKey:@"other_location"] forKey:@"other_location[3]"];
        [self.params setObject:[fourthEduItem objectForKey:@"city"] forKey:@"town[3]"];
        [self.params setObject:[fourthEduItem objectForKey:@"school_id"] forKey:@"school[3]"];
        [self.params setObject:[fourthEduItem objectForKey:@"other_school"] forKey:@"other_school[3]"];
        [self.params setObject:@"0" forKey:@"remove[3]"];
        self.lblEducation4.text = [NSString stringWithFormat:@"%@: %@", SchoolStatus4, [fourthEduItem objectForKey:@"school"]];
    }
    else{
        self.edu4Height.constant = 0;
        self.viewEdu4.alpha = 0;
    }
    if([eduArray count] >=5) {
        self.btnAddSchool.enabled = NO;
        NSDictionary *fifthEduItem = [eduArray objectAtIndex:4];
        if ([[fifthEduItem objectForKey:@"school_status_id"] intValue] == 1) {
            SchoolStatus5 = @"Enrolled";
        }
        if ([[fifthEduItem objectForKey:@"school_status_id"] intValue] == 2) {
            SchoolStatus5 = @"Graduated";
        }
        if ([[fifthEduItem objectForKey:@"school_status_id"] intValue] == 3) {
            SchoolStatus5 = @"Attended";
        }
        [self.params setObject:[fifthEduItem objectForKey:@"id"] forKey:@"edu_id[4]"];
        [self.params setObject:[fifthEduItem objectForKey:@"school"] forKey:@"school_level[4]"];
        [self.params setObject:[fifthEduItem objectForKey:@"school_status_id"] forKey:@"status[4]"];
        [self.params setObject:[fifthEduItem objectForKey:@"state_id"] forKey:@"state[4]"];
        [self.params setObject:[fifthEduItem objectForKey:@"other_location"] forKey:@"other_location[4]"];
        [self.params setObject:[fifthEduItem objectForKey:@"city"] forKey:@"town[4]"];
        [self.params setObject:[fifthEduItem objectForKey:@"school_id"] forKey:@"school[4]"];
        [self.params setObject:[fifthEduItem objectForKey:@"other_school"] forKey:@"other_school[4]"];
        [self.params setObject:@"0" forKey:@"remove[4]"];
        self.lblEducation5.text = [NSString stringWithFormat:@"%@: %@", SchoolStatus5, [fifthEduItem objectForKey:@"school"]];
    }
    else{
        self.edu5Height.constant = 0;
        self.viewEdu5.alpha = 0;
    }
    
    [self.view layoutIfNeeded];
}

- (IBAction)btnAddSchool:(id)sender {
    ProfileEditStep4ViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileEditAddSchool"];
    [self.navigationController pushViewController:myController animated:TRUE];
    [myController setEducount:self.educationCount];
}

- (IBAction)pressRemove:(UIButton *)sender {
    if (sender.tag == 0) {
        [self.params setObject:@"1" forKey:@"remove[0]"];
        [UIView animateWithDuration:.3 animations:^{
            self.viewEdu1.alpha = 0;
            }
         
                         completion:^ (BOOL finished)
         {
             if (finished) {
                 [UIView animateWithDuration:.3 animations:^{
                     self.edu1Height.constant = 0;
                     [self.view layoutIfNeeded];}];
             }
         }];
    }
    if (sender.tag == 1) {
        [self.params setObject:@"1" forKey:@"remove[1]"];
        [UIView animateWithDuration:.3 animations:^{
            self.viewEdu2.alpha = 0;
        }
         
                         completion:^ (BOOL finished)
         {
             if (finished) {
                 [UIView animateWithDuration:.3 animations:^{
                     self.edu2Height.constant = 0;
                     [self.view layoutIfNeeded];}];
             }
         }];
    }
    if (sender.tag == 2) {
        [self.params setObject:@"1" forKey:@"remove[2]"];
        [UIView animateWithDuration:.3 animations:^{
            self.viewEdu3.alpha = 0;
        }
         
                         completion:^ (BOOL finished)
         {
             if (finished) {
                 [UIView animateWithDuration:.3 animations:^{
                     self.edu3Height.constant = 0;
                     [self.view layoutIfNeeded];}];
             }
         }];
    }
    if (sender.tag == 3) {
        [self.params setObject:@"1" forKey:@"remove[3]"];
        [UIView animateWithDuration:.3 animations:^{
            self.viewEdu4.alpha = 0;
        }
         
                         completion:^ (BOOL finished)
         {
             if (finished) {
                 [UIView animateWithDuration:.3 animations:^{
                     self.edu4Height.constant = 0;
                     [self.view layoutIfNeeded];}];
             }
         }];
    }
    if (sender.tag == 4) {
        [self.params setObject:@"1" forKey:@"remove[4]"];
        [UIView animateWithDuration:.3 animations:^{
            self.viewEdu5.alpha = 0;
        }
         
                         completion:^ (BOOL finished)
         {
             if (finished) {
                 [UIView animateWithDuration:.3 animations:^{
                     self.edu5Height.constant = 0;
                     [self.view layoutIfNeeded];}];
             }
         }];
    }
}
- (IBAction)pressEdit:(UIButton *)sender {
    if (sender.tag == 0)
    {
        ProfileEditStep4ViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileEditAddSchool"];
        [self.navigationController pushViewController:myController animated:TRUE];
        [myController setEduEditCount:@"0"];
    }
    if (sender.tag == 1)
    {
        ProfileEditStep4ViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileEditAddSchool"];
        [self.navigationController pushViewController:myController animated:TRUE];
        [myController setEduEditCount:@"1"];
    }
    if (sender.tag == 2)
    {
        ProfileEditStep4ViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileEditAddSchool"];
        [self.navigationController pushViewController:myController animated:TRUE];
        [myController setEduEditCount:@"2"];
    }
    if (sender.tag == 3)
    {
        ProfileEditStep4ViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileEditAddSchool"];
        [self.navigationController pushViewController:myController animated:TRUE];
        [myController setEduEditCount:@"3"];
    }
    if (sender.tag == 4)
    {
        ProfileEditStep4ViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileEditAddSchool"];
        [self.navigationController pushViewController:myController animated:TRUE];
        [myController setEduEditCount:@"4"];
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
