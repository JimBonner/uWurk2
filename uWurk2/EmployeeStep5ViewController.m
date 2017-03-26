 //
//  EmployeeStep5ViewController.m
//  uWurk2
//
//  Created by Avery Bonner on 9/4/15.
//  Copyright (c) 2015 Michael Brown. All rights reserved.
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.params = [[NSMutableDictionary alloc] init];
    self.viewExpTip.layer.cornerRadius = 10;
    self.viewNoExpTip.layer.cornerRadius = 10;
    if([[self.appDelegate.user objectForKey:@"has_no_experience"] isEqualToString:@"1"]){
        self.btnExperienceNo.selected = TRUE;
        self.cnstrntNoExpViewHeight.constant = 155;
        self.viewNoExp.alpha = 1;
        self.cnstrntWorkExpHeight.constant = 0;
        self.viewWorkExp.alpha = 0;
        
    }
    if([[self.appDelegate.user objectForKey:@"has_no_experience"]  intValue] == 0){
        self.btnExperienceYes.selected = TRUE;
        self.cnstrntNoExpViewHeight.constant = 0;
        self.viewNoExp.alpha = 0;
    }
    NSArray *experienceArray = [self.appDelegate.user objectForKey:@"experience"];
    if([experienceArray count] >0) {
        NSDictionary *firstExperienceItem = [experienceArray objectAtIndex:0];
        [self.btnPosition setTitle:[firstExperienceItem objectForKey:@"position"] forState:UIControlStateNormal];
        [self.btnPosition setTitle:[firstExperienceItem objectForKey:@"position_id"] forState:UIControlStateSelected];
        [self.btnIndustry setTitle:[firstExperienceItem objectForKey:@"industry"] forState:UIControlStateNormal];
        [self.btnIndustry setTitle:[firstExperienceItem objectForKey:@"industry_id"] forState:UIControlStateSelected];
        [self.params setObject:[firstExperienceItem objectForKey:@"id"] forKey:@"exp_id[0]"];
        [self assignValue:[firstExperienceItem objectForKey:@"company"] control:self.txtCompany];
        if([[firstExperienceItem objectForKey:@"status"] intValue] ==1)
            self.btnCurrentJob.selected = TRUE;
        if([[firstExperienceItem objectForKey:@"status"]  intValue] == 2)
            self.btnPreviousJob.selected = TRUE;
        if([[firstExperienceItem objectForKey:@"job_length"] intValue] == 1)
            self.btnUnderYear.selected = TRUE;
        if([[firstExperienceItem objectForKey:@"job_length"]  intValue] == 2)
            self.btnYear2Year.selected = TRUE;
        if([[firstExperienceItem objectForKey:@"job_length"]  intValue] == 3)
            self.btnOver2Year.selected = TRUE;
    }
    else {
        [self.params setObject:@"" forKey:@"exp_id[0]"];
        
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)pressNoExp:(id)sender {
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
- (IBAction)pressYesExp:(id)sender {
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

- (IBAction)industryPress:(id)sender {
    
     ListSelectorTableViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"ListSelector"];
    
    
    [myController setParameters:nil];
    [myController setUrl:@"http://uwurk.tscserver.com/api/v1/industries"];
    [myController setDisplay:@"description"];
    [myController setKey:@"id"];
    [myController setDelegate:self];
    [myController setJsonGroup:@"industries"];
    [myController setSender:self.btnIndustry];
    [myController setTitle:@"Industries"];
    
    [self.navigationController pushViewController:myController animated:TRUE];
    
}
- (IBAction)positionPress:(id)sender {
    
    ListSelectorTableViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"ListSelector"];
    
    
    [myController setParameters:@{@"industry_id":[self.btnIndustry titleForState:UIControlStateSelected]}];
    [myController setUrl:@"http://uwurk.tscserver.com/api/v1/positions"];
    [myController setDisplay:@"description"];
    [myController setKey:@"id"];
    [myController setDelegate:self];
    [myController setJsonGroup:@"positions"];
    [myController setSender:self.btnPosition];
    [myController setTitle:@"Positions"];
    
    [self.navigationController pushViewController:myController animated:TRUE];
    
}

- (IBAction)nextPress:(id)sender
{
    // Did data get updated?
    
    [self saveUserDefault:self.appDelegate.user Key:@"user_data"];
    
    AFHTTPRequestOperationManager *manager = [self getManager];
    [self.params setObject:self.txtCompany.text forKey:@"company[0]"];
    [self.params setObject:[self.btnPosition titleForState:UIControlStateSelected] forKey:@"position[0]"];
    [self.params setObject:@"" forKey:@"position2[0]"];
    [self.params setObject:@"" forKey:@"other_position[0]"];
    [self.params setObject:@"0" forKey:@"remove[0]"];
    [self.params setObject:[self.btnIndustry titleForState:UIControlStateSelected] forKey:@"industry[0]"];
    if(self.btnUnderYear.isSelected) {
        [self.params setObject:@"1" forKey:@"job_length[0]"];
    }
    if(self.btnYear2Year.isSelected) {
        [self.params setObject:@"2" forKey:@"job_length[0]"];
    }
    if(self.btnOver2Year.isSelected) {
        [self.params setObject:@"3" forKey:@"job_length[0]"];
    }
    if (self.btnCurrentJob.isSelected) {
        [self.params setObject:@"1" forKey:@"status[0]"];
    }
    if (self.btnPreviousJob.isSelected) {
        [self.params setObject:@"2" forKey:@"status[0]"];
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
                
                
                UIViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"EmployeeProfileSetup6"];
                [self.navigationController pushViewController:myController animated:YES];
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
        UIViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"EmployeeProfileSetup6"];
        [self.navigationController pushViewController:myController animated:YES];
    }
}
}

@end
