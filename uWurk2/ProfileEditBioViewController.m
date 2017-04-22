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
@property (weak, nonatomic) IBOutlet UILabel *charsRemaining;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIView *viewTextView;
@property (weak, nonatomic) IBOutlet UIView *viewPersonality;
@property (weak, nonatomic) IBOutlet UIButton *btnSaveChanges;

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

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.btnSaveChanges.enabled = NO;
    self.viewPersonality.layer.cornerRadius = 5;
    self.viewTextView.layer.borderWidth = 1;
    self.viewTextView.layer.borderColor = [UIColor blackColor].CGColor;
///    [self assignValue:[self.appDelegate.user objectForKey:@"biography"] control:self.textView];
    long len = 2000 - self.textView.text.length;
    self.charsRemaining.text=[NSString stringWithFormat:@"%li characters remaining",len];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
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
- (IBAction)pressSave:(id)sender {
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
    }
    else {
    if([params count]){
        [manager POST:@"http://uwurk.tscserver.com/api/v1/profile" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            if([self validateResponse:responseObject]){
                
                // Update the user object
                
                
                UIViewController *myController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"EmployeeLanding"];
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
        UIViewController *myController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"EmployeeLanding"];
        [self.navigationController setViewControllers:@[myController] animated:YES];
    }
}
}
@end
