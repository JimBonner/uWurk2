//
//  EditEmployerPreferencesViewController.m
//  uWurk2
//
//  Created by Avery Bonner on 2/19/16.
//  Copyright (c) 2016 Michael Brown. All rights reserved.
//  Copyright (c) 2017 Jim Bonner. All rights reserved.
//

#import "EditEmployerPreferencesViewController.h"
#import "ListSelectorTableViewController.h"

@interface EditEmployerPreferencesViewController ()

@property(weak,nonatomic)IBOutlet UIButton *btnLanguage;
@property(weak,nonatomic)IBOutlet UIButton *btnRemoveFavorite;
@property(weak,nonatomic)IBOutlet UIButton *btnRemoveSchool;
@property(weak,nonatomic)IBOutlet UIButton *btnRemovePhoto;
@property(weak,nonatomic)IBOutlet UIButton *btnRemoveSearch;
@property(weak,nonatomic)IBOutlet UIButton *btnSaveChanges;
@property BOOL performInit;

@end

@implementation EditEmployerPreferencesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.performInit = YES;

    self.btnSaveChanges.enabled = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"\nEmployer Edit Preferences:\n%@",self.appDelegate.user);
    
    if(!self.performInit) {
        return;
    }
    self.performInit = NO;
    
    if(([self getUserDefault:@"EmployerPrefLanguage"] != nil) &&
       (![[self getUserDefault:@"EmployerPrefLanguage"] isEqualToString:@"Select Language"])) {
        [self.btnLanguage setTitle:[self getUserDefault:@"EmployerPrefLanguage"] forState:UIControlStateNormal];
    } else {
        [self.btnLanguage setTitle:@"Select Language" forState:UIControlStateNormal];
    }
    if(([self getUserDefault:@"EmployerPrefRemoveFavorite"] != nil) &&
       ([[self getUserDefault:@"EmployerPrefRemoveFavorite"] isEqualToString:@"1"])) {
        [self.btnRemoveFavorite setSelected:YES];
    } else {
        [self.btnRemoveFavorite setSelected:NO];
        
    }
    if(([self getUserDefault:@"EmployerPrefRemoveSchool"] != nil) &&
       [[self getUserDefault:@"EmployerPrefRemoveSchool"] isEqualToString:@"1"]) {
        [self.btnRemoveSchool setSelected:YES];
    } else {
        [self.btnRemoveSchool setSelected:NO];
    }
    if(([self getUserDefault:@"EmployerPrefRemovePhoto"] != nil) &&
       ([[self getUserDefault:@"EmployerPrefRemovePhoto"] isEqualToString:@"1"])) {
        [self.btnRemovePhoto setSelected:YES];
    } else {
        [self.btnRemovePhoto setSelected:NO];
    }
    if(([self getUserDefault:@"EmployerPrefRemoveSearch"] != nil) &&
       ([[self getUserDefault:@"EmployerPrefRemoveSearch"] isEqualToString:@"1"])) {
        [self.btnRemoveSearch setSelected:YES];
    } else {
        [self.btnRemoveSearch setSelected:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)pressLanguage:(id)sender
{
    ListSelectorTableViewController *myController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ListSelector"];
    
    [myController setDelegate:self];
    [myController setParameters:nil];
    [myController setUrl:@"http://uwurk.tscserver.com/api/v1/languages"];
    [myController setDisplay:@"description"];
    [myController setKey:@"id"];
    [myController setJsonGroup:@"languages"];
    [myController setSender:self.btnLanguage];
    [myController setTitle:@"Language"];
    [myController setPassThru:@"languages"];
    
    [self.navigationController pushViewController:myController animated:TRUE];
}

- (IBAction)pressRemoveEmployeeFav:(id)sender
{
}

- (IBAction)pressRemoveContact:(id)sender
{
}

- (IBAction)pressRemoveSchool:(id)sender
{
}

- (IBAction)pressRemovePhoto:(id)sender
{
}

- (IBAction)pressRemoveSavedSearch:(id)sender
{
}

- (IBAction)pressSave:(id)sender
{
    [self saveUserDefault:   self.btnLanguage.titleLabel.text             Key:@"EmployerPrefLanguage"];
    [self saveUserDefault:[@(self.btnRemoveFavorite.selected)stringValue] Key:@"EmployerPrefRemoveFavorite"];
    [self saveUserDefault:[@(self.btnRemoveSchool.selected)stringValue]   Key:@"EmployerPrefRemoveSchool"];
    [self saveUserDefault:[@(self.btnRemovePhoto.selected)stringValue]    Key:@"EmployerPrefRemovePhoto"];
    [self saveUserDefault:[@(self.btnRemoveSearch.selected)stringValue]   Key:@"EmployerPrefRemoveSearch"];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)changeCheckBox:(UIButton *)sender
{
    [sender setSelected:!sender.selected];

    self.btnSaveChanges.enabled = YES;
}

- (void)SelectionMade:(NSString *)passThru withDict:(NSDictionary *)dict displayString:(NSString *)displayString
{
    self.btnSaveChanges.enabled = YES;
}

@end
