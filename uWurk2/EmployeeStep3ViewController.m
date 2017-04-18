//
//  EmployeeStep3ViewController.m
//  uWurk2
//
//  Created by Avery Bonner on 9/4/15.
//  Copyright (c) 2015 Michael Brown. All rights reserved.
//  Copyright (c) 2017 Jim Bonner. All rights reserved.
//

#import "EmployeeStep3ViewController.h"
#import "RadioButton.h"
#import "ListMultiSelectorTableViewController.h"

@interface EmployeeStep3ViewController () //<ListMultiSelectorTableViewControllerProtocol>

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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cnstrntBodyArtHeight;
@property (weak, nonatomic) IBOutlet UIView *viewCool;
@property (weak, nonatomic) IBOutlet UIButton *addLanguage;
@property (weak, nonatomic) IBOutlet UILabel  *lblLanguages;
@property (nonatomic, strong) NSMutableDictionary *langDict;
@property BOOL performLanguagesInit;

@end

@implementation EmployeeStep3ViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.performLanguagesInit = YES;
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.viewCool.layer.cornerRadius = 5;
    
    NSLog(@"Employee Step 3:\n%@",self.appDelegate.user);
    
    if([self.appDelegate.user objectForKey:@"has_drivers_license"]) {
        if([[self.appDelegate.user objectForKey:@"has_drivers_license"]intValue] == 1){
            self.btnDLYes.selected = TRUE;
        } else {
            self.btnDLNo.selected = TRUE;
        }
    }
    if([self.appDelegate.user objectForKey:@"is_veteran"]) {
        if([[self.appDelegate.user objectForKey:@"is_veteran"]intValue] == 1){
            self.btnVetYes.selected = TRUE;
        } else {
            self.btnVetNo.selected = TRUE;
        }
    }
    if([self.appDelegate.user objectForKey:@"fluent_english"]) {
        if([[self.appDelegate.user objectForKey:@"fluent_english"]intValue] == 1){
            self.btnFluEngYes.selected = TRUE;
        } else {
            self.btnFluEngNo.selected = TRUE;
        }
    }
    if(self.performLanguagesInit) {
        self.langDict = [[NSMutableDictionary alloc]init];
        NSString *display = @"";
        if([self.appDelegate.user objectForKey:@"languages"] != nil) {
            if([[self.appDelegate.user objectForKey:@"languages"]count] > 0) {
                for(id dict in [self.appDelegate.user objectForKey:@"languages"]) {
                    if([display length] > 0) {
                        display = [display stringByAppendingString:@", "];
                    }
                    display = [display stringByAppendingString:[dict objectForKey:@"description"]];
                    [self.langDict setObject:[dict objectForKey:@"description"]
                                      forKey:[[NSNumber numberWithInt:[[dict objectForKey:@"id"]intValue]]   stringValue]];
                }
                self.lblLanguages.text = display;
            }
        }
    }
    self.performLanguagesInit = NO;
    if([self.lblLanguages.text length] > 0) {
        [self.addLanguage setTitle:@"Modify Languages" forState:UIControlStateNormal];
    }else {
        [self.addLanguage setTitle:@"Add Languages" forState:UIControlStateNormal];
    }
    if([self.appDelegate.user objectForKey:@"has_body_art"]) {
        if([[self.appDelegate.user objectForKey:@"has_body_art"]intValue] == 1){
            self.btnBodyArtYes.selected = TRUE;
            [self pressYesBdyArt:self.btnBodyArtYes];
        } else {
            self.btnBodyArtNo.selected = TRUE;
            [self pressNoBdyArt:self.btnBodyArtNo];
        }
    }
    if([self.appDelegate.user objectForKey:@"has_facial_piercing"]) {
        if([[self.appDelegate.user objectForKey:@"has_facial_piercing"]intValue] == 1){
            self.btnFacialPiercing.selected = TRUE;
        } else {
            self.btnFacialPiercing.selected = FALSE;
        }
    }
    if([self.appDelegate.user objectForKey:@"has_tattoo"]) {

        if([[self.appDelegate.user objectForKey:@"has_tattoo"]intValue] == 1){
            self.btnTattoo.selected = TRUE;
        } else {
            self.btnTattoo.selected = FALSE;
        }
    }
    if([self.appDelegate.user objectForKey:@"has_tongue_piercing"]){
        if([[self.appDelegate.user objectForKey:@"has_tongue_piercing"]intValue] == 1){
            self.btnTonguePiercing.selected = TRUE;
        } else {
            self.btnTonguePiercing.selected = FALSE;
        }
    }
    if([self.appDelegate.user objectForKey:@"has_ear_gauges"]){
        if([[self.appDelegate.user objectForKey:@"has_ear_gauges"]intValue] == 1){
            self.btnEarGauges.selected = TRUE;
        } else {
            self.btnEarGauges.selected = FALSE;
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (IBAction)changeCheckBox:(UIButton *)sender
{
    [sender setSelected:!sender.selected];
}
- (IBAction)pressYesBdyArt:(id)sender {
    self.cnstrntBodyArtHeight.constant = 333;
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
- (IBAction)pressNoBdyArt:(id)sender
{
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
             self.cnstrntBodyArtHeight.constant = 0;
             [UIView animateWithDuration:.3 animations:^{
                 [self.view layoutIfNeeded];}];
         }
     }];
}

- (IBAction)nextPress:(id)sender
{
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
        NSArray *allKeys = [self.langDict allKeys];
        long count = [allKeys count];
        for(long icnt = 0; icnt < count; icnt++) {
            NSString *ident = [allKeys objectAtIndex:icnt];
            [self updateParamDict:params value:ident
                              key:[NSString stringWithFormat:@"other_languages[%ld]",icnt]];
        }
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
        if([params count]){
            [manager POST:@"http://uwurk.tscserver.com/api/v1/profile" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"JSON: %@", responseObject);
                if([self validateResponse:responseObject]){
                    self.performLanguagesInit = YES;
                    UIViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"EmployeeProfileSetup4"];
                    [self.navigationController pushViewController:myController animated:TRUE];
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
        }
        else{
            UIViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"EmployeeProfileSetup4"];
            [self.navigationController pushViewController:myController animated:TRUE];
        }
    }
}

- (void)saveScreenData
{
    if(self.btnDLYes.isSelected) {
        [self.appDelegate.user setObject:@"1" forKey:@"has_drivers_license"];
    } else {
        [self.appDelegate.user setObject:@"0" forKey:@"has_drivers_license"];
    }
    if(self.btnVetYes.isSelected) {
        [self.appDelegate.user setObject:@"1" forKey:@"is_veteran"];
    } else {
        [self.appDelegate.user setObject:@"0" forKey:@"is_veteran"];
    }
    if(self.btnFluEngYes.isSelected) {
        [self.appDelegate.user setObject:@"1" forKey:@"fluent_english"];
    } else {
        [self.appDelegate.user setObject:@"0" forKey:@"fluent_english"];
    }
    if(self.btnBodyArtYes.isSelected) {
        [self.appDelegate.user setObject:@"1" forKey:@"has_body_art"];
    } else {
        [self.appDelegate.user setObject:@"0" forKey:@"has_body_art"];
    }
    if(self.btnTattoo.isSelected) {
        [self.appDelegate.user setObject:@"1" forKey:@"has_tattoo"];
    } else {
        [self.appDelegate.user setObject:@"0" forKey:@"has_tattoo"];
    }
    if(self.btnFacialPiercing.isSelected) {
        [self.appDelegate.user setObject:@"1" forKey:@"has_facial_piercing"];
    } else {
        [self.appDelegate.user setObject:@"0" forKey:@"has_facial_piercing"];
    }
    if(self.btnEarGauges.isSelected) {
        [self.appDelegate.user setObject:@"1" forKey:@"has_ear_gauge"];
    } else {
        [self.appDelegate.user setObject:@"0" forKey:@"has_ear_gauge"];
    }
    if(self.btnTonguePiercing.isSelected) {
        [self.appDelegate.user setObject:@"1" forKey:@"has_tounge_piercing"];
    } else {
        [self.appDelegate.user setObject:@"0" forKey:@"has_tounge_piercing"];
    }
}

- (IBAction)addLanguagePress:(id)sender
{
    [self saveScreenData];
    
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

- (void)SelectionMade:(NSString *)passThru withDict:(NSMutableDictionary *)dict displayString:(NSString *)displayString
{
    self.lblLanguages.text = displayString;
    self.langDict = dict;
}

- (NSMutableDictionary *)buildLanguageDictionaryFromArray:(NSMutableArray *)langArray
{
    NSMutableDictionary *langDict =[[NSMutableDictionary alloc]init];
    
    return langDict;
}

- (NSMutableArray *)buildLanguageArrayFromDictionary:(NSMutableDictionary *)langDict
{
    NSMutableArray *langArray = [[NSMutableArray alloc]init];
    NSArray *allKeys = [langDict allKeys];
    for(NSString *key in allKeys) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        long value = (long)[key intValue];
        [dict setValue:@(value) forKey:@"id"];
        [dict setObject:[langDict objectForKey:key] forKey:@"description"];
        [langArray addObject:dict];
    }
    return langArray;
}

@end

@interface LanguageSpokenCollectionViewCell()
@end

@implementation LanguageSpokenCollectionViewCell

@end


