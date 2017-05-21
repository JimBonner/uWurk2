//
//  ProfileEditStep4ViewController.m
//  uWurk2
//
//  Created by Avery Bonner on 9/16/15.
//  Copyright (c) 2015 Michael Brown. All rights reserved.
//  Copyright (c) 2017 Jim Bonner. All rights reserved.
//

#import "ProfileEditStep4ViewController.h"
#import "RadioButton.h"
#import "ListSelectorTableViewController.h"
#import "ListSelectorStringsTableViewController.h"
#import "ProfileEditEducationViewController.h"

@interface ProfileEditStep4ViewController () <ListSelectorStringsTableViewControllerProtocol, ListSelectorTableViewControllerProtocol>
@property (weak, nonatomic) IBOutlet RadioButton *btnHighSchool;
@property (weak, nonatomic) IBOutlet RadioButton *btnCollege;
@property (weak, nonatomic) IBOutlet RadioButton *btnTradeSchool;
@property (weak, nonatomic) IBOutlet RadioButton *btnGED;
@property (weak, nonatomic) IBOutlet UIButton *btnState;
@property (weak, nonatomic) IBOutlet UIButton *btnCity;
@property (weak, nonatomic) IBOutlet UIButton *btnSchool;
@property (weak, nonatomic) IBOutlet RadioButton *btnEnrolled;
@property (weak, nonatomic) IBOutlet RadioButton *btnGraduated;
@property (weak, nonatomic) IBOutlet RadioButton *btnAttended;
@property (weak, nonatomic) IBOutlet UIView *viewSchool;
@property (weak, nonatomic) IBOutlet UIView *viewCurrent;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cnstrntStatusHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cnstrntSchoolHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cnstrntCityHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightAttended;
@property (weak, nonatomic) IBOutlet UIView *viewAttended;
@property (weak, nonatomic) IBOutlet UIButton *btnSaveChanges;
@property (strong, nonatomic) NSMutableDictionary *params;
@property (strong, nonatomic) NSString *eduId;
@property (strong, nonatomic) NSString *schoolLevel;
@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSString *otherLocation;
@property (strong, nonatomic) NSString *town;
@property (strong, nonatomic) NSString *school;
@property (strong, nonatomic) NSString *otherSchool;
@property (strong, nonatomic) NSString *remove;

@property BOOL performInit;

@end

@implementation ProfileEditStep4ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.performInit = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if(!self.performInit) {
        [self refreshData];
    }
    self.performInit = NO;
}

- (void)refreshData
{
    self.performInit = NO;
    
    NSLog(@"\nEmployee Profile Edit Step 4:\n%@",self.appDelegate.user);
    
    self.params = [[NSMutableDictionary alloc] init];
    NSArray *eduArray = [self.appDelegate.user objectForKey:@"education"];
    if ([self.eduEditCount intValue] == 0) {
        [self setupAttributesForIndex:0];
        [self.params setObject:@"" forKey:self.eduId];
    }
    if([self.eduEditCount intValue] == 1) {
        if([self.mode isEqualToString:@"add"]) {
            [self setupAttributesForIndex:1];
            [self.params setObject:@"" forKey:self.eduId];
        } else if([self.mode isEqualToString:@"edit"]) {
            [self setupAttributesForIndex:0];
            NSDictionary *firstEduItem = [eduArray objectAtIndex:0];
            [self.params setObject:[firstEduItem objectForKey:@"id"] forKey:self.eduId];
            if([[firstEduItem objectForKey:@"type"] isEqualToString:@"high_school"]) {
                self.btnHighSchool.selected = TRUE;
            }
            if([[firstEduItem objectForKey:@"type"] isEqualToString:@"college"]) {
                self.btnCity.alpha = 0;
                self.cnstrntCityHeight.constant = 0;
                self.btnCollege.selected = TRUE;
            }
            if([[firstEduItem objectForKey:@"type"] isEqualToString:@"trade_school"]) {
                self.btnCity.alpha = 0;
                self.cnstrntCityHeight.constant = 0;
                self.btnTradeSchool.selected = TRUE;
            }
            if([[firstEduItem objectForKey:@"type"] isEqualToString:@"GED"]) {
                self.cnstrntSchoolHeight.constant = 0;
                self.viewSchool.alpha = 0;
                self.heightAttended.constant = 0;
                self.viewAttended.alpha = 0;
                [self.btnGraduated setTitle:@"Completed GED" forState:UIControlStateNormal];
                self.btnGED.selected = TRUE;
            } else {
                [self.btnSchool setTitle:[firstEduItem objectForKey:@"school"] forState:UIControlStateNormal];
                [self.btnSchool setTag: [[firstEduItem objectForKey:@"school_id"]integerValue]];
                [self.btnState setTitle: [firstEduItem objectForKey:@"state"] forState:UIControlStateNormal];
                [self.btnState setTag:  [[firstEduItem objectForKey:@"state_id"]integerValue]];
                [self.btnCity setTitle:  [firstEduItem objectForKey:@"city"] forState:UIControlStateNormal];
            }
            if([[firstEduItem objectForKey:@"school_status_id"] intValue] == 1) {
                self.btnEnrolled.selected = TRUE;
            } else if([[firstEduItem objectForKey:@"school_status_id"] intValue] == 2) {
                self.btnGraduated.selected = TRUE;
            } else if([[firstEduItem objectForKey:@"school_status_id"] intValue] == 3) {
                self.btnAttended.selected = TRUE;
            }
        }
    }
    if ([self.eduEditCount intValue] == 2) {
        NSDictionary *firstEduItem = [eduArray objectAtIndex:0];
        [self.params setObject:[firstEduItem objectForKey:@"id"] forKey:@"edu_id[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"type"] forKey:@"school_level[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"school_status_id"] forKey:@"status[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"state_id"] forKey:@"state[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"other_location"] forKey:@"other_location[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"city"] forKey:@"town[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"school_id"] forKey:@"school[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"other_school"] forKey:@"other_school[0]"];
        [self.params setObject:@"0" forKey:@"remove[0]"];
        if([self.mode isEqualToString:@"add"]) {
            NSDictionary *secondEduItem = [eduArray objectAtIndex:1];
            [self.params setObject:[secondEduItem objectForKey:@"id"] forKey:@"edu_id[1]"];
            [self.params setObject:[secondEduItem objectForKey:@"type"] forKey:@"school_level[1]"];
            [self.params setObject:[secondEduItem objectForKey:@"school_status_id"] forKey:@"status[1]"];
            [self.params setObject:[secondEduItem objectForKey:@"state_id"] forKey:@"state[1]"];
            [self.params setObject:[secondEduItem objectForKey:@"other_location"] forKey:@"other_location[1]"];
            [self.params setObject:[secondEduItem objectForKey:@"city"] forKey:@"town[1]"];
            [self.params setObject:[secondEduItem objectForKey:@"school_id"] forKey:@"school[1]"];
            [self.params setObject:[secondEduItem objectForKey:@"other_school"] forKey:@"other_school[1]"];
            [self.params setObject:@"0" forKey:@"remove[1]"];
            [self setupAttributesForIndex:2];
            [self.params setObject:@"" forKey:self.eduId];
        } else if([self.mode isEqualToString:@"edit"]) {
            [self setupAttributesForIndex:1];
            NSDictionary *secondEduItem = [eduArray objectAtIndex:1];
            [self.params setObject:[secondEduItem objectForKey:@"id"] forKey:self.eduId];
            if([[secondEduItem objectForKey:@"type"] isEqualToString:@"high_school"])
                self.btnHighSchool.selected = TRUE;
            if([[secondEduItem objectForKey:@"type"] isEqualToString:@"college"])
            {
                self.btnCity.alpha = 0;
                self.cnstrntCityHeight.constant = 0;
                self.btnCollege.selected = TRUE;
            }
            if([[secondEduItem objectForKey:@"type"] isEqualToString:@"trade_school"])
            {
                self.btnCity.alpha = 0;
                self.cnstrntCityHeight.constant = 0;
                self.btnTradeSchool.selected = TRUE;
            }
            if([[secondEduItem objectForKey:@"type"] isEqualToString:@"GED"])
            {
                self.cnstrntSchoolHeight.constant = 0;
                self.viewSchool.alpha = 0;
                self.heightAttended.constant = 0;
                self.viewAttended.alpha = 0;
                [self.btnGraduated setTitle:@"Completed GED" forState:UIControlStateNormal];
                self.btnGED.selected = TRUE;
            } else {
                [self.btnSchool setTitle:[secondEduItem objectForKey:@"school"] forState:UIControlStateNormal];
                [self.btnSchool setTag: [[secondEduItem objectForKey:@"school_id"]integerValue]];
                [self.btnState  setTitle:[secondEduItem objectForKey:@"state"] forState:UIControlStateNormal];
                [self.btnState  setTag: [[secondEduItem objectForKey:@"state_id"]integerValue]];
                [self.btnCity   setTitle:[secondEduItem objectForKey:@"city"] forState:UIControlStateNormal];
            }
            if([[secondEduItem objectForKey:@"school_status_id"] intValue] == 1) {
                self.btnEnrolled.selected = TRUE;
            }
            else if([[secondEduItem objectForKey:@"school_status_id"] intValue] == 2) {
                self.btnGraduated.selected = TRUE;
            }
            else if([[secondEduItem objectForKey:@"school_status_id"] intValue] == 3) {
                self.btnAttended.selected = TRUE;
            }
        }
    }
    if ([self.eduEditCount intValue] == 3) {
        NSDictionary *firstEduItem = [eduArray objectAtIndex:0];
        [self.params setObject:[firstEduItem objectForKey:@"id"] forKey:@"edu_id[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"type"] forKey:@"school_level[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"school_status_id"] forKey:@"status[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"state_id"] forKey:@"state[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"other_location"] forKey:@"other_location[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"city"] forKey:@"town[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"school_id"] forKey:@"school[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"other_school"] forKey:@"other_school[0]"];
        [self.params setObject:@"0" forKey:@"remove[0]"];
        NSDictionary *secondEduItem = [eduArray objectAtIndex:1];
        [self.params setObject:[secondEduItem objectForKey:@"id"] forKey:@"edu_id[1]"];
        [self.params setObject:[secondEduItem objectForKey:@"type"] forKey:@"school_level[1]"];
        [self.params setObject:[secondEduItem objectForKey:@"school_status_id"] forKey:@"status[1]"];
        [self.params setObject:[secondEduItem objectForKey:@"state_id"] forKey:@"state[1]"];
        [self.params setObject:[secondEduItem objectForKey:@"other_location"] forKey:@"other_location[1]"];
        [self.params setObject:[secondEduItem objectForKey:@"city"] forKey:@"town[1]"];
        [self.params setObject:[secondEduItem objectForKey:@"school_id"] forKey:@"school[1]"];
        [self.params setObject:[secondEduItem objectForKey:@"other_school"] forKey:@"other_school[1]"];
        [self.params setObject:@"0" forKey:@"remove[1]"];
        if([self.mode isEqualToString:@"add"]) {
            NSDictionary *thirdEduItem = [eduArray objectAtIndex:2];
            [self.params setObject:[thirdEduItem objectForKey:@"id"] forKey:@"edu_id[2]"];
            [self.params setObject:[thirdEduItem objectForKey:@"type"] forKey:@"school_level[2]"];
            [self.params setObject:[thirdEduItem objectForKey:@"school_status_id"] forKey:@"status[2]"];
            [self.params setObject:[thirdEduItem objectForKey:@"state_id"] forKey:@"state[2]"];
            [self.params setObject:[thirdEduItem objectForKey:@"other_location"] forKey:@"other_location[2]"];
            [self.params setObject:[thirdEduItem objectForKey:@"city"] forKey:@"town[2]"];
            [self.params setObject:[thirdEduItem objectForKey:@"school_id"] forKey:@"school[2]"];
            [self.params setObject:[thirdEduItem objectForKey:@"other_school"] forKey:@"other_school[2]"];
            [self.params setObject:@"0" forKey:@"remove[2]"];
            [self setupAttributesForIndex:3];
            [self.params setObject:@"" forKey:self.eduId];
        } else if([self.mode isEqualToString:@"edit"]) {
            [self setupAttributesForIndex:2];
            NSDictionary *secondEduItem = [eduArray objectAtIndex:2];
            [self.params setObject:[secondEduItem objectForKey:@"id"] forKey:self.eduId];
            if([[secondEduItem objectForKey:@"type"] isEqualToString:@"high_school"])
                self.btnHighSchool.selected = TRUE;
            if([[secondEduItem objectForKey:@"type"] isEqualToString:@"college"])
            {
                self.btnCity.alpha = 0;
                self.cnstrntCityHeight.constant = 0;
                self.btnCollege.selected = TRUE;
            }
            if([[secondEduItem objectForKey:@"type"] isEqualToString:@"trade_school"])
            {
                self.btnCity.alpha = 0;
                self.cnstrntCityHeight.constant = 0;
                self.btnTradeSchool.selected = TRUE;
            }
            if([[secondEduItem objectForKey:@"type"] isEqualToString:@"GED"])
            {
                self.cnstrntSchoolHeight.constant = 0;
                self.viewSchool.alpha = 0;
                self.heightAttended.constant = 0;
                self.viewAttended.alpha = 0;
                [self.btnGraduated setTitle:@"Completed GED" forState:UIControlStateNormal];
                self.btnGED.selected = TRUE;
            } else {
                [self.btnSchool setTitle:[secondEduItem objectForKey:@"school"] forState:UIControlStateNormal];
                [self.btnSchool setTag: [[secondEduItem objectForKey:@"school_id"]integerValue]];
                [self.btnState  setTitle:[secondEduItem objectForKey:@"state"] forState:UIControlStateNormal];
                [self.btnState  setTag: [[secondEduItem objectForKey:@"state_id"]integerValue]];
                [self.btnCity  setTitle: [secondEduItem objectForKey:@"city"] forState:UIControlStateNormal];
            }
            if([[secondEduItem objectForKey:@"school_status_id"] intValue] == 1) {
                self.btnEnrolled.selected = TRUE;
            } else if([[secondEduItem objectForKey:@"school_status_id"] intValue] == 2) {
                self.btnGraduated.selected = TRUE;
            } else if([[secondEduItem objectForKey:@"school_status_id"] intValue] == 3) {
                self.btnAttended.selected = TRUE;
            }
        }
    }
    if ([self.eduEditCount intValue] == 4) {
        NSDictionary *firstEduItem = [eduArray objectAtIndex:0];
        [self.params setObject:[firstEduItem objectForKey:@"id"] forKey:@"edu_id[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"type"] forKey:@"school_level[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"school_status_id"] forKey:@"status[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"state_id"] forKey:@"state[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"other_location"] forKey:@"other_location[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"city"] forKey:@"town[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"school_id"] forKey:@"school[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"other_school"] forKey:@"other_school[0]"];
        [self.params setObject:@"0" forKey:@"remove[0]"];
        NSDictionary *secondEduItem = [eduArray objectAtIndex:1];
        [self.params setObject:[secondEduItem objectForKey:@"id"] forKey:@"edu_id[1]"];
        [self.params setObject:[secondEduItem objectForKey:@"type"] forKey:@"school_level[1]"];
        [self.params setObject:[secondEduItem objectForKey:@"school_status_id"] forKey:@"status[1]"];
        [self.params setObject:[secondEduItem objectForKey:@"state_id"] forKey:@"state[1]"];
        [self.params setObject:[secondEduItem objectForKey:@"other_location"] forKey:@"other_location[1]"];
        [self.params setObject:[secondEduItem objectForKey:@"city"] forKey:@"town[1]"];
        [self.params setObject:[secondEduItem objectForKey:@"school_id"] forKey:@"school[1]"];
        [self.params setObject:[secondEduItem objectForKey:@"other_school"] forKey:@"other_school[1]"];
        [self.params setObject:@"0" forKey:@"remove[1]"];
        NSDictionary *thirdEduItem = [eduArray objectAtIndex:2];
        [self.params setObject:[thirdEduItem objectForKey:@"id"] forKey:@"edu_id[2]"];
        [self.params setObject:[thirdEduItem objectForKey:@"type"] forKey:@"school_level[2]"];
        [self.params setObject:[thirdEduItem objectForKey:@"school_status_id"] forKey:@"status[2]"];
        [self.params setObject:[thirdEduItem objectForKey:@"state_id"] forKey:@"state[2]"];
        [self.params setObject:[thirdEduItem objectForKey:@"other_location"] forKey:@"other_location[2]"];
        [self.params setObject:[thirdEduItem objectForKey:@"city"] forKey:@"town[2]"];
        [self.params setObject:[thirdEduItem objectForKey:@"school_id"] forKey:@"school[2]"];
        [self.params setObject:[thirdEduItem objectForKey:@"other_school"] forKey:@"other_school[2]"];
        [self.params setObject:@"0" forKey:@"remove[2]"];
        if([self.mode isEqualToString:@"add"]) {
            NSDictionary *fourthEduItem = [eduArray objectAtIndex:3];
            [self.params setObject:[fourthEduItem objectForKey:@"id"] forKey:@"edu_id[3]"];
            [self.params setObject:[fourthEduItem objectForKey:@"type"] forKey:@"school_level[3]"];
            [self.params setObject:[fourthEduItem objectForKey:@"school_status_id"] forKey:@"status[3]"];
            [self.params setObject:[fourthEduItem objectForKey:@"state_id"] forKey:@"state[3]"];
            [self.params setObject:[fourthEduItem objectForKey:@"other_location"] forKey:@"other_location[3]"];
            [self.params setObject:[fourthEduItem objectForKey:@"city"] forKey:@"town[3]"];
            [self.params setObject:[fourthEduItem objectForKey:@"school_id"] forKey:@"school[3]"];
            [self.params setObject:[fourthEduItem objectForKey:@"other_school"] forKey:@"other_school[3]"];
            [self.params setObject:@"0" forKey:@"remove[3]"];
            [self setupAttributesForIndex:4];
            [self.params setObject:@"" forKey:self.eduId];
        } else if([self.mode isEqualToString:@"edit"]) {
            [self setupAttributesForIndex:3];
            NSDictionary *forthEduItem = [eduArray objectAtIndex:3];
            [self.params setObject:[forthEduItem objectForKey:@"id"] forKey:self.eduId];
            if([[forthEduItem objectForKey:@"type"] isEqualToString:@"high_school"]) {
                self.btnHighSchool.selected = TRUE;
                if([[forthEduItem objectForKey:@"type"] isEqualToString:@"college"]) {
                    self.btnCity.alpha = 0;
                    self.cnstrntCityHeight.constant = 0;
                    self.btnCollege.selected = TRUE;
                }
                if([[forthEduItem objectForKey:@"type"] isEqualToString:@"trade_school"]) {
                    self.btnCity.alpha = 0;
                    self.cnstrntCityHeight.constant = 0;
                    self.btnTradeSchool.selected = TRUE;
                }
                if([[forthEduItem objectForKey:@"type"] isEqualToString:@"GED"]) {
                    self.cnstrntSchoolHeight.constant = 0;
                    self.viewSchool.alpha = 0;
                    self.heightAttended.constant = 0;
                    self.viewAttended.alpha = 0;
                    [self.btnGraduated setTitle:@"Completed GED" forState:UIControlStateNormal];
                    self.btnGED.selected = TRUE;
                } else {
                    [self.btnSchool setTitle:[forthEduItem objectForKey:@"school"] forState:UIControlStateNormal];
                    [self.btnSchool setTag: [[forthEduItem objectForKey:@"school_id"]integerValue]];
                    [self.btnState  setTitle:[forthEduItem objectForKey:@"state"] forState:UIControlStateNormal];
                    [self.btnState  setTag: [[forthEduItem objectForKey:@"state_id"]integerValue]];
                    [self.btnCity   setTitle:[forthEduItem objectForKey:@"city"] forState:UIControlStateNormal];
                }
                if([[forthEduItem objectForKey:@"school_status_id"] intValue] == 1) {
                    self.btnEnrolled.selected = TRUE;
                } else if([[forthEduItem objectForKey:@"school_status_id"] intValue] == 2) {
                    self.btnGraduated.selected = TRUE;
                } else if([[forthEduItem objectForKey:@"school_status_id"] intValue] == 3) {
                    self.btnAttended.selected = TRUE;
                }
            }
        }
    }
    if ([self.eduEditCount intValue] == 5) {
        NSDictionary *firstEduItem = [eduArray objectAtIndex:0];
        [self.params setObject:[firstEduItem objectForKey:@"id"] forKey:@"edu_id[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"type"] forKey:@"school_level[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"school_status_id"] forKey:@"status[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"state_id"] forKey:@"state[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"other_location"] forKey:@"other_location[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"city"] forKey:@"town[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"school_id"] forKey:@"school[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"other_school"] forKey:@"other_school[0]"];
        [self.params setObject:@"0" forKey:@"remove[0]"];
        NSDictionary *secondEduItem = [eduArray objectAtIndex:1];
        [self.params setObject:[secondEduItem objectForKey:@"id"] forKey:@"edu_id[1]"];
        [self.params setObject:[secondEduItem objectForKey:@"type"] forKey:@"school_level[1]"];
        [self.params setObject:[secondEduItem objectForKey:@"school_status_id"] forKey:@"status[1]"];
        [self.params setObject:[secondEduItem objectForKey:@"state_id"] forKey:@"state[1]"];
        [self.params setObject:[secondEduItem objectForKey:@"other_location"] forKey:@"other_location[1]"];
        [self.params setObject:[secondEduItem objectForKey:@"city"] forKey:@"town[1]"];
        [self.params setObject:[secondEduItem objectForKey:@"school_id"] forKey:@"school[1]"];
        [self.params setObject:[secondEduItem objectForKey:@"other_school"] forKey:@"other_school[1]"];
        [self.params setObject:@"0" forKey:@"remove[1]"];
        NSDictionary *thirdEduItem = [eduArray objectAtIndex:2];
        [self.params setObject:[thirdEduItem objectForKey:@"id"] forKey:@"edu_id[2]"];
        [self.params setObject:[thirdEduItem objectForKey:@"type"] forKey:@"school_level[2]"];
        [self.params setObject:[thirdEduItem objectForKey:@"school_status_id"] forKey:@"status[2]"];
        [self.params setObject:[thirdEduItem objectForKey:@"state_id"] forKey:@"state[2]"];
        [self.params setObject:[thirdEduItem objectForKey:@"other_location"] forKey:@"other_location[2]"];
        [self.params setObject:[thirdEduItem objectForKey:@"city"] forKey:@"town[2]"];
        [self.params setObject:[thirdEduItem objectForKey:@"school_id"] forKey:@"school[2]"];
        [self.params setObject:[thirdEduItem objectForKey:@"other_school"] forKey:@"other_school[2]"];
        [self.params setObject:@"0" forKey:@"remove[2]"];
        NSDictionary *fourthEduItem = [eduArray objectAtIndex:3];
        [self.params setObject:[fourthEduItem objectForKey:@"id"] forKey:@"edu_id[3]"];
        [self.params setObject:[fourthEduItem objectForKey:@"type"] forKey:@"school_level[3]"];
        [self.params setObject:[fourthEduItem objectForKey:@"school_status_id"] forKey:@"status[3]"];
        [self.params setObject:[fourthEduItem objectForKey:@"state_id"] forKey:@"state[3]"];
        [self.params setObject:[fourthEduItem objectForKey:@"other_location"] forKey:@"other_location[3]"];
        [self.params setObject:[fourthEduItem objectForKey:@"city"] forKey:@"town[3]"];
        [self.params setObject:[fourthEduItem objectForKey:@"school_id"] forKey:@"school[3]"];
        [self.params setObject:[fourthEduItem objectForKey:@"other_school"] forKey:@"other_school[3]"];
        [self.params setObject:@"0" forKey:@"remove[3]"];
        if([self.mode isEqualToString:@"add"]) {
            NSDictionary *fourthEduItem = [eduArray objectAtIndex:4];
            [self.params setObject:[fourthEduItem objectForKey:@"id"] forKey:@"edu_id[4]"];
            [self.params setObject:[fourthEduItem objectForKey:@"type"] forKey:@"school_level[4]"];
            [self.params setObject:[fourthEduItem objectForKey:@"school_status_id"] forKey:@"status[4]"];
            [self.params setObject:[fourthEduItem objectForKey:@"state_id"] forKey:@"state[4]"];
            [self.params setObject:[fourthEduItem objectForKey:@"other_location"] forKey:@"other_location[4]"];
            [self.params setObject:[fourthEduItem objectForKey:@"city"] forKey:@"town[4]"];
            [self.params setObject:[fourthEduItem objectForKey:@"school_id"] forKey:@"school[4]"];
            [self.params setObject:[fourthEduItem objectForKey:@"other_school"] forKey:@"other_school[4]"];
            [self.params setObject:@"0" forKey:@"remove[4]"];
            [self setupAttributesForIndex:5];
            [self.params setObject:@"" forKey:self.eduId];
        } else if([self.mode isEqualToString:@"edit"]) {
            [self setupAttributesForIndex:4];
            NSDictionary *fifthEduItem = [eduArray objectAtIndex:4];
            [self.params setObject:[fifthEduItem objectForKey:@"id"] forKey:self.eduId];
            if([[fifthEduItem objectForKey:@"type"] isEqualToString:@"high_school"])
                self.btnHighSchool.selected = TRUE;
            if([[fifthEduItem objectForKey:@"type"] isEqualToString:@"college"])
            {
                self.btnCity.alpha = 0;
                self.cnstrntCityHeight.constant = 0;
                self.btnCollege.selected = TRUE;
            }
            if([[fifthEduItem objectForKey:@"type"] isEqualToString:@"trade_school"])
            {
                self.btnCity.alpha = 0;
                self.cnstrntCityHeight.constant = 0;
                self.btnTradeSchool.selected = TRUE;
            }
            if([[fifthEduItem objectForKey:@"type"] isEqualToString:@"GED"])
            {
                self.cnstrntSchoolHeight.constant = 0;
                self.viewSchool.alpha = 0;
                self.heightAttended.constant = 0;
                self.viewAttended.alpha = 0;
                [self.btnGraduated setTitle:@"Completed GED" forState:UIControlStateNormal];
                self.btnGED.selected = TRUE;
            }
            else {
                [self.btnSchool setTitle:[fifthEduItem objectForKey:@"school"] forState:UIControlStateNormal];
                [self.btnSchool setTag: [[fifthEduItem objectForKey:@"school_id"]integerValue]];
                [self.btnState setTitle: [fifthEduItem objectForKey:@"state"] forState:UIControlStateNormal];
                [self.btnState setTag:  [[fifthEduItem objectForKey:@"city"]integerValue]];
            }
            if([[fifthEduItem objectForKey:@"school_status_id"] intValue] == 1) {
                self.btnEnrolled.selected = TRUE;
            } else if([[fifthEduItem objectForKey:@"school_status_id"] intValue] == 2) {
                self.btnGraduated.selected = TRUE;
            } else if([[fifthEduItem objectForKey:@"school_status_id"] intValue] == 3) {
                self.btnAttended.selected = TRUE;
            }
        }
    }
 }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changeValue:(id)sender
{
    self.btnSaveChanges.enabled = YES;
}

- (IBAction)highSchoolPress:(id)sender
{
    if(sender) {
        self.btnEnrolled.selected = FALSE;
        self.btnGraduated.selected = FALSE;
        self.btnAttended.selected = FALSE;
    }
    [self.btnGraduated setTitle:@"Graduated" forState:UIControlStateNormal];
    self.cnstrntCityHeight.constant = 30;
    self.heightAttended.constant = 100;
    self.cnstrntSchoolHeight.constant = 200;
    self.cnstrntStatusHeight.constant = 165;
    [UIView animateWithDuration:.3 animations:^{
        [self.btnSchool setTitle:@"Select School" forState:UIControlStateNormal];
        [self.btnCity setTitle:@"Select City" forState:UIControlStateNormal];
        [self.btnState setTitle:@"Select State" forState:UIControlStateNormal];
        [self.view layoutIfNeeded];}
                     completion:^ (BOOL finished)
     {
         if (finished) {
             [UIView animateWithDuration:.3 animations:^{
                 self.btnCity.alpha = 1;
                 self.viewSchool.alpha = 1;
                 self.viewCurrent.alpha = 1;
                 self.viewAttended.alpha = 1;
                 [self.view layoutIfNeeded];}];
         }
     }];
}
- (IBAction)collegePress:(id)sender
{
    if(sender) {
        self.btnEnrolled.selected = FALSE;
        self.btnGraduated.selected = FALSE;
        self.btnAttended.selected = FALSE;
    }
    [self.btnGraduated setTitle:@"Graduated" forState:UIControlStateNormal];
    self.btnCity.alpha = 0;
    self.heightAttended.constant = 100;
    self.cnstrntSchoolHeight.constant = 200;
    self.cnstrntStatusHeight.constant = 165;
    [UIView animateWithDuration:.3 animations:^{
        [self.btnSchool setTitle:@"Select School" forState:UIControlStateNormal];
        [self.btnCity setTitle:@"Select City" forState:UIControlStateNormal];
        [self.btnState setTitle:@"Select State" forState:UIControlStateNormal];
        [self.view layoutIfNeeded];}
                     completion:^ (BOOL finished)
     {
         if (finished) {
             [UIView animateWithDuration:.3 animations:^{
                 self.cnstrntCityHeight.constant = 0;
                 self.viewSchool.alpha = 1;
                 self.viewCurrent.alpha = 1;
                 self.viewAttended.alpha = 1;
                 [self.view layoutIfNeeded];}];
         }
     }];
}

- (IBAction)tradeSchoolPress:(id)sender
{
    if(sender) {
        self.btnEnrolled.selected = FALSE;
        self.btnGraduated.selected = FALSE;
        self.btnAttended.selected = FALSE;
    }
    [self.btnGraduated setTitle:@"Graduated" forState:UIControlStateNormal];
    self.btnCity.alpha = 0;
    self.heightAttended.constant = 100;
    self.cnstrntSchoolHeight.constant = 200;
    self.cnstrntStatusHeight.constant = 165;
    [UIView animateWithDuration:.3 animations:^{
        [self.btnSchool setTitle:@"Select School" forState:UIControlStateNormal];
        [self.btnCity setTitle:@"Select City" forState:UIControlStateNormal];
        [self.btnState setTitle:@"Select State" forState:UIControlStateNormal];
        [self.view layoutIfNeeded];}
                     completion:^ (BOOL finished)
     {
         if (finished) {
             [UIView animateWithDuration:.3 animations:^{
                 self.cnstrntCityHeight.constant = 0;
                 self.viewSchool.alpha = 1;
                 self.viewCurrent.alpha = 1;
                 self.viewAttended.alpha = 1;
                 [self.view layoutIfNeeded];}];
         }
     }];
}

- (IBAction)gedPress:(id)sender
{
    if(sender) {
        self.btnEnrolled.selected = FALSE;
        self.btnGraduated.selected = FALSE;
        self.btnAttended.selected = FALSE;
    }
    [self.btnGraduated setTitle:@"Completed GED" forState:UIControlStateNormal];
    self.viewSchool.alpha = 0;
    self.viewAttended.alpha = 0;
    [UIView animateWithDuration:.3 animations:^{
        [self.btnSchool setTitle:@"Select School" forState:UIControlStateNormal];
        [self.btnCity setTitle:@"Select City" forState:UIControlStateNormal];
        [self.btnState setTitle:@"Select State" forState:UIControlStateNormal];
        [self.btnState setTitle:@"Select State" forState:UIControlStateHighlighted];
        [self.view layoutIfNeeded];}
                     completion:^ (BOOL finished)
     {
         if (finished) {
             [UIView animateWithDuration:.3 animations:^{
                 self.heightAttended.constant = 0;
                 self.cnstrntSchoolHeight.constant = 0;
                 [self.view layoutIfNeeded];}];
         }
     }];
}

- (IBAction)statePress:(id)sender
{
    [self.btnSchool setTitle:@"Select School" forState:UIControlStateNormal];
    [self.btnSchool setTitle:@"Select School" forState:UIControlStateHighlighted];
    [self.btnSchool setTitle:@"Select School" forState:UIControlStateSelected];
    [self.btnCity setTitle:@"Select City" forState:UIControlStateNormal];
    [self.btnCity setTitle:@"Select City" forState:UIControlStateHighlighted];
    [self.btnCity setTitle:@"Select City" forState:UIControlStateSelected];
    
    ListSelectorTableViewController *myController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ListSelector"];
    
    [myController setParameters:nil];
    [myController setUrl:@"http://uwurk.tscserver.com/api/v1/states"];
    [myController setDisplay:@"description"];
    [myController setKey:@"id"];
    [myController setDelegate:self];
    [myController setJsonGroup:@"states"];
    [myController setSender:self.btnState];
    [myController setTitle:@"States"];
    
    [self.navigationController pushViewController:myController animated:TRUE];
}

- (IBAction)cityPress:(id)sender
{
    [self.btnSchool setTitle:@"Select School" forState:UIControlStateNormal];
    
    if([self.btnState.titleLabel.text isEqualToString:@"Select State"]) {
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Oops!"
                                     message:@"Please select a state."
                                     preferredStyle:UIAlertControllerStyleActionSheet];
        [alert addAction:[UIAlertAction
                          actionWithTitle:@"OK"
                          style:UIAlertActionStyleDefault
                          handler:^(UIAlertAction *action)
                          {
                          }]];
        [self presentViewController:alert animated:TRUE completion:nil];
        return;
    }
    
    ListSelectorStringsTableViewController *myController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ListSelectorStrings"];
    
    [myController setDelegate:self];
    [myController setParameters:@{@"state_id":[@(self.btnState.tag)stringValue]}];
    [myController setUrl:@"http://uwurk.tscserver.com/api/v1/cities"];
    [myController setDisplay:@"description"];
    [myController setKey:@"id"];
    [myController setDelegate:self];
    [myController setJsonGroup:@"cities"];
    [myController setSender:self.btnCity];
    [myController setTitle:@"Cities"];
    [myController setPassThru:@"cities"];
    
    [self.navigationController pushViewController:myController animated:TRUE];
}

- (IBAction)schoolPress:(id)sender
{
    ListSelectorTableViewController *myController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ListSelector"];
    
    [myController setParameters:nil];
    
    if (self.btnHighSchool.isSelected) {
        [myController setUrl:@"http://uwurk.tscserver.com/api/v1/highschools"];
        [myController setParameters:@{@"city":[self.btnCity titleForState:UIControlStateNormal]}];
        [myController setJsonGroup:@"highschools"];
        [myController setBPost:FALSE];
        [myController setBUseArray:TRUE];
    }
    if (self.btnCollege.isSelected) {
        [myController setUrl:@"http://uwurk.tscserver.com/api/v1/colleges"];
        [myController setParameters:@{@"state":[@(self.btnState.tag)stringValue]}];
        [myController setJsonGroup:@"colleges"];
        [myController setBPost:FALSE];
        [myController setBUseArray:TRUE];
    }
    if (self.btnTradeSchool.isSelected) {
        [myController setUrl:@"http://uwurk.tscserver.com/api/v1/trade_schools"];
        [myController setParameters:@{@"state":[@(self.btnState.tag)stringValue]}];
        [myController setJsonGroup:@"schools"];
        [myController setBPost:FALSE];
        [myController setBUseArray:TRUE];
    }
    
    [myController setDelegate:self];
    [myController setDisplay:@"description"];
    [myController setKey:@"id"];
    [myController setDelegate:self];
    [myController setSender:self.btnSchool];
    [myController setTitle:@"Schools"];
    [myController setPassThru:@"selected_school"];
    
    [self.navigationController pushViewController:myController animated:TRUE];
}

- (IBAction)nextPress:(id)sender
{
    NSMutableString *Error = [[NSMutableString alloc] init];
    [Error appendString:@"To continue, complete the missing information:"];
    if (!self.btnHighSchool.isSelected &&
        !self.btnCollege.isSelected &&
        !self.btnTradeSchool.isSelected &&
        !self.btnGED.isSelected) {
        [Error appendString:@"\n\nSchool"];
    }
    if (!self.btnEnrolled.isSelected &&
        !self.btnGraduated.isSelected &&
        !self.btnAttended.isSelected) {
        [Error appendString:@"\n\nCurrent Status"];
    }
    if ((self.btnHighSchool.isSelected && [self.btnState.titleLabel.text isEqualToString:@"Select State"]) || (self.btnCollege.isSelected && [self.btnState.titleLabel.text isEqualToString:@"Select State"]) ||
        (self.btnTradeSchool.isSelected && [self.btnState.titleLabel.text isEqualToString:@"Select State"])) {
        [Error appendString:@"\n\nSelect State"];
    }
    if (self.btnHighSchool.isSelected && [self.btnCity.titleLabel.text isEqualToString:@"Select City"]) {
        [Error appendString:@"\n\nSelect City"];
    }
    if ((self.btnHighSchool.isSelected && [self.btnSchool.titleLabel.text isEqualToString:@"Select School"]) ||
        (self.btnCollege.isSelected && [self.btnSchool.titleLabel.text isEqualToString:@"Select School"]) ||
        (self.btnTradeSchool.isSelected && [self.btnSchool.titleLabel.text isEqualToString:@"Select School"])) {
        [Error appendString:@"\n\nSelect School"];
    }
    if ((Error.length) > 50) {
        [self handleErrorWithMessage:Error];
    } else {
        if (self.btnHighSchool.isSelected){
            [self updateParamDict:self.params value:@"high_school" key:self.schoolLevel];
            [self updateParamDict:self.params value:self.btnCity.titleLabel.text key:self.town];
        } else {
            [self updateParamDict:self.params value:@"" key:self.town];
        }
        if (self.btnCollege.isSelected){
            [self updateParamDict:self.params value:@"college" key:self.schoolLevel];
        }
        if (self.btnTradeSchool.isSelected){
            [self updateParamDict:self.params value:@"trade_school" key:self.schoolLevel];
        }
        if (self.btnGED.isSelected){
            [self updateParamDict:self.params value:@"GED" key:self.schoolLevel];
        }
        if(self.btnEnrolled.isSelected) {
            [self updateParamDict:self.params value:@"1" key:self.status];
        }
        if(self.btnGraduated.isSelected) {
            [self updateParamDict:self.params value:@"2" key:self.status];
        }
        if(self.btnAttended.isSelected) {
            [self updateParamDict:self.params value:@"3" key:self.status];
        }
        [self updateParamDict:self.params value:[@(self.btnState.tag)stringValue] key:self.state];
        [self updateParamDict:self.params value:[@(self.btnSchool.tag)stringValue] key:self.school];
        [self updateParamDict:self.params value:@"" key:self.otherLocation];
        [self updateParamDict:self.params value:@"" key:self.otherSchool];
        [self updateParamDict:self.params value:@"0" key:self.remove];
        if([self.params count]){
            AFHTTPRequestOperationManager *manager = [self getManager];
            [manager POST:@"http://uwurk.tscserver.com/api/v1/profile" parameters:self.params
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      NSLog(@"\nEmployee Step 4 - Json Response: %@", responseObject);
                      if([self validateResponse:responseObject]){
                          [self setPerformInit:YES];
                          [self.delegate setPerformInit:YES];
                          [self refreshData];
                          [self.navigationController popViewControllerAnimated:YES];
                      } else {
                          [self handleErrorJsonResponse:@"Employee Step 4"];
                      }}
                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      NSLog(@"Error: %@", error);
                      [self handleErrorAccessError:@"Employee Step 4" withError:error];
                  }];
        } else {
            UIViewController *myController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"EmployeeProfileSetup5"];
            [self.navigationController pushViewController:myController animated:TRUE];
        }
    }
}

- (void)setupAttributesForIndex:(NSInteger)index
{
    NSString *postFix = [NSString stringWithFormat:@"[%ld]",(long)index];
    self.eduId = [NSString stringWithFormat:@"edu_id%@",postFix];
    self.schoolLevel = [NSString stringWithFormat:@"school_level%@",postFix];
    self.status = [NSString stringWithFormat:@"status%@",postFix];
    self.state = [NSString stringWithFormat:@"state%@",postFix];
    self.otherLocation = [NSString stringWithFormat:@"other_location%@",postFix];
    self.town = [NSString stringWithFormat:@"town%@",postFix];
    self.school = [NSString stringWithFormat:@"school%@",postFix];
    self.otherSchool = [NSString stringWithFormat:@"other_school%@",postFix];
    self.remove = [NSString stringWithFormat:@"remove%@",postFix];
}

- (void)SelectionMade:(NSString *)passThru withDict:(NSDictionary *)dict displayString:(NSString *)displayString;
{
    [self changeValue:nil];
}

- (void)SelectionMadeString:(NSString *)passThru displayString:(NSString *)displayString
{
    [self changeValue:nil];
}

@end
