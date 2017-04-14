 //
//  EmployeeStep5ViewController.m
//  uWurk2
//
//  Created by Avery Bonner on 9/4/15.
//  Copyright (c) 2015 Michael Brown. All rights reserved.
//  Copyright (c) 2017 Jim Bonner. All rights reserved.
//

#import "EmployeeStep5ViewController.h"
#import "ListSelectorTableViewController.h"
#import "RadioButton.h"

@interface EmployeeStep5ViewController ()
@property (weak, nonatomic) IBOutlet RadioButton *btnExperienceYes;
@property (weak, nonatomic) IBOutlet RadioButton *btnExperienceNo;
@property (weak, nonatomic) IBOutlet UIButton *btnIndustry;
@property (weak, nonatomic) IBOutlet UIButton *btnPosition;
@property (weak, nonatomic) IBOutlet RadioButton *btnUnderYear;
@property (weak, nonatomic) IBOutlet RadioButton *btnYear2Year;
@property (weak, nonatomic) IBOutlet RadioButton *btnOver2Year;
@property (weak, nonatomic) IBOutlet RadioButton *btnCurrentJob;
@property (weak, nonatomic) IBOutlet RadioButton *btnPreviousJob;
@property (weak, nonatomic) IBOutlet UITextField *txtCompany;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cnstrntWorkExpHeight;
@property (weak, nonatomic) IBOutlet UIView *viewWorkExp;
@property (weak, nonatomic) IBOutlet UIView *viewExpTip;
@property (weak, nonatomic) IBOutlet UIView *viewMoreExp;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cnstrntNoExpViewHeight;
@property (weak, nonatomic) IBOutlet UIView *viewNoExp;
@property (weak, nonatomic) IBOutlet UIView *viewNoExpTip;
@property (strong, nonatomic) NSMutableDictionary *params;


@end

@implementation EmployeeStep5ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.params = [[NSMutableDictionary alloc] init];
    self.viewExpTip.layer.cornerRadius = 10;
    self.viewNoExpTip.layer.cornerRadius = 10;
    
    if([self.appDelegate.user objectForKey:@"has_experience"] == nil) {
        [self.btnExperienceYes setSelected:TRUE];
        [self pressYesExp:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"%@",self.appDelegate.user);

    NSArray *experienceArray = [self.appDelegate.user objectForKey:@"experience"];
    if([experienceArray count] > 0) {
        NSDictionary *firstExperienceItem = [experienceArray objectAtIndex:0];
        [self.btnPosition setTitle:[firstExperienceItem objectForKey:@"position"] forState:UIControlStateNormal];
        [self.btnPosition setTitle:[firstExperienceItem objectForKey:@"position_id"] forState:UIControlStateSelected];
        [self.btnIndustry setTitle:[firstExperienceItem objectForKey:@"industry"] forState:UIControlStateNormal];
        [self.btnIndustry setTitle:[firstExperienceItem objectForKey:@"industry_id"] forState:UIControlStateSelected];
        [self assignValue:[firstExperienceItem objectForKey:@"company"] control:self.txtCompany];
        if([[firstExperienceItem objectForKey:@"status"] intValue] ==1)
            self.btnCurrentJob.selected = TRUE;
        if([[firstExperienceItem objectForKey:@"status"] intValue] == 2)
            self.btnPreviousJob.selected = TRUE;
        if([[firstExperienceItem objectForKey:@"job_length"] intValue] == 1)
            self.btnUnderYear.selected = TRUE;
        if([[firstExperienceItem objectForKey:@"job_length"] intValue] == 2)
            self.btnYear2Year.selected = TRUE;
        if([[firstExperienceItem objectForKey:@"job_length"] intValue] == 3)
            self.btnOver2Year.selected = TRUE;
        [self.params setObject:[firstExperienceItem objectForKey:@"id"] forKey:@"exp_id[0]"];
    } else {
//        [self.params setObject:@"" forKey:@"exp_id[0]"];
    }
    
    if([[self.appDelegate.user objectForKey:@"has_experience"]intValue] == 1) {
        self.btnExperienceYes.selected = TRUE;
        self.cnstrntNoExpViewHeight.constant = 0;
        self.viewNoExp.alpha = 0;
    } else {
        self.btnExperienceNo.selected = TRUE;
        self.cnstrntNoExpViewHeight.constant = 155;
        self.viewNoExp.alpha = 1;
        self.cnstrntWorkExpHeight.constant = 0;
        self.viewWorkExp.alpha = 0;
    }
    [self.txtCompany setText:[self.appDelegate.user objectForKey:@"company_names"]];
    [self.btnCurrentJob setSelected:[[self.appDelegate.user objectForKey:@"current_job"]intValue]];
    [self.btnIndustry setTitle:[self.appDelegate.user objectForKey:@"industry_name"]
                      forState:UIControlStateNormal];
    [self.btnIndustry setTag:[[self.appDelegate.user objectForKey:@"industry_id"]intValue]];
    [self.btnPosition setTitle:[self.appDelegate.user objectForKey:@"position_name"] forState:UIControlStateNormal];
    if([[self.appDelegate.user objectForKey:@"industry_tenure_underyear"]intValue] == 1) {
        [self.btnUnderYear setSelected:TRUE];
    } else {
        [self.btnUnderYear setSelected:FALSE];
    }
    if([[self.appDelegate.user objectForKey:@"industry_tenure_year2year"]intValue] == 1) {
        [self.btnYear2Year setSelected:TRUE];
    } else {
        [self.btnYear2Year setSelected:FALSE];
    }
    if([[self.appDelegate.user objectForKey:@"industry_tenure_over2year"]intValue] == 1) {
        [self.btnOver2Year setSelected:TRUE];
    } else {
        [self.btnOver2Year setSelected:FALSE];
    }
    
    if(([self.appDelegate.user objectForKey:@"industry_name"] == nil) ||
       ([[self.appDelegate.user objectForKey:@"industry_name"] isEqualToString:@""])) {
        [self.btnIndustry setTitle:@"Select Industry" forState:UIControlStateNormal];
        [self.btnPosition setTitle:@"Select Position" forState:UIControlStateNormal];
    } else if(([self.appDelegate.user objectForKey:@"position_name"] == nil) ||
              ([[self.appDelegate.user objectForKey:@"position_name"] isEqualToString:@""])) {
        [self.btnPosition setTitle:@"Select Position" forState:UIControlStateNormal];
    }
}

-(void)saveUserData
{
    [self.appDelegate.user setObjectOrNil:self.btnExperienceYes.selected ? @"1" : @"0" forKey:@"has_experience"];
    [self.appDelegate.user setObjectOrNil:self.txtCompany.text forKey:@"company_names"];
    [self.appDelegate.user setObjectOrNil:self.btnCurrentJob.selected ? @"1" : @"0" forKey:@"current_job"];
    [self.appDelegate.user setObjectOrNil:self.btnIndustry.titleLabel.text forKey:@"industry_name"];
    [self.appDelegate.user setObjectOrNil:[@(self.btnIndustry.tag)stringValue] forKey:@"industry_id"];
    [self.appDelegate.user setObjectOrNil:self.btnPosition.titleLabel.text forKey:@"industry_position"];
    [self.appDelegate.user setObjectOrNil:self.btnUnderYear.selected ? @"1" : @"0" forKey:@"industry_tenure_underyear"];
    [self.appDelegate.user setObjectOrNil:self.btnYear2Year.selected ? @"1" : @"0" forKey:@"industry_tenure_year2year"];
    [self.appDelegate.user setObjectOrNil:self.btnOver2Year.selected ? @"1" : @"0" forKey:@"industry_tenure_over2year"];
}

- (IBAction)pressNoExp:(id)sender
{
    [self.appDelegate.user setObjectOrNil:@"0" forKey:@"has_experience"];
    [UIView animateWithDuration:.3 animations:^{
        self.viewWorkExp.alpha = 0;
        self.viewNoExp.alpha = 1;
        [self.view layoutIfNeeded];}
     
                     completion:^ (BOOL finished)
     {
         if (finished) {
                 self.cnstrntWorkExpHeight.constant = 0;
                 self.cnstrntNoExpViewHeight.constant = 155;
             [UIView animateWithDuration:.3 animations:^{
                 [self.view layoutIfNeeded];}];
         }
     }];
}
    
- (IBAction)pressYesExp:(id)sender
{
    [self.appDelegate.user setObjectOrNil:@"1" forKey:@"has_experience"];
    self.cnstrntWorkExpHeight.constant = 700;
    self.viewNoExp.alpha = 0;
    
    [UIView animateWithDuration:.3 animations:^{
        [self.view layoutIfNeeded];}
     
                     completion:^ (BOOL finished)
     {
         if (finished) {
             self.cnstrntNoExpViewHeight.constant = 0;
             self.viewWorkExp.alpha = 1;
             [UIView animateWithDuration:.3 animations:^{
                 [self.view layoutIfNeeded];}];
         }
     }];
}

- (IBAction)industryPress:(id)sender
{
     ListSelectorTableViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"ListSelector"];
    
    [myController setParameters:nil];
    [myController setUrl:@"http://uwurk.tscserver.com/api/v1/industries"];
    [myController setDisplay:@"description"];
    [myController setKey:@"id"];
    [myController setDelegate:self];
    [myController setJsonGroup:@"industries"];
    [myController setSender:self.btnIndustry];
    [myController setTitle:@"Industries"];
    [myController setUser:@"industry_name"];
    
    [self.navigationController pushViewController:myController animated:TRUE];
}

- (IBAction)positionPress:(id)sender
{
    ListSelectorTableViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"ListSelector"];
    
    [myController setParameters:@{@"industry_id":[@(self.btnIndustry.tag)stringValue]}];
    [myController setUrl:@"http://uwurk.tscserver.com/api/v1/positions"];
    [myController setDisplay:@"description"];
    [myController setKey:@"id"];
    [myController setDelegate:self];
    [myController setJsonGroup:@"positions"];
    [myController setSender:self.btnPosition];
    [myController setTitle:@"Positions"];
    [myController setUser:@"position_name"];
    
    [self.navigationController pushViewController:myController animated:TRUE];
}

- (IBAction)nextPress:(id)sender
{
    if(self.btnUnderYear.isSelected) {
        [self.params setObjectOrNil:@"1" forKey:@"job_length[0]"];
    }
    if(self.btnYear2Year.isSelected) {
        [self.params setObjectOrNil:@"2" forKey:@"job_length[0]"];
    }
    if(self.btnOver2Year.isSelected) {
        [self.params setObjectOrNil:@"3" forKey:@"job_length[0]"];
    }
    if (self.btnCurrentJob.isSelected) {
        [self.params setObjectOrNil:@"1" forKey:@"status[0]"];
    }
    if (self.btnPreviousJob.isSelected) {
        [self.params setObjectOrNil:@"2" forKey:@"status[0]"];
    }
    
    NSMutableString *Error = [[NSMutableString alloc] init];
    [Error appendString:@"To continue, complete the missing information:"];
    if (self.btnExperienceYes.selected == NO && self.btnExperienceNo.selected == NO) {
        [Error appendString:@"\n\nJob Status"];
    }
    if (self.btnExperienceYes.selected == YES && self.txtCompany.text.length == 0) {
        [Error appendString:@"\n\nCompany Name"];
    }
    if (self.btnExperienceYes.selected == YES && self.btnCurrentJob.selected == NO && self.btnPreviousJob.selected == NO) {
        [Error appendString:@"\n\nJob Type"];
    }
    if (self.btnExperienceYes.selected == YES && [[self.btnIndustry titleForState:UIControlStateNormal]isEqualToString:@"Select Industry"]) {
        [Error appendString:@"\n\nSelect Industry"];
    }
    if (self.btnExperienceYes.selected == YES && [[self.btnPosition titleForState:UIControlStateNormal]isEqualToString:@"Select Position"]) {
        [Error appendString:@"\n\nSelect Position"];
    }
    if (self.btnExperienceYes.selected == YES && self.btnUnderYear.selected == NO && self.btnYear2Year.selected == NO && self.btnOver2Year.selected == NO) {
        [Error appendString:@"\n\nJob Length"];
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
        [self.params setObjectOrNil:self.txtCompany.text forKey:@"company[0]"];
        [self.params setObjectOrNil:[self.btnPosition titleForState:UIControlStateSelected] forKey:@"position[0]"];
        [self.params setObjectOrNil:@"" forKey:@"position2[0]"];
        [self.params setObjectOrNil:@"" forKey:@"other_position[0]"];
        [self.params setObjectOrNil:@"0" forKey:@"remove[0]"];
        [self.params setObjectOrNil:[self.btnIndustry titleForState:UIControlStateSelected] forKey:@"industry[0]"];

        if([self.params count])
        {
            AFHTTPRequestOperationManager *manager = [self getManager];
            [manager POST:@"http://uwurk.tscserver.com/api/v1/profile" parameters:self.params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"JSON: %@", responseObject);
                if([self validateResponse:responseObject]){
                    
                    // Update the user object
                    
                    
                    UIViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"EmployeeProfileSetup6"];
                    [self.navigationController pushViewController:myController animated:YES];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
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
            UIViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"EmployeeProfileSetup6"];
            [self.navigationController pushViewController:myController animated:YES];
        }
    }
}

-(void)SelectionMade:(NSString *)user withDict:(NSDictionary *)dict displayString:(NSString *)displayString;
{
    [self.appDelegate.user setObjectOrNil:displayString forKey:user];
    
    if([user isEqualToString:@"industry_name"]) {
        [self.appDelegate.user setObjectOrNil:[@(self.btnIndustry.tag)stringValue] forKey:@"industry_id"];
    }
}

-(void)SelectionMadeString:(NSString *)user displayString:(NSString *)displayString;
{
    [self.appDelegate.user setObjectOrNil:displayString forKey:user];
}

@end
