//
//  EmployeeStep6ViewController.m
//  
//
//  Created by Avery Bonner on 11/22/15.
//
//

#import "EmployeeStep6ViewController.h"

@interface EmployeeStep6ViewController ()

@property (weak, nonatomic) IBOutlet UIButton    *btnPhotoAdd;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIView      *photoSkipView;
@property (weak, nonatomic) IBOutlet UIView      *photoTipView;
@property (weak, nonatomic) IBOutlet UIButton    *btnPhotoSkip;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cnstrntImageHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cnstrntPhotoSkipHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cnstrntPhotoTipHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cnstrntPhotoHeight;

@property (weak, nonatomic) IBOutlet UITextView *bioTextView;
@property (weak, nonatomic) IBOutlet UIView     *bioTipView;
@property (weak, nonatomic) IBOutlet UIButton   *btnBioSkip;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cnstrntBioTextHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cnstrntBioTipHeight;


@property (strong, nonatomic) UIImage *photo;
@property (weak, nonatomic)   NSURL   *photoLocalURL;
@end

@implementation EmployeeStep6ViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    self.photoImageView.layer.borderWidth = 1;
    self.photoImageView.layer.borderColor = [UIColor blackColor].CGColor;
    self.bioTextView.layer.borderWidth = 1;
    self.bioTextView.layer.borderColor = [UIColor blackColor].CGColor;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.photoLocalURL = [NSURL URLWithString:[self.appDelegate.user objectForKey:@"url_string_employee_photo"]];
    
    if([[self.appDelegate.user objectForKey:@"skip_photo"]intValue] == 1) {
        [self.btnPhotoSkip setSelected:FALSE];
    } else {
        [self.btnPhotoSkip setSelected:TRUE];
    }
    [self pressSkipPhoto:nil];

    if([[self.appDelegate.user objectForKey:@"skip_bio"]intValue] == 1) {
        [self.btnBioSkip setSelected:TRUE];
    } else {
        [self.btnBioSkip setSelected:FALSE];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self saveUserData];
}

- (void)saveUserData
{
    [self.appDelegate.user setObjectOrNil:self.btnPhotoSkip.selected ? @"1" : @"0" forKey:@"skip_photo"];
    [self.appDelegate.user setObjectOrNil:self.btnBioSkip.selected ? @"1" : @"0" forKey:@"skip_bio"];
    
    if([self.appDelegate.user objectForKey:@"url_string_employee_photo"] != nil) {
        [self.appDelegate.user setObjectOrNil:[self.photoLocalURL absoluteString] forKey:@"url_string_employee_photo"];
    }
    
    [self.appDelegate.user setObjectOrNil:self.bioTextView.text forKey:@"bio_text"];
    
    [self saveUserDefault:[self objectToJsonString:self.appDelegate.user] Key:@"user_data"];
}

- (IBAction)btnPhoto:(UIButton*)sender
{
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:nil
                                 message:nil
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction
                      actionWithTitle:@"Photo Library"
                      style:UIAlertActionStyleDefault
                      handler:^(UIAlertAction * action)
                      {
                          UIImagePickerController * picker = [[UIImagePickerController alloc] init];
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
                          UIImagePickerController * picker = [[UIImagePickerController alloc] init];
                          picker.delegate = self;
                          picker.sourceType = UIImagePickerControllerSourceTypeCamera;
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
    self.photo = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    [self dismissViewControllerAnimated:YES completion:nil];
    self.cnstrntPhotoHeight.constant = 0;
    self.photoTipView.alpha = 0.0;
    [self.photoImageView setImage:self.photo];
    self.cnstrntImageHeight.constant = 200;
    self.photoImageView.layer.borderWidth = 3;
    self.photoImageView.layer.borderColor = [UIColor blackColor].CGColor;
    self.photoImageView.alpha = 1;
    [self.view layoutIfNeeded];
    self.btnPhotoAdd.alpha = 0;

    self.photoLocalURL = (NSURL *)[info valueForKey:UIImagePickerControllerReferenceURL];
}

- (IBAction)changeCheckBox:(UIButton *)sender {
    [sender setSelected:!sender.selected];
}

- (IBAction)pressSkipPhoto:(id)sender
{
    [self changeCheckBox:self.btnPhotoSkip];
    if (self.btnPhotoSkip.selected == TRUE) {
        self.btnPhotoAdd.alpha = 0.0;
        self.cnstrntImageHeight.constant = 0.0;
        self.photoImageView.alpha = 0.0;
    } else {
        self.btnPhotoAdd.alpha = 1.0;
        self.cnstrntImageHeight.constant = 200.0;
        self.photoImageView.alpha = 1.0;
    }
}

- (IBAction)pressSkipBio:(id)sender
{
    [self changeCheckBox:self.btnBioSkip];
    if (self.btnBioSkip.selected == TRUE) {
        self.cnstrntBioTextHeight.constant = 0.0;
        self.bioTextView.alpha = 0.0;
     } else {
         self.cnstrntBioTextHeight.constant = 173.0;
         self.bioTextView.alpha = 1.0;
    }
    [self.view.layer layoutIfNeeded];
}

- (IBAction)nextPress:(id)sender
{
    AFHTTPRequestOperationManager *manager = [self getManager];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [self updateParamDict:params value:self.bioTextView.text key:@"biography"];
    NSMutableString *Error = [[NSMutableString alloc] init];
    [Error appendString:@"To continue, complete the missing information:"];
    if (self.btnBioSkip.selected == NO && self.bioTextView.text.length == 0)
    {
        [Error appendString:@"\n\nEnter Bio or Select Skip"];
    }
    if ((Error.length) > 50)
    {
        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"OOPS!"
                                                         message:Error
                                                        delegate:self
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles: nil];
        [alert show];
    }
    else
    {
        if([params count])
        {
            [manager POST:@"http://uwurk.tscserver.com/api/v1/profile" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
            {
                NSLog(@"JSON: %@", responseObject);
                if([self validateResponse:responseObject]){
                    NSData *imageData = UIImageJPEGRepresentation(self.photo, 0.5);
                    [manager POST:@"http://uwurk.tscserver.com/api/v1/photos" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                    {
                        [formData appendPartWithFileData:imageData name:@"photo_file" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
                    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        UIViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"EmployeeLanding"];
                        [self.navigationController setViewControllers:@[myController] animated:YES];
                        
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        NSLog(@"Error: %@", error);
                        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Oops!"
                                                                         message:@"Unable to contact server"
                                                                        delegate:self
                                                               cancelButtonTitle:@"OK"
                                                               otherButtonTitles: nil];
                        [alert show];
                    }];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error)
            {
                NSLog(@"Error: %@", error);
                UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Oops!"
                                                                 message:@"Unable to contact server"
                                                                delegate:self
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles: nil];
                [alert show];
            }];
        }
        else
        {
            UIViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"EmployeeLanding"];
            [self.navigationController setViewControllers:@[myController] animated:YES];
        }
    }
}

@end
