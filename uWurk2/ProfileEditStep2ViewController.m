//
//  ProfileEditStep2ViewController.m
//  uWurk2
//
//  Created by Avery Bonner on 9/16/15.
//  Copyright (c) 2015 Michael Brown. All rights reserved.
//

#import "ProfileEditStep2ViewController.h"
#import "AddLocationViewController.h"

@interface ProfileEditStep2ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txtMiles1;
@property (weak, nonatomic) IBOutlet UITextField *txtZip1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cnstrntLoc1Height;
@property (weak, nonatomic) IBOutlet UIView *viewLoc1;
@property (weak, nonatomic) IBOutlet UITextField *txtMiles2;
@property (weak, nonatomic) IBOutlet UITextField *txtZip2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cnstrntLoc2Height;
@property (weak, nonatomic) IBOutlet UIView *viewLoc2;
@property (weak, nonatomic) IBOutlet UITextField *txtMiles3;
@property (weak, nonatomic) IBOutlet UITextField *txtZip3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cnstrntLoc3Height;
@property (weak, nonatomic) IBOutlet UIView *viewLoc3;
@property (weak, nonatomic) IBOutlet UITextField *txtMiles4;
@property (weak, nonatomic) IBOutlet UITextField *txtZip4;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cnstrntLoc4Height;
@property (weak, nonatomic) IBOutlet UIView *viewLoc4;
@property (weak, nonatomic) IBOutlet UITextField *txtMiles5;
@property (weak, nonatomic) IBOutlet UITextField *txtZip5;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cnstrntLoc5Height;
@property (weak, nonatomic) IBOutlet UIView *viewLoc5;
@property (weak, nonatomic) IBOutlet UIButton *btnTips;
@property (weak, nonatomic) IBOutlet UIButton *btnHourly;
@property (weak, nonatomic) IBOutlet UITextField *txtHourly;
@property (strong, nonatomic) NSString *zipcount;
@property (strong, nonatomic) NSString *milescount;
@property (weak, nonatomic) IBOutlet UIButton *btnSaveChanges;
@property (weak, nonatomic) IBOutlet UIView *viewAddZip;
@property (weak, nonatomic) IBOutlet UIButton *btnRemove1;
@property (weak, nonatomic) IBOutlet UIButton *btnRemove2;
@property (weak, nonatomic) IBOutlet UIButton *btnRemove3;
@property (weak, nonatomic) IBOutlet UIButton *btnRemove4;
@property (weak, nonatomic) IBOutlet UIButton *btnRemove5;

@end

@implementation ProfileEditStep2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
-(NSMutableArray *)availabiltyarray1:(NSArray *)array
{
    return [NSMutableArray arrayWithArray:array];
}
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.viewAddZip.layer.cornerRadius = 10;
    self.cnstrntLoc1Height.constant = 0;
    self.cnstrntLoc2Height.constant = 0;
    self.cnstrntLoc3Height.constant = 0;
    self.cnstrntLoc4Height.constant = 0;
    self.cnstrntLoc5Height.constant = 0;
    self.viewLoc1.alpha = 0;
    self.viewLoc2.alpha = 0;
    self.viewLoc3.alpha = 0;
    self.viewLoc4.alpha = 0;
    self.viewLoc5.alpha = 0;
    self.btnRemove1.alpha = 0;
    self.btnRemove2.alpha = 0;
    self.btnRemove3.alpha = 0;
    self.btnRemove4.alpha = 0;
    self.btnRemove5.alpha = 0;
    self.btnSaveChanges.enabled = NO;
    NSArray *availabilityArray = [self.appDelegate.user objectForKey:@"availability"];
    if([availabilityArray count] >=1) {
        NSDictionary *firstAvailabilityItem = [availabilityArray objectAtIndex:0];
        [self assignValue:[[firstAvailabilityItem objectForKey:@"miles"] stringValue] control:self.txtMiles1];
        [self assignValue:[firstAvailabilityItem objectForKey:@"zip"] control:self.txtZip1];
        self.cnstrntLoc1Height.constant = 60;
        self.viewLoc1.alpha = 1;
        self.milescount = @"miles[1]";
        self.zipcount = @"zip[1]";
        
    }
    if([availabilityArray count] >=2) {
        NSDictionary *secondAvailabilityItem = [availabilityArray objectAtIndex:1];
        [self assignValue:[[secondAvailabilityItem objectForKey:@"miles"] stringValue] control:self.txtMiles2];
        [self assignValue:[secondAvailabilityItem objectForKey:@"zip"] control:self.txtZip2];
        self.cnstrntLoc2Height.constant = 60;
        self.viewLoc2.alpha = 1;
        self.btnRemove1.alpha = 1;
        self.btnRemove2.alpha = 1;
        self.btnRemove3.alpha = 1;
        self.btnRemove4.alpha = 1;
        self.btnRemove5.alpha = 1;
        self.milescount = @"miles[2]";
        self.zipcount = @"zip[2]";
    }
    if([availabilityArray count] >=3) {
        NSDictionary *thirdAvailabilityItem = [availabilityArray objectAtIndex:2];
        [self assignValue:[[thirdAvailabilityItem objectForKey:@"miles"] stringValue] control:self.txtMiles3];
        [self assignValue:[thirdAvailabilityItem objectForKey:@"zip"] control:self.txtZip3];
        self.cnstrntLoc3Height.constant = 60;
        self.viewLoc3.alpha = 1;
        self.milescount = @"miles[3]";
        self.zipcount = @"zip[3]";
    }
    if([availabilityArray count] >=4) {
        NSDictionary *fourthAvailabilityItem = [availabilityArray objectAtIndex:3];
        [self assignValue:[[fourthAvailabilityItem objectForKey:@"miles"] stringValue] control:self.txtMiles4];
        [self assignValue:[fourthAvailabilityItem objectForKey:@"zip"] control:self.txtZip4];
        self.cnstrntLoc4Height.constant = 60;
        self.viewLoc4.alpha = 1;
        self.milescount = @"miles[4]";
        self.zipcount = @"zip[4]";
    }
    if([availabilityArray count] >=5) {
        NSDictionary *fifthAvailabilityItem = [availabilityArray objectAtIndex:4];
        [self assignValue:[fifthAvailabilityItem objectForKey:@"miles"] control:self.txtMiles5];
        [self assignValue:[fifthAvailabilityItem objectForKey:@"zip"] control:self.txtZip5];
        self.cnstrntLoc5Height.constant = 60;
        self.viewLoc5.alpha = 1;
    }
    if([[self.appDelegate.user objectForKey:@"wage_type[]"] isEqualToString:@"hourly"]){
            self.btnHourly.selected = FALSE;
    }
    [self assignValue:[self.appDelegate.user objectForKey:@"hourly_wage"] control:self.txtHourly];
    if ([self.appDelegate.user objectForKey:@"hourly_wage"] == (id)[NSNull null] || [[self.appDelegate.user objectForKey:@"hourly_wage"]length] == 0 ) {
        self.btnHourly.selected = FALSE;
    }
    else {
        self.btnHourly.selected = TRUE;
    }
    if([[self.appDelegate.user objectForKey:@"tipped_position"] intValue] == 0)
        self.btnTips.selected = FALSE;
    
    else if([[self.appDelegate.user objectForKey:@"tipped_position"] intValue] == 1)
        self.btnTips.selected = TRUE;
}
- (IBAction)pressRemove:(UIButton *)sender {
    self.btnSaveChanges.enabled = YES;
    if (sender.tag == 0) {
        self.txtMiles1.text = @"";
        self.txtZip1.text = @"";
        [UIView animateWithDuration:.3 animations:^{
            self.viewLoc1.alpha = 0;
            [self.view layoutIfNeeded];}
         
                         completion:^ (BOOL finished)
         {
             if (finished) {
                 [UIView animateWithDuration:.3 animations:^{
                     self.cnstrntLoc1Height.constant = 0;
                     [self.view layoutIfNeeded];}];
             }
         }];
    }
    if (sender.tag == 1) {
        self.txtMiles2.text = @"";
        self.txtZip2.text = @"";
        [UIView animateWithDuration:.3 animations:^{
            self.viewLoc2.alpha = 0;
            [self.view layoutIfNeeded];}
         
                         completion:^ (BOOL finished)
         {
             if (finished) {
                 [UIView animateWithDuration:.3 animations:^{
                     self.cnstrntLoc2Height.constant = 0;
                     [self.view layoutIfNeeded];}];
             }
         }];
    }
    if (sender.tag == 2) {
        self.txtMiles3.text = @"";
        self.txtZip3.text = @"";
        [UIView animateWithDuration:.3 animations:^{
            self.viewLoc3.alpha = 0;
            [self.view layoutIfNeeded];}
         
                         completion:^ (BOOL finished)
         {
             if (finished) {
                 [UIView animateWithDuration:.3 animations:^{
                     self.cnstrntLoc3Height.constant = 0;
                     [self.view layoutIfNeeded];}];
             }
         }];
    }
    if (sender.tag == 3) {
        self.txtMiles4.text = @"";
        self.txtZip4.text = @"";
        [UIView animateWithDuration:.3 animations:^{
            self.viewLoc4.alpha = 0;
            [self.view layoutIfNeeded];}
         
                         completion:^ (BOOL finished)
         {
             if (finished) {
                 [UIView animateWithDuration:.3 animations:^{
                     self.cnstrntLoc4Height.constant = 0;
                     [self.view layoutIfNeeded];}];
             }
         }];
    }
    if (sender.tag == 4) {
        self.txtMiles5.text = @"";
        self.txtZip5.text = @"";
        [UIView animateWithDuration:.3 animations:^{
            self.viewLoc5.alpha = 0;
            [self.view layoutIfNeeded];}
         
                         completion:^ (BOOL finished)
         {
             if (finished) {
                 [UIView animateWithDuration:.3 animations:^{
                     self.cnstrntLoc5Height.constant = 0;
                     [self.view layoutIfNeeded];}];
             }
         }];
    }
    if (self.txtMiles2.text.length == 0 && self.txtMiles3.text.length == 0 && self.txtMiles4.text.length == 0 && self.txtMiles5.text.length == 0) {
        [UIView animateWithDuration:.3 animations:^{
            self.btnRemove1.alpha = 0;
            [self.view layoutIfNeeded];
        }];
    }
    if (self.txtMiles1.text.length == 0 && self.txtMiles3.text.length == 0 && self.txtMiles4.text.length == 0 && self.txtMiles5.text.length == 0) {
        [UIView animateWithDuration:.3 animations:^{
            self.btnRemove2.alpha = 0;
            [self.view layoutIfNeeded];
        }];
    }
    if (self.txtMiles1.text.length == 0 && self.txtMiles2.text.length == 0 && self.txtMiles4.text.length == 0 && self.txtMiles5.text.length == 0) {
        [UIView animateWithDuration:.3 animations:^{
            self.btnRemove3.alpha = 0;
            [self.view layoutIfNeeded];
        }];
    }
    if (self.txtMiles1.text.length == 0 && self.txtMiles2.text.length == 0 && self.txtMiles3.text.length == 0 && self.txtMiles5.text.length == 0) {
        [UIView animateWithDuration:.3 animations:^{
            self.btnRemove4.alpha = 0;
            [self.view layoutIfNeeded];
        }];
    }
    if (self.txtMiles1.text.length == 0 && self.txtMiles2.text.length == 0 && self.txtMiles3.text.length == 0 && self.txtMiles4.text.length == 0) {
        [UIView animateWithDuration:.3 animations:^{
            self.btnRemove5.alpha = 0;
            [self.view layoutIfNeeded];
        }];
    }
}

- (IBAction)changeSave:(id)sender {
    self.btnSaveChanges.enabled = YES;
}

- (IBAction)changeCheckBox:(UIButton *)sender {
    [sender setSelected:!sender.selected];
    self.btnSaveChanges.enabled = YES;
}
- (IBAction)addLoc:(id)sender {
    AddLocationViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"AddLocation"];
    [myController setZipCode:self.zipcount];
    [myController setMiles:self.milescount];
    [self.navigationController pushViewController:myController animated:TRUE];
}
- (IBAction)nextPress:(id)sender {
    // Did data get updated?
    
    AFHTTPRequestOperationManager *manager = [self getManager];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:self.txtMiles1.text forKey:@"miles[0]"];
    [params setObject:self.txtZip1.text forKey:@"zip[0]"];
    [params setObject:self.txtMiles2.text forKey:@"miles[1]"];
    [params setObject:self.txtZip2.text forKey:@"zip[1]"];
    [params setObject:self.txtMiles3.text forKey:@"miles[2]"];
    [params setObject:self.txtZip3.text forKey:@"zip[2]"];
    [params setObject:self.txtMiles4.text forKey:@"miles[3]"];
    [params setObject:self.txtZip4.text forKey:@"zip[3]"];
    [params setObject:self.txtMiles5.text forKey:@"miles[4]"];
    [params setObject:self.txtZip5.text forKey:@"zip[4]"];
    if (self.btnTips.selected == TRUE) {
        [params setObject:@"tips" forKey:@"wage_type[]"];
    }
    if (self.btnHourly.selected == TRUE) {
        [params setObject:@"hourly" forKey:@"wage_type[]"];
    }
    [params setObject:self.txtHourly.text forKey:@"hourly_wage"];
    [self updateParamDict:params value:self.btnTips.selected ? @"1" : @"0" key:@"tipped_position"];
    NSMutableString *Error = [[NSMutableString alloc] init];
    [Error appendString:@"To continue, complete the missing information:"];
    if (self.btnHourly.selected == YES && self.txtHourly.text.length ==0) {
        [Error appendString:@"\n\nHourly Wage"];
    }
    if (self.btnHourly.selected == NO && self.btnTips.selected == NO) {
        [Error appendString:@"\n\nSelect Wage Type"];
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
                
                
                UIViewController *myController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"EmployeeLanding"];
                [self.navigationController setViewControllers:@[myController] animated:TRUE];
                
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
        UIViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"EmployeeLanding"];
        [self.navigationController setViewControllers:@[myController] animated:TRUE];
    }
}
}
@end
