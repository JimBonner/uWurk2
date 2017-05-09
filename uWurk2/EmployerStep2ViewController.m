//
//  EmployerStep2ViewController.m
//  uWurk2
//
//  Created by Avery Bonner on 9/4/15.
//  Copyright (c) 2015 Michael Brown. All rights reserved.
//  Copyright (c) 2017 Jim Bonner. All rights reserved.
//

#import "EmployerStep2ViewController.h"
#import "ListSelectorTableViewController.h"

@interface EmployerStep2ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txtCompany;
@property (weak, nonatomic) IBOutlet UIButton *btnIndustry;
@property (weak, nonatomic) IBOutlet UITextField *txtWebsite;
@property (weak, nonatomic) IBOutlet UIView *viewTipOuter;
@property (weak, nonatomic) IBOutlet UIView *viewTipInner;
@property BOOL performInit;

@end

@implementation EmployerStep2ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self saveStepNumber:2 completion:^(NSInteger result) { }];
    
    self.performInit = YES;
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.viewTipInner.layer.cornerRadius = 10;
    
    NSLog(@"\nEmployer Step 2 - Init:\n%@",self.appDelegate.user);
    
    if(self.performInit) {
        self.performInit = NO;
        if(![[self.appDelegate.user objectForKey:@"company"] isEqualToString:@""]) {
            [self assignValue:[self.appDelegate.user objectForKey:@"company"] control:self.txtCompany];
            [self assignValue:[self.appDelegate.user objectForKey:@"web_site_url"] control:self.txtWebsite];
            [self.btnIndustry setTitle:[self.appDelegate.user objectForKey:@"industry"] forState:UIControlStateNormal];
            [self.btnIndustry setTag:[[self.appDelegate.user objectForKey:@"industry_id"]intValue]];
        }
    } else {
        [self restoreScreenData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (IBAction)nextPress:(id)sender
{
    AFHTTPRequestOperationManager *manager = [self getManager];
    NSMutableString *Error = [[NSMutableString alloc] init];
    [Error appendString:@"To continue, complete the missing information:"];
    if (self.txtCompany.text.length == 0) {
        [Error appendString:@"\n\nCompany Name"];
    }
    if ([[self.btnIndustry titleForState:UIControlStateNormal] isEqualToString:@"Select Industry"]) {
        [Error appendString:@"\n\nIndustry"];
    }
    if ((Error.length) > 50) {
        [self handleErrorWithMessage:Error];
    } else {
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [self updateParamDict:params value:self.txtCompany.text key:@"company"];
        [self updateParamDict:params value:self.txtWebsite.text key:@"web_site_url"];
        [self updateParamDict:params value:[@(self.btnIndustry.tag)stringValue] key:@"industry_id"];
        [self updateParamDict:params value:@"2" key:@"setup_step"];
        [self updateParamDict:params value:@"1" key:@"profile_complete"];
        if([params count]){
            [manager POST:@"http://uwurk.tscserver.com/api/v1/profile" parameters:params
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    self.performInit = YES;
                    NSLog(@"\nEmployer Step 2 - Json Response: %@", responseObject);
                    if([self validateResponse:responseObject]) {
                        [self saveStepNumber:-1 completion:^(NSInteger result) {
                            if(result == 1) {
                                UIViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"EmployerLanding"];
                                [self.navigationController setViewControllers:@[myController] animated:YES];
                            } else {
                                [self handleServerErrorUnableToSaveData:@"Step Number"];
                            }
                        }];
                    } else {
                        [self handleErrorJsonResponse:@"EmployerStep2"];
                    }
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        NSLog(@"Error: %@", error);
                        [self handleErrorAccessError:error];
                }];
        } else {
            [self saveStepNumber:-1 completion:^(NSInteger result) {
                if(result == 1) {
                    UIViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"EmployerLanding"];
                    [self.navigationController setViewControllers:@[myController] animated:YES];
                } else {
                    [self handleServerErrorUnableToSaveData:@"Step Number"];
                }
            }];
        }
    }
}

-(void)SelectionMade:(NSString *)passThru withDict:(NSDictionary *)dict displayString:(NSString *)displayString;
{

}

- (void)saveScreenData
{
    [self.appDelegate.user setObject:self.txtCompany.text forKey:@"step2_company"];
    [self.appDelegate.user setObject:self.txtWebsite.text forKey:@"step2_website"];

}
     
- (void)restoreScreenData
{
    [self.txtCompany setText:[self.appDelegate.user objectForKey:@"step2_company"]];
    [self.txtWebsite setText:[self.appDelegate.user objectForKey:@"step2_website"]];
}

@end
