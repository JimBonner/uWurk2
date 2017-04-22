//
//  EditEmployerCompanyInfoViewController.m
//  uWurk2
//
//  Created by Avery Bonner on 2/19/16.
//  Copyright (c) 2016 Michael Brown. All rights reserved.
//  Copyright (c) 2017 Jim Bonner. All rights reserved.
//

#import "EditEmployerCompanyInfoViewController.h"
#import "ListSelectorTableViewController.h"

@interface EditEmployerCompanyInfoViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txtCompanyName;
@property (weak, nonatomic) IBOutlet UITextField *txtWebsite;
@property (weak, nonatomic) IBOutlet UIButton *btnIndustry;
@property (weak, nonatomic) IBOutlet UITextView *txtCompanyBio;
@property (weak, nonatomic) IBOutlet UIImageView *imagePhotoView;
@property (weak, nonatomic) IBOutlet UIView *viewTipLogo;
@property (weak, nonatomic) IBOutlet UILabel *lblCharsRemain;

@end

@implementation EditEmployerCompanyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.viewTipLogo.layer.cornerRadius = 10;
    [self assignValue:[self.appDelegate.user objectForKey:@"company"] control:self.txtCompanyName];
    [self assignValue:[self.appDelegate.user objectForKey:@"web_site_url"] control:self.txtWebsite];
    long len = 2000 - self.txtCompanyBio.text.length;
    self.lblCharsRemain.text=[NSString stringWithFormat:@"%li characters remaining",len];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)textViewDidChange:(UITextView *)txtCompanyBio
{
    long len = 2000 - self.txtCompanyBio.text.length;
    self.lblCharsRemain.text=[NSString stringWithFormat:@"%li characters remaining",len];
}

- (BOOL)textView:(UITextView *)txtCompanyBio shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text length] == 0)
    {
        if([txtCompanyBio.text length] != 0)
        {
            return YES;
        }
    }
    else if([[txtCompanyBio text] length] > 1999)
    {
        return NO;
    }
    return YES;
}
- (IBAction)industryPress:(id)sender {
    
    ListSelectorTableViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"ListSelector"];
    
    
    [myController setParameters:nil];
    [myController setUrl:@"http://uwurk.tscserver.com/api/v1/industries"];
    [myController setDisplay:@"description"];
    [myController setKey:@"id"];
    [myController setDelegate:self];
    [myController setJsonGroup:@"industries"];
    [myController setSender:self.btnIndustry];
    [myController setTitle:@"Industries"];
    
    [self.navigationController pushViewController:myController animated:TRUE];
    
}
- (IBAction)nextPress:(id)sender {
//    AFHTTPRequestOperationManager *manager = [self getManager];
//    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
//    [self updateParamDict:params value:self.textView.text key:@"biography"];
//    NSMutableString *Error = [[NSMutableString alloc] init];
//    [Error appendString:@"To continue, complete the missing information:"];
//    if (self.btnBioSkip.selected == NO && self.textView.text.length == 0) {
//        [Error appendString:@"\n\nEnter Bio or Select Skip"];
//    }
//    if ((Error.length) > 50) {
//    UIAlertController * alert = [UIAlertController
//                                 alertControllerWithTitle:@"Oops!"
//                                 message:Error
//                                 preferredStyle:UIAlertControllerStyleActionSheet];
//    [alert addAction:[UIAlertAction
//                      actionWithTitle:@"OK"
//                      style:UIAlertActionStyleDefault
//                      handler:^(UIAlertAction *action)
//                      {
//                      }]];
//    [self presentViewController:alert animated:TRUE completion:nil];
//    }
//    else {
//        if([params count]){
//            [manager POST:@"http://uwurk.tscserver.com/api/v1/profile" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                NSLog(@"JSON: %@", responseObject);
//                if([self validateResponse:responseObject]){
//                    NSData *imageData = UIImageJPEGRepresentation(self.photo, 0.5);
//                    [manager POST:@"http://uwurk.tscserver.com/api/v1/photos" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//                        [formData appendPartWithFileData:imageData name:@"photo_file" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
//                    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                        UIViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"EmployeeLanding"];
//                        [self.navigationController setViewControllers:@[myController] animated:YES];
//                        
//                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                        NSLog(@"Error: %@", error);
//    UIAlertController * alert = [UIAlertController
//                                 alertControllerWithTitle:@"Oops!"
//                                 message:@"Unable to contact server"
//                                 preferredStyle:UIAlertControllerStyleActionSheet];
//    [alert addAction:[UIAlertAction
//                      actionWithTitle:@"OK"
//                      style:UIAlertActionStyleDefault
//                      handler:^(UIAlertAction *action)
//                      {
//                      }]];
//    [self presentViewController:alert animated:TRUE completion:nil];
//                    }];
//                }
//            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                NSLog(@"Error: %@", error);
//    UIAlertController * alert = [UIAlertController
//                                 alertControllerWithTitle:@"Oops!"
//                                 message:@"Unable to contact server"
//                                 preferredStyle:UIAlertControllerStyleActionSheet];
//    [alert addAction:[UIAlertAction
//                      actionWithTitle:@"OK"
//                      style:UIAlertActionStyleDefault
//                      handler:^(UIAlertAction *action)
//                      {
//                      }]];
//    [self presentViewController:alert animated:TRUE completion:nil];
//            }];
//        }
//        else{
//            UIViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"EmployeeLanding"];
//            [self.navigationController setViewControllers:@[myController] animated:YES];
//        }
//    }
}
@end
