//
//  RefineSearchViewController.m
//  uWurk2
//
//  Created by Avery Bonner on 12/27/15.
//  Copyright (c) 2015 Michael Brown. All rights reserved.
//  Copyright (c) 2017 Jim Bonner. All rights reserved.
//

#import "RefineSearchViewController.h"
#import "SearchResultsTableViewController.h"
#import  "IndustryPositionViewController.h"
#import "ListMultiSelectorTableViewController.h"

@interface RefineSearchViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightWage;
@property (weak, nonatomic) IBOutlet UIView *viewWage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightAge;
@property (weak, nonatomic) IBOutlet UIView *viewAge;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightBodyArt;
@property (weak, nonatomic) IBOutlet UIView *viewBodyArt;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightEducation;
@property (weak, nonatomic) IBOutlet UIView *viewEducation;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightOppYouth;
@property (weak, nonatomic) IBOutlet UIView *viewOppYouth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightLicense;
@property (weak, nonatomic) IBOutlet UIView *viewLicense;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightVeteran;
@property (weak, nonatomic) IBOutlet UIView *viewVeteran;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightLanguage;
@property (weak, nonatomic) IBOutlet UIView *viewLanguage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightExperience;
@property (weak, nonatomic) IBOutlet UIView *viewExperience;
@property (weak, nonatomic) IBOutlet UIButton *btnWage;
@property (weak, nonatomic) IBOutlet UIButton *btnAge;
@property (weak, nonatomic) IBOutlet UIButton *btnBodyArt;
@property (weak, nonatomic) IBOutlet UIButton *btnEducation;
@property (weak, nonatomic) IBOutlet UIButton *btnOppYouth;
@property (weak, nonatomic) IBOutlet UIButton *btnLicense;
@property (weak, nonatomic) IBOutlet UIButton *btnVeteran;
@property (weak, nonatomic) IBOutlet UIButton *btnLanguage;
@property (weak, nonatomic) IBOutlet UIButton *btnExperience;
@property (strong, nonatomic) NSMutableDictionary *params;
@property (weak, nonatomic) IBOutlet UIButton *btnHourly;
@property (weak, nonatomic) IBOutlet UIButton *btnTipped;
@property (weak, nonatomic) IBOutlet UIButton *btnAge1;
@property (weak, nonatomic) IBOutlet UIButton *btnAge2;
@property (weak, nonatomic) IBOutlet UIButton *btnAge3;
@property (weak, nonatomic) IBOutlet UIButton *btnNoTattoo;
@property (weak, nonatomic) IBOutlet UIButton *btnNoFacePiercing;
@property (weak, nonatomic) IBOutlet UIButton *btnNoTonguePiercing;
@property (weak, nonatomic) IBOutlet UIButton *btnNoGuages;
@property (weak, nonatomic) IBOutlet UIButton *btnNoMinEdu;
@property (weak, nonatomic) IBOutlet UIButton *btnAttendHS;
@property (weak, nonatomic) IBOutlet UIButton *btnGradHS;
@property (weak, nonatomic) IBOutlet UIButton *btnSomeCollege;
@property (weak, nonatomic) IBOutlet UIButton *btnAttendingCollege;
@property (weak, nonatomic) IBOutlet UIButton *btnGradCollege;
@property (weak, nonatomic) IBOutlet UIButton *btnSpecificSchool;
@property (weak, nonatomic) IBOutlet UIButton *btnOppYouthReq;
@property (weak, nonatomic) IBOutlet UIButton *btnLicenseReq;
@property (weak, nonatomic) IBOutlet UIButton *btnVeteranReq;
@property (weak, nonatomic) IBOutlet UITextField *txtHourly;
@property (weak, nonatomic) IBOutlet UITextField *txtSpecificSchool;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightSpecificSchool;
@property (weak, nonatomic) IBOutlet UIButton *addLanguage;
@property (weak, nonatomic) IBOutlet UILabel *lblLanguages;
@property (nonatomic, strong) NSMutableDictionary *langDict;



@end

@implementation RefineSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.params = [[NSMutableDictionary alloc] init];
    self.btnAge1.selected = YES;
    self.btnAge2.selected = YES;
    self.btnAge3.selected = YES;
    if ([[self.searchparms objectForKey:@"age_1"] intValue] == 0) {
        self.btnAge1.selected = NO;
    }
    if ([[self.searchparms objectForKey:@"age_2"] intValue] == 0) {
        self.btnAge2.selected = NO;
    }
    if ([[self.searchparms objectForKey:@"age_3"] intValue] == 0) {
        self.btnAge3.selected = NO;
    }
    if ([[self.searchparms objectForKey:@"bodyart_1"] intValue] == 1) {
        self.btnNoTattoo.selected = NO;
    }
    if ([[self.searchparms objectForKey:@"bodyart_2"] intValue] == 1) {
        self.btnNoFacePiercing.selected = NO;
    }
    if ([[self.searchparms objectForKey:@"bodyart_3"] intValue] == 1) {
        self.btnNoTonguePiercing.selected = NO;
    }
    if ([[self.searchparms objectForKey:@"bodyart_4"] intValue] == 1) {
        self.btnNoGuages.selected = NO;
    }
    if ([[self.searchparms objectForKey:@"education[]"] intValue] == 1) {
        self.btnNoMinEdu.selected = YES;
    }
    if ([[self.searchparms objectForKey:@"education[]"] intValue] == 2) {
        self.btnAttendHS.selected = YES;
    }
    if ([[self.searchparms objectForKey:@"education[]"] intValue] == 3) {
        self.btnGradHS.selected = YES;
    }
    if ([[self.searchparms objectForKey:@"education[]"] intValue] == 4) {
        self.btnSomeCollege.selected = YES;
    }
    if ([[self.searchparms objectForKey:@"education[]"] intValue] == 5) {
        self.btnAttendingCollege.selected = YES;
    }
    if ([[self.searchparms objectForKey:@"education[]"]isEqualToString:@"6"]) {
        self.btnGradCollege.selected = YES;
    }
    if ([[self.searchparms objectForKey:@"school"]length] >0) {
        self.btnSpecificSchool.selected = YES;
        self.txtSpecificSchool.text = [self.searchparms objectForKey:@"school"];
    }
    if ([[self.searchparms objectForKey:@"opp_youth"] intValue] == 1) {
        self.btnOppYouthReq.selected = YES;
    }
    if ([[self.searchparms objectForKey:@"license"] intValue] == 1) {
        self.btnLicenseReq.selected = YES;
    }
    if ([[self.searchparms objectForKey:@"veteran"] intValue] == 1) {
        self.btnVeteranReq.selected = YES;
    }
    if([[self.searchparms objectForKey:@"hours"] intValue] == 1) {
        self.btnHourly.selected = YES;
    }
    else {
        self.btnTipped.selected = YES;
    }
    [self.params setObject:[self.searchparms objectForKey:@"exp_positions[]"] forKey:@"exp_positions[]"];
    if ([[self.searchparms objectForKey:@"exp_required"] intValue] == 0) {
        // self.btnExpNo.selected = YES;
    }
    self.txtHourly.text = [self.searchparms objectForKey:@"hourly_wage"];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"\nRefine Search:\n%@",self.appDelegate.user);
    
    if(!self.langDict) {
        self.langDict = [NSMutableDictionary new];
        
        NSArray *languages = [self.searchparms objectForKey:@"languages[]"];
        NSString *displayString = @"";
        for(NSDictionary *dict in languages) {
            [self.langDict setObject:[dict objectForKey:@"description"] forKey:[dict objectForKey:@"id"]];
            if([displayString length] >0) {
                displayString = [displayString stringByAppendingString:@", "];
            }
            displayString = [displayString stringByAppendingString:[dict objectForKey:@"description"]];
        }
        [self SelectionMade:self.langDict displayString:displayString];
    }
    self.heightWage.constant = 0;
    self.viewWage.alpha = 0;
    self.heightAge.constant = 0;
    self.viewAge.alpha = 0;
    self.heightBodyArt.constant = 0;
    self.viewBodyArt.alpha = 0;
    self.heightEducation.constant = 0;
    self.viewEducation.alpha = 0;
    self.heightOppYouth.constant = 0;
    self.viewOppYouth.alpha = 0;
    self.heightLicense.constant = 0;
    self.viewLicense.alpha = 0;
    self.heightVeteran.constant = 0;
    self.viewVeteran.alpha = 0;
    self.heightLanguage.constant = 0;
    self.viewLanguage.alpha = 0;
    self.heightExperience.constant = 0;
    self.viewExperience.alpha = 0;
    if([self.lblLanguages.text length] > 0) {
        [self.addLanguage setTitle:@"Modify Languages" forState:UIControlStateNormal];
        self.heightLanguage.constant = 100;
        self.viewLanguage.alpha = 1;
    }
    [self.view layoutIfNeeded];
    [self.params setObject:[self.searchparms objectForKey:@"industry"] forKey:@"industry"];
    [self.params setObject:[self.searchparms objectForKey:@"position"] forKey:@"position"];
    [self.params setObject:[self.searchparms objectForKey:@"zip"] forKey:@"zip"];
    [self.params setObject:[self.searchparms objectForKey:@"hours"] forKey:@"hours"];
    [self.params setObject:@"1" forKey:@"refine"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)changeCheckBox:(UIButton *)sender {
    [sender setSelected:!sender.selected];
}
- (IBAction)pressWage:(id)sender {
    if (self.btnWage.selected == YES) {
    self.heightWage.constant = 100;
    [UIView animateWithDuration:.15 animations:^{
        [self.view layoutIfNeeded];}
     
                     completion:^ (BOOL finished)
     {
         if (finished) {
             [UIView animateWithDuration:.15 animations:^{
                 self.viewWage.alpha = 1;
                 [self.view layoutIfNeeded];}];
         }
     }];
    }
    else {
        [UIView animateWithDuration:.15 animations:^{
            self.viewWage.alpha = 0;
            [self.view layoutIfNeeded];}
         
                         completion:^ (BOOL finished)
         {
             if (finished) {
                 self.heightWage.constant = 0;
                 [UIView animateWithDuration:.15 animations:^{
                     [self.view layoutIfNeeded];}];
             }
         }];
    }
}
- (IBAction)pressAge:(id)sender {
    if (self.btnAge.selected == YES) {
    self.heightAge.constant = 100;
    [UIView animateWithDuration:.15 animations:^{
        [self.view layoutIfNeeded];}
     
                     completion:^ (BOOL finished)
     {
         if (finished) {
             [UIView animateWithDuration:.15 animations:^{
                 self.viewAge.alpha = 1;
                 [self.view layoutIfNeeded];}];
         }
     }];
    }
    else {
        [UIView animateWithDuration:.15 animations:^{
            self.viewAge.alpha = 0;
            [self.view layoutIfNeeded];}
         
                         completion:^ (BOOL finished)
         {
             if (finished) {
                 self.heightAge.constant = 0;
                 [UIView animateWithDuration:.15 animations:^{
                     [self.view layoutIfNeeded];}];
             }
         }];
    }
}
- (IBAction)pressBodyArt:(id)sender {
    if (self.btnBodyArt.selected == YES) {
    self.heightBodyArt.constant = 200;
    [UIView animateWithDuration:.15 animations:^{
        [self.view layoutIfNeeded];}
     
                     completion:^ (BOOL finished)
     {
         if (finished) {
             [UIView animateWithDuration:.15 animations:^{
                 self.viewBodyArt.alpha = 1;
                 [self.view layoutIfNeeded];}];
         }
     }];
    }
    else {
        [UIView animateWithDuration:.15 animations:^{
            self.viewBodyArt.alpha = 0;
            [self.view layoutIfNeeded];}
         
                         completion:^ (BOOL finished)
         {
             if (finished) {
                 self.heightBodyArt.constant = 0;
                 [UIView animateWithDuration:.15 animations:^{
                     [self.view layoutIfNeeded];}];
             }
         }];
    }
}
- (IBAction)pressEducation:(id)sender {
    self.heightSpecificSchool.constant = 0;
    self.txtSpecificSchool.alpha = 0;
    if (self.btnEducation.selected == YES) {
    self.heightEducation.constant = 200;
    [UIView animateWithDuration:.15 animations:^{
        [self.view layoutIfNeeded];}
     
                     completion:^ (BOOL finished)
     {
         if (finished) {
             [UIView animateWithDuration:.15 animations:^{
                 self.viewEducation.alpha = 1;
                 [self.view layoutIfNeeded];}];
         }
     }];
    }
    else {
        [UIView animateWithDuration:.15 animations:^{
            self.viewEducation.alpha = 0;
            [self.view layoutIfNeeded];}
         
                         completion:^ (BOOL finished)
         {
             if (finished) {
                 self.heightEducation.constant = 0;
                 [UIView animateWithDuration:.15 animations:^{
                     [self.view layoutIfNeeded];}];
             }
         }];
    }
}
- (IBAction)pressOppYouth:(id)sender {
    if (self.btnOppYouth.selected == YES) {
    self.heightOppYouth.constant = 100;
    [UIView animateWithDuration:.15 animations:^{
        [self.view layoutIfNeeded];}
     
                     completion:^ (BOOL finished)
     {
         if (finished) {
             [UIView animateWithDuration:.15 animations:^{
                 self.viewOppYouth.alpha = 1;
                 [self.view layoutIfNeeded];}];
         }
     }];
    }
    else {
        [UIView animateWithDuration:.15 animations:^{
            self.viewOppYouth.alpha = 0;
            [self.view layoutIfNeeded];}
         
                         completion:^ (BOOL finished)
         {
             if (finished) {
                 self.heightOppYouth.constant = 0;
                 [UIView animateWithDuration:.15 animations:^{
                     [self.view layoutIfNeeded];}];
             }
         }];
    }
}
- (IBAction)pressLicense:(id)sender {
    if (self.btnLicense.selected == YES) {
    self.heightLicense.constant = 100;
    [UIView animateWithDuration:.15 animations:^{
        [self.view layoutIfNeeded];}
     
                     completion:^ (BOOL finished)
     {
         if (finished) {
             [UIView animateWithDuration:.15 animations:^{
                 self.viewLicense.alpha = 1;
                 [self.view layoutIfNeeded];}];
         }
     }];
    }
    else {
        [UIView animateWithDuration:.15 animations:^{
            self.viewLicense.alpha = 0;
            [self.view layoutIfNeeded];}
         
                         completion:^ (BOOL finished)
         {
             if (finished) {
                 self.heightLicense.constant = 0;
                 [UIView animateWithDuration:.15 animations:^{
                     [self.view layoutIfNeeded];}];
             }
         }];
    }
}
- (IBAction)pressVeteran:(id)sender {
    if (self.btnVeteran.selected == YES) {
    self.heightVeteran.constant = 100;
    [UIView animateWithDuration:.15 animations:^{
        [self.view layoutIfNeeded];}
     
                     completion:^ (BOOL finished)
     {
         if (finished) {
             [UIView animateWithDuration:.15 animations:^{
                 self.viewVeteran.alpha = 1;
                 [self.view layoutIfNeeded];}];
         }
     }];
    }
    else {
        [UIView animateWithDuration:.15 animations:^{
            self.viewVeteran.alpha = 0;
            [self.view layoutIfNeeded];}
         
                         completion:^ (BOOL finished)
         {
             if (finished) {
                 self.heightVeteran.constant = 0;
                 [UIView animateWithDuration:.15 animations:^{
                     [self.view layoutIfNeeded];}];
             }
         }];
    }
}
- (IBAction)pressLanguage:(id)sender {
    if (self.btnLanguage.selected == YES) {
    self.heightLanguage.constant = 100;
    [UIView animateWithDuration:.15 animations:^{
        [self.view layoutIfNeeded];}
     
                     completion:^ (BOOL finished)
     {
         if (finished) {
             [UIView animateWithDuration:.15 animations:^{
                 self.viewLanguage.alpha = 1;
                 [self.view layoutIfNeeded];}];
         }
     }];
    }
    else {
        [UIView animateWithDuration:.15 animations:^{
            self.viewLanguage.alpha = 0;
            [self.view layoutIfNeeded];}
         
                         completion:^ (BOOL finished)
         {
             if (finished) {
                 self.heightLanguage.constant = 0;
                 [UIView animateWithDuration:.15 animations:^{
                     [self.view layoutIfNeeded];}];
             }
         }];
    }
}
- (IBAction)addLanguagePress:(id)sender {
    ListMultiSelectorTableViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"ListMultiSelector"];
    
    
    [myController setParameters:nil];
    [myController setUrl:@"http://uwurk.tscserver.com/api/v1/languages"];
    [myController setDisplay:@"description"];
    [myController setKey:@"id"];
    [myController setDelegate:self];
    [myController setJsonGroup:@"languages"];
    [myController setTitle:@"Lauguages"];
    [myController setIdDict:self.langDict];
    
    [self.navigationController pushViewController:myController animated:TRUE];
    
}

-(void) SelectionMade:(NSMutableDictionary *)dict displayString:(NSString *)displayString {
    self.lblLanguages.text = displayString;
    self.langDict = dict;
}
- (IBAction)pressSpecificSchool:(id)sender {
    if (self.btnSpecificSchool.selected == YES) {
        self.heightSpecificSchool.constant = 20;
        [UIView animateWithDuration:.15 animations:^{
            [self.view layoutIfNeeded];}
         
                         completion:^ (BOOL finished)
         {
             if (finished) {
                 [UIView animateWithDuration:.15 animations:^{
                     self.txtSpecificSchool.alpha = 1;}];
             }
         }];
    }
    else {
        [UIView animateWithDuration:.15 animations:^{
            self.txtSpecificSchool.alpha = 0;
        }
         
                         completion:^ (BOOL finished)
         {
             if (finished) {
                 self.heightSpecificSchool.constant = 0;
                 [UIView animateWithDuration:.15 animations:^{
                     [self.view layoutIfNeeded];}];
             }
         }];
    }
}
- (IBAction)pressExperience:(id)sender {
    
    UITableViewController *myController = [[UIStoryboard storyboardWithName:@"GeneralViews" bundle:nil] instantiateViewControllerWithIdentifier:@"IndustryPositionViewController"];
    [self.navigationController pushViewController:myController animated:YES];

    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)pressUpdate:(id)sender {
    if (self.btnHourly.selected == YES) {
        [self.params setObject:self.txtHourly.text forKey:@"hourly_wage"];
        [self.params setObject:@"1" forKey:@"hours"];
    }
    if (self.btnTipped.selected == YES) {
        [self.params setObject:@"2" forKey:@"hours"];
    }
    [self updateParamDict:self.params value:self.btnAge1.selected ? @"1" : @"0" key:@"age_1"];
    [self updateParamDict:self.params value:self.btnAge2.selected ? @"1" : @"0" key:@"age_2"];
    [self updateParamDict:self.params value:self.btnAge3.selected ? @"1" : @"0" key:@"age_3"];
    [self updateParamDict:self.params value:self.btnNoTattoo.selected ? @"1" : @"0" key:@"bodyart_1"];
    [self updateParamDict:self.params value:self.btnNoFacePiercing.selected ? @"1" : @"0" key:@"bodyart_2"];
    [self updateParamDict:self.params value:self.btnNoTonguePiercing.selected ? @"1" : @"0" key:@"bodyart_3"];
    [self updateParamDict:self.params value:self.btnNoGuages.selected ? @"1" : @"0" key:@"bodyart_4"];
    if (self.btnNoMinEdu.selected == YES) {
        [self.params setObject:@"1" forKey:@"education[]"];
    }
    if (self.btnAttendHS.selected == YES) {
        [self.params setObject:@"2" forKey:@"education[]"];
    }
    if (self.btnGradHS.selected == YES) {
        [self.params setObject:@"3" forKey:@"education[]"];
    }
    if (self.btnSomeCollege.selected == YES) {
        [self.params setObject:@"4" forKey:@"education[]"];
    }
    if (self.btnAttendingCollege.selected == YES) {
        [self.params setObject:@"5" forKey:@"education[]"];
    }
    if (self.btnGradCollege.selected == YES) {
        [self.params setObject:@"6" forKey:@"education[]"];
    }
    if (self.btnSpecificSchool.selected == YES) {
        [self.params setObject:self.txtSpecificSchool forKey:@"school"];
    }
    [self updateParamDict:self.params value:self.btnOppYouthReq.selected ? @"1" : @"0" key:@"opp_youth"];
    [self updateParamDict:self.params value:self.btnLicenseReq.selected ? @"1" : @"0" key:@"license"];
    [self updateParamDict:self.params value:self.btnVeteranReq.selected ? @"1" : @"0" key:@"veteran"];
    if([self.lblLanguages.text length] > 0) {
        [self.params setObject:self.langDict.allKeys forKey:@"languages"];
    }
    SearchResultsTableViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"employeeListID"];
    [myController setParameters:self.params];
    [myController setUrl:@"http://uwurk.tscserver.com/api/v1/search"];
    [self.navigationController pushViewController:myController animated:TRUE];
}

@end
