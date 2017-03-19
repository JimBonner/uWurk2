//
//  EmployeeStep4ViewController.m
//  uWurk2
//
//  Created by Avery Bonner on 9/4/15.
//  Copyright (c) 2015 Michael Brown. All rights reserved.
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.params = [[NSMutableDictionary alloc] init];
    self.eduId = @"edu_id[0]";
    NSArray *educationArray = [self.appDelegate.user objectForKey:@"education"];
    if([educationArray count] >0) {
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
        if([[firstEducationItem objectForKey:@"school_status_id"]  intValue] == 1)
            self.btnEnrolled.selected = TRUE;
        else if([[firstEducationItem objectForKey:@"school_status_id"]  intValue] == 2)
            self.btnGraduated.selected = TRUE;
        else if([[firstEducationItem objectForKey:@"school_status_id"]  intValue] == 3)
            self.btnAttended.selected = TRUE;
}
    else {
        [self.params setObject:@"" forKey:self.eduId];
    }
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

- (IBAction)highSchoolPress:(id)sender {
    self.cnstrntCityHeight.constant = 30;
    self.heightAttended.constant = 100;
    [self.btnGraduated setTitle:@"Graduated" forState:UIControlStateNormal];
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
                 self.viewAttended.alpha = 1;
                 [self.view layoutIfNeeded];}];
         }
     }];
}
- (IBAction)collegePress:(id)sender {
    self.btnCity.alpha = 0;
    self.heightAttended.constant = 100;
    [self.btnGraduated setTitle:@"Graduated" forState:UIControlStateNormal];
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
                 self.viewAttended.alpha = 1;
                 [self.view layoutIfNeeded];}];
         }
     }];
}
- (IBAction)tradeSchoolPress:(id)sender {
    self.btnCity.alpha = 0;
    self.heightAttended.constant = 100;
    [self.btnGraduated setTitle:@"Graduated" forState:UIControlStateNormal];
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
                 self.viewAttended.alpha = 1;
                 self.viewSchool.alpha = 1;
                 self.viewCurrent.alpha = 1;
                 [self.view layoutIfNeeded];}];
         }
         
         
     }];
}
- (IBAction)gedPress:(id)sender {
    self.viewSchool.alpha = 0;
    [self.btnGraduated setTitle:@"Completed GED" forState:UIControlStateNormal];
    self.viewAttended.alpha = 0;
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
                self.heightAttended.constant = 0;
                 self.cnstrntSchoolHeight.constant = 0;
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
    
    ListSelectorTableViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"ListSelector"];
    
    
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
    
    ListSelectorStringsTableViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"ListSelectorStrings"];
    
    
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
    
    ListSelectorTableViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"ListSelector"];
    
    
    [myController setParameters:nil];
    if (self.btnHighSchool.isSelected) {
        [myController setUrl:@"http://uwurk.tscserver.com/api/v1/high_schools"];
        [myController setParameters:@{@"state_id":[self.btnState titleForState:UIControlStateSelected],@"city":[self.btnCity titleForState:UIControlStateSelected],@"type":@"high_schools"}];
        myController.bPost = TRUE;
        myController.bUseArray = TRUE;
    }
    if (self.btnCollege.isSelected) {
        [myController setUrl:@"http://uwurk.tscserver.com/api/v1/colleges"];
        [myController setParameters:@{@"state_id":[self.btnState titleForState:UIControlStateSelected],@"type":@"colleges"}];
        myController.bPost = TRUE;
        myController.bUseArray = TRUE;
    }
    if (self.btnTradeSchool.isSelected) {
        [myController setUrl:@"http://uwurk.tscserver.com/api/v1/trade_schools"];
        [myController setParameters:@{@"state_id":[self.btnState titleForState:UIControlStateSelected]}];
    }
    // Come back for schools
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
    }
    else {
    
    if([self.params count]){
        [manager POST:@"http://uwurk.tscserver.com/api/v1/profile" parameters:self.params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            if([self validateResponse:responseObject]){
                
                // Update the user object
                
                
                UIViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"EmployeeProfileSetup5"];
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
    }
    else{
        UIViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"EmployeeProfileSetup5"];
        [self.navigationController pushViewController:myController animated:TRUE];
    }
}
}

@end
