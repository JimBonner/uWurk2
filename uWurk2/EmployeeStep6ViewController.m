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

@property (weak, nonatomic) NSString *photoLocalIdentifier;
@property (weak, nonatomic) UIImage  *photoImage;

//@property (weak, nonatomic) NSString *photoUrlString;

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
    
    self.photoLocalIdentifier = [self.appDelegate.user objectForKey:@"photo_local_Identifier"];
    if(self.photoLocalIdentifier != nil) {
        self.photoImageView.image = [self loadPhotoImageUsingLocalIdentifier:self.photoLocalIdentifier];
    } else {
        self.photoImageView.image = [UIImage imageNamed:@"PhotoNotAvailable.png"];
    }
    
/*    self.photoUrlString = [self.appDelegate.user objectForKey:@"url_string_employee_photo"];
    if(self.photoUrlString != nil) {
        if([self.photoUrlString containsString:@"assets-library:"]) {
            self.photoImageView.image = [self loadPhotoWithAssetString:self.photoUrlString];
        } else if([self.photoUrlString containsString:@"file:"]) {
            self.photoImageView.image = [self loadPhotoWithFileString:self.photoUrlString];
        } else {
            self.photoImageView.image = [UIImage imageNamed:@"PhotoNotAvailable.png"];
        }
    } */
    
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
    
    [self.appDelegate.user setObjectOrNil:self.photoLocalIdentifier forKey:@"photo_local_identifier"];
    
    [self.appDelegate.user setObjectOrNil:self.bioTextView.text forKey:@"bio_text"];
    
    [self saveUserDefault:[self objectToJsonString:self.appDelegate.user] Key:@"user_data"];
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
    [self.photoImageView setImage:[info objectForKey:@"UIImagePickerControllerOriginalImage"]];
    self.photoImageView.alpha = 1.0;
    [self.view layoutIfNeeded];
    self.photoLocalIdentifier = nil;
    if(picker.sourceType == UIImagePickerControllerSourceTypeSavedPhotosAlbum) {
        self.photoUrlString = [[info valueForKey:UIImagePickerControllerReferenceURL]absoluteString];
    } else if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(self.photoImage,
                                       self,
                                       @selector(image:didFinishSavingWithError:contextInfo:),
                                       nil);
        self.photoUrlString = [self urlStringForLastPhotoInSavedAlbum];
    } else {
        return;
    }
    [self saveUserData];
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
    }
    [self presentViewController:alert animated:TRUE completion:nil];
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
                    NSData *imageData = UIImageJPEGRepresentation(self.photoImage, 0.5);
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

UIImage *returnImage;

- (UIImage *)loadPhotoImageUsingLocalIdentifier:(NSString *)localId
{
    returnImage = nil;
    PHAsset *asset = [[PHAsset fetchAssetsWithLocalIdentifiers:[NSArray arrayWithObject:localId]
                                                       options:nil]lastObject];
    if(asset != nil) {
        CGSize targetSize = CGSizeMake(300.0,300.0);
        PHImageRequestOptions *requestOptions = [[PHImageRequestOptions alloc]init];
        requestOptions.synchronous = YES;
        [[PHImageManager defaultManager]requestImageForAsset:asset targetSize:targetSize contentMode:PHImageContentModeAspectFit options:requestOptions resultHandler:^(UIImage *image, NSDictionary * info) {
            returnImage = image;
        }];
    }
    return returnImage;
}

- (NSString *)localIdentifierOfLastPhotoAsset
{
    PHAsset *asset = nil;
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
    fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    PHFetchResult *fetchResult = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:fetchOptions];
    if (fetchResult != nil && fetchResult.count > 0) {
        asset = [fetchResult lastObject];
    }
    NSString *localID = nil;
    if (asset) {
        localID = asset.localIdentifier;
    }
    return localID;
}

- (UIImage *)loadPhotoWithAssetString:(NSString *)photoUrlString
{
    returnImage = nil;
    NSArray *urlArray = [NSArray arrayWithObject:[NSURL URLWithString:photoUrlString]];
    PHAsset *asset = [[PHAsset fetchAssetsWithALAssetURLs:urlArray options:nil]lastObject];
    if(asset != nil) {
        CGSize targetSize = CGSizeMake(300.0,300.0);
        PHImageRequestOptions *requestOptions = [[PHImageRequestOptions alloc]init];
        requestOptions.synchronous = YES;
        [[PHImageManager defaultManager]requestImageForAsset:asset targetSize:targetSize contentMode:PHImageContentModeAspectFit options:requestOptions resultHandler:^(UIImage *image, NSDictionary * info) {
            returnImage = image;
            }];
    }
    return returnImage;
}

- (UIImage *)loadPhotoWithFileString:(NSString *)photoUrlString
{
    returnImage = nil;
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:photoUrlString]];
//    dispatch_async(dispatch_get_main_queue(), ^{
        returnImage = [UIImage imageWithData:imageData];
//    });
    return returnImage;
}

NSURL *returnURL;

- (NSString *)urlStringForLastPhotoInSavedAlbum
{
    returnURL = nil;
    
    PHAsset *asset = nil;
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
    fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    PHFetchResult *fetchResult = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:fetchOptions];
    if (fetchResult != nil && fetchResult.count > 0) {
        asset = [fetchResult lastObject];
    }
    
    if (asset) {
        PHImageRequestOptions *imageRequestOptions = [[PHImageRequestOptions alloc] init];
        imageRequestOptions.synchronous = YES;
        [[PHImageManager defaultManager] requestImageDataForAsset:asset
                                                          options:imageRequestOptions
                                                    resultHandler:^(NSData *imageData, NSString *dataUTI,
                                                                    UIImageOrientation orientation,
                                                                    NSDictionary *info)
         {
             NSLog(@"info = %@", info);
             if ([info objectForKey:@"PHImageFileURLKey"]) {
                 NSURL *fileURL = [info objectForKey:@"PHImageFileURLKey"];
                 returnURL = [NSURL URLWithString:[fileURL absoluteString]];
             }
         }];
    }
    return [returnURL absoluteString];
}

@end
