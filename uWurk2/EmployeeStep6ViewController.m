//
//  EmployeeStep6ViewController.m
//  
//
//  Created by Avery Bonner on 11/22/15.
//
//

#import "EmployeeStep6ViewController.h"

@interface EmployeeStep6ViewController () 
@property (weak, nonatomic) IBOutlet UIView *viewBio;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cnstrntBioTipHeight;
@property (weak, nonatomic) IBOutlet UIView *viewBioTip;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cnstrntPhotoTipHeight;
@property (weak, nonatomic) IBOutlet UIView *viewPhotoTip;
@property (weak, nonatomic) IBOutlet UIButton *btnPhotoSkip;
@property (weak, nonatomic) IBOutlet UIButton *btnBioSkip;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) UIImage *photo;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cnstrntPhotoHeight;
@property (weak, nonatomic) IBOutlet UIView *viewPhoto;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cnstrntImageHeight;
@property (weak, nonatomic) IBOutlet UIImageView *imagePhotoView;
@property (weak, nonatomic) IBOutlet UIButton *btnaddphoto;
@property (weak, nonatomic) NSURL *photoLocalURL;
@end

@implementation EmployeeStep6ViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.cnstrntImageHeight.constant = 0;
    self.imagePhotoView.alpha = 0;
    self.viewBio.layer.borderWidth = 1;
    self.viewBio.layer.borderColor = [UIColor blackColor].CGColor;
    self.cnstrntBioTipHeight.constant = 0;
    self.cnstrntPhotoTipHeight.constant = 0;
    self.viewBioTip.alpha = 0;
    self.viewPhotoTip.alpha = 0;
    
    self.photoLocalURL = [NSURL URLWithString:[self.appDelegate.user objectForKey:@"url_string_employee_photo"]];
    if([[self.appDelegate.user objectForKey:@"skip_photo"]intValue] == 1) {
        [self.btnPhotoSkip setSelected:FALSE];
    } else {
        [self.btnPhotoSkip setSelected:TRUE];
    }
    [self pressSkipPhoto:nil];

    if([[self.appDelegate.user objectForKey:@"skip_bio"]intValue] == 1) {
        [self.btnBioSkip setSelected:TRUE];
        [self pressSkipBio:nil];
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
    
    [self.appDelegate.user setObjectOrNil:[self.photoLocalURL absoluteString] forKey:@"url_string_employee_photo"];
     
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
    self.viewPhoto.alpha = 0.0;
    [self.imagePhotoView setImage:self.photo];
    self.cnstrntImageHeight.constant = 200;
    self.imagePhotoView.layer.borderWidth = 3;
    self.imagePhotoView.layer.borderColor = [UIColor blackColor].CGColor;
    self.imagePhotoView.alpha = 1;
    [self.view layoutIfNeeded];
    self.btnaddphoto.alpha = 0;

    self.photoLocalURL = (NSURL *)[info valueForKey:UIImagePickerControllerReferenceURL];
}

- (IBAction)changeCheckBox:(UIButton *)sender {
    [sender setSelected:!sender.selected];
}

- (IBAction)pressSkipPhoto:(id)sender
{
    [self changeCheckBox:self.btnPhotoSkip];
    if (self.btnPhotoSkip.selected == TRUE) {
        self.cnstrntPhotoTipHeight.constant = 0;
        self.viewPhoto.alpha = 0;
        self.viewPhotoTip.alpha = 0;
    } else {
        self.cnstrntPhotoTipHeight.constant = 100;
        self.viewPhoto.alpha = 1;
        self.viewPhotoTip.alpha = 1;
    }
}

- (IBAction)pressSkipBio:(id)sender {
    [self changeCheckBox:self.btnBioSkip];
    if (self.btnBioSkip.selected == TRUE) {
        self.cnstrntBioTipHeight.constant = 100;
        self.viewBio.alpha = 1;
        self.viewBioTip.alpha = 1;
    } else {
        self.cnstrntBioTipHeight.constant = 0;
        self.viewBio.alpha = 0;
        self.viewBioTip.alpha = 0;
    }
}

- (IBAction)nextPress:(id)sender
{
    AFHTTPRequestOperationManager *manager = [self getManager];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [self updateParamDict:params value:self.textView.text key:@"biography"];
    NSMutableString *Error = [[NSMutableString alloc] init];
    [Error appendString:@"To continue, complete the missing information:"];
    if (self.btnBioSkip.selected == NO && self.textView.text.length == 0)
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
