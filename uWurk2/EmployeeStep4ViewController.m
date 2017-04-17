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
    
    NSLog(@"Employee Step 4:\n%@",self.appDelegate.user);
    
    self.eduId = @"edu_id[0]";
    self.params = [[NSMutableDictionary alloc]init];
    NSArray *eduArray = [self.appDelegate.user objectForKey:@"education"];
    NSDictionary *eduDict = nil;
    if([eduArray count] > 0) {
        eduDict = [eduArray objectAtIndex:0];
        [self.params setObject:[eduDict objectForKey:@"id"] forKey:self.eduId];

        if([[eduDict objectForKey:@"type"] isEqualToString:@"high_school"])
            self.btnHighSchool.selected = TRUE;
        if([[eduDict objectForKey:@"type"] isEqualToString:@"college"])
        {
            self.btnCity.alpha = 0;
            self.cnstrntCityHeight.constant = 0;
            self.btnCollege.selected = TRUE;
        }
        if([[eduDict objectForKey:@"type"] isEqualToString:@"trade_school"])
        {
            self.btnCity.alpha = 0;
            self.cnstrntCityHeight.constant = 0;
            self.btnTradeSchool.selected = TRUE;
        }
        if([[eduDict objectForKey:@"type"] isEqualToString:@"GED"])
        {
            self.cnstrntSchoolHeight.constant = 0;
            self.viewSchool.alpha = 0;
            self.heightAttended.constant = 0;
            self.viewAttended.alpha = 0;
            [self.btnGraduated setTitle:@"Completed GED" forState:UIControlStateNormal];
            self.btnGED.selected = TRUE;
        } else {
            [self.btnSchool setTitle:[eduDict objectForKey:@"school"] forState:UIControlStateNormal];
            [self.btnSchool   setTag:[[eduDict objectForKey:@"school_id"]intValue]];
            [self.btnState  setTitle:[eduDict objectForKey:@"state"] forState:UIControlStateNormal];
            [self.btnState    setTag:[[eduDict objectForKey:@"state_id"]intValue]];
            [self.btnCity   setTitle:[eduDict objectForKey:@"city"] forState:UIControlStateNormal];
        }
        if([[eduDict objectForKey:@"school_status_id"]intValue] == 1) {
            [self.btnEnrolled setSelected:TRUE];
        } else {
            [self.btnEnrolled setSelected:FALSE];
        }
        if([[eduDict objectForKey:@"school_status_id"]intValue] == 2) {
            [self.btnGraduated setSelected:TRUE];
        } else {
            [self.btnGraduated setSelected:FALSE];
        }
        if([[eduDict objectForKey:@"school_status_id"]intValue] == 3) {
            [self.btnAttended setSelected:TRUE];
        } else {
            [self.btnAttended setSelected:FALSE];
        }
    } else {
        [self.params setObject:@"" forKey:self.eduId];
    }

//    if([[self.appDelegate.user objectForKey:@"high_school_selected"]intValue] == 1) {
//        [self.btnHighSchool setSelected:TRUE];
//    } else {
//        [self.btnHighSchool setSelected:FALSE];
//    }
//    if([[self.appDelegate.user objectForKey:@"college_selected"]intValue] == 1) {
//        [self.btnCollege setSelected:TRUE];
//    } else {
//        [self.btnCollege setSelected:FALSE];
//    }
//    if([[self.appDelegate.user objectForKey:@"trade_school_selected"]intValue] == 1) {
//        [self.btnTradeSchool setSelected:TRUE];
//    } else {
//        [self.btnTradeSchool setSelected:FALSE];
//    }
//    if([[self.appDelegate.user objectForKey:@"ged_selected"]intValue] == 1) {
//        [self.btnGED setSelected:TRUE];
//    } else {
//        [self.btnGED setSelected:FALSE];
//    }

    if(eduDict == nil) {
        return;
    }
    
    if([[eduDict objectForKey:@"type"]  isEqualToString:@"high_school"])
    {
        [self highSchoolPress:nil];
        if(([self.appDelegate.user objectForKey:@"selected_state"] != nil) &&
           (![[self.appDelegate.user objectForKey:@"selected_state"] isEqualToString:@""]))
        {
            [self.btnState setTitle:[self.appDelegate.user objectForKey:@"selected_state"] forState:UIControlStateNormal];
            [self.btnState setTag:[[self.appDelegate.user objectForKey:@"state_id"]intValue]];
        }
        if(([self.appDelegate.user objectForKey:@"selected_city"] != nil) &&
           (![[self.appDelegate.user objectForKey:@"selected_city"] isEqualToString:@""]))
        {
            [self.btnCity setTitle:[self.appDelegate.user objectForKey:@"selected_city"] forState:UIControlStateNormal];
        }
        if(([self.appDelegate.user objectForKey:@"selected_school"] != nil) &&
           (![[self.appDelegate.user objectForKey:@"selected_school"] isEqualToString:@""]))
        {
            [self.btnSchool setTitle:[self.appDelegate.user objectForKey:@"selected_school"] forState:UIControlStateNormal];
            [self.btnSchool setTag:[[self.appDelegate.user objectForKey:@"school_id"]intValue]];
        }
    }
    if([[eduDict objectForKey:@"type"] isEqualToString:@"college"])
    {
        [self collegePress:nil];
        if(([self.appDelegate.user objectForKey:@"selected_state"] != nil) &&
           (![[self.appDelegate.user objectForKey:@"selected_state"] isEqualToString:@""]))
        {
            [self.btnState setTitle:[self.appDelegate.user objectForKey:@"selected_state"] forState:UIControlStateNormal];
            [self.btnState setTag:[[self.appDelegate.user objectForKey:@"state_id"]intValue]];
        }
        if(([self.appDelegate.user objectForKey:@"selected_school"] != nil) &&
           (![[self.appDelegate.user objectForKey:@"selected_school"] isEqualToString:@""]))
        {
            [self.btnSchool setTitle:[self.appDelegate.user objectForKey:@"selected_school"] forState:UIControlStateNormal];
            [self.btnSchool setTag:[[self.appDelegate.user objectForKey:@"school_id"]intValue]];
        }
    }
    if([[eduDict objectForKey:@"type"] isEqualToString:@"trade_show"])
    {
        [self tradeSchoolPress:nil];
        if(([self.appDelegate.user objectForKey:@"selected_state"] != nil) &&
           (![[self.appDelegate.user objectForKey:@"selected_state"] isEqualToString:@""]))
        {
            [self.btnState setTitle:[self.appDelegate.user objectForKey:@"selected_state"] forState:UIControlStateNormal];
            [self.btnState setTag:[[self.appDelegate.user objectForKey:@"state_id"]intValue]];
        }
        if(([self.appDelegate.user objectForKey:@"selected_school"] != nil) &&
           (![[self.appDelegate.user objectForKey:@"selected_school"] isEqualToString:@""]))
        {
            [self.btnSchool setTitle:[self.appDelegate.user objectForKey:@"selected_school"] forState:UIControlStateNormal];
            [self.btnSchool setTag:[[self.appDelegate.user objectForKey:@"school_id"]intValue]];
         }
    }
    if([[eduDict objectForKey:@"type"] isEqualToString:@"ged"])
    {
        [self gedPress:nil];
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
    
//    if(!selected) {
//        [self.btnHighSchool setSelected:TRUE];
//        [self highSchoolPress:nil];
//    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (IBAction)highSchoolPress:(id)sender
{
    self.cnstrntCityHeight.constant = 30;
    self.heightAttended.constant = 100;
    self.btnEnrolled.selected = FALSE;
    self.btnGraduated.selected = FALSE;
    self.btnAttended.selected = FALSE;
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
    self.btnEnrolled.selected = FALSE;
    self.btnGraduated.selected = FALSE;
    self.btnAttended.selected = FALSE;
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
    self.btnEnrolled.selected = FALSE;
    self.btnGraduated.selected = FALSE;
    self.btnAttended.selected = FALSE;
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
    
    [self.navigationController pushViewController:myController animated:TRUE];
}

- (IBAction)cityPress:(id)sender
{
    [self.btnSchool setTitle:@"Select School" forState:UIControlStateNormal];
    
    if([self.btnSchool.titleLabel.text isEqualToString:@"Select State"]) {
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
    
    [self.navigationController pushViewController:myController animated:TRUE];
}

- (IBAction)nextPress:(id)sender
{
    if (self.btnHighSchool.isSelected){
        [self updateParamDict:self.params value:@"high_school" key:@"school_level[0]"];
        [self updateParamDict:self.params value:self.btnCity.titleLabel.text key:@"town[0]"];
    } else {
        [self updateParamDict:self.params value:@"" key:@"town[0]"];
    }
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
    [self updateParamDict:self.params value:self.btnState.titleLabel.text key:@"state[0]"];
    [self updateParamDict:self.params value:self.btnSchool.titleLabel.text key:@"school[0]"];
    [self updateParamDict:self.params value:@"" key:@"other_location[0]"];
    [self updateParamDict:self.params value:@"" key:@"other_school[0]"];
    [self updateParamDict:self.params value:@"0" key:@"remove[0]"];
    
//    NSMutableDictionary *eduDict = [[NSMutableDictionary alloc]init];
//    if(self.btnHighSchool.isSelected) {
//        [eduDict setObject:@"high_school" forKey:@"type"];
//    } else if(self.btnCollege.isSelected) {
//        [eduDict setObject:@"college" forKey:@"type"];
//    } else if(self.btnTradeSchool) {
//        [eduDict setObject:@"trade_school" forKey:@"type"];
//    } else if(self.btnHighSchool.isSelected) {
//        [eduDict setObject:@"ged" forKey:@"type"];
//    }
//    if(self.btnEnrolled.isSelected) {
//        [eduDict setValue:@(1) forKey:@"school_status_id"];
//    } else if(self.btnGraduated.isSelected) {
//        [eduDict setValue:@(2) forKey:@"school_status_id"];
//    } else if(self.btnAttended.isSelected) {
//        [eduDict setValue:@(3) forKey:@"school_status_id"];
//    }
//    if(![self.btnState.titleLabel.text isEqualToString:@"Select State"]) {
//        [eduDict setObject:self.btnState.titleLabel.text forKey:@"selected_state"];
//        [eduDict setValue:@(self.btnState.tag) forKey:@"state_id"];
//    }
//    if(![self.btnCity.titleLabel.text isEqualToString:@"Select City"]) {
//        [eduDict setObject:self.btnCity.titleLabel.text forKey:@"city"];
//    }
//    if(![self.btnSchool.titleLabel.text isEqualToString:@"Select School"]) {
//        [eduDict setObject:self.btnSchool.titleLabel.text forKey:@"selected_school"];
//        [eduDict setValue:@(self.btnSchool.tag) forKey:@"school_id"];
//    }
//    [self.params setObject:@"" forKey:@"other_location"];
//    [self.params setObject:@"" forKey:@"other_school"];
//    [self.params setObject:@"0" forKey:@"remove"];
//
//    [self.params setObject:[eduDict objectForKey:@"id"] forKey:self.eduId];
//
//    NSArray *eduArray = [NSArray arrayWithObject:eduDict];
//    NSString *json = [self objectToJsonString:eduArray];
//    [self.params setObject:json forKey:@"education"];
    
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
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Oops!"
                                     message:Error
                                     preferredStyle:UIAlertControllerStyleActionSheet];
        [alert addAction:[UIAlertAction
                          actionWithTitle:@"OK"
                          style:UIAlertActionStyleDefault
                          handler:^(UIAlertAction *action)
                          {
                          }]];
        [self presentViewController:alert animated:TRUE completion:nil];
    } else {
        if([self.params count]){
            AFHTTPRequestOperationManager *manager = [self getManager];
            [manager POST:@"http://uwurk.tscserver.com/api/v1/profile" parameters:self.params
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      NSLog(@"JSON: %@", responseObject);
                      if([self validateResponse:responseObject]){
                          UIViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"EmployeeProfileSetup5"];
                          [self.navigationController pushViewController:myController animated:TRUE];
                      }}
                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      NSLog(@"Error: %@", error);
                      UIAlertController * alert = [UIAlertController
                                                   alertControllerWithTitle:@"Oops!"
                                                   message:@"Unable to contact server"
                                                   preferredStyle:UIAlertControllerStyleActionSheet];
                      [alert addAction:[UIAlertAction
                                        actionWithTitle:@"OK"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction *action)
                                        {
                                         }]];
                      [self presentViewController:alert animated:TRUE completion:nil];
                  }];
        } else {
            UIViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"EmployeeProfileSetup5"];
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
