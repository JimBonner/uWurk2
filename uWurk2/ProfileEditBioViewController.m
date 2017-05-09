//
//  ProfileEditBioViewController.m
//  uWurk2
//
//  Created by Avery Bonner on 9/17/15.
//  Copyright (c) 2015 Michael Brown. All rights reserved.
//  Copyright (c) 2017 Jim Bonner. All rights reserved.
//

#import "ProfileEditBioViewController.h"

@interface ProfileEditBioViewController ()
@property (weak, nonatomic) IBOutlet UILabel     *charsRemaining;
@property (weak, nonatomic) IBOutlet UITextView  *textView;
@property (weak, nonatomic) IBOutlet UIView      *viewTextView;
@property (weak, nonatomic) IBOutlet UIView      *viewPersonality;
@property (weak, nonatomic) IBOutlet UIButton    *btnSaveChanges;

@end

@implementation ProfileEditBioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"\nEmployee Profile Edit Bio:\n%@",self.appDelegate.user);
    
    self.btnSaveChanges.enabled = NO;
    self.viewPersonality.layer.cornerRadius = 5;
    self.viewTextView.layer.borderWidth = 1;
    self.viewTextView.layer.borderColor = [UIColor blackColor].CGColor;
    [self assignValueTextView:[self.appDelegate.user objectForKey:@"biography"] control:self.textView];
    long len = 2000 - self.textView.text.length;
    self.charsRemaining.text=[NSString stringWithFormat:@"%li characters remaining",len];
}

-(void)textViewDidChange:(UITextView *)textView
{
    long len = 2000 - self.textView.text.length;
    self.charsRemaining.text=[NSString stringWithFormat:@"%li characters remaining",len];
    self.btnSaveChanges.enabled = YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text length] == 0)
    {
        if([textView.text length] != 0)
        {
            return YES;
        }
    }
    else if([[textView text] length] > 1999)
    {
        return NO;
    }
    return YES;
}
- (IBAction)pressSave:(id)sender
{
    // Did data get updated?
    
    AFHTTPRequestOperationManager *manager = [self getManager];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [self updateParamDict:params value:self.textView.text key:@"biography"];
    NSMutableString *Error = [[NSMutableString alloc] init];
    [Error appendString:@"To continue, complete the missing information:"];
    if (self.textView.text.length == 0) {
        [Error appendString:@"\n\nEnter Bio or Select Skip"];
    }
    if ((Error.length) > 50) {
        [self handleErrorWithMessage:Error];
    }
    else {
    if([params count]){
        [manager POST:@"http://uwurk.tscserver.com/api/v1/profile" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            if([self validateResponse:responseObject]){
                UIViewController *myController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"EmployeeLanding"];
                [self.navigationController setViewControllers:@[myController] animated:YES];
            } else {
                [self handleErrorJsonResponse:@"ProfileEditBio"];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            [self handleErrorAccessError:error];
        }];
    }
    else{
        UIViewController *myController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"EmployeeLanding"];
        [self.navigationController setViewControllers:@[myController] animated:YES];
    }
}
}
@end
