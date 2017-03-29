//
//  EmployeeStep3ViewController.m
//  uWurk2
//
//  Created by Avery Bonner on 9/4/15.
//  Copyright (c) 2015 Michael Brown. All rights reserved.
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
@property (weak, nonatomic) IBOutlet UILabel *lblLanguages;
@property (nonatomic, strong) NSMutableDictionary *langDict;

@end

@implementation EmployeeStep3ViewController

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

-(void) SelectionMade:(NSMutableDictionary *)dict displayString:(NSString *)displayString
{
    self.lblLanguages.text = displayString;
    self.langDict = dict;
    
    [self.appDelegate.user setObject:displayString forKey:@"languages_display"];
//    [self.appDelegate.user setObject:dict forKey:@"languages_dictionary"];
}

//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    return 0;
//}

//// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    LanguageSpokenCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LanguageSpoken" forIndexPath:indexPath];
//    if (!cell) {
//        cell = [[LanguageSpokenCollectionViewCell alloc] init];
//    }
//    cell.delegate = self;
//    return cell;
//}
//
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    
//}
//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    if(indexPath.row == 0)
//        return CGSizeMake(260, 260);
//    else
//        return CGSizeMake(120, 120);
//}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    if([[self.appDelegate.user objectForKey:@"has_drivers_license"]intValue] == 1){
        self.btnDLYes.selected = TRUE;
    } else {
        self.btnDLNo.selected = TRUE;
    }
    if([[self.appDelegate.user objectForKey:@"is_veteran"]intValue] == 1){
        self.btnVetYes.selected = TRUE;
    } else {
        self.btnVetNo.selected = TRUE;
    }
    if([[self.appDelegate.user objectForKey:@"fluent_english"]intValue] == 1){
        self.btnFluEngYes.selected = TRUE;
    } else {
        self.btnFluEngNo.selected = TRUE;
    }
    if([self.appDelegate.user objectForKey:@"languages_display"]) {
        [self.lblLanguages setText:[self.appDelegate.user objectForKey:@"languages_display"]];
    } else {
        [self.lblLanguages setText:@""];
    }
    //    if([self.appDelegate.user objectForKey:@"languages_dictionary"]) {
    //        NSDictionary *tempDict = [self.appDelegate.user objectForKey:@"languages_dictionary"];
    //        self.langDict = [tempDict mutableCopy];
    //    }
    if([[self.appDelegate.user objectForKey:@"has_body_art"]intValue] == 1){
        self.btnBodyArtYes.selected = TRUE;
        [self pressYesBdyArt:self.btnBodyArtYes];
    } else {
        self.btnBodyArtNo.selected = TRUE;
        [self pressNoBdyArt:self.btnBodyArtNo];
    }
    if([[self.appDelegate.user objectForKey:@"has_facial_piercing"]intValue] == 1){
        self.btnFacialPiercing.selected = TRUE;
    } else {
        self.btnFacialPiercing.selected = FALSE;
    }
    if([[self.appDelegate.user objectForKey:@"has_tattoo"]intValue] == 1){
        self.btnTattoo.selected = TRUE;
    } else {
        self.btnTattoo.selected = FALSE;
    }
    if([[self.appDelegate.user objectForKey:@"has_tongue_piercing"]intValue] == 1){
        self.btnTonguePiercing.selected = TRUE;
    } else {
        self.btnTonguePiercing.selected = FALSE;
    }
    if([[self.appDelegate.user objectForKey:@"has_ear_gauges"]intValue] == 1){
        self.btnEarGauges.selected = TRUE;
    } else {
        self.btnEarGauges.selected = FALSE;
    }
    
    if(!self.langDict & 0) {
        self.langDict = [[NSMutableDictionary alloc]init];
        
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
    
    if([self.lblLanguages.text length] > 0) {
        [self.addLanguage setTitle:@"Modify Languages" forState:UIControlStateNormal];
        [self.appDelegate.user setObject:self.lblLanguages.text forKey:@"languages_display"];
    } else {
        [self.addLanguage setTitle:@"Add Languages" forState:UIControlStateNormal];
        [self.appDelegate.user setObject:@"" forKey:@"languages_display"];
    }
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.viewCool.layer.cornerRadius = 5;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
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
    [self.appDelegate.user setObject:self.btnDLYes.selected ? @"1" : @"0" forKey:@"has_drivers_license"];
    [self.appDelegate.user setObject:self.btnVetYes.selected ? @"1" : @"0" forKey:@"is_veteran"];
    [self.appDelegate.user setObject:self.btnFluEngYes.selected ? @"1" : @"0" forKey:@"fluent_english"];
    [self.appDelegate.user setObject:self.lblLanguages.text forKey:@"languages_display"];
//    [self.appDelegate.user setObject:self.langDict forKey:@"languages_dictionary"];
    [self.appDelegate.user setObject:self.btnBodyArtYes.selected ? @"1" : @"0" forKey:@"has_body_art"];
    [self.appDelegate.user setObject:self.btnFacialPiercing.selected ? @"1" : @"0" forKey:@"has_facial_piercing"];
    [self.appDelegate.user setObject:self.btnTattoo.selected ? @"1" : @"0" forKey:@"has_tattoo"];
    [self.appDelegate.user setObject:self.btnTonguePiercing.selected ? @"1" : @"0" forKey:@"has_tongue_piercing"];
    [self.appDelegate.user setObject:self.btnEarGauges.selected ? @"1" : @"0" forKey:@"has_ear_gauges"];
    
    [self saveUserDefault:[self objectToJsonString:self.appDelegate.user]
                      Key:@"user_data"];

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
//        [params setObject:self.langDict.allKeys forKey:@"other_languages"];
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
                
                // Update the user object
                
                
                UIViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"EmployeeProfileSetup4"];
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
        UIViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"EmployeeProfileSetup4"];
        [self.navigationController pushViewController:myController animated:TRUE];
    }
}
}

@end

@interface LanguageSpokenCollectionViewCell()
@end

@implementation LanguageSpokenCollectionViewCell

@end


