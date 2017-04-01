//
//  EmployeeStep4ViewController.m
//  uWurk2
//
//  Created by Avery Bonner on 9/4/15.
//  Copyright (c) 2015 Michael Brown. All rights reserved.
//  Copyright (c) 2017 Jim Bonner. All rights reserved.
//

#import "EmployeeStep4ViewController.h"
#import "RadioButton.h"
#import "ListSelectorTableViewController.h"
#import "ListSelectorStringsTableViewController.h"

@interface EmployeeStep4ViewController ()

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
@property (weak, nonatomic) IBOutlet UIView *viewAttended;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightAttended;
@property (strong, nonatomic) NSMutableDictionary *params;
@property (weak, nonatomic) NSString *eduId;

@end

@implementation EmployeeStep4ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if([[self.appDelegate.user objectForKey:@"high_school_selected"]intValue] == 1){
        [self.btnHighSchool setSelected:TRUE];
    } else {
        [self.btnHighSchool setSelected:FALSE];
    }
    if([[self.appDelegate.user objectForKey:@"college_selected"]intValue] == 1){
        [self.btnCollege setSelected:TRUE];
    } else {
        [self.btnCollege setSelected:FALSE];
    }
    if([[self.appDelegate.user objectForKey:@"trade_school_selected"]intValue] == 1){
        [self.btnTradeSchool setSelected:TRUE];
    } else {
        [self.btnTradeSchool setSelected:FALSE];
    }
    if([[self.appDelegate.user objectForKey:@"ged_selected"]intValue] == 1){
        [self gedPress:nil];
    } else {
        [self.btnGED setSelected:FALSE];
    }

    if([[self.appDelegate.user objectForKey:@"enrolled_selected"]intValue] == 1){
        [self.btnEnrolled setSelected:TRUE];
    } else {
        [self.btnEnrolled setSelected:FALSE];
    }
    if([[self.appDelegate.user objectForKey:@"graduated_selected"]intValue] == 1){
        [self.btnGraduated setSelected:TRUE];
    } else {
        [self.btnGraduated setSelected:FALSE];
    }
    if([[self.appDelegate.user objectForKey:@"attended_selected"]intValue] == 1){
        [self.btnAttended setSelected:TRUE];
    } else {
        [self.btnAttended setSelected:FALSE];
    }
    if([[self.appDelegate.user objectForKey:@"high_school_selected"]intValue] == 1) {
        if(![[self.appDelegate.user objectForKey:@"selected_state"] isEqualToString:@"Select State"])
        {
            if(([self.appDelegate.user objectForKey:@"selected_state"] != nil) &&
               (![[self.appDelegate.user objectForKey:@"selected_state"] isEqualToString:@""]))
            {
                [self.btnState setTitle:[self.appDelegate.user objectForKey:@"selected_state"] forState:UIControlStateNormal];
                [self.btnState setTag:[[self.appDelegate.user objectForKey:@"state_id"]intValue]];
            }
        }
        if(![[self.appDelegate.user objectForKey:@"selected_city"] isEqualToString:@"Select City"])
        {
            if(([self.appDelegate.user objectForKey:@"selected_city"] != nil) &&
               (![[self.appDelegate.user objectForKey:@"selected_city"] isEqualToString:@""]))
            {
                [self.btnCity setTitle:[self.appDelegate.user objectForKey:@"selected_city"] forState:UIControlStateNormal];
            }
        }
        if(![[self.appDelegate.user objectForKey:@"selected_school"] isEqualToString:@"Select School"])
        {
            if(([self.appDelegate.user objectForKey:@"selected_school"] != nil) &&
               (![[self.appDelegate.user objectForKey:@"selected_school"] isEqualToString:@""]))
            {
                [self.btnSchool setTitle:[self.appDelegate.user objectForKey:@"selected_school"] forState:UIControlStateNormal];
            }
        }
    }
    if([[self.appDelegate.user objectForKey:@"college_selected"]intValue] == 1) {
        if(![[self.appDelegate.user objectForKey:@"selected_state"] isEqualToString:@"Select State"])
        {
            if(([self.appDelegate.user objectForKey:@"selected_state"] != nil) &&
               (![[self.appDelegate.user objectForKey:@"selected_state"] isEqualToString:@""]))
            {
                [self.btnState setTitle:[self.appDelegate.user objectForKey:@"selected_state"] forState:UIControlStateNormal];
                [self.btnState setTag:[[self.appDelegate.user objectForKey:@"state_id"]intValue]];
            }
        }
        if(![[self.appDelegate.user objectForKey:@"selected_school"] isEqualToString:@"Select School"])
        {
            if(([self.appDelegate.user objectForKey:@"selected_school"] != nil) &&
               (![[self.appDelegate.user objectForKey:@"selected_school"] isEqualToString:@""]))
            {
                [self.btnSchool setTitle:[self.appDelegate.user objectForKey:@"selected_school"] forState:UIControlStateNormal];
            }
        }
    }
    if([[self.appDelegate.user objectForKey:@"trade_show_selected"]intValue] == 1) {
        if(![[self.appDelegate.user objectForKey:@"selected_state"] isEqualToString:@"Select State"])
        {
            if(([self.appDelegate.user objectForKey:@"selected_state"] != nil) &&
               (![[self.appDelegate.user objectForKey:@"selected_state"] isEqualToString:@""]))
            {
                [self.btnState setTitle:[self.appDelegate.user objectForKey:@"selected_state"] forState:UIControlStateNormal];
                [self.btnState setTag:[[self.appDelegate.user objectForKey:@"state_id"]intValue]];
            }
        }
        if(![[self.appDelegate.user objectForKey:@"selected_school"] isEqualToString:@"Select School"])
        {
            if(([self.appDelegate.user objectForKey:@"selected_school"] != nil) &&
               (![[self.appDelegate.user objectForKey:@"selected_school"] isEqualToString:@""]))
            {
                [self.btnSchool setTitle:[self.appDelegate.user objectForKey:@"selected_school"] forState:UIControlStateNormal];
             }
        }
    }

    self.params = [[NSMutableDictionary alloc] init];
    self.eduId = @"edu_id[0]";
    NSArray *educationArray = [self.appDelegate.user objectForKey:@"education"];
    if([educationArray count] > 0) {
        NSDictionary *firstEducationItem = [educationArray objectAtIndex:0];
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
    else {
        [self.params setObject:@"" forKey:self.eduId];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    BOOL selected = FALSE;
    if(self.btnHighSchool.selected) selected = TRUE;
    if(self.btnCollege.selected) selected = TRUE;
    if(self.btnTradeSchool.selected) selected = TRUE;
    if(self.btnGED.selected) selected = TRUE;
    
    if(!selected) {
        [self.btnHighSchool setSelected:TRUE];
        [self highSchoolPress:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self saveUserData];
}

-(void) saveUserData
{
    [self.appDelegate.user setObjectOrNil:self.btnHighSchool.selected ? @"1" : @"0" forKey:@"high_school_selected"];
    [self.appDelegate.user setObjectOrNil:self.btnCollege.selected ? @"1" : @"0" forKey:@"college_selected"];
    [self.appDelegate.user setObjectOrNil:self.btnTradeSchool.selected ? @"1" : @"0" forKey:@"trade_school_selected"];
    [self.appDelegate.user setObjectOrNil:self.btnGED.selected ? @"1" : @"0" forKey:@"ged_selected"];
    [self.appDelegate.user setObjectOrNil:self.btnEnrolled.selected ? @"1" : @"0" forKey:@"enrolled_selected"];
    [self.appDelegate.user setObjectOrNil:self.btnGraduated.selected ? @"1" : @"0" forKey:@"graduated_selected"];
    [self.appDelegate.user setObjectOrNil:self.btnAttended.selected ? @"1" : @"0" forKey:@"attedned_selected"];
    if([[self.btnState titleForState:UIControlStateNormal] isEqualToString:@"Select State"]) {
        [self.appDelegate.user setObjectOrNil:@"" forKey:@"selected_state"];
    } else {
        [self.appDelegate.user setObjectOrNil:[self.btnState titleForState:UIControlStateNormal] forKey:@"selected_state"];
        [self.appDelegate.user setObjectOrNil:[@(self.btnState.tag)stringValue] forKey:@"state_id"];
    }
    if([[self.btnCity titleForState:UIControlStateNormal] isEqualToString:@"Select City"]) {
        [self.appDelegate.user setObjectOrNil:@"" forKey:@"selected_city"];
    } else {
        [self.appDelegate.user setObjectOrNil:[self.btnCity titleForState:UIControlStateNormal] forKey:@"selected_city"];
    }
    if([[self.btnSchool titleForState:UIControlStateNormal] isEqualToString:@"Select School"]) {
        [self.appDelegate.user setObjectOrNil:@"" forKey:@"selected_school"];
    } else {
        [self.appDelegate.user setObjectOrNil:[self.btnSchool titleForState:UIControlStateNormal] forKey:@"selected_school"];
    }
    
    [self saveUserDefault:[self objectToJsonString:self.appDelegate.user]
                      Key:@"user_data"];
}

- (IBAction)highSchoolPress:(id)sender
{
    self.cnstrntCityHeight.constant = 30;
    self.heightAttended.constant = 100;
    [self.btnGraduated setTitle:@"Graduated" forState:UIControlStateNormal];
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
    self.btnCity.alpha = 0;
    self.heightAttended.constant = 100;
    [self.btnGraduated setTitle:@"Graduated" forState:UIControlStateNormal];
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
    self.btnCity.alpha = 0;
    self.heightAttended.constant = 100;
    [self.btnGraduated setTitle:@"Graduated" forState:UIControlStateNormal];
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
                 self.viewAttended.alpha = 1;
                 self.viewSchool.alpha = 1;
                 self.viewCurrent.alpha = 1;
                 [self.view layoutIfNeeded];}];
         }
     }];
}

- (IBAction)gedPress:(id)sender
{
    self.viewSchool.alpha = 0;
    [self.btnGraduated setTitle:@"Completed GED" forState:UIControlStateNormal];
    self.viewAttended.alpha = 0;
    [UIView animateWithDuration:.3 animations:^{
        [self.btnSchool setTitle:@"Select School" forState:UIControlStateNormal];
        [self.btnCity setTitle:@"Select City" forState:UIControlStateNormal];
        [self.btnState setTitle:@"Select State" forState:UIControlStateNormal];
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
    [self.btnCity setTitle:@"Select City" forState:UIControlStateNormal];
    
    ListSelectorTableViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"ListSelector"];
    
    [myController setParameters:nil];
    [myController setUrl:@"http://uwurk.tscserver.com/api/v1/states"];
    
    [myController setDisplay:@"description"];
    [myController setKey:@"id"];
    [myController setDelegate:self];
    [myController setJsonGroup:@"states"];
    [myController setSender:self.btnState];
    [myController setTitle:@"States"];
    [myController setUser:@"selected_state"];
    
    [self saveUserData];
    
    [self.navigationController pushViewController:myController animated:TRUE];
}

- (IBAction)cityPress:(id)sender
{
    [self.btnSchool setTitle:@"Select School" forState:UIControlStateNormal];
    
    ListSelectorStringsTableViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"ListSelectorStrings"];
    
    [myController setParameters:@{@"state_id":[@(self.btnState.tag)stringValue]}];
    [myController setUrl:@"http://uwurk.tscserver.com/api/v1/cities"];
    [myController setDisplay:@"description"];
    [myController setKey:@"id"];
    [myController setDelegate:self];
    [myController setJsonGroup:@"cities"];
    [myController setSender:self.btnCity];
    [myController setTitle:@"Cities"];
    [myController setUser:@"selected_city"];
    
    [self saveUserData];
    
    [self.navigationController pushViewController:myController animated:TRUE];
}

- (IBAction)schoolPress:(id)sender
{
    ListSelectorTableViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"ListSelector"];
    
    if (self.btnHighSchool.isSelected) {
        [myController setUrl:@"http://uwurk.tscserver.com/api/v1/highschools"];
        [myController setParameters:@{@"city":[self.btnCity titleForState:UIControlStateNormal]}];
        [myController setJsonGroup:@"highschools"];
        myController.bPost = FALSE;
        myController.bUseArray = TRUE;
    }
    if (self.btnCollege.isSelected) {
        [myController setUrl:@"http://uwurk.tscserver.com/api/v1/colleges"];
        [myController setParameters:@{@"state":[@(self.btnState.tag)stringValue]}];
        [myController setJsonGroup:@"colleges"];
        myController.bPost = FALSE;
        myController.bUseArray = TRUE;
    }
    if (self.btnTradeSchool.isSelected) {
        [myController setUrl:@"http://uwurk.tscserver.com/api/v1/trade_schools"];
        [myController setParameters:@{@"state":[@(self.btnState.tag)stringValue]}];
        [myController setJsonGroup:@"schools"];
        myController.bPost = FALSE;
        myController.bUseArray = TRUE;
    }
    
    [myController setDisplay:@"description"];
    [myController setKey:@"id"];
    [myController setDelegate:self];
    [myController setSender:self.btnSchool];
    [myController setTitle:@"Schools"];
    [myController setUser:@"selected_school"];
    
    [self saveUserData];
    
    [self.navigationController pushViewController:myController animated:TRUE];
}

- (IBAction)nextPress:(id)sender
{
    AFHTTPRequestOperationManager *manager = [self getManager];
    if (self.btnHighSchool.isSelected){
        [self updateParamDict:self.params value:@"high_school" key:@"school_level[0]"];
        [self.params setObject:[self.btnCity titleForState:UIControlStateNormal] forKey:@"town[0]"];
    }
    else
        [self.params setObject:@"" forKey:@"town[0]"];
    if (self.btnCollege.isSelected){
        [self updateParamDict:self.params value:@"college" key:@"school_level[0]"];
    }
    if (self.btnTradeSchool.isSelected){
        [self updateParamDict:self.params value:@"trade_school" key:@"school_level[0]"];
    }
    if (self.btnGED.isSelected){
        [self updateParamDict:self.params value:@"GED" key:@"school_level[0]"];
    }
    if(self.btnEnrolled.isSelected) {
        [self updateParamDict:self.params value:@"1" key:@"status[0]"];
    }
    if(self.btnGraduated.isSelected) {
        [self updateParamDict:self.params value:@"2" key:@"status[0]"];
    }
    if(self.btnAttended.isSelected) {
        [self updateParamDict:self.params value:@"3" key:@"status[0]"];
    }
    [self.params setObject:[self.btnState titleForState:UIControlStateSelected] forKey:@"state[0]"];
    [self.params setObject:[self.btnSchool titleForState:UIControlStateSelected] forKey:@"school[0]"];
    [self.params setObject:@"" forKey:@"other_location[0]"];
    [self.params setObject:@"" forKey:@"other_school[0]"];
    [self.params setObject:@"0" forKey:@"remove[0]"];
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
    } else {
        if([self.params count]){
            [manager POST:@"http://uwurk.tscserver.com/api/v1/profile" parameters:self.params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"JSON: %@", responseObject);
                if([self validateResponse:responseObject]){
                 
                    UIViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"EmployeeProfileSetup5"];
                    
                    [self saveUserData];
                    
                    [self.navigationController pushViewController:myController animated:TRUE];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Error"
                                                                 message:@"Unable to contact server"
                                                                delegate:self
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles: nil];
                [alert show];
            }];
        } else {
            UIViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"EmployeeProfileSetup5"];
            
            [self saveUserData];
            
            [self.navigationController pushViewController:myController animated:TRUE];
        }
    }
}

-(void)SelectionMade:(NSString *)user withDict:(NSDictionary *)dict displayString:(NSString *)displayString;
{
    [self.appDelegate.user setObjectOrNil:displayString forKey:user];
    
    if([user isEqualToString:@"selected_state"]) {
        [self.appDelegate.user setObjectOrNil:[@(self.btnState.tag)stringValue] forKey:@"state_id"];
    }
}

-(void)SelectionMadeString:(NSString *)user displayString:(NSString *)displayString;
{
    [self.appDelegate.user setObjectOrNil:displayString forKey:user];
}

@end
