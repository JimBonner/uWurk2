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
@property (weak, nonatomic) NSString *expId;
@property  BOOL performExperienceInit;

@end

@implementation EmployeeStep5ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.params = [[NSMutableDictionary alloc] init];
    self.viewExpTip.layer.cornerRadius = 10;
    self.viewNoExpTip.layer.cornerRadius = 10;
    
    self.performExperienceInit = YES;
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
    
    NSLog(@"\nEmployee Step 5 - Init:\n%@",self.appDelegate.user);

    self.expId = @"exp_id[0]";
    if(self.performExperienceInit) {
        self.performExperienceInit = NO;
        self.params = [[NSMutableDictionary alloc]init];
        NSArray *expArray = [self.appDelegate.user objectForKey:@"experience"];
        NSDictionary *expDict = nil;
        if([expArray count] > 0) {
            expDict = [expArray objectAtIndex:0];
            [self.params setObject:[expDict objectForKey:@"id"] forKey:self.expId];
            [self.btnIndustry setTitle:[expDict objectForKey:@"industry"] forState:UIControlStateNormal];
            [self.btnIndustry setTag:[[expDict objectForKey:@"industry_id"]intValue]];
            [self.btnPosition setTitle:[expDict objectForKey:@"position"] forState:UIControlStateNormal];
            [self.btnPosition setTag:[[expDict objectForKey:@"position_id"]intValue]];
            [self.txtCompany  setText:[expDict objectForKey:@"company"]];
            if([self.appDelegate.user objectForKey:@"has_experience"]) {
                    self.btnExperienceNo.selected = YES;
                } else {
                    self.btnExperienceYes.selected = YES;
                }
            if([[expDict objectForKey:@"status"] intValue] == 1) {
                self.btnCurrentJob.selected = TRUE;
            }
            if([[expDict objectForKey:@"status"] intValue] == 2) {
                self.btnPreviousJob.selected = TRUE;
            }
            if([[expDict objectForKey:@"job_length"] intValue] == 1) {
                self.btnUnderYear.selected = TRUE;
            }
            if([[expDict objectForKey:@"job_length"] intValue] == 2) {
                self.btnYear2Year.selected = TRUE;
            }
            if([[expDict objectForKey:@"job_length"] intValue] == 3) {
                self.btnOver2Year.selected = TRUE;
            }
        } else {
            [self.params setObject:@"" forKey:self.expId];
            [self restoreScreenData];
        }
    } else {
        [self restoreScreenData];
    }
}

-(void)saveScreenData
{
    [self.appDelegate.user setObjectOrNil:self.btnExperienceYes.selected ? @"1" : @"0" forKey:@"exp_has_experience"];
    [self.appDelegate.user setObjectOrNil:self.btnExperienceNo.selected ? @"1" : @"0" forKey:@"exp_has_no_experience"];
    [self.appDelegate.user setObjectOrNil:self.txtCompany.text forKey:@"exp_company_names"];
    [self.appDelegate.user setObjectOrNil:self.btnCurrentJob.selected ? @"1" : @"0" forKey:@"exp_current_job"];
    [self.appDelegate.user setObjectOrNil:self.btnUnderYear.selected ? @"1" : @"0" forKey:@"exp_industry_tenure_underyear"];
    [self.appDelegate.user setObjectOrNil:self.btnYear2Year.selected ? @"1" : @"0" forKey:@"exp_industry_tenure_year2year"];
    [self.appDelegate.user setObjectOrNil:self.btnOver2Year.selected ? @"1" : @"0" forKey:@"exp_industry_tenure_over2year"];
    [self.appDelegate.user setObjectOrNil:self.btnIndustry.titleLabel.text forKey:@"exp_industry_name"];
    [self.appDelegate.user setObjectOrNil:[@(self.btnIndustry.tag)stringValue] forKey:@"exp_industry_id"];
    [self.appDelegate.user setObjectOrNil:self.btnPosition.titleLabel.text forKey:@"exp_industry_position"];
    [self.appDelegate.user setObjectOrNil:[@(self.btnPosition.tag)stringValue] forKey:@"exp_industry_position_id"];
}

- (void)restoreScreenData
{
    if(([self.appDelegate.user objectForKey:@"exp_has_experience"] == nil) &&
       ([self.appDelegate.user objectForKey:@"exp_has_no_experience"] == nil)) {
        [self pressNoExp:nil];
        return;
    }
    if([self.appDelegate.user objectForKey:@"exp_has_experience"]) {
        [self.btnExperienceYes setSelected:[[self.appDelegate.user objectForKey:@"exp_has_experience"]intValue]];
    }
    if([self.appDelegate.user objectForKey:@"exp_current_job"]) {
        [self.btnCurrentJob setSelected:[[self.appDelegate.user objectForKey:@"exp_current_job"]intValue]];
    }
    if([self.appDelegate.user objectForKey:@"exp_industry_tenure_underyear"]) {
        [self.btnUnderYear setSelected:[[self.appDelegate.user objectForKey:@"exp_industry_tenure_underyear"]intValue]];
    }
    if([self.appDelegate.user objectForKey:@"exp_industry_tenure_year2year"]) {
        [self.btnYear2Year setSelected:[[self.appDelegate.user objectForKey:@"exp_industry_tenure_year2year"]intValue]];
    }
    if([self.appDelegate.user objectForKey:@"exp_industry_tenure_over2year"]) {
        [self.btnOver2Year setSelected:[[self.appDelegate.user objectForKey:@"exp_industry_tenure_over2year"]intValue]];
    }
}

- (IBAction)pressNoExp:(id)sender
{
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
    [self saveScreenData];
    
    ListSelectorTableViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"ListSelector"];
    
    [myController setParameters:nil];
    [myController setUrl:@"http://uwurk.tscserver.com/api/v1/industries"];
    [myController setDisplay:@"description"];
    [myController setKey:@"id"];
    [myController setDelegate:self];
    [myController setJsonGroup:@"industries"];
    [myController setSender:self.btnIndustry];
    [myController setTitle:@"Industries"];
    [myController setPassThru:@"selected_industry"];
    
    [self.navigationController pushViewController:myController animated:TRUE];
}

- (IBAction)positionPress:(id)sender
{
    [self saveScreenData];
    
    ListSelectorTableViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"ListSelector"];
    
    [myController setParameters:@{@"industry_id":[@(self.btnIndustry.tag)stringValue]}];
    [myController setUrl:@"http://uwurk.tscserver.com/api/v1/positions"];
    [myController setDisplay:@"description"];
    [myController setKey:@"id"];
    [myController setDelegate:self];
    [myController setJsonGroup:@"positions"];
    [myController setSender:self.btnPosition];
    [myController setTitle:@"Positions"];
    [myController setPassThru:@"selected_position"];
    
    [self.navigationController pushViewController:myController animated:TRUE];
}

- (IBAction)nextPress:(id)sender
{
    BOOL hasExp;
    if(self.btnExperienceNo.isSelected) {
        hasExp = NO;
    } else {
        hasExp = YES;
    }
    if(hasExp) {
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
            return;
        }
    }
    if(hasExp) {
        [self.params setObjectOrNil:@"0" forKey:@"has_no_experience[0]"];
    } else {
        [self.params setObjectOrNil:@"1" forKey:@"has_no_experience"];
    }
    if(hasExp) {
        if(([self.txtCompany.text length] > 0)) {
            [self.params setObjectOrNil:self.txtCompany.text forKey:@"company[0]"];
        } else {
            [self.params setObjectOrNil:@"" forKey:@"company[0]"];
        }
        if((self.btnCurrentJob.isSelected)) {
            [self.params setObjectOrNil:@"1" forKey:@"status[0]"];
        } else {
            [self.params setObjectOrNil:@"2" forKey:@"status[0]"];
        }
        if(![self.btnIndustry.titleLabel.text isEqualToString:@"Select Industry"]) {
            [self.params setObjectOrNil:[@(self.btnIndustry.tag)stringValue] forKey:@"industry[0]"];
        }
        if(![self.btnPosition.titleLabel.text isEqualToString:@"Select Position"]) {
            [self.params setObjectOrNil:[@(self.btnPosition.tag)stringValue] forKey:@"position[0]"];
        }
        if(self.btnUnderYear.isSelected) {
            [self.params setObjectOrNil:@"1" forKey:@"job_length[0]"];
        };
        if(self.btnYear2Year.isSelected) {
            [self.params setObjectOrNil:@"2" forKey:@"job_length[0]"];
        }
        if(self.btnOver2Year.isSelected) {
            [self.params setObjectOrNil:@"3" forKey:@"job_length[0]"];
        }
        [self.params setObjectOrNil:@"" forKey:@"position2[0]"];
        [self.params setObjectOrNil:@"" forKey:@"other_position[0]"];
        [self.params setObjectOrNil:@"0" forKey:@"remove[0]"];

    } else {
        [self.params removeObjectForKey:self.expId];
        [self.params setObjectOrNil:@"" forKey:@"company"];
        [self.params setObjectOrNil:@"" forKey:@"industry"];
        [self.params setObjectOrNil:@"" forKey:@"position"];
        [self.params setObjectOrNil:@"" forKey:@"position2"];
        [self.params setObjectOrNil:@"" forKey:@"other_position"];
    }
    
    if([self.params count])
    {
        AFHTTPRequestOperationManager *manager = [self getManager];
        [manager POST:@"http://uwurk.tscserver.com/api/v1/profile" parameters:self.params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"\nEmployee Step 5 - Json Response: %@", responseObject);
            if([self validateResponse:responseObject]){
                self.performExperienceInit = YES;
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

-(void)SelectionMade:(NSString *)passThru withDict:(NSDictionary *)dict displayString:(NSString *)displayString;
{
    if([passThru isEqualToString:@"selected_industry"]) {
        [self.appDelegate.user setObject:[self.btnIndustry titleForState:UIControlStateNormal]
                                  forKey:@"exp_industry_name"];
        [self.appDelegate.user setObjectOrNil:[@(self.btnIndustry.tag)stringValue] forKey:@"exp_industry_id"];
    }
    if([passThru isEqualToString:@"selected_position"]) {
        [self.appDelegate.user setObject:[self.btnPosition titleForState:UIControlStateNormal]
                                  forKey:@"exp_industry_position"];
        [self.appDelegate.user setObjectOrNil:[@(self.btnPosition.tag)stringValue] forKey:@"exp_industry_position_id"];
    }
}

@end
