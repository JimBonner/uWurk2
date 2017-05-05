
//
//  ProfileEditPreferencesViewController.m
//  uWurk2
//
//  Created by Avery Bonner on 9/17/15.
//  Copyright (c) 2015 Michael Brown. All rights reserved.
//  Copyright (c) 2017 Jim Bonner. All rights reserved.
//

#import "ProfileEditPreferencesViewController.h"
#import "ListSelectorTableViewController.h"

@interface ProfileEditPreferencesViewController ()

@property (strong, nonatomic) IBOutlet UIButton *btnSaveChanges;
@property (strong, nonatomic) IBOutlet UIButton *btnPrefRemoveJob;
@property (strong, nonatomic) IBOutlet UIButton *btnPrefRemoveSchool;
@property (strong, nonatomic) IBOutlet UIButton *btnPrefRemovePhoto;

@property BOOL performInit;

@end

@implementation ProfileEditPreferencesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.btnSaveChanges.enabled = NO;
    
    self. performInit = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(!self.performInit) {
        return;
    }
    
    self.performInit = NO;
    
    if(([self getUserDefault:@"interfaceLanguage"] != nil) &&
      (![[self getUserDefault:@"interfaceLanguage"] isEqualToString:@"Select Language"])) {
        [self.btnLanguage setTitle:[self getUserDefault:@"interfaceLanguage"] forState:UIControlStateNormal];
    } else {
        [self.btnLanguage setTitle:@"Select Language" forState:UIControlStateNormal];
    }
    if(([self getUserDefault:@"prefRemoveJob"] != nil) &&
      ([[self getUserDefault:@"prefRemoveJob"] isEqualToString:@"1"])) {
        [self.btnPrefRemoveJob setSelected:YES];
    } else {
        [self.btnPrefRemoveJob setSelected:NO];
        
    }
    if(([self getUserDefault:@"prefRemoveSchool"] != nil) &&
       [[self getUserDefault:@"prefRemoveSchool"] isEqualToString:@"1"]) {
        [self.btnPrefRemoveSchool setSelected:YES];
    } else {
        [self.btnPrefRemoveSchool setSelected:NO];
    }
    if(([self getUserDefault:@"prefRemovePhoto"] != nil) &&
       ([[self getUserDefault:@"prefRemovePhoto"] isEqualToString:@"1"])) {
        [self.btnPrefRemovePhoto setSelected:YES];
    } else {
        [self.btnPrefRemovePhoto setSelected:NO];
    }
}

- (IBAction)pressRemoveJob:(id)sender
{
    
}

- (IBAction)pressRemoveSchool:(id)sender
{

}

- (IBAction)pressRemovePhoto:(id)sender
{

}

- (IBAction)changeCheckBox:(UIButton *)sender
{
    [sender setSelected:!sender.selected];
    
    self.btnSaveChanges.enabled = YES;
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

- (IBAction)pressSave:(id)sender
{
    NSMutableString *Error = [[NSMutableString alloc] init];
    [Error appendString:@"To continue, complete the missing information:"];
    if([[self.btnLanguage titleForState:UIControlStateNormal]isEqualToString:@"Select Language"]) {
        [Error appendString:@"\n\nSelect Language"];
    }
    if ((Error.length) > 50) {
        [self handleErrorWithMessage:Error];
    } else {
        [self saveUserDefault:[self.btnLanguage titleForState:UIControlStateNormal] Key:@"interfaceLanguage"];
        [self saveUserDefault:self.btnPrefRemoveJob.isSelected?@"1":@"0" Key:@"prefRemoveJob"];
        [self saveUserDefault:self.btnPrefRemoveSchool.isSelected?@"1":@"0" Key:@"prefRemoveSchool"];
        [self saveUserDefault:self.btnPrefRemovePhoto.isSelected?@"1":@"0" Key:@"prefRemovePhoto"];
    }
    
    UIViewController *myController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"EmployeeLanding"];
    [self.navigationController setViewControllers:@[myController] animated:TRUE];
}

- (void)SelectionMade:(NSString *)passThru withDict:(NSDictionary *)dict displayString:(NSString *)displayString
{
    self.btnSaveChanges.enabled = YES;
}

@end
