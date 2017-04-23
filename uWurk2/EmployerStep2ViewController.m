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
    
    self.performInit = YES;
}
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"\nEmployer Step 2 - Init:\n%@",self.appDelegate.user);

    self.viewTipInner.layer.cornerRadius = 10;
    
    if(self.performInit) {
        self.performInit = NO;
        [self assignValue:[self.appDelegate.user objectForKey:@"company"] control:self.txtCompany];
        [self assignValue:[self.appDelegate.user objectForKey:@"web_site_url"] control:self.txtWebsite];
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
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [self updateParamDict:params value:self.txtCompany.text key:@"company"];
        [self updateParamDict:params value:self.txtWebsite.text key:@"web_site_url"];
        [self updateParamDict:params value:[@(self.btnIndustry.tag)stringValue] key:@"industry"];
        if([params count]){
            [manager POST:@"http://uwurk.tscserver.com/api/v1/profile" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                self.performInit = YES;
                NSLog(@"\nEmployer Step 2 - Json Response: %@", responseObject);
                if([self validateResponse:responseObject]){
                    UIViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"EmployerLanding"];
                    [self.navigationController setViewControllers:@[myController] animated:YES];
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
            UIViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"EmployerLanding"];
            [self.navigationController setViewControllers:@[myController] animated:YES];
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
