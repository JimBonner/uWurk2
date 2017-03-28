//
//  ProfileStepEdit3ViewController.m
//  uWurk2
//
//  Created by Avery Bonner on 9/16/15.
//  Copyright (c) 2015 Michael Brown. All rights reserved.
//

#import "ProfileEditStep3ViewController.h"
#import "RadioButton.h"
#import "ListMultiSelectorTableViewController.h"

@interface ProfileEditStep3ViewController () <ListMultiSelectorTableViewControllerProtocol>
@property (weak, nonatomic) IBOutlet RadioButton *btnDLYes;
@property (weak, nonatomic) IBOutlet RadioButton *btnDLNo;
@property (weak, nonatomic) IBOutlet RadioButton *btnVetYes;
@property (weak, nonatomic) IBOutlet RadioButton *btnVetNo;
@property (weak, nonatomic) IBOutlet RadioButton *btnFluEngYes;
@property (weak, nonatomic) IBOutlet RadioButton *btnFluEngNo;
@property (weak, nonatomic) IBOutlet RadioButton *btnBodyArtYes;
@property (weak, nonatomic) IBOutlet RadioButton *btnBodyArtNo;
@property (weak, nonatomic) IBOutlet UIButton *btnEarGauges;
@property (weak, nonatomic) IBOutlet UIButton *btnFacialPiercing;
@property (weak, nonatomic) IBOutlet UIButton *btnTattoo;
@property (weak, nonatomic) IBOutlet UIButton *btnTonguePiercing;
@property (weak, nonatomic) IBOutlet UIView *viewBdyArt;
@property (weak, nonatomic) IBOutlet UIButton *addLanguage;
@property (weak, nonatomic) IBOutlet UILabel *lblLanguages;
@property (nonatomic, strong) NSMutableDictionary *langDict;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightBodyArt;
@property (weak, nonatomic) IBOutlet UIView *viewCool;


@end

@implementation ProfileEditStep3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.constraintBdyArtToTop.constant = self.constraintBdyArtToTop.constant;
    //    self.constraintApplyToBdyArt.priority = 500;
    //    self.constraintBdyArtToTop.priority = 999;
    //    self.viewBdyArt.alpha = 0;
    //    [self.view layoutIfNeeded];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
        self.viewCool.layer.cornerRadius = 5;
    if([[self.appDelegate.user objectForKey:@"has_drivers_license"] intValue] == 1)
        self.btnDLYes.selected = TRUE;
    else if([[self.appDelegate.user objectForKey:@"has_drivers_license"] intValue] == 0)
        self.btnDLNo.selected = TRUE;
    if([[self.appDelegate.user objectForKey:@"is_veteran"] intValue] == 1)
        self.btnVetYes.selected = TRUE;
    else if([[self.appDelegate.user objectForKey:@"is_veteran"] intValue] == 0)
        self.btnVetNo.selected = TRUE;
    if([[self.appDelegate.user objectForKey:@"fluent_english"] intValue] == 1)
        self.btnFluEngYes.selected = TRUE;
    else if([[self.appDelegate.user objectForKey:@"fluent_english"] intValue] == 0)
        self.btnFluEngNo.selected = TRUE;
    if([[self.appDelegate.user objectForKey:@"has_body_art"] intValue] == 1)
        self.btnBodyArtYes.selected = TRUE;
    else if([[self.appDelegate.user objectForKey:@"has_body_art"] intValue] == 0)
        self.btnBodyArtNo.selected = TRUE;
    if([[self.appDelegate.user objectForKey:@"has_ear_gauge"] intValue] == 1)
        self.btnEarGauges.selected = TRUE;
    else if([[self.appDelegate.user objectForKey:@"has_ear_gauge"] intValue] == 0)
        self.btnEarGauges.selected = FALSE;
    if([[self.appDelegate.user objectForKey:@"has_facial_piercing"] intValue] == 1)
        self.btnFacialPiercing.selected = TRUE;
    else if([[self.appDelegate.user objectForKey:@"has_facial_piercing"] intValue] == 0)
        self.btnFacialPiercing.selected = FALSE;
    if([[self.appDelegate.user objectForKey:@"has_tattoo"] intValue] == 1)
        self.btnTattoo.selected = TRUE;
    else if([[self.appDelegate.user objectForKey:@"has_tattoo"] intValue] == 0)
        self.btnTattoo.selected = FALSE;
    if([[self.appDelegate.user objectForKey:@"has_tongue_piercing"] intValue] == 1)
        self.btnTonguePiercing.selected = TRUE;
    else if([[self.appDelegate.user objectForKey:@"has_tongue_piercing"] intValue] == 0)
        self.btnTonguePiercing.selected = FALSE;
    if (self.btnBodyArtYes.isSelected) {
        self.heightBodyArt.constant = 333;
        self.viewBdyArt.alpha = 1;
        [self.view layoutIfNeeded];
    }
    else if (self.btnBodyArtNo.isSelected)
    {
        self.heightBodyArt.constant = 0;
        self.viewBdyArt.alpha = 0;
        [self.view layoutIfNeeded];
    }
    
    if(!self.langDict) {
        self.langDict = [NSMutableDictionary new];

        NSArray *languages = [self.appDelegate.user objectForKey:@"languages"];
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
    if ([self.lblLanguages.text length] > 0) {
        [self.addLanguage setTitle:@"Modify Languages" forState:UIControlStateNormal];
    }
    
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)addLanguagePress:(id)sender {
    ListMultiSelectorTableViewController *myController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ListMultiSelector"];
    
    
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


- (IBAction)changeCheckBox:(UIButton *)sender {
    [sender setSelected:!sender.selected];
}
- (IBAction)pressYesBdyArt:(id)sender {
    self.heightBodyArt.constant = 333;
    [UIView animateWithDuration:.3 animations:^{
        [self.view layoutIfNeeded];}
     
                     completion:^ (BOOL finished)
     {
         if (finished) {
             [UIView animateWithDuration:.3 animations:^{
                 self.viewBdyArt.alpha = 1;
                 [self.view layoutIfNeeded];}];
         }
     }];
    
}
- (IBAction)pressNoBdyArt:(id)sender {
    self.btnEarGauges.selected = FALSE;
    self.btnFacialPiercing.selected = FALSE;
    self.btnTattoo.selected = FALSE;
    self.btnTonguePiercing.selected = FALSE;
    [UIView animateWithDuration:.3 animations:^{
        [self.view layoutIfNeeded];
        self.viewBdyArt.alpha = 0;
    }
                     completion:^ (BOOL finished)
     {
         if (finished) {
             self.heightBodyArt.constant = 0;
             [UIView animateWithDuration:.3 animations:^{
                 [self.view layoutIfNeeded];}];
         }
     }];
}


- (IBAction)nextPress:(id)sender {
    // Did data get updated?
    
    AFHTTPRequestOperationManager *manager = [self getManager];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [self updateParamDict:params value:self.btnDLYes.selected ? @"1" : @"0" key:@"has_drivers_license"];
    [self updateParamDict:params value:self.btnVetYes.selected ? @"1" : @"0" key:@"is_veteran"];
    [self updateParamDict:params value:self.btnFluEngYes.selected ? @"1" : @"0" key:@"fluent_english"];
    [self updateParamDict:params value:self.btnBodyArtYes.selected ? @"1" : @"0" key:@"has_body_art"];
    [self updateParamDict:params value:self.btnEarGauges.selected ? @"1" : @"0" key:@"has_ear_gauge"];
    [self updateParamDict:params value:self.btnFacialPiercing.selected ? @"1" : @"0" key:@"has_facial_piercing"];
    [self updateParamDict:params value:self.btnTattoo.selected ? @"1" : @"0" key:@"has_tattoo"];
    [self updateParamDict:params value:self.btnTonguePiercing.selected ? @"1" : @"0" key:@"has_tongue_piercing"];
    if([self.lblLanguages.text length] > 0) {
        [params setObject:self.langDict.allKeys forKey:@"other_languages"];
    }
    NSMutableString *Error = [[NSMutableString alloc] init];
    [Error appendString:@"To continue, complete the missing information:"];
    if (self.btnDLYes.selected == NO && self.btnDLNo.selected == NO) {
        [Error appendString:@"\n\nDriver's License"];
    }
    if (self.btnVetYes.selected == NO && self.btnVetNo.selected == NO) {
        [Error appendString:@"\n\nVeteran Status"];
    }
    if (self.btnFluEngYes.selected == NO && self.btnFluEngNo.selected == NO) {
        [Error appendString:@"\n\nEnglish Fluency"];
    }
    if (self.btnBodyArtYes.selected == NO && self.btnBodyArtNo.selected == NO) {
        [Error appendString:@"\n\nBody Art"];
    }
    if (self.btnBodyArtYes.selected == YES && self.btnEarGauges.selected == NO && self.btnFacialPiercing.selected == NO && self.btnTattoo.selected == NO && self.btnTonguePiercing.selected == NO) {
        [Error appendString:@"\n\nSelect Body Art Type"];
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
        
        if([params count]){
            [manager POST:@"http://uwurk.tscserver.com/api/v1/profile" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"JSON: %@", responseObject);
                if([self validateResponse:responseObject]){
                    [self.navigationController popViewControllerAnimated:YES];
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
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
@end
