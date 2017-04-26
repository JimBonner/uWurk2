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
@property (weak, nonatomic) IBOutlet UIButton *btnSaveChanges;
@property (strong, nonatomic) NSMutableDictionary *params;
@property (weak, nonatomic) NSString *eduId;
@property (weak, nonatomic) NSString *schoolLevel;
@property (weak, nonatomic) NSString *status;
@property (weak, nonatomic) NSString *state;
@property (weak, nonatomic) NSString *otherLocation;
@property (weak, nonatomic) NSString *town;
@property (weak, nonatomic) NSString *school;
@property (weak, nonatomic) NSString *otherSchool;
@property (weak, nonatomic) NSString *remove;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightAttended;
@property (weak, nonatomic) IBOutlet UIView *viewAttended;



@end

@implementation ProfileEditStep4ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"\nEmployee Profile Edit Step 4:\n%@",self.appDelegate.user);
    
    self.params = [[NSMutableDictionary alloc] init];
    NSArray *eduArray = [self.appDelegate.user objectForKey:@"education"];
    if ([self.eduEditCount intValue] == 0) {
        self.eduId = @"edu_id[0]";
        self.schoolLevel = @"school_level[0]";
        self.status = @"status[0]";
        self.state = @"state[0]";
        self.otherLocation = @"other_location[0]";
        self.town = @"town[0]";
        self.school = @"school[0]";
        self.otherSchool = @"other_school[0]";
        self.remove = @"remove[0]";
        NSDictionary *firstEducationItem = [eduArray objectAtIndex:0];
        [self.params setObject:[firstEducationItem objectForKey:@"id"] forKey:self.eduId];
        if([[firstEducationItem objectForKey:@"type"] isEqualToString:@"high_school"])
            self.btnHighSchool.selected = TRUE;
        if([[firstEducationItem objectForKey:@"type"] isEqualToString:@"college"])
        {
            self.btnCity.alpha = 0;
            self.cnstrntCityHeight.constant = 0;
            self.btnCollege.selected = TRUE;
        }
        if([[firstEducationItem objectForKey:@"type"] isEqualToString:@"trade_school"])
        {
            self.btnCity.alpha = 0;
            self.cnstrntCityHeight.constant = 0;
            self.btnTradeSchool.selected = TRUE;
        }
        if([[firstEducationItem objectForKey:@"type"] isEqualToString:@"GED"])
        {
            self.cnstrntSchoolHeight.constant = 0;
            self.viewSchool.alpha = 0;
            self.heightAttended.constant = 0;
            self.viewAttended.alpha = 0;
            [self.btnGraduated setTitle:@"Completed GED" forState:UIControlStateNormal];
            self.btnGED.selected = TRUE;
        }
        else {
            [self.btnSchool setTitle:[firstEducationItem objectForKey:@"school"] forState:UIControlStateNormal];
            [self.btnSchool setTitle:[firstEducationItem objectForKey:@"school_id"] forState:UIControlStateSelected];
            [self.btnState setTitle:[firstEducationItem objectForKey:@"state"] forState:UIControlStateNormal];
            [self.btnState setTitle:[firstEducationItem objectForKey:@"state_id"] forState:UIControlStateSelected];
            [self.btnCity setTitle:[firstEducationItem objectForKey:@"city"] forState:UIControlStateNormal];
        }
        if([[firstEducationItem objectForKey:@"school_status_id"] intValue] == 1)
            self.btnEnrolled.selected = TRUE;
        else if([[firstEducationItem objectForKey:@"school_status_id"] intValue] == 2)
            self.btnGraduated.selected = TRUE;
        else if([[firstEducationItem objectForKey:@"school_status_id"] intValue] == 3)
            self.btnAttended.selected = TRUE;
        
    }
    if ([self.eduEditCount intValue] == 1) {
        self.eduId = @"edu_id[1]";
        self.schoolLevel = @"school_level[1]";
        self.status = @"status[1]";
        self.state = @"state[1]";
        self.otherLocation = @"other_location[1]";
        self.town = @"town[1]";
        self.school = @"school[1]";
        self.otherSchool = @"other_school[1]";
        self.remove = @"remove[1]";
        NSDictionary *firstEduItem = [eduArray objectAtIndex:0];
        [self.params setObject:[firstEduItem objectForKey:@"id"] forKey:@"edu_id[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"school"] forKey:@"school_level[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"school_status_id"] forKey:@"status[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"state_id"] forKey:@"state[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"other_location"] forKey:@"other_location[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"city"] forKey:@"town[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"school_id"] forKey:@"school[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"other_school"] forKey:@"other_school[0]"];
        [self.params setObject:@"0" forKey:@"remove[0]"];
        NSDictionary *firstEducationItem = [eduArray objectAtIndex:1];
        [self.params setObject:[firstEducationItem objectForKey:@"id"] forKey:self.eduId];
        if([[firstEducationItem objectForKey:@"type"] isEqualToString:@"high_school"])
            self.btnHighSchool.selected = TRUE;
        if([[firstEducationItem objectForKey:@"type"] isEqualToString:@"college"])
        {
            self.btnCity.alpha = 0;
            self.cnstrntCityHeight.constant = 0;
            self.btnCollege.selected = TRUE;
        }
        if([[firstEducationItem objectForKey:@"type"] isEqualToString:@"trade_school"])
        {
            self.btnCity.alpha = 0;
            self.cnstrntCityHeight.constant = 0;
            self.btnTradeSchool.selected = TRUE;
        }
        if([[firstEducationItem objectForKey:@"type"] isEqualToString:@"GED"])
        {
            self.cnstrntSchoolHeight.constant = 0;
            self.viewSchool.alpha = 0;
            self.heightAttended.constant = 0;
            self.viewAttended.alpha = 0;
            [self.btnGraduated setTitle:@"Completed GED" forState:UIControlStateNormal];
            self.btnGED.selected = TRUE;
        }
        else {
            [self.btnSchool setTitle:[firstEducationItem objectForKey:@"school"] forState:UIControlStateNormal];
            [self.btnSchool setTitle:[firstEducationItem objectForKey:@"school_id"] forState:UIControlStateSelected];
            [self.btnState setTitle:[firstEducationItem objectForKey:@"state"] forState:UIControlStateNormal];
            [self.btnState setTitle:[firstEducationItem objectForKey:@"state_id"] forState:UIControlStateSelected];
            [self.btnCity setTitle:[firstEducationItem objectForKey:@"city"] forState:UIControlStateNormal];
        }
        if([[firstEducationItem objectForKey:@"school_status_id"] intValue] == 1)
            self.btnEnrolled.selected = TRUE;
        else if([[firstEducationItem objectForKey:@"school_status_id"] intValue] == 2)
            self.btnGraduated.selected = TRUE;
        else if([[firstEducationItem objectForKey:@"school_status_id"] intValue] == 3)
            self.btnAttended.selected = TRUE;
    }
    if ([self.eduEditCount intValue] == 2) {
        self.eduId = @"edu_id[2]";
        self.schoolLevel = @"school_level[2]";
        self.status = @"status[2]";
        self.state = @"state[2]";
        self.otherLocation = @"other_location[2]";
        self.town = @"town[2]";
        self.school = @"school[2]";
        self.otherSchool = @"other_school[2]";
        self.remove = @"remove[2]";
        NSDictionary *firstEduItem = [eduArray objectAtIndex:0];
        [self.params setObject:[firstEduItem objectForKey:@"id"] forKey:@"edu_id[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"school"] forKey:@"school_level[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"school_status_id"] forKey:@"status[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"state_id"] forKey:@"state[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"other_location"] forKey:@"other_location[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"city"] forKey:@"town[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"school_id"] forKey:@"school[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"other_school"] forKey:@"other_school[0]"];
        [self.params setObject:@"0" forKey:@"remove[0]"];
        NSDictionary *secondEduItem = [eduArray objectAtIndex:1];
        [self.params setObject:[secondEduItem objectForKey:@"id"] forKey:@"edu_id[1]"];
        [self.params setObject:[secondEduItem objectForKey:@"school"] forKey:@"school_level[1]"];
        [self.params setObject:[secondEduItem objectForKey:@"school_status_id"] forKey:@"status[1]"];
        [self.params setObject:[secondEduItem objectForKey:@"state_id"] forKey:@"state[1]"];
        [self.params setObject:[secondEduItem objectForKey:@"other_location"] forKey:@"other_location[1]"];
        [self.params setObject:[secondEduItem objectForKey:@"city"] forKey:@"town[1]"];
        [self.params setObject:[secondEduItem objectForKey:@"school_id"] forKey:@"school[1]"];
        [self.params setObject:[secondEduItem objectForKey:@"other_school"] forKey:@"other_school[1]"];
        [self.params setObject:@"0" forKey:@"remove[1]"];
        NSDictionary *firstEducationItem = [eduArray objectAtIndex:2];
        [self.params setObject:[firstEducationItem objectForKey:@"id"] forKey:self.eduId];
        if([[firstEducationItem objectForKey:@"type"] isEqualToString:@"high_school"])
            self.btnHighSchool.selected = TRUE;
        if([[firstEducationItem objectForKey:@"type"] isEqualToString:@"college"])
        {
            self.btnCity.alpha = 0;
            self.cnstrntCityHeight.constant = 0;
            self.btnCollege.selected = TRUE;
        }
        if([[firstEducationItem objectForKey:@"type"] isEqualToString:@"trade_school"])
        {
            self.btnCity.alpha = 0;
            self.cnstrntCityHeight.constant = 0;
            self.btnTradeSchool.selected = TRUE;
        }
        if([[firstEducationItem objectForKey:@"type"] isEqualToString:@"GED"])
        {
            self.cnstrntSchoolHeight.constant = 0;
            self.viewSchool.alpha = 0;
            self.heightAttended.constant = 0;
            self.viewAttended.alpha = 0;
            [self.btnGraduated setTitle:@"Completed GED" forState:UIControlStateNormal];
            self.btnGED.selected = TRUE;
        }
        else {
            [self.btnSchool setTitle:[firstEducationItem objectForKey:@"school"] forState:UIControlStateNormal];
            [self.btnSchool setTitle:[firstEducationItem objectForKey:@"school_id"] forState:UIControlStateSelected];
            [self.btnState setTitle:[firstEducationItem objectForKey:@"state"] forState:UIControlStateNormal];
            [self.btnState setTitle:[firstEducationItem objectForKey:@"state_id"] forState:UIControlStateSelected];
            [self.btnCity setTitle:[firstEducationItem objectForKey:@"city"] forState:UIControlStateNormal];
        }
        if([[firstEducationItem objectForKey:@"school_status_id"] intValue] == 1)
            self.btnEnrolled.selected = TRUE;
        else if([[firstEducationItem objectForKey:@"school_status_id"] intValue] == 2)
            self.btnGraduated.selected = TRUE;
        else if([[firstEducationItem objectForKey:@"school_status_id"] intValue] == 3)
            self.btnAttended.selected = TRUE;
        
    }
    if ([self.eduEditCount intValue] == 3) {
        self.eduId = @"edu_id[3]";
        self.schoolLevel = @"school_level[3]";
        self.status = @"status[3]";
        self.state = @"state[3]";
        self.otherLocation = @"other_location[3]";
        self.town = @"town[3]";
        self.school = @"school[3]";
        self.otherSchool = @"other_school[3]";
        self.remove = @"remove[3]";
        NSDictionary *firstEduItem = [eduArray objectAtIndex:0];
        [self.params setObject:[firstEduItem objectForKey:@"id"] forKey:@"edu_id[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"school"] forKey:@"school_level[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"school_status_id"] forKey:@"status[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"state_id"] forKey:@"state[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"other_location"] forKey:@"other_location[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"city"] forKey:@"town[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"school_id"] forKey:@"school[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"other_school"] forKey:@"other_school[0]"];
        [self.params setObject:@"0" forKey:@"remove[0]"];
        NSDictionary *secondEduItem = [eduArray objectAtIndex:1];
        [self.params setObject:[secondEduItem objectForKey:@"id"] forKey:@"edu_id[1]"];
        [self.params setObject:[secondEduItem objectForKey:@"school"] forKey:@"school_level[1]"];
        [self.params setObject:[secondEduItem objectForKey:@"school_status_id"] forKey:@"status[1]"];
        [self.params setObject:[secondEduItem objectForKey:@"state_id"] forKey:@"state[1]"];
        [self.params setObject:[secondEduItem objectForKey:@"other_location"] forKey:@"other_location[1]"];
        [self.params setObject:[secondEduItem objectForKey:@"city"] forKey:@"town[1]"];
        [self.params setObject:[secondEduItem objectForKey:@"school_id"] forKey:@"school[1]"];
        [self.params setObject:[secondEduItem objectForKey:@"other_school"] forKey:@"other_school[1]"];
        [self.params setObject:@"0" forKey:@"remove[1]"];
        NSDictionary *thirdEduItem = [eduArray objectAtIndex:2];
        [self.params setObject:[thirdEduItem objectForKey:@"id"] forKey:@"edu_id[2]"];
        [self.params setObject:[thirdEduItem objectForKey:@"school"] forKey:@"school_level[2]"];
        [self.params setObject:[thirdEduItem objectForKey:@"school_status_id"] forKey:@"status[2]"];
        [self.params setObject:[thirdEduItem objectForKey:@"state_id"] forKey:@"state[2]"];
        [self.params setObject:[thirdEduItem objectForKey:@"other_location"] forKey:@"other_location[2]"];
        [self.params setObject:[thirdEduItem objectForKey:@"city"] forKey:@"town[2]"];
        [self.params setObject:[thirdEduItem objectForKey:@"school_id"] forKey:@"school[2]"];
        [self.params setObject:[thirdEduItem objectForKey:@"other_school"] forKey:@"other_school[2]"];
        [self.params setObject:@"0" forKey:@"remove[2]"];
        NSDictionary *firstEducationItem = [eduArray objectAtIndex:3];
        [self.params setObject:[firstEducationItem objectForKey:@"id"] forKey:self.eduId];
        if([[firstEducationItem objectForKey:@"type"] isEqualToString:@"high_school"])
            self.btnHighSchool.selected = TRUE;
        if([[firstEducationItem objectForKey:@"type"] isEqualToString:@"college"])
        {
            self.btnCity.alpha = 0;
            self.cnstrntCityHeight.constant = 0;
            self.btnCollege.selected = TRUE;
        }
        if([[firstEducationItem objectForKey:@"type"] isEqualToString:@"trade_school"])
        {
            self.btnCity.alpha = 0;
            self.cnstrntCityHeight.constant = 0;
            self.btnTradeSchool.selected = TRUE;
        }
        if([[firstEducationItem objectForKey:@"type"] isEqualToString:@"GED"])
        {
            self.cnstrntSchoolHeight.constant = 0;
            self.viewSchool.alpha = 0;
            self.heightAttended.constant = 0;
            self.viewAttended.alpha = 0;
            [self.btnGraduated setTitle:@"Completed GED" forState:UIControlStateNormal];
            self.btnGED.selected = TRUE;
        }
        else {
            [self.btnSchool setTitle:[firstEducationItem objectForKey:@"school"] forState:UIControlStateNormal];
            [self.btnSchool setTitle:[firstEducationItem objectForKey:@"school_id"] forState:UIControlStateSelected];
            [self.btnState setTitle:[firstEducationItem objectForKey:@"state"] forState:UIControlStateNormal];
            [self.btnState setTitle:[firstEducationItem objectForKey:@"state_id"] forState:UIControlStateSelected];
            [self.btnCity setTitle:[firstEducationItem objectForKey:@"city"] forState:UIControlStateNormal];
        }
        if([[firstEducationItem objectForKey:@"school_status_id"] intValue] == 1)
            self.btnEnrolled.selected = TRUE;
        else if([[firstEducationItem objectForKey:@"school_status_id"] intValue] == 2)
            self.btnGraduated.selected = TRUE;
        else if([[firstEducationItem objectForKey:@"school_status_id"] intValue] == 3)
            self.btnAttended.selected = TRUE;
        
    }
    if ([self.eduEditCount intValue] == 4) {
        self.eduId = @"edu_id[4]";
        self.schoolLevel = @"school_level[4]";
        self.status = @"status[4]";
        self.state = @"state[4]";
        self.otherLocation = @"other_location[4]";
        self.town = @"town[4]";
        self.school = @"school[4]";
        self.otherSchool = @"other_school[4]";
        self.remove = @"remove[4]";
        NSDictionary *firstEduItem = [eduArray objectAtIndex:0];
        [self.params setObject:[firstEduItem objectForKey:@"id"] forKey:@"edu_id[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"school"] forKey:@"school_level[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"school_status_id"] forKey:@"status[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"state_id"] forKey:@"state[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"other_location"] forKey:@"other_location[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"city"] forKey:@"town[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"school_id"] forKey:@"school[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"other_school"] forKey:@"other_school[0]"];
        [self.params setObject:@"0" forKey:@"remove[0]"];
        NSDictionary *secondEduItem = [eduArray objectAtIndex:1];
        [self.params setObject:[secondEduItem objectForKey:@"id"] forKey:@"edu_id[1]"];
        [self.params setObject:[secondEduItem objectForKey:@"school"] forKey:@"school_level[1]"];
        [self.params setObject:[secondEduItem objectForKey:@"school_status_id"] forKey:@"status[1]"];
        [self.params setObject:[secondEduItem objectForKey:@"state_id"] forKey:@"state[1]"];
        [self.params setObject:[secondEduItem objectForKey:@"other_location"] forKey:@"other_location[1]"];
        [self.params setObject:[secondEduItem objectForKey:@"city"] forKey:@"town[1]"];
        [self.params setObject:[secondEduItem objectForKey:@"school_id"] forKey:@"school[1]"];
        [self.params setObject:[secondEduItem objectForKey:@"other_school"] forKey:@"other_school[1]"];
        [self.params setObject:@"0" forKey:@"remove[1]"];
        NSDictionary *thirdEduItem = [eduArray objectAtIndex:2];
        [self.params setObject:[thirdEduItem objectForKey:@"id"] forKey:@"edu_id[2]"];
        [self.params setObject:[thirdEduItem objectForKey:@"school"] forKey:@"school_level[2]"];
        [self.params setObject:[thirdEduItem objectForKey:@"school_status_id"] forKey:@"status[2]"];
        [self.params setObject:[thirdEduItem objectForKey:@"state_id"] forKey:@"state[2]"];
        [self.params setObject:[thirdEduItem objectForKey:@"other_location"] forKey:@"other_location[2]"];
        [self.params setObject:[thirdEduItem objectForKey:@"city"] forKey:@"town[2]"];
        [self.params setObject:[thirdEduItem objectForKey:@"school_id"] forKey:@"school[2]"];
        [self.params setObject:[thirdEduItem objectForKey:@"other_school"] forKey:@"other_school[2]"];
        [self.params setObject:@"0" forKey:@"remove[2]"];
        NSDictionary *fourthEduItem = [eduArray objectAtIndex:3];
        [self.params setObject:[fourthEduItem objectForKey:@"id"] forKey:@"edu_id[3]"];
        [self.params setObject:[fourthEduItem objectForKey:@"school"] forKey:@"school_level[3]"];
        [self.params setObject:[fourthEduItem objectForKey:@"school_status_id"] forKey:@"status[3]"];
        [self.params setObject:[fourthEduItem objectForKey:@"state_id"] forKey:@"state[3]"];
        [self.params setObject:[fourthEduItem objectForKey:@"other_location"] forKey:@"other_location[3]"];
        [self.params setObject:[fourthEduItem objectForKey:@"city"] forKey:@"town[3]"];
        [self.params setObject:[fourthEduItem objectForKey:@"school_id"] forKey:@"school[3]"];
        [self.params setObject:[fourthEduItem objectForKey:@"other_school"] forKey:@"other_school[3]"];
        [self.params setObject:@"0" forKey:@"remove[3]"];
        NSDictionary *firstEducationItem = [eduArray objectAtIndex:4];
        [self.params setObject:[firstEducationItem objectForKey:@"id"] forKey:self.eduId];
        if([[firstEducationItem objectForKey:@"type"] isEqualToString:@"high_school"])
            self.btnHighSchool.selected = TRUE;
        if([[firstEducationItem objectForKey:@"type"] isEqualToString:@"college"])
        {
            self.btnCity.alpha = 0;
            self.cnstrntCityHeight.constant = 0;
            self.btnCollege.selected = TRUE;
        }
        if([[firstEducationItem objectForKey:@"type"] isEqualToString:@"trade_school"])
        {
            self.btnCity.alpha = 0;
            self.cnstrntCityHeight.constant = 0;
            self.btnTradeSchool.selected = TRUE;
        }
        if([[firstEducationItem objectForKey:@"type"] isEqualToString:@"GED"])
        {
            self.cnstrntSchoolHeight.constant = 0;
            self.viewSchool.alpha = 0;
            self.heightAttended.constant = 0;
            self.viewAttended.alpha = 0;
            [self.btnGraduated setTitle:@"Completed GED" forState:UIControlStateNormal];
            self.btnGED.selected = TRUE;
        }
        else {
            [self.btnSchool setTitle:[firstEducationItem objectForKey:@"school"] forState:UIControlStateNormal];
            [self.btnSchool setTitle:[firstEducationItem objectForKey:@"school_id"] forState:UIControlStateSelected];
            [self.btnState setTitle:[firstEducationItem objectForKey:@"state"] forState:UIControlStateNormal];
            [self.btnState setTitle:[firstEducationItem objectForKey:@"state_id"] forState:UIControlStateSelected];
            [self.btnCity setTitle:[firstEducationItem objectForKey:@"city"] forState:UIControlStateNormal];
        }
        if([[firstEducationItem objectForKey:@"school_status_id"] intValue] == 1)
            self.btnEnrolled.selected = TRUE;
        else if([[firstEducationItem objectForKey:@"school_status_id"] intValue] == 2)
            self.btnGraduated.selected = TRUE;
        else if([[firstEducationItem objectForKey:@"school_status_id"] intValue] == 3)
            self.btnAttended.selected = TRUE;
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSArray *eduArray = [self.appDelegate.user objectForKey:@"education"];
    if ([self.educount intValue] == 1) {
        self.eduId = @"edu_id[0]";
        self.schoolLevel = @"school_level[0]";
        self.status = @"status[0]";
        self.state = @"state[0]";
        self.otherLocation = @"other_location[0]";
        self.town = @"town[0]";
        self.school = @"school[0]";
        self.otherSchool = @"other_school[0]";
        self.remove = @"remove[0]";
        [self.params setObject:@"" forKey:self.eduId];
    }
    if ([self.educount intValue] == 2) {
        self.eduId = @"edu_id[1]";
        self.schoolLevel = @"school_level[1]";
        self.status = @"status[1]";
        self.state = @"state[1]";
        self.otherLocation = @"other_location[1]";
        self.town = @"town[1]";
        self.school = @"school[1]";
        self.otherSchool = @"other_school[1]";
        self.remove = @"remove[1]";
        [self.params setObject:@"" forKey:self.eduId];
        NSDictionary *firstEduItem = [eduArray objectAtIndex:0];
        [self.params setObject:[firstEduItem objectForKey:@"id"] forKey:@"edu_id[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"school"] forKey:@"school_level[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"school_status_id"] forKey:@"status[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"state_id"] forKey:@"state[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"other_location"] forKey:@"other_location[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"city"] forKey:@"town[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"school_id"] forKey:@"school[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"other_school"] forKey:@"other_school[0]"];
        [self.params setObject:@"0" forKey:@"remove[0]"];
    }
    if ([self.educount intValue] == 3) {
        self.eduId = @"edu_id[2]";
        self.schoolLevel = @"school_level[2]";
        self.status = @"status[2]";
        self.state = @"state[2]";
        self.otherLocation = @"other_location[2]";
        self.town = @"town[2]";
        self.school = @"school[2]";
        self.otherSchool = @"other_school[2]";
        self.remove = @"remove[2]";
        [self.params setObject:@"" forKey:self.eduId];
        NSDictionary *firstEduItem = [eduArray objectAtIndex:0];
        [self.params setObject:[firstEduItem objectForKey:@"id"] forKey:@"edu_id[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"school"] forKey:@"school_level[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"school_status_id"] forKey:@"status[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"state_id"] forKey:@"state[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"other_location"] forKey:@"other_location[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"city"] forKey:@"town[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"school_id"] forKey:@"school[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"other_school"] forKey:@"other_school[0]"];
        [self.params setObject:@"0" forKey:@"remove[0]"];
        NSDictionary *secondEduItem = [eduArray objectAtIndex:1];
        [self.params setObject:[secondEduItem objectForKey:@"id"] forKey:@"edu_id[1]"];
        [self.params setObject:[secondEduItem objectForKey:@"school"] forKey:@"school_level[1]"];
        [self.params setObject:[secondEduItem objectForKey:@"school_status_id"] forKey:@"status[1]"];
        [self.params setObject:[secondEduItem objectForKey:@"state_id"] forKey:@"state[1]"];
        [self.params setObject:[secondEduItem objectForKey:@"other_location"] forKey:@"other_location[1]"];
        [self.params setObject:[secondEduItem objectForKey:@"city"] forKey:@"town[1]"];
        [self.params setObject:[secondEduItem objectForKey:@"school_id"] forKey:@"school[1]"];
        [self.params setObject:[secondEduItem objectForKey:@"other_school"] forKey:@"other_school[1]"];
        [self.params setObject:@"0" forKey:@"remove[1]"];
    }
    if ([self.educount intValue] == 4) {
        self.eduId = @"edu_id[3]";
        self.schoolLevel = @"school_level[3]";
        self.status = @"status[3]";
        self.state = @"state[3]";
        self.otherLocation = @"other_location[3]";
        self.town = @"town[3]";
        self.school = @"school[3]";
        self.otherSchool = @"other_school[3]";
        self.remove = @"remove[3]";
        [self.params setObject:@"" forKey:self.eduId];
        NSDictionary *firstEduItem = [eduArray objectAtIndex:0];
        [self.params setObject:[firstEduItem objectForKey:@"id"] forKey:@"edu_id[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"school"] forKey:@"school_level[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"school_status_id"] forKey:@"status[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"state_id"] forKey:@"state[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"other_location"] forKey:@"other_location[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"city"] forKey:@"town[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"school_id"] forKey:@"school[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"other_school"] forKey:@"other_school[0]"];
        [self.params setObject:@"0" forKey:@"remove[0]"];
        NSDictionary *secondEduItem = [eduArray objectAtIndex:1];
        [self.params setObject:[secondEduItem objectForKey:@"id"] forKey:@"edu_id[1]"];
        [self.params setObject:[secondEduItem objectForKey:@"school"] forKey:@"school_level[1]"];
        [self.params setObject:[secondEduItem objectForKey:@"school_status_id"] forKey:@"status[1]"];
        [self.params setObject:[secondEduItem objectForKey:@"state_id"] forKey:@"state[1]"];
        [self.params setObject:[secondEduItem objectForKey:@"other_location"] forKey:@"other_location[1]"];
        [self.params setObject:[secondEduItem objectForKey:@"city"] forKey:@"town[1]"];
        [self.params setObject:[secondEduItem objectForKey:@"school_id"] forKey:@"school[1]"];
        [self.params setObject:[secondEduItem objectForKey:@"other_school"] forKey:@"other_school[1]"];
        [self.params setObject:@"0" forKey:@"remove[1]"];
        NSDictionary *thirdEduItem = [eduArray objectAtIndex:2];
        [self.params setObject:[thirdEduItem objectForKey:@"id"] forKey:@"edu_id[2]"];
        [self.params setObject:[thirdEduItem objectForKey:@"school"] forKey:@"school_level[2]"];
        [self.params setObject:[thirdEduItem objectForKey:@"school_status_id"] forKey:@"status[2]"];
        [self.params setObject:[thirdEduItem objectForKey:@"state_id"] forKey:@"state[2]"];
        [self.params setObject:[thirdEduItem objectForKey:@"other_location"] forKey:@"other_location[2]"];
        [self.params setObject:[thirdEduItem objectForKey:@"city"] forKey:@"town[2]"];
        [self.params setObject:[thirdEduItem objectForKey:@"school_id"] forKey:@"school[2]"];
        [self.params setObject:[thirdEduItem objectForKey:@"other_school"] forKey:@"other_school[2]"];
        [self.params setObject:@"0" forKey:@"remove[2]"];
    }
    if ([self.educount intValue] == 5) {
        self.eduId = @"edu_id[4]";
        self.schoolLevel = @"school_level[4]";
        self.status = @"status[4]";
        self.state = @"state[4]";
        self.otherLocation = @"other_location[4]";
        self.town = @"town[4]";
        self.school = @"school[4]";
        self.otherSchool = @"other_school[4]";
        self.remove = @"remove[4]";
        [self.params setObject:@"" forKey:self.eduId];
        NSDictionary *firstEduItem = [eduArray objectAtIndex:0];
        [self.params setObject:[firstEduItem objectForKey:@"id"] forKey:@"edu_id[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"school"] forKey:@"school_level[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"school_status_id"] forKey:@"status[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"state_id"] forKey:@"state[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"other_location"] forKey:@"other_location[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"city"] forKey:@"town[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"school_id"] forKey:@"school[0]"];
        [self.params setObject:[firstEduItem objectForKey:@"other_school"] forKey:@"other_school[0]"];
        [self.params setObject:@"0" forKey:@"remove[0]"];
        NSDictionary *secondEduItem = [eduArray objectAtIndex:1];
        [self.params setObject:[secondEduItem objectForKey:@"id"] forKey:@"edu_id[1]"];
        [self.params setObject:[secondEduItem objectForKey:@"school"] forKey:@"school_level[1]"];
        [self.params setObject:[secondEduItem objectForKey:@"school_status_id"] forKey:@"status[1]"];
        [self.params setObject:[secondEduItem objectForKey:@"state_id"] forKey:@"state[1]"];
        [self.params setObject:[secondEduItem objectForKey:@"other_location"] forKey:@"other_location[1]"];
        [self.params setObject:[secondEduItem objectForKey:@"city"] forKey:@"town[1]"];
        [self.params setObject:[secondEduItem objectForKey:@"school_id"] forKey:@"school[1]"];
        [self.params setObject:[secondEduItem objectForKey:@"other_school"] forKey:@"other_school[1]"];
        [self.params setObject:@"0" forKey:@"remove[1]"];
        NSDictionary *thirdEduItem = [eduArray objectAtIndex:2];
        [self.params setObject:[thirdEduItem objectForKey:@"id"] forKey:@"edu_id[2]"];
        [self.params setObject:[thirdEduItem objectForKey:@"school"] forKey:@"school_level[2]"];
        [self.params setObject:[thirdEduItem objectForKey:@"school_status_id"] forKey:@"status[2]"];
        [self.params setObject:[thirdEduItem objectForKey:@"state_id"] forKey:@"state[2]"];
        [self.params setObject:[thirdEduItem objectForKey:@"other_location"] forKey:@"other_location[2]"];
        [self.params setObject:[thirdEduItem objectForKey:@"city"] forKey:@"town[2]"];
        [self.params setObject:[thirdEduItem objectForKey:@"school_id"] forKey:@"school[2]"];
        [self.params setObject:[thirdEduItem objectForKey:@"other_school"] forKey:@"other_school[2]"];
        [self.params setObject:@"0" forKey:@"remove[2]"];
        NSDictionary *fourthEduItem = [eduArray objectAtIndex:3];
        [self.params setObject:[fourthEduItem objectForKey:@"id"] forKey:@"edu_id[3]"];
        [self.params setObject:[fourthEduItem objectForKey:@"school"] forKey:@"school_level[3]"];
        [self.params setObject:[fourthEduItem objectForKey:@"school_status_id"] forKey:@"status[3]"];
        [self.params setObject:[fourthEduItem objectForKey:@"state_id"] forKey:@"state[3]"];
        [self.params setObject:[fourthEduItem objectForKey:@"other_location"] forKey:@"other_location[3]"];
        [self.params setObject:[fourthEduItem objectForKey:@"city"] forKey:@"town[3]"];
        [self.params setObject:[fourthEduItem objectForKey:@"school_id"] forKey:@"school[3]"];
        [self.params setObject:[fourthEduItem objectForKey:@"other_school"] forKey:@"other_school[3]"];
        [self.params setObject:@"0" forKey:@"remove[3]"];
    }
    self.btnSaveChanges.enabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
-(void) SelectionMadeString {
    self.btnSaveChanges.enabled = YES;
}
-(void) SelectionMade {
    self.btnSaveChanges.enabled = YES;
}

-(IBAction)changeValue:(id)sender {
    self.btnSaveChanges.enabled = YES;
}

- (IBAction)highSchoolPress:(id)sender {
    self.cnstrntCityHeight.constant = 30;
    self.cnstrntSchoolHeight.constant = 200;
    self.cnstrntStatusHeight.constant = 165;
    [UIView animateWithDuration:.3 animations:^{
        [self.btnSchool setTitle:@"Select School" forState:UIControlStateNormal];
        [self.btnSchool setTitle:@"Select School" forState:UIControlStateHighlighted];
        [self.btnSchool setTitle:@"Select School" forState:UIControlStateSelected];
        [self.btnCity setTitle:@"Select City" forState:UIControlStateNormal];
        [self.btnCity setTitle:@"Select City" forState:UIControlStateHighlighted];
        [self.btnCity setTitle:@"Select City" forState:UIControlStateSelected];
        [self.btnState setTitle:@"Select State" forState:UIControlStateNormal];
        [self.btnState setTitle:@"Select State" forState:UIControlStateHighlighted];
        [self.btnState setTitle:@"Select State" forState:UIControlStateSelected];
        [self.view layoutIfNeeded];}
     
                     completion:^ (BOOL finished)
     {
         if (finished) {
             [UIView animateWithDuration:.3 animations:^{
                 self.btnCity.alpha = 1;
                 self.viewSchool.alpha = 1;
                 self.viewCurrent.alpha = 1;
                 [self.view layoutIfNeeded];}];
         }
     }];
}
- (IBAction)collegePress:(id)sender {
    self.btnCity.alpha = 0;
    self.cnstrntSchoolHeight.constant = 200;
    self.cnstrntStatusHeight.constant = 165;
    [UIView animateWithDuration:.3 animations:^{
        [self.btnSchool setTitle:@"Select School" forState:UIControlStateNormal];
        [self.btnSchool setTitle:@"Select School" forState:UIControlStateHighlighted];
        [self.btnSchool setTitle:@"Select School" forState:UIControlStateSelected];
        [self.btnCity setTitle:@"Select City" forState:UIControlStateNormal];
        [self.btnCity setTitle:@"Select City" forState:UIControlStateHighlighted];
        [self.btnCity setTitle:@"Select City" forState:UIControlStateSelected];
        [self.btnState setTitle:@"Select State" forState:UIControlStateNormal];
        [self.btnState setTitle:@"Select State" forState:UIControlStateHighlighted];
        [self.btnState setTitle:@"Select State" forState:UIControlStateSelected];
        [self.view layoutIfNeeded];}
     
                     completion:^ (BOOL finished)
     {
         if (finished) {
             [UIView animateWithDuration:.3 animations:^{
                 self.cnstrntCityHeight.constant = 0;
                 self.viewSchool.alpha = 1;
                 self.viewCurrent.alpha = 1;
                 [self.view layoutIfNeeded];}];
         }
     }];
}
- (IBAction)tradeSchoolPress:(id)sender {
    self.btnCity.alpha = 0;
    self.cnstrntSchoolHeight.constant = 200;
    self.cnstrntStatusHeight.constant = 165;
    [UIView animateWithDuration:.3 animations:^{
        [self.btnSchool setTitle:@"Select School" forState:UIControlStateNormal];
        [self.btnSchool setTitle:@"Select School" forState:UIControlStateHighlighted];
        [self.btnSchool setTitle:@"Select School" forState:UIControlStateSelected];
        [self.btnCity setTitle:@"Select City" forState:UIControlStateNormal];
        [self.btnCity setTitle:@"Select City" forState:UIControlStateHighlighted];
        [self.btnCity setTitle:@"Select City" forState:UIControlStateSelected];
        [self.btnState setTitle:@"Select State" forState:UIControlStateNormal];
        [self.btnState setTitle:@"Select State" forState:UIControlStateHighlighted];
        [self.btnState setTitle:@"Select State" forState:UIControlStateSelected];
        [self.view layoutIfNeeded];}
     
                     completion:^ (BOOL finished)
     {
         if (finished) {
             [UIView animateWithDuration:.3 animations:^{
                 self.cnstrntCityHeight.constant = 0;
                 self.viewSchool.alpha = 1;
                 self.viewCurrent.alpha = 1;
                 [self.view layoutIfNeeded];}];
         }
         
         
     }];
}
- (IBAction)gedPress:(id)sender {
    self.viewSchool.alpha = 0;
    self.viewCurrent.alpha = 0;
    [UIView animateWithDuration:.3 animations:^{
        [self.btnSchool setTitle:@"Select School" forState:UIControlStateNormal];
        [self.btnSchool setTitle:@"Select School" forState:UIControlStateHighlighted];
        [self.btnSchool setTitle:@"Select School" forState:UIControlStateSelected];
        [self.btnCity setTitle:@"Select City" forState:UIControlStateNormal];
        [self.btnCity setTitle:@"Select City" forState:UIControlStateHighlighted];
        [self.btnCity setTitle:@"Select City" forState:UIControlStateSelected];
        [self.btnState setTitle:@"Select State" forState:UIControlStateNormal];
        [self.btnState setTitle:@"Select State" forState:UIControlStateHighlighted];
        [self.btnState setTitle:@"Select State" forState:UIControlStateSelected];
        [self.view layoutIfNeeded];}
     
                     completion:^ (BOOL finished)
     {
         if (finished) {
             [UIView animateWithDuration:.3 animations:^{
                 self.cnstrntSchoolHeight.constant = 0;
                 self.cnstrntStatusHeight.constant = 0;
                 [self.view layoutIfNeeded];}];
         }
     }];
}



- (IBAction)statePress:(id)sender {
    [self.btnSchool setTitle:@"Select School" forState:UIControlStateNormal];
    [self.btnSchool setTitle:@"Select School" forState:UIControlStateHighlighted];
    [self.btnSchool setTitle:@"Select School" forState:UIControlStateSelected];
    [self.btnCity setTitle:@"Select City" forState:UIControlStateNormal];
    [self.btnCity setTitle:@"Select City" forState:UIControlStateHighlighted];
    [self.btnCity setTitle:@"Select City" forState:UIControlStateSelected];
    
    ListSelectorTableViewController *myController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ListSelector"];
    
    
    [myController setParameters:nil];
    [myController setUrl:@"http://uwurk.tscserver.com/api/v1/states"];
    // Come back for states
    [myController setDisplay:@"description"];
    [myController setKey:@"id"];
    [myController setDelegate:self];
    [myController setJsonGroup:@"states"];
    [myController setSender:self.btnState];
    [myController setTitle:@"States"];
    
    [self.navigationController pushViewController:myController animated:TRUE];
    
}
- (IBAction)cityPress:(id)sender {
    [self.btnSchool setTitle:@"Select School" forState:UIControlStateNormal];
    [self.btnSchool setTitle:@"Select School" forState:UIControlStateHighlighted];
    [self.btnSchool setTitle:@"Select School" forState:UIControlStateSelected];
    
    ListSelectorStringsTableViewController *myController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ListSelectorStrings"];
    
    
    [myController setParameters:@{@"state_id":[self.btnState titleForState:UIControlStateSelected]}];
    [myController setUrl:@"http://uwurk.tscserver.com/api/v1/cities"];
    // Come back for city
    [myController setDisplay:@"description"];
    [myController setKey:@"id"];
    [myController setDelegate:self];
    [myController setJsonGroup:@"cities"];
    [myController setSender:self.btnCity];
    [myController setTitle:@"Cities"];
    
    [self.navigationController pushViewController:myController animated:TRUE];
}
- (IBAction)schoolPress:(id)sender {
    
    ListSelectorTableViewController *myController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ListSelector"];
    
    [myController setParameters:nil];
    if (self.btnHighSchool.isSelected) {
        [myController setUrl:@"http://uwurk.tscserver.com/user/form-options"];
        [myController setParameters:@{@"state_id":[self.btnState titleForState:UIControlStateSelected],@"city":[self.btnCity titleForState:UIControlStateSelected],@"type":@"high_schools"}];
        myController.bPost = TRUE;
        myController.bUseArray = TRUE;
    }
    if (self.btnCollege.isSelected) {
        [myController setUrl:@"http://uwurk.tscserver.com/user/form-options"];
        [myController setParameters:@{@"state_id":[self.btnState titleForState:UIControlStateSelected],@"type":@"colleges"}];
        myController.bPost = TRUE;
        myController.bUseArray = TRUE;
    }
    if (self.btnTradeSchool.isSelected) {
        [myController setUrl:@"http://uwurk.tscserver.com/api/v1/form-options"];
        [myController setParameters:@{@"state_id":[self.btnState titleForState:UIControlStateSelected]}];
    }
    
    [myController setDisplay:@"description"];
    [myController setKey:@"id"];
    [myController setDelegate:self];
    [myController setJsonGroup:@"options"];
    [myController setSender:self.btnSchool];
    [myController setTitle:@"Schools"];
    
    [self.navigationController pushViewController:myController animated:TRUE];
    
}

- (IBAction)nextPress:(id)sender {
    // Did data get updated?
    
    AFHTTPRequestOperationManager *manager = [self getManager];
    if (self.btnHighSchool.isSelected){
        [self updateParamDict:self.params value:@"high_school" key:self.schoolLevel];
        [self.params setObject:[self.btnCity titleForState:UIControlStateNormal] forKey:self.town];
    }
    else
        [self.params setObject:@"" forKey:self.town];
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
    [self.params setObject:[self.btnState titleForState:UIControlStateSelected] forKey:self.state];
    [self.params setObject:[self.btnSchool titleForState:UIControlStateSelected] forKey:self.school];
    [self.params setObject:@"" forKey:self.otherLocation];
    [self.params setObject:@"" forKey:self.otherSchool];
    [self.params setObject:@"0" forKey:self.remove];
    
    NSMutableString *Error = [[NSMutableString alloc] init];
    [Error appendString:@"To continue, complete the missing information:"];
    if (self.btnHighSchool.selected == NO && self.btnCollege.selected == NO && self.btnTradeSchool.selected == NO && self.btnGED.selected == NO) {
        [Error appendString:@"\n\nSchool"];
    }
    if (self.btnEnrolled.selected == NO && self.btnGraduated.selected == NO && self.btnAttended.selected == NO) {
        [Error appendString:@"\n\nCurrent Status"];
    }
    if ((self.btnHighSchool.selected == YES && [[self.btnState titleForState:UIControlStateNormal]isEqualToString:@"Select State"])|| (self.btnCollege.selected == YES && [[self.btnState titleForState:UIControlStateNormal]isEqualToString:@"Select State"]) || (self.btnTradeSchool.selected == YES && [[self.btnState titleForState:UIControlStateNormal]isEqualToString:@"Select State"])) {
        [Error appendString:@"\n\nSelect State"];
    }
    if (self.btnHighSchool.selected == YES && [[self.btnCity titleForState:UIControlStateNormal]isEqualToString:@"Select City"]) {
        [Error appendString:@"\n\nSelect City"];
    }
    if ((self.btnHighSchool.selected == YES && [[self.btnSchool titleForState:UIControlStateNormal]isEqualToString:@"Select School"])|| (self.btnCollege.selected == YES && [[self.btnSchool titleForState:UIControlStateNormal]isEqualToString:@"Select School"]) || (self.btnTradeSchool.selected == YES && [[self.btnSchool titleForState:UIControlStateNormal]isEqualToString:@"Select School"])) {
        [Error appendString:@"\n\nSelect School"];
    }
    if ((Error.length) > 50) {
        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"OOPS!"
                                                         message:Error
                                                        delegate:self
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles: nil];
        [alert show];
    }
    else {

    if([self.params count]){
        [manager POST:@"http://uwurk.tscserver.com/api/v1/profile" parameters:self.params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            if([self validateResponse:responseObject]){
                
                // Update the user object
                
                
                UIViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileEditEducationList"];
                [self.navigationController pushViewController:myController animated:TRUE];
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
        UIViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileEditEducationList"];
        [self.navigationController pushViewController:myController animated:TRUE];
    }
}
}

-(void)SelectionMadeString:(NSString *)passThru displayString:(NSString *)displayString;
{
    
}

- (void)SelectionMade:(NSString *)passThru withDict:(NSDictionary *)dict displayString:(NSString *)displayString;
{
    
}

@end
