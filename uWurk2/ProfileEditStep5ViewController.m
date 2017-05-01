//
//  ProfileEditStep5ViewController.m
//  uWurk2
//
//  Created by Avery Bonner on 9/16/15.
//  Copyright (c) 2015 Michael Brown. All rights reserved.
//  Copyright (c) 2017 Jim Bonner. All rights reserved.
//

#import "ProfileEditStep5ViewController.h"
#import "RadioButton.h"
#import "ListSelectorTableViewController.h"

@interface ProfileEditStep5ViewController () <ListSelectorTableViewControllerProtocol>
@property (weak, nonatomic) IBOutlet UIButton *btnIndustry;
@property (weak, nonatomic) IBOutlet UIButton *btnPosition;
@property (weak, nonatomic) IBOutlet RadioButton *btnUnderYear;
@property (weak, nonatomic) IBOutlet RadioButton *btnYear2Year;
@property (weak, nonatomic) IBOutlet RadioButton *btnOver2Year;
@property (weak, nonatomic) IBOutlet UIButton *btnSaveChanges;
@property (weak, nonatomic) IBOutlet UITextField *txtCompany;
@property (weak, nonatomic) IBOutlet RadioButton *btnCurrentJob;
@property (weak, nonatomic) IBOutlet RadioButton *btnPreviousJob;
@property (strong, nonatomic) NSMutableDictionary *params;
@property (weak, nonatomic) NSString *expId;
@property (weak, nonatomic) NSString *noExp;
@property (weak, nonatomic) NSString *company;
@property (weak, nonatomic) NSString *status;
@property (weak, nonatomic) NSString *industry;
@property (weak, nonatomic) NSString *position;
@property (weak, nonatomic) NSString *position2;
@property (weak, nonatomic) NSString *otherPosition;
@property (weak, nonatomic) NSString *jobLength;
@property (weak, nonatomic) NSString *remove;

@end

@implementation ProfileEditStep5ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"\nEmployee Profile Edit Step 5:\n%@",self.appDelegate.user);
    
    self.params = [[NSMutableDictionary alloc] init];
    NSArray *experienceArray = [self.appDelegate.user objectForKey:@"experience"];
    
    if ([self.expEditCount intValue] == 0) {
        [self setupAttributesForIndex:0];
    }

    if ([self.expEditCount intValue] == 1) {
        if([self.mode isEqualToString:@"edit"]) {
            [self setupAttributesForIndex:0];
        } else if([self.mode isEqualToString:@"add"]) {
            [self setupAttributesForIndex:1];
        }
        self.expId = @"exp_id[0]";
        self.noExp = @"has_no_experience[0]";
        self.company = @"company[0]";
        self.status = @"status[0]";
        self.industry = @"industry[0]";
        self.position = @"position[0]";
        self.position2 = @"position2[0]";
        self.otherPosition = @"other_position[0]";
        self.jobLength = @"job_length[0]";
        self.remove = @"remove[0]";
        
        NSDictionary *firstExpItem = [experienceArray objectAtIndex:0];
        [self.params setObject:    [firstExpItem objectForKey:@"id"] forKey:self.expId];
        [self.txtCompany setText:  [firstExpItem objectForKey:@"company"]];
        [self.btnPosition setTitle:[firstExpItem objectForKey:@"position"] forState:UIControlStateNormal];
        [self.btnPosition setTag: [[firstExpItem objectForKey:@"position_id"]integerValue]];
        [self.btnIndustry setTitle:[firstExpItem objectForKey:@"industry"] forState:UIControlStateNormal];
        [self.btnIndustry setTag: [[firstExpItem objectForKey:@"industry_id"]integerValue]];
        if([[firstExpItem objectForKey:@"status"] intValue] == 1) {
            self.btnCurrentJob.selected = TRUE;
        }
        if([[firstExpItem objectForKey:@"status"] intValue] == 2) {
            self.btnPreviousJob.selected = TRUE;
        }
        if([[firstExpItem objectForKey:@"job_length"] intValue] == 1) {
            self.btnUnderYear.selected = TRUE;
        }
        if([[firstExpItem objectForKey:@"job_length"] intValue] == 2) {
            self.btnYear2Year.selected = TRUE;
        }
        if([[firstExpItem objectForKey:@"job_length"] intValue] == 3) {
            self.btnOver2Year.selected = TRUE;
        }
    }
    
    if ([self.expEditCount intValue] == 2) {
        self.expId = @"exp_id[1]";
        self.noExp = @"has_no_experience[1]";
        self.company = @"company[1]";
        self.status = @"status[1]";
        self.industry = @"industry[1]";
        self.position = @"position[1]";
        self.position2 = @"position2[1]";
        self.otherPosition = @"other_position[1]";
        self.jobLength = @"job_length[1]";
        self.remove = @"remove[1]";
        
        NSDictionary *firstExpItem = [experienceArray objectAtIndex:0];
        [self.params setObject:[firstExpItem objectForKey:@"id"] forKey:@"exp_id[0]"];
        [self.params setObject:[firstExpItem objectForKey:@"company"] forKey:@"company[0]"];
        [self.params setObject:[firstExpItem objectForKey:@"status"] forKey:@"status[0]"];
        [self.params setObject:[firstExpItem objectForKey:@"industry_id"] forKey:@"industry[0]"];
        [self.params setObject:[firstExpItem objectForKey:@"position_id"] forKey:@"position[0]"];
        [self.params setObject:[firstExpItem objectForKey:@"job_length"] forKey:@"job_length[0]"];
        [self.params setObject:@"" forKey:@"position2[0]"];
        [self.params setObject:@"" forKey:@"other_position[0]"];
        [self.params setObject:@"0" forKey:@"remove[0]"];
        
        NSDictionary *secondExpItem = [experienceArray objectAtIndex:1];
        [self.params setObject:    [secondExpItem objectForKey:@"id"] forKey:self.expId];
        [self.txtCompany  setText: [secondExpItem objectForKey:@"company"]];
        [self.btnIndustry setTitle:[secondExpItem objectForKey:@"industry"] forState:UIControlStateNormal];
        [self.btnIndustry setTag: [[secondExpItem objectForKey:@"industry_id"]integerValue]];
        [self.btnPosition setTitle:[secondExpItem objectForKey:@"position"] forState:UIControlStateNormal];
        [self.btnPosition setTag: [[secondExpItem objectForKey:@"position_id"]integerValue]];
         if([[secondExpItem objectForKey:@"status"] intValue] == 1) {
            self.btnCurrentJob.selected = TRUE;
        }
        if([[secondExpItem objectForKey:@"status"] intValue] == 2) {
            self.btnPreviousJob.selected = TRUE;
        }
        if([[secondExpItem objectForKey:@"job_length"] intValue] == 1) {
            self.btnUnderYear.selected = TRUE;
        }
        if([[secondExpItem objectForKey:@"job_length"] intValue] == 2) {
            self.btnYear2Year.selected = TRUE;
        }
        if([[secondExpItem objectForKey:@"job_length"] intValue] == 3) {
            self.btnOver2Year.selected = TRUE;
        }
    }
    
    if ([self.expEditCount intValue] == 3) {
        self.expId = @"exp_id[2]";
        self.noExp = @"has_no_experience[2]";
        self.company = @"company[2]";
        self.status = @"status[2]";
        self.industry = @"industry[2]";
        self.position = @"position[2]";
        self.position2 = @"position2[2]";
        self.otherPosition = @"other_position[2]";
        self.jobLength = @"job_length[2]";
        self.remove = @"remove[2]";
        
        NSDictionary *firstExpItem = [experienceArray objectAtIndex:0];
        [self.params setObject:[firstExpItem objectForKey:@"id"] forKey:@"exp_id[0]"];
        [self.params setObject:[firstExpItem objectForKey:@"company"] forKey:@"company[0]"];
        [self.params setObject:[firstExpItem objectForKey:@"status"] forKey:@"status[0]"];
        [self.params setObject:[firstExpItem objectForKey:@"industry_id"] forKey:@"industry[0]"];
        [self.params setObject:[firstExpItem objectForKey:@"position_id"] forKey:@"position[0]"];
        [self.params setObject:[firstExpItem objectForKey:@"job_length"] forKey:@"job_length[0]"];
        [self.params setObject:@"" forKey:@"position2[0]"];
        [self.params setObject:@"" forKey:@"other_position[0]"];
        [self.params setObject:@"0" forKey:@"remove[0]"];
        
        NSDictionary *secondExpItem = [experienceArray objectAtIndex:1];
        [self.params setObject:[secondExpItem objectForKey:@"id"] forKey:@"exp_id[1]"];
        [self.params setObject:[secondExpItem objectForKey:@"company"] forKey:@"company[1]"];
        [self.params setObject:[secondExpItem objectForKey:@"status"] forKey:@"status[1]"];
        [self.params setObject:[secondExpItem objectForKey:@"industry_id"] forKey:@"industry[1]"];
        [self.params setObject:[secondExpItem objectForKey:@"position_id"] forKey:@"position[1]"];
        [self.params setObject:[secondExpItem objectForKey:@"job_length"] forKey:@"job_length[1]"];
        [self.params setObject:@"" forKey:@"position2[1]"];
        [self.params setObject:@"" forKey:@"other_position[1]"];
        [self.params setObject:@"0" forKey:@"remove[1]"];
        
        NSDictionary *thirdExpItem = [experienceArray objectAtIndex:2];
        [self.params      setObject:[thirdExpItem objectForKey:@"id"] forKey:self.expId];
        [self.txtCompany setText:   [thirdExpItem objectForKey:@"company"]];
        [self.btnIndustry setTitle: [thirdExpItem objectForKey:@"industry"] forState:UIControlStateNormal];
        [self.btnIndustry setTag:  [[thirdExpItem objectForKey:@"industry_id"]integerValue]];
        [self.btnPosition setTitle: [thirdExpItem objectForKey:@"position"] forState:UIControlStateNormal];
        [self.btnPosition setTag:  [[thirdExpItem objectForKey:@"position_id"]integerValue]];
        if([[thirdExpItem objectForKey:@"status"] intValue] == 1) {
            self.btnCurrentJob.selected = TRUE;
        }
        if([[thirdExpItem objectForKey:@"status"] intValue] == 2) {
            self.btnPreviousJob.selected = TRUE;
        }
        if([[thirdExpItem objectForKey:@"job_length"] intValue] == 1) {
            self.btnUnderYear.selected = TRUE;
        }
        if([[thirdExpItem objectForKey:@"job_length"] intValue] == 2) {
            self.btnYear2Year.selected = TRUE;
        }
        if([[thirdExpItem objectForKey:@"job_length"] intValue] == 3) {
            self.btnOver2Year.selected = TRUE;
        }
    }
    
    if ([self.expEditCount intValue] == 4) {
        self.expId = @"exp_id[3]";
        self.noExp = @"has_no_experience[3]";
        self.company = @"company[3]";
        self.status = @"status[3]";
        self.industry = @"industry[3]";
        self.position = @"position[3]";
        self.position2 = @"position2[3]";
        self.otherPosition = @"other_position[3]";
        self.jobLength = @"job_length[3]";
        self.remove = @"remove[3]";
        
        NSDictionary *firstExpItem = [experienceArray objectAtIndex:0];
        [self.params setObject:[firstExpItem objectForKey:@"id"] forKey:@"exp_id[0]"];
        [self.params setObject:[firstExpItem objectForKey:@"company"] forKey:@"company[0]"];
        [self.params setObject:[firstExpItem objectForKey:@"status"] forKey:@"status[0]"];
        [self.params setObject:[firstExpItem objectForKey:@"industry_id"] forKey:@"industry[0]"];
        [self.params setObject:[firstExpItem objectForKey:@"position_id"] forKey:@"position[0]"];
        [self.params setObject:@"" forKey:@"position2[0]"];
        [self.params setObject:@"" forKey:@"other_position[0]"];
        [self.params setObject:[firstExpItem objectForKey:@"job_length"] forKey:@"job_length[0]"];
        [self.params setObject:@"0" forKey:@"remove[0]"];
        
        NSDictionary *secondExpItem = [experienceArray objectAtIndex:1];
        [self.params setObject:[secondExpItem objectForKey:@"id"] forKey:@"exp_id[1]"];
        [self.params setObject:[secondExpItem objectForKey:@"company"] forKey:@"company[1]"];
        [self.params setObject:[secondExpItem objectForKey:@"status"] forKey:@"status[1]"];
        [self.params setObject:[secondExpItem objectForKey:@"industry_id"] forKey:@"industry[1]"];
        [self.params setObject:[secondExpItem objectForKey:@"position_id"] forKey:@"position[1]"];
        [self.params setObject:@"" forKey:@"position2[1]"];
        [self.params setObject:@"" forKey:@"other_position[1]"];
        [self.params setObject:[secondExpItem objectForKey:@"job_length"] forKey:@"job_length[1]"];
        [self.params setObject:@"0" forKey:@"remove[1]"];
        
        NSDictionary *thirdExpItem = [experienceArray objectAtIndex:2];
        [self.params setObject:[thirdExpItem objectForKey:@"id"] forKey:@"exp_id[2]"];
        [self.params setObject:[thirdExpItem objectForKey:@"company"] forKey:@"company[2]"];
        [self.params setObject:[thirdExpItem objectForKey:@"status"] forKey:@"status[2]"];
        [self.params setObject:[thirdExpItem objectForKey:@"industry_id"] forKey:@"industry[2]"];
        [self.params setObject:[thirdExpItem objectForKey:@"position_id"] forKey:@"position[2]"];
        [self.params setObject:@"" forKey:@"position2[2]"];
        [self.params setObject:@"" forKey:@"other_position[2]"];
        [self.params setObject:[secondExpItem objectForKey:@"job_length"] forKey:@"job_length[2]"];
        [self.params setObject:@"0" forKey:@"remove[2]"];
        
        NSDictionary *fourthExpItem = [experienceArray objectAtIndex:3];
        [self.params setObject:[fourthExpItem objectForKey:@"id"] forKey:self.expId];
        [self assignValue:[fourthExpItem objectForKey:@"company"] control:self.txtCompany];
        [self.btnPosition setTitle:[fourthExpItem objectForKey:@"position"] forState:UIControlStateNormal];
        [self.btnPosition setTag:[[fourthExpItem objectForKey:@"position_id"]integerValue]];
        [self.btnIndustry setTitle:[fourthExpItem objectForKey:@"industry"] forState:UIControlStateNormal];
        [self.btnIndustry setTag:[[fourthExpItem objectForKey:@"industry_id"]integerValue]];
        if([[fourthExpItem objectForKey:@"status"] intValue] == 1) {
            self.btnCurrentJob.selected = TRUE;
        }
        if([[fourthExpItem objectForKey:@"status"] intValue] == 2) {
            self.btnPreviousJob.selected = TRUE;
        }
        if([[fourthExpItem objectForKey:@"job_length"] intValue] == 1) {
            self.btnUnderYear.selected = TRUE;
        }
        if([[fourthExpItem objectForKey:@"job_length"] intValue] == 2) {
            self.btnYear2Year.selected = TRUE;
        }
        if([[fourthExpItem objectForKey:@"job_length"] intValue] == 3) {
            self.btnOver2Year.selected = TRUE;
        }
    }
    
    if ([self.expEditCount intValue] == 5) {
        self.expId = @"exp_id[4]";
        self.noExp = @"has_no_experience[4]";
        self.company = @"company[4]";
        self.status = @"status[4]";
        self.industry = @"industry[4]";
        self.position = @"position[4]";
        self.position2 = @"position2[4]";
        self.otherPosition = @"other_position[4]";
        self.jobLength = @"job_length[4]";
        self.remove = @"remove[4]";
        
        NSDictionary *firstExpItem = [experienceArray objectAtIndex:0];
        [self.params setObject:[firstExpItem objectForKey:@"id"] forKey:@"exp_id[0]"];
        [self.params setObject:[firstExpItem objectForKey:@"company"] forKey:@"company[0]"];
        [self.params setObject:[firstExpItem objectForKey:@"status"] forKey:@"status[0]"];
        [self.params setObject:[firstExpItem objectForKey:@"industry_id"] forKey:@"industry[0]"];
        [self.params setObject:[firstExpItem objectForKey:@"position_id"] forKey:@"position[0]"];
        [self.params setObject:@"" forKey:@"position2[0]"];
        [self.params setObject:@"" forKey:@"other_position[0]"];
        [self.params setObject:[firstExpItem objectForKey:@"job_length"] forKey:@"job_length[0]"];
        [self.params setObject:@"0" forKey:@"remove[0]"];
        
        NSDictionary *secondExpItem = [experienceArray objectAtIndex:1];
        [self.params setObject:[secondExpItem objectForKey:@"id"] forKey:@"exp_id[1]"];
        [self.params setObject:[secondExpItem objectForKey:@"company"] forKey:@"company[1]"];
        [self.params setObject:[secondExpItem objectForKey:@"status"] forKey:@"status[1]"];
        [self.params setObject:[secondExpItem objectForKey:@"industry_id"] forKey:@"industry[1]"];
        [self.params setObject:[secondExpItem objectForKey:@"position_id"] forKey:@"position[1]"];
        [self.params setObject:@"" forKey:@"position2[1]"];
        [self.params setObject:@"" forKey:@"other_position[1]"];
        [self.params setObject:[secondExpItem objectForKey:@"job_length"] forKey:@"job_length[1]"];
        [self.params setObject:@"0" forKey:@"remove[1]"];
        
        NSDictionary *thirdExpItem = [experienceArray objectAtIndex:2];
        [self.params setObject:[thirdExpItem objectForKey:@"id"] forKey:@"exp_id[2]"];
        [self.params setObject:[thirdExpItem objectForKey:@"company"] forKey:@"company[2]"];
        [self.params setObject:[thirdExpItem objectForKey:@"status"] forKey:@"status[2]"];
        [self.params setObject:[thirdExpItem objectForKey:@"industry_id"] forKey:@"industry[2]"];
        [self.params setObject:[thirdExpItem objectForKey:@"position_id"] forKey:@"position[2]"];
        [self.params setObject:@"" forKey:@"position2[2]"];
        [self.params setObject:@"" forKey:@"other_position[2]"];
        [self.params setObject:[secondExpItem objectForKey:@"job_length"] forKey:@"job_length[2]"];
        [self.params setObject:@"0" forKey:@"remove[2]"];
        
        NSDictionary *fourthExpItem = [experienceArray objectAtIndex:3];
        [self.params setObject:[fourthExpItem objectForKey:@"id"] forKey:@"exp_id[3]"];
        [self.params setObject:[fourthExpItem objectForKey:@"company"] forKey:@"company[3]"];
        [self.params setObject:[fourthExpItem objectForKey:@"status"] forKey:@"status[3]"];
        [self.params setObject:[fourthExpItem objectForKey:@"industry_id"] forKey:@"industry[3]"];
        [self.params setObject:[fourthExpItem objectForKey:@"position_id"] forKey:@"position[3]"];
        [self.params setObject:@"" forKey:@"position2[3]"];
        [self.params setObject:@"" forKey:@"other_position[3]"];
        [self.params setObject:[fourthExpItem objectForKey:@"job_length"] forKey:@"job_length[3]"];
        [self.params setObject:@"0" forKey:@"remove[3]"];
        
        NSDictionary *fifthExpItem = [experienceArray objectAtIndex:4];
        [self.params setObject:    [fifthExpItem objectForKey:@"id"] forKey:self.expId];
        [self.txtCompany   setText:[fifthExpItem objectForKey:@"company"]];
        [self.btnIndustry setTitle:[fifthExpItem objectForKey:@"industry"] forState:UIControlStateNormal];
        [self.btnIndustry setTag: [[fifthExpItem objectForKey:@"industry_id"]integerValue]];
        [self.btnPosition setTitle:[fifthExpItem objectForKey:@"position"] forState:UIControlStateNormal];
        [self.btnPosition setTag: [[fifthExpItem objectForKey:@"position_id"]integerValue]];
        if([[fifthExpItem objectForKey:@"status"] intValue] == 1)
            self.btnCurrentJob.selected = TRUE;
        if([[fifthExpItem objectForKey:@"status"] intValue] == 2)
            self.btnPreviousJob.selected = TRUE;
        if([[fifthExpItem objectForKey:@"job_length"] intValue] == 1)
            self.btnUnderYear.selected = TRUE;
        if([[fifthExpItem objectForKey:@"job_length"] intValue] == 2)
            self.btnYear2Year.selected = TRUE;
        if([[fifthExpItem objectForKey:@"job_length"] intValue] == 3)
            self.btnOver2Year.selected = TRUE;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSArray *experienceArray = [self.appDelegate.user objectForKey:@"experience"];
    
    self.btnSaveChanges.enabled = NO;
    
    if([self.expCount intValue] == 0) {
        if([self.mode isEqualToString:@"add"]) {
            [self setupAttributesForIndex:0];
            [self.params setObject:@"" forKey:self.expId];
        }
    }
    
    if ([self.expCount intValue] == 1) {
        if([self.mode isEqualToString:@"add"]) {
            [self setupAttributesForIndex:1];
            [self.params setObject:@"" forKey:self.expId];
        } else if([self.mode isEqualToString:@"edit"]) {
            [self setupAttributesForIndex:0];
            NSDictionary *firstExpItem = [experienceArray objectAtIndex:0];
            [self.params setObject:[firstExpItem objectForKey:@"id"] forKey:@"exp_id[0]"];
            [self.params setObject:@"0" forKey:@"has_no_experience[0]"];
            [self.params setObject:[firstExpItem objectForKey:@"company"] forKey:@"company[0]"];
            [self.params setObject:[firstExpItem objectForKey:@"status"] forKey:@"status[0]"];
            [self.params setObject:[firstExpItem objectForKey:@"industry_id"] forKey:@"industry[0]"];
            [self.params setObject:[firstExpItem objectForKey:@"position_id"] forKey:@"position[0]"];
            [self.params setObject:[firstExpItem objectForKey:@"job_length"] forKey:@"job_length[0]"];
            [self.params setObject:@"" forKey:@"position2[0]"];
            [self.params setObject:@"" forKey:@"other_position[0]"];
            [self.params setObject:@"0" forKey:@"remove[0]"];
        }
    }
    
    if ([self.expCount intValue] == 2) {
        self.expId = @"exp_id[2]";
        self.noExp = @"has_no_experience[2]";
        self.company = @"company[2]";
        self.status = @"status[2]";
        self.industry = @"industry[2]";
        self.position = @"position[2]";
        self.position2 = @"position2[2]";
        self.otherPosition = @"other_position[2]";
        self.jobLength = @"job_length[2]";
        self.remove = @"remove[2]";
        [self.params setObject:@"" forKey:self.expId];
        
        NSDictionary *firstExpItem = [experienceArray objectAtIndex:0];
        [self.params setObject:[firstExpItem objectForKey:@"id"] forKey:@"exp_id[0]"];
        [self.params setObject:@"0" forKey:@"has_no_experience[0]"];
        [self.params setObject:[firstExpItem objectForKey:@"company"] forKey:@"company[0]"];
        [self.params setObject:[firstExpItem objectForKey:@"status"] forKey:@"status[0]"];
        [self.params setObject:[firstExpItem objectForKey:@"industry_id"] forKey:@"industry[0]"];
        [self.params setObject:[firstExpItem objectForKey:@"position_id"] forKey:@"position[0]"];
        [self.params setObject:[firstExpItem objectForKey:@"job_length"] forKey:@"job_length[0]"];
        [self.params setObject:@"" forKey:@"position2[0]"];
        [self.params setObject:@"" forKey:@"other_position[0]"];
        [self.params setObject:@"0" forKey:@"remove[0]"];
        
        NSDictionary *secondExpItem = [experienceArray objectAtIndex:1];
        [self.params setObject:[secondExpItem objectForKey:@"id"] forKey:@"exp_id[1]"];
        [self.params setObject:@"0" forKey:@"has_no_experience[1]"];
        [self.params setObject:[secondExpItem objectForKey:@"company"] forKey:@"company[1]"];
        [self.params setObject:[secondExpItem objectForKey:@"status"] forKey:@"status[1]"];
        [self.params setObject:[secondExpItem objectForKey:@"industry_id"] forKey:@"industry[1]"];
        [self.params setObject:[secondExpItem objectForKey:@"position_id"] forKey:@"position[1]"];
        [self.params setObject:[secondExpItem objectForKey:@"job_length"] forKey:@"job_length[1]"];
        [self.params setObject:@"" forKey:@"position2[1]"];
        [self.params setObject:@"" forKey:@"other_position[1]"];
        [self.params setObject:@"0" forKey:@"remove[1]"];
    }
    
    if ([self.expCount intValue] == 3) {
        self.expId = @"exp_id[3]";
        self.noExp = @"has_no_experience[3]";
        self.company = @"company[3]";
        self.status = @"status[3]";
        self.industry = @"industry[3]";
        self.position = @"position[3]";
        self.position2 = @"position2[3]";
        self.otherPosition = @"other_position[3]";
        self.jobLength = @"job_length[3]";
        self.remove = @"remove[3]";
        [self.params setObject:@"" forKey:self.expId];
        
        NSDictionary *firstExpItem = [experienceArray objectAtIndex:0];
        [self.params setObject:[firstExpItem objectForKey:@"id"] forKey:@"exp_id[0]"];
        [self.params setObject:@"0" forKey:@"has_no_experience[0]"];
        [self.params setObject:[firstExpItem objectForKey:@"company"] forKey:@"company[0]"];
        [self.params setObject:[firstExpItem objectForKey:@"status"] forKey:@"status[0]"];
        [self.params setObject:[firstExpItem objectForKey:@"industry_id"] forKey:@"industry[0]"];
        [self.params setObject:[firstExpItem objectForKey:@"position_id"] forKey:@"position[0]"];
        [self.params setObject:[firstExpItem objectForKey:@"job_length"] forKey:@"job_length[0]"];
        [self.params setObject:@"" forKey:@"position2[0]"];
        [self.params setObject:@"" forKey:@"other_position[0]"];
        [self.params setObject:@"0" forKey:@"remove[0]"];
        
        NSDictionary *secondExpItem = [experienceArray objectAtIndex:1];
        [self.params setObject:[secondExpItem objectForKey:@"id"] forKey:@"exp_id[1]"];
        [self.params setObject:@"0" forKey:@"has_no_experience[1]"];
        [self.params setObject:[secondExpItem objectForKey:@"company"] forKey:@"company[1]"];
        [self.params setObject:[secondExpItem objectForKey:@"status"] forKey:@"status[1]"];
        [self.params setObject:[secondExpItem objectForKey:@"industry_id"] forKey:@"industry[1]"];
        [self.params setObject:[secondExpItem objectForKey:@"position_id"] forKey:@"position[1]"];
        [self.params setObject:[secondExpItem objectForKey:@"job_length"] forKey:@"job_length[1]"];
        [self.params setObject:@"" forKey:@"position2[1]"];
        [self.params setObject:@"" forKey:@"other_position[1]"];
        [self.params setObject:@"0" forKey:@"remove[1]"];
        
        NSDictionary *thirdExpItem = [experienceArray objectAtIndex:2];
        [self.params setObject:[thirdExpItem objectForKey:@"id"] forKey:@"exp_id[2]"];
        [self.params setObject:@"0" forKey:@"has_no_experience[2]"];
        [self.params setObject:[thirdExpItem objectForKey:@"company"] forKey:@"company[2]"];
        [self.params setObject:[thirdExpItem objectForKey:@"status"] forKey:@"status[2]"];
        [self.params setObject:[thirdExpItem objectForKey:@"industry_id"] forKey:@"industry[2]"];
        [self.params setObject:[thirdExpItem objectForKey:@"position_id"] forKey:@"position[2]"];
        [self.params setObject:[thirdExpItem objectForKey:@"job_length"] forKey:@"job_length[2]"];
        [self.params setObject:@"" forKey:@"position2[2]"];
        [self.params setObject:@"" forKey:@"other_position[2]"];
        [self.params setObject:@"0" forKey:@"remove[2]"];
    }
    
    if ([self.expCount intValue] == 4) {
        self.expId = @"exp_id[4]";
        self.noExp = @"has_no_experience[4]";
        self.company = @"company[4]";
        self.status = @"status[4]";
        self.industry = @"industry[4]";
        self.position = @"position[4]";
        self.position2 = @"position2[4]";
        self.otherPosition = @"other_position[4]";
        self.jobLength = @"job_length[4]";
        self.remove = @"remove[4]";
        [self.params setObject:@"" forKey:self.expId];
        
        NSDictionary *firstExpItem = [experienceArray objectAtIndex:0];
        [self.params setObject:[firstExpItem objectForKey:@"id"] forKey:@"exp_id[0]"];
        [self.params setObject:@"0" forKey:@"has_no_experience[0]"];
        [self.params setObject:[firstExpItem objectForKey:@"company"] forKey:@"company[0]"];
        [self.params setObject:[firstExpItem objectForKey:@"status"] forKey:@"status[0]"];
        [self.params setObject:[firstExpItem objectForKey:@"industry_id"] forKey:@"industry[0]"];
        [self.params setObject:[firstExpItem objectForKey:@"position_id"] forKey:@"position[0]"];
        [self.params setObject:[firstExpItem objectForKey:@"job_length"] forKey:@"job_length[0]"];
        [self.params setObject:@"" forKey:@"position2[0]"];
        [self.params setObject:@"" forKey:@"other_position[0]"];
        [self.params setObject:@"0" forKey:@"remove[0]"];
        
        NSDictionary *secondExpItem = [experienceArray objectAtIndex:1];
        [self.params setObject:[secondExpItem objectForKey:@"id"] forKey:@"exp_id[1]"];
        [self.params setObject:@"0" forKey:@"has_no_experience[1]"];
        [self.params setObject:[secondExpItem objectForKey:@"company"] forKey:@"company[1]"];
        [self.params setObject:[secondExpItem objectForKey:@"status"] forKey:@"status[1]"];
        [self.params setObject:[secondExpItem objectForKey:@"industry_id"] forKey:@"industry[1]"];
        [self.params setObject:[secondExpItem objectForKey:@"position_id"] forKey:@"position[1]"];
        [self.params setObject:[secondExpItem objectForKey:@"job_length"] forKey:@"job_length[1]"];
        [self.params setObject:@"" forKey:@"position2[1]"];
        [self.params setObject:@"" forKey:@"other_position[1]"];
        [self.params setObject:@"0" forKey:@"remove[1]"];
        
        NSDictionary *thirdExpItem = [experienceArray objectAtIndex:2];
        [self.params setObject:[thirdExpItem objectForKey:@"id"] forKey:@"exp_id[2]"];
        [self.params setObject:@"0" forKey:@"has_no_experience[2]"];
        [self.params setObject:[thirdExpItem objectForKey:@"company"] forKey:@"company[2]"];
        [self.params setObject:[thirdExpItem objectForKey:@"status"] forKey:@"status[2]"];
        [self.params setObject:[thirdExpItem objectForKey:@"industry_id"] forKey:@"industry[2]"];
        [self.params setObject:[thirdExpItem objectForKey:@"position_id"] forKey:@"position[2]"];
        [self.params setObject:[thirdExpItem objectForKey:@"job_length"] forKey:@"job_length[2]"];
        [self.params setObject:@"" forKey:@"position2[2]"];
        [self.params setObject:@"" forKey:@"other_position[2]"];
        [self.params setObject:@"0" forKey:@"remove[2]"];
        
        NSDictionary *fourthExpItem = [experienceArray objectAtIndex:3];
        [self.params setObject:[fourthExpItem objectForKey:@"id"] forKey:@"exp_id[3]"];
        [self.params setObject:@"0" forKey:@"has_no_experience[3]"];
        [self.params setObject:[fourthExpItem objectForKey:@"company"] forKey:@"company[3]"];
        [self.params setObject:[fourthExpItem objectForKey:@"status"] forKey:@"status[3]"];
        [self.params setObject:[fourthExpItem objectForKey:@"industry_id"] forKey:@"industry[3]"];
        [self.params setObject:[fourthExpItem objectForKey:@"position_id"] forKey:@"position[3]"];
        [self.params setObject:[fourthExpItem objectForKey:@"job_length"] forKey:@"job_length[3]"];
        [self.params setObject:@"" forKey:@"position2[3]"];
        [self.params setObject:@"" forKey:@"other_position[3]"];
        [self.params setObject:@"0" forKey:@"remove[3]"];
    }
}

-(void) SelectionMade
{
    self.btnSaveChanges.enabled = YES;
}

-(IBAction)changeValue:(id)sender
{
    self.btnSaveChanges.enabled = YES;
}
- (IBAction)industryPress:(id)sender
{
    ListSelectorTableViewController *myController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ListSelector"];
    
    [myController setParameters:nil];
    [myController setUrl:@"http://uwurk.tscserver.com/api/v1/industries"];
    [myController setDisplay:@"description"];
    [myController setKey:@"id"];
    [myController setDelegate:self];
    [myController setJsonGroup:@"industries"];
    [myController setSender:self.btnIndustry];
    [myController setTitle:@"Industries"];
    [myController setPassThru:@"industries"];
    
    [self.navigationController pushViewController:myController animated:TRUE];
    
}
- (IBAction)positionPress:(id)sender
{
    ListSelectorTableViewController *myController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ListSelector"];
    
    [myController setParameters:@{@"industry_id":[self.btnIndustry titleForState:UIControlStateSelected]}];
    [myController setUrl:@"http://uwurk.tscserver.com/api/v1/positions"];
    [myController setDisplay:@"description"];
    [myController setKey:@"id"];
    [myController setDelegate:self];
    [myController setJsonGroup:@"positions"];
    [myController setSender:self.btnPosition];
    [myController setTitle:@"Positions"];
    [myController setPassThru:@"positions"];
    
    [self.navigationController pushViewController:myController animated:TRUE];
    
}

- (IBAction)nextPress:(id)sender
{
    if([[self.params objectForKey:self.expId] isEqualToString:@""]) {
        [self.params setObject:@"0" forKey:self.noExp];
        [self.params setObject:self.txtCompany.text forKey:self.company];
        [self.params setObject:[@(self.btnPosition.tag)stringValue] forKey:self.position];
        [self.params setObject:@"" forKey:self.position2];
        [self.params setObject:@"" forKey:self.otherPosition];
        [self.params setObject:@"0" forKey:self.remove];
        [self.params setObject:[@(self.btnIndustry.tag)stringValue] forKey:self.industry];
        if(self.btnUnderYear.isSelected) {
            [self.params setObject:@"1" forKey:self.jobLength];
        }
        if(self.btnYear2Year.isSelected) {
            [self.params setObject:@"2" forKey:self.jobLength];
        }
        if(self.btnOver2Year.isSelected) {
            [self.params setObject:@"3" forKey:self.jobLength];
        }
        if (self.btnCurrentJob.isSelected) {
            [self.params setObject:@"1" forKey:self.status];
        }
        if (self.btnPreviousJob.isSelected) {
            [self.params setObject:@"2" forKey:self.status];
        }
    }
    NSMutableString *Error = [[NSMutableString alloc] init];
    [Error appendString:@"To continue, complete the missing information:"];
    if (self.txtCompany.text.length == 0) {
        [Error appendString:@"\n\nCompany Name"];
    }
    if (self.btnCurrentJob.selected == NO && self.btnPreviousJob.selected == NO) {
        [Error appendString:@"\n\nJob Type"];
    }
    if ([[self.btnIndustry titleForState:UIControlStateNormal]isEqualToString:@"Select Industry"]) {
        [Error appendString:@"\n\nSelect Industry"];
    }
    if ([[self.btnPosition titleForState:UIControlStateNormal]isEqualToString:@"Select Position"]) {
        [Error appendString:@"\n\nSelect Position"];
    }
    if (self.btnUnderYear.selected == NO && self.btnYear2Year.selected == NO && self.btnOver2Year.selected == NO) {
        [Error appendString:@"\n\nJob Length"];
    }
    if ((Error.length) > 50) {
        [self handleErrorWithMessage:Error];
    } else {
        if([self.params count]){
            AFHTTPRequestOperationManager *manager = [self getManager];
            [manager POST:@"http://uwurk.tscserver.com/api/v1/profile" parameters:self.params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"\nProfile Edit Step 5 - Json Response:\n%@", responseObject);
                if([self validateResponse:responseObject]){
                     UIViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileEditExperienceList"];
                    [self.navigationController setViewControllers:@[myController] animated:YES];
                } else {
                    [self handleErrorJsonResponse:@"ProfileEditStep5"];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                [self handleServerErrorUnableToContact];
            }];
        }
        else{
            UIViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileEditExperienceList"];
            [self.navigationController setViewControllers:@[myController] animated:YES];
        }
    }
}

- (void)setupAttributesForIndex:(NSInteger)index
{
    NSString *postFix = [NSString stringWithFormat:@"[%ld]",index];
    self.expId = [NSString stringWithFormat:@"exp_id%@",postFix];
    self.noExp = [NSString stringWithFormat:@"has_no_experience%@",postFix];
    self.company = [NSString stringWithFormat:@"company%@",postFix];
    self.status = [NSString stringWithFormat:@"status%@",postFix];
    self.industry = [NSString stringWithFormat:@"industry%@",postFix];
    self.position = [NSString stringWithFormat:@"position%@",postFix];
    self.position2 = [NSString stringWithFormat:@"position2%@",postFix];
    self.otherPosition = [NSString stringWithFormat:@"other_position%@",postFix];
    self.jobLength = [NSString stringWithFormat:@"job_length%@",postFix];
    self.remove = [NSString stringWithFormat:@"remove%@",postFix];
}

- (void)SelectionMade:(NSString *)passThru withDict:(NSDictionary *)dict displayString:(NSString *)displayString;
{
    
}

@end
