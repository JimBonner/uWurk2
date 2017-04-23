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
@property  BOOL performEducationInit;

@end

@implementation EmployeeStep4ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.performEducationInit = YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"\nEmployee Step 4 - Init:\n%@",self.appDelegate.user);
    
    if(self.performEducationInit) {
        self.performEducationInit = NO;
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
            if([[eduDict objectForKey:@"type"] isEqualToString:@"high_school"])
            {
                [self highSchoolPress:nil];
                if([eduDict objectForKey:@"state"] != nil) {
                    [self.btnState setTitle:[eduDict objectForKey:@"state"] forState:UIControlStateNormal];
                    [self.btnState setTag:[[eduDict objectForKey:@"state_id"]intValue]];
                }
                if([eduDict objectForKey:@"city"] != nil) {
                    [self.btnCity setTitle:[eduDict objectForKey:@"city"] forState:UIControlStateNormal];
                }
                if([eduDict objectForKey:@"school"] != nil) {
                    [self.btnSchool setTitle:[eduDict objectForKey:@"school"] forState:UIControlStateNormal];
                    [self.btnSchool setTag:[[eduDict objectForKey:@"school_id"]intValue]];
                }
            }
            if([[eduDict objectForKey:@"type"] isEqualToString:@"college"])
            {
                [self collegePress:nil];
                if([eduDict objectForKey:@"state"] != nil) {
                    [self.btnState setTitle:[eduDict objectForKey:@"state"] forState:UIControlStateNormal];
                    [self.btnState setTag:[[eduDict objectForKey:@"state_id"]intValue]];
                }
                if([eduDict objectForKey:@"school"] != nil) {
                    [self.btnSchool setTitle:[eduDict objectForKey:@"school"] forState:UIControlStateNormal];
                    [self.btnSchool setTag:[[eduDict objectForKey:@"school_id"]intValue]];
                }
            }
            if([[eduDict objectForKey:@"type"] isEqualToString:@"trade_show"])
            {
                [self tradeSchoolPress:nil];
                if([eduDict objectForKey:@"state"] != nil) {
                    [self.btnState setTitle:[eduDict objectForKey:@"state"] forState:UIControlStateNormal];
                    [self.btnState setTag:[[eduDict objectForKey:@"state_id"]intValue]];
                }
                if([eduDict objectForKey:@"school"] != nil) {
                    [self.btnSchool setTitle:[eduDict objectForKey:@"school"] forState:UIControlStateNormal];
                    [self.btnSchool setTag:[[eduDict objectForKey:@"school_id"]intValue]];
                 }
            }
            if([[eduDict objectForKey:@"type"] isEqualToString:@"ged"])
            {
                [self gedPress:nil];
            }
        } else {
            [self.params setObject:@"" forKey:self.eduId];
        }
    } else {
        [self restoreScreenData];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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
                 self.viewAttended.alpha = 1;
                 self.viewSchool.alpha = 1;
                 self.viewCurrent.alpha = 1;
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
    [self saveScreenData];
    
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
    [myController setPassThru:@"selected_state"];
    
    [self.navigationController pushViewController:myController animated:TRUE];
}

- (IBAction)cityPress:(id)sender
{
    [self saveScreenData];
    
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
    
    ListSelectorStringsTableViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"ListSelectorStrings"];
    
    [myController setParameters:@{@"state_id":[@(self.btnState.tag)stringValue]}];
    [myController setUrl:@"http://uwurk.tscserver.com/api/v1/cities"];
    [myController setDisplay:@"description"];
    [myController setKey:@"id"];
    [myController setDelegate:self];
    [myController setJsonGroup:@"cities"];
    [myController setSender:self.btnCity];
    [myController setTitle:@"Cities"];
    [myController setPassThru:@"selected_city"];
    
    [self.navigationController pushViewController:myController animated:TRUE];
}

- (IBAction)schoolPress:(id)sender
{
    [self saveScreenData];
    
    ListSelectorTableViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"ListSelector"];
    
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
    
    [myController setDisplay:@"description"];
    [myController setKey:@"id"];
    [myController setDelegate:self];
    [myController setSender:self.btnSchool];
    [myController setTitle:@"Schools"];
    [myController setPassThru:@"selected_school"];
    
    [self.navigationController pushViewController:myController animated:TRUE];
}

- (void)saveScreenData
{
    if([self.btnHighSchool isSelected]) {
        [self.appDelegate.user setObject:@"high_school" forKey:@"school_type"];
    }
    if([self.btnCollege isSelected]) {
        [self.appDelegate.user setObject:@"college" forKey:@"school_type"];
    }
    if([self.btnTradeSchool isSelected]) {
        [self.appDelegate.user setObject:@"trade_school" forKey:@"school_type"];
    }
    if([self.btnGED isSelected]) {
        [self.appDelegate.user setObject:@"ged" forKey:@"school_type"];
    }
    if([self.btnEnrolled isSelected]) {
        [self.appDelegate.user setObject:@"1" forKey:@"school_status_enrolled"];
    } else {
        [self.appDelegate.user setObject:@"0" forKey:@"school_status_enrolled"];
    }
    if([self.btnGraduated isSelected]) {
        [self.appDelegate.user setObject:@"1" forKey:@"school_status_graduated"];
    } else {
        [self.appDelegate.user setObject:@"0" forKey:@"school_status_graduated"];
    }
    if([self.btnAttended isSelected]) {
        [self.appDelegate.user setObject:@"1" forKey:@"school_status_attended"];
    } else {
        [self.appDelegate.user setObject:@"0" forKey:@"school_status_attended"];
    }
    [self.appDelegate.user setObject:self.btnState.titleLabel.text forKey:@"school_state"];
    [self.appDelegate.user setObject:[@(self.btnState.tag)stringValue] forKey:@"school_state_id"];
    [self.appDelegate.user setObject:self.btnCity.titleLabel.text forKey:@"school_city"];
    [self.appDelegate.user setObject:self.btnSchool.titleLabel.text forKey:@"school_name"];
    [self.appDelegate.user setObject:[@(self.btnSchool.tag)stringValue] forKey:@"school_name_id"];
}

- (void)restoreScreenData
{
    if([[self.appDelegate.user objectForKey:@"school_type"]isEqualToString:@"high_school"]) {
        [self.btnHighSchool setSelected:YES];
    } else {
        [self.btnHighSchool setSelected:NO];
    }
    if([[self.appDelegate.user objectForKey:@"school_type"]isEqualToString:@"college"]) {
        [self.btnCollege setSelected:YES];
    } else {
        [self.btnCollege setSelected:NO];
    }
    if([[self.appDelegate.user objectForKey:@"school_type"]isEqualToString:@"trade_school"]) {
        [self.btnTradeSchool setSelected:YES];
    } else {
        [self.btnTradeSchool setSelected:NO];
    }
    if([[self.appDelegate.user objectForKey:@"school_type"]isEqualToString:@"ged"]) {
        [self.btnGED setSelected:YES];
    } else {
        [self.btnGED setSelected:NO];
    }
    self.btnEnrolled.selected = [[self.appDelegate.user objectForKey:@"school_status_enrolled"]intValue];
    self.btnGraduated.selected = [[self.appDelegate.user objectForKey:@"school_status_graduated"]intValue];
    self.btnAttended.selected = [[self.appDelegate.user objectForKey:@"school_status_attended"]intValue];
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
        [self updateParamDict:self.params value:[@(self.btnState.tag)stringValue] key:@"state[0]"];
        [self updateParamDict:self.params value:[@(self.btnSchool.tag)stringValue] key:@"school[0]"];
        [self updateParamDict:self.params value:@"" key:@"other_location[0]"];
        [self updateParamDict:self.params value:@"" key:@"other_school[0]"];
        [self updateParamDict:self.params value:@"0" key:@"remove[0]"];
        if([self.params count]){
            AFHTTPRequestOperationManager *manager = [self getManager];
            [manager POST:@"http://uwurk.tscserver.com/api/v1/profile" parameters:self.params
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      NSLog(@"\nEmployee Step 4 - Json Response: %@", responseObject);
                      if([self validateResponse:responseObject]){
                          self.performEducationInit = YES;
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

-(void)SelectionMade:(NSString *)passThru withDict:(NSDictionary *)dict displayString:(NSString *)displayString;
{
    if([passThru isEqualToString:@"selected_state"]) {
        [self.appDelegate.user setObject:[self.btnSchool titleForState:UIControlStateNormal]
                                  forKey:@"school_state"];
        [self.appDelegate.user setObject:[@(self.btnState.tag)stringValue]
                                  forKey:@"school_state_id"];
    }
    if([passThru isEqualToString:@"selected_city"]) {
        [self.appDelegate.user setObject:[self.btnCity titleForState:UIControlStateNormal]
                                  forKey:@"school_city"];
    }
    if([passThru isEqualToString:@"selected_school"]) {
        [self.appDelegate.user setObject:[self.btnSchool titleForState:UIControlStateNormal]
                                  forKey:@"school_name"];
        [self.appDelegate.user setObject:[@(self.btnSchool.tag)stringValue]
                                  forKey:@"school_name_id"];
    }
}

@end
