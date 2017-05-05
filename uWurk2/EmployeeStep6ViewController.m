//
//  EmployeeStep6ViewController.m
//  
//
//  Created by Avery Bonner on 11/22/15.
//  Copyright (c) 2017 Jim Bonner. All rights reserved.
//
//

#import "EmployeeStep6ViewController.h"
#import "UrlImageRequest.h"

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

@property (weak, nonatomic) NSMutableDictionary *photoDict;
@property (weak, nonatomic) UIImage  *photoImage;

@property BOOL performDbmsInit;

@end

@implementation EmployeeStep6ViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    self.photoImageView.layer.borderWidth = 1;
    self.photoImageView.layer.borderColor = [UIColor blackColor].CGColor;
    
    self.bioTextView.layer.borderWidth = 1;
    self.bioTextView.layer.borderColor = [UIColor blackColor].CGColor;
    
    [self saveStepNumber:6 completion:^(NSInteger result) { }];
    
    self.performDbmsInit = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"\nEmployee Step 6 - Init:\n%@",self.appDelegate.user);
    
    if(self.performDbmsInit) {
        self.performDbmsInit = NO;
        NSMutableArray *photoArray = [self.appDelegate.user objectForKey:@"photos"];
        if([photoArray count] > 0) {
            self.photoImage = [self loadPhotoImageFromServerUsingUrl:photoArray];
            self.photoImageView.image = self.photoImage;
        } else {
            self.photoImageView.image = [UIImage imageNamed:@"PhotoNotAvailable.png"];
        }
        
        [self.bioTextView setText:[self.appDelegate.user objectForKey:@"biography"]];
    }
    self.btnPhotoAdd.alpha = 1.0;
    self.cnstrntImageHeight.constant = 200.0;
    self.photoImageView.alpha = 1.0;

    self.cnstrntBioTextHeight.constant = 173.0;
    self.bioTextView.alpha = 1.0;
    
    [self.view layoutIfNeeded];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (IBAction)btnPhoto:(UIButton*)sender
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
    [self.photoImageView setImage:self.photoImage];
    self.photoImageView.alpha = 1.0;
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
    NSMutableString *Error = [[NSMutableString alloc] init];
    [Error appendString:@"To continue, complete the missing information:"];
    if ((self.btnPhotoSkip.selected == NO) && (self.photoImage == nil))
    {
        [Error appendString:@"\n\nSelect Photo or Select Skip"];
    }
    if ((self.btnBioSkip.selected == NO) && (self.bioTextView.text.length == 0))
    {
        [Error appendString:@"\n\nEnter Bio or Select Skip"];
    }
    if ((Error.length) > 50)
    {
        [self handleErrorWithMessage:Error];
    } else {
        [self savePhotoDataToDbms];
    }
}

NSString *returnString;
UIImage  *returnImage;

- (void)savePhotoDataToDbms
{
    if(self.btnPhotoSkip.selected == NO) {
        NSData *imageData = UIImageJPEGRepresentation(self.photoImage, 0.5);
        AFHTTPRequestOperationManager *manager = [self getManager];
        [manager POST:@"http://uwurk.tscserver.com/api/v1/photos"
           parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
         {
             [formData appendPartWithFileData:imageData name:@"photo_file" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
         } success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSLog(@"\nEmployee Step 6 - Json Photo Response: %@", responseObject);
             if([self validateResponse:responseObject]) {
                 if(self.btnBioSkip.selected == YES) {
                     UIViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"EmployeeLanding"];
                     [self.navigationController setViewControllers:@[myController] animated:YES];
                 } else {
                     [self saveBioDataToDbms];
                 }
             } else {
                 [self handleServerErrorUnableToSaveData:@"Photo"];
             }
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error.description);
             [self handleServerErrorUnableToSaveData:@"Photo"];
         }];
    } else {
        if(self.btnBioSkip.selected) {
            [self saveProfileComplete:^(NSInteger result) {
                if(result == 1) {
                    UIViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"EmployeeLanding"];
                    [self.navigationController setViewControllers:@[myController] animated:YES];
                } else {
                    [self handleServerErrorUnableToSaveData:@"Photo"];
                }
            }];
        } else {
            [self saveBioDataToDbms];
        }
    }
}

- (void)saveBioDataToDbms
{
    if(self.btnBioSkip.selected  == NO) {
        NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
        [self updateParamDict:params value:self.bioTextView.text key:@"biography"];
        AFHTTPRequestOperationManager *manager = [self getManager];
        [manager POST:@"http://uwurk.tscserver.com/api/v1/profile" parameters:params
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSLog(@"\nEmployee Step 6 - Bio Json Response: %@", responseObject);
                [self saveProfileComplete:^(NSInteger result) {
                   if(result == 1) {
                       UIViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"EmployeeLanding"];
                       [self.navigationController setViewControllers:@[myController] animated:YES];
                   } else {
                       [self handleServerErrorUnableToSaveData:@"Biography"];
                   }
               }];
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
             [self handleServerErrorUnableToSaveData:@"Biography"];
         }];
    } else {
        [self saveStepNumber:6 completion:^(NSInteger result) {
            if(result == 1) {
                UIViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"EmployeeLanding"];
                [self.navigationController setViewControllers:@[myController] animated:YES];
            } else {
                [self handleServerErrorUnableToSaveData:@"Biography"];
            }
        }];
    }
}

UIImage *image;

- (UIImage *)loadPhotoImageFromServerUsingUrl:(NSMutableArray *)photoArray
{
    image = nil;
    
    for(NSDictionary *photoDict in photoArray) {
        if([[photoDict objectForKey:@"for_profile"] intValue] == 1) {
            NSURL *photoURL =[self serverUrlWith:[photoDict objectForKey:@"url"]];
            
            UrlImageRequest *photoRequest = [[UrlImageRequest alloc]initWithURL:photoURL];
            
            [photoRequest startWithCompletion:^(UIImage *newImage, NSError *error) {
                if(newImage) {
                    image = newImage;
                }
            }];
        }
    }
    
    return image;
}

@end
