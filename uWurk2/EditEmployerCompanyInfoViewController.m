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
#import "UrlImageRequest.h"

@interface EditEmployerCompanyInfoViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txtCompanyName;
@property (weak, nonatomic) IBOutlet UITextField *txtWebsite;
@property (weak, nonatomic) IBOutlet UITextView  *txtCompanyBio;
@property (weak, nonatomic) IBOutlet UIImageView *imagePhotoView;
@property (weak, nonatomic) IBOutlet UIView      *viewTipLogo;
@property (weak, nonatomic) IBOutlet UILabel     *lblCharsRemain;
@property (weak, nonatomic) IBOutlet UIButton    *btnAddPhoto;
@property (weak, nonatomic) IBOutlet UIButton    *btnSave;

@property (weak, nonatomic) UIImage  *photoImage;
@property (weak, nonatomic) NSString *photoUrl;

@property BOOL performInit;

@end

@implementation EditEmployerCompanyInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.performInit = YES;
    
    self.btnSave.enabled = NO;
    
    self.txtCompanyBio.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"\nEmployer Edit Company:\n%@",self.appDelegate.user);
    
    self.viewTipLogo.layer.cornerRadius = 10;
    if(self.performInit) {
        self.performInit = NO;
        [self assignValue:[self.appDelegate.user objectForKey:@"company"] control:self.txtCompanyName];
        [self assignValue:[self.appDelegate.user objectForKey:@"web_site_url"] control:self.txtWebsite];
        NSString *industry = [self.appDelegate.user objectForKey:@"industry"];
        if(industry) {
            [self.btnIndustry setTitle:industry forState:UIControlStateNormal];
        }
        [self.txtCompanyBio setText:[self.appDelegate.user objectForKey:@"company_description"]];
        long len = 2000 - self.txtCompanyBio.text.length;
        self.lblCharsRemain.text=[NSString stringWithFormat:@"%li characters remaining",len];
        if([self.appDelegate.user objectForKey:@"image_url"] != nil) {
            [self loadPhotoImageFromServerUsingUrlString:[self.appDelegate.user objectForKey:@"image_url"] imageView:self.imagePhotoView];
            self.imagePhotoView.tag = 1;
        } else {
            self.imagePhotoView.image = [UIImage imageNamed:@"NoPhotoAvailable.png"];
            self.imagePhotoView.tag = 0;
            self.imagePhotoView.alpha = 0.3;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)textViewDidChange:(UITextView *)txtCompanyBio
{
    long len = 2000 - self.txtCompanyBio.text.length;
    self.lblCharsRemain.text=[NSString stringWithFormat:@"%li characters remaining",len];
    [self checkSaveButton:nil];
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

- (IBAction)industryPress:(id)sender
{
    ListSelectorTableViewController *myController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]  instantiateViewControllerWithIdentifier:@"ListSelector"];
    
    [myController setDelegate:self];
    [myController setParameters:nil];
    [myController setUrl:@"http://uwurk.tscserver.com/api/v1/industries"];
    [myController setDisplay:@"description"];
    [myController setKey:@"id"];
    [myController setDelegate:self];
    [myController setJsonGroup:@"industries"];
    [myController setSender:self.btnIndustry];
    [myController setTitle:@"Industries"];
    [myController setPassThru:@"industries"];
    
    [self.navigationController pushViewController:myController animated:TRUE];
}

- (IBAction)nextPress:(id)sender
{
    NSMutableString *Error = [[NSMutableString alloc] init];
    [Error appendString:@"To continue, complete the missing information:"];
    if(self.txtCompanyName.text.length == 0) {
        [Error appendString:@"\n\nEnter Company Name"];
    }
    if([[self.btnIndustry titleForState:UIControlStateNormal] isEqualToString:@"Select Industry"]) {
        [Error appendString:@"\n\nSelect Industry"];
    }
    if ((Error.length) > 50) {
        [self handleErrorWithMessage:Error];
    } else {
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [self updateParamDict:params value:self.txtCompanyName.text key:@"company"];
        [self updateParamDict:params value:self.txtWebsite.text key:@"web_site_url"];
        [self updateParamDict:params value:[@(self.btnIndustry.tag)stringValue] key:@"industry"];
        [self updateParamDict:params value:self.txtCompanyBio.text key:@"company_description"];
        AFHTTPRequestOperationManager *manager = [self getManager];
        [manager POST:@"http://uwurk.tscserver.com/api/v1/profile" parameters:params
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  NSLog(@"\nEmployer Edit Company Info - Json Response:\n%@", responseObject);
                  if([self validateResponse:responseObject]) {
                      if(self.photoImage == nil) {
                          self.performInit = YES;
                          UIViewController *myController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]  instantiateViewControllerWithIdentifier:@"EmployerLanding"];
                          [self.navigationController setViewControllers:@[myController] animated:YES];
                      } else {
                          NSData *imageData = UIImageJPEGRepresentation(self.photoImage, 0.5);
                          [manager POST:@"http://uwurk.tscserver.com/api/v1/photos"
                             parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                           {
                               [formData appendPartWithFileData:imageData name:@"photo_file" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
                           } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                               NSLog(@"\nEmployer Edit Company Photo - Json Response:\n%@", responseObject);
                               if([self validateResponse:responseObject]) {
                                   self.performInit = YES;
                                   UIViewController *myController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"EmployerLanding"];
                                   [self.navigationController setViewControllers:@[myController] animated:YES];
                               } else {
                                   [self handleErrorUnableToSaveData:@"Company Photo"];
                               }
                           } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                               NSLog(@"Error: %@", error.description);
                               [self handleErrorUnableToSaveData:@"Company Photo"];
                           }];
                      }
                  } else {
                      [self handleErrorJsonResponse:@"Company Information"];
                  }
              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  NSLog(@"Error: %@", error);
                  [self handleErrorAccessError:@"Company Information" withError:error];
              }];
         }
}

- (IBAction)AddPhotoPress:(UIButton *)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.delegate = self;
    
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:nil
                                 message:nil
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction
                      actionWithTitle:@"Photo Library"
                      style:UIAlertActionStyleDefault
                      handler:^(UIAlertAction *action)
                      {
                          UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                          picker.delegate = self;
                          picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                          [alert dismissViewControllerAnimated:YES completion:nil];
                          [self presentViewController:picker animated:true completion:nil];
                      }]];
    [alert addAction:[UIAlertAction
                      actionWithTitle:@"Take Photo"
                      style:UIAlertActionStyleDefault
                      handler:^(UIAlertAction * action)
                      {
                          UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                          picker.delegate = self;
                          picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                          [alert dismissViewControllerAnimated:YES completion:nil];
                          [self presentViewController:picker animated:true completion:nil];
                      }]];
    [alert addAction:[UIAlertAction
                      actionWithTitle:@"Cancel"
                      style:UIAlertActionStyleCancel
                      handler:^(UIAlertAction * action)
                      {
                          [alert dismissViewControllerAnimated:YES completion:nil];
                      }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"%@",info);
    [self dismissViewControllerAnimated:YES completion:nil];
    self.photoImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    [self.imagePhotoView setImage:self.photoImage];
    self.imagePhotoView.alpha = 1.0;
    [self checkSaveButton:nil];
    [self.view layoutIfNeeded];
    if(picker.sourceType == UIImagePickerControllerSourceTypeSavedPhotosAlbum) {
        
    } else if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(self.photoImage,
                                       self,
                                       @selector(image:didFinishSavingWithError:contextInfo:),
                                       nil);
    } else {
        return;
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(NSDictionary *)contextInfo
{
    UIAlertController *alert;
    if (error) {
        alert = [UIAlertController
                 alertControllerWithTitle:@"Oops!"
                 message:@"Save of photo to Photo Album failed"
                 preferredStyle:UIAlertControllerStyleActionSheet];
        [alert addAction:[UIAlertAction
                          actionWithTitle:@"OK"
                          style:UIAlertActionStyleDefault
                          handler:^(UIAlertAction *action)
                          {
                          }]];
        [self presentViewController:alert animated:TRUE completion:nil];
    } else  {
        alert = [UIAlertController
                 alertControllerWithTitle:@"Success!"
                 message:@"Save of photo to Photo Album successful"
                 preferredStyle:UIAlertControllerStyleActionSheet];
        [alert addAction:[UIAlertAction
                          actionWithTitle:@"OK"
                          style:UIAlertActionStyleDefault
                          handler:^(UIAlertAction *action)
                          {
                              
                          }]];
        [self presentViewController:alert animated:TRUE completion:nil];
    }
}

- (IBAction)checkSaveButton:(id)sender
{
    BOOL bSave = YES;
    if(self.txtCompanyName.text.length == 0) {
        bSave = NO;
    } else if([[self.btnIndustry titleForState:UIControlStateNormal] isEqualToString:@"Select Industry"]) {
        bSave = NO;
    }
    self.btnSave.enabled = bSave;
}

- (void)SelectionMade:(NSString *)passThru withDict:(NSDictionary *)dict displayString:(NSString *)displayString;
{
    [self checkSaveButton:nil];
}

@end
