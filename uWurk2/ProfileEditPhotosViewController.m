//
//  ProfileEditPhotosViewController.m
//  uWurk2
//
//  Created by Rob Bonner on 12/25/15.
//  Copyright (c) 2015 Michael Brown. All rights reserved.
//  Copyright (c) 2017 Jim Bonner. All rights reserved.
//

#import "ProfileEditPhotosViewController.h"
#import "UrlImageRequest.h"
#import "PhotoImageView.h"

@interface ProfileEditPhotosViewController ()
    <ProfileAddPhotoCollectionViewCellDelegate,
     ProfileExistingPhotoCollectionViewCellDelegate,
     UIImagePickerControllerDelegate,
     UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet PhotoImageView     *imgMain;
@property (weak, nonatomic) IBOutlet UICollectionView   *imagesCollection;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageCollectionViewHeight;
@property (weak, nonatomic) IBOutlet UIView *viewPhotoTip;
@property (strong, nonatomic) NSMutableArray *photoArray;

@end

@implementation ProfileEditPhotosViewController 

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"\nEmployee Profile Edit Photos:\n%@",self.appDelegate.user);

    self.viewPhotoTip.layer.cornerRadius = 10;
    
    [self alignUserPhotoArray];
    
    [self.imagesCollection reloadData];
    
}
- (IBAction)saveChanges:(id)sender
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    for(int i = 0; i < [self.photoArray count]; ++i) {
        NSDictionary *photoDict = [self.photoArray objectAtIndex:i];
        if(i == 0) {
            [self updateParamDict:params value:[photoDict objectForKey:@"id"] key:@"profile_photo_id"];
        }
        [self updateParamDict:params value:[photoDict objectForKey:@"id"] key:[NSString stringWithFormat:@"photo[%d]", i]];
    }
    AFHTTPRequestOperationManager *manager = [self getManager];
    [manager POST:@"http://uwurk.tscserver.com/api/v1/photos" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [manager POST:@"http://uwurk.tscserver.com/api/v1/profile" parameters:nil
              success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
                  NSLog(@"Profile Edit Profile - Json Response: %@", responseObject);
                  if([self validateResponse:responseObject]){
                      [self.navigationController popViewControllerAnimated:TRUE];
                  } else {
                      [self handleErrorJsonResponse:@"Profile Edit Photos"];
                  }
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  [self handleErrorAccessError:@"Profile Edit Photos" withError:error];
              }
         ];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [self handleErrorAccessError:@"Profile Edit Photos" withError:error];
    }];
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath willMoveToIndexPath:(NSIndexPath *)toIndexPath
{
    id object = [self.photoArray objectAtIndex:fromIndexPath.item];
    [self.photoArray removeObjectAtIndex:fromIndexPath.item];
    [self.photoArray insertObject:object atIndex:toIndexPath.item];
}


- (void)alignUserPhotoArray
{
    self.photoArray = [NSMutableArray arrayWithArray:[[self.appDelegate user] objectForKey:@"photos"]];
    for(int i=0; i < [self.photoArray count]; ++i) {
        NSDictionary *photoDict = [self.photoArray objectAtIndex:i];
        if([[photoDict objectForKey:@"for_profile"] intValue] == 1) {
            NSURL *photoURL =[NSURL URLWithString:[NSString stringWithFormat:@"http://uwurk.tscserver.com%@",[photoDict objectForKey:@"url"]]];
            [self.imgMain loadPhoto:photoURL];
            break;
        }
    }
    float n = self.photoArray.count + 1;
    int nCount = ceil(n / 2);
    
    self.imageCollectionViewHeight.constant = 260 + 20  + (((nCount) * 120) + 10);
}

- (void)addBoarder:(UIImageView*)view
{
    view.layer.borderColor = [UIColor colorWithWhite:1.0f alpha:1.0f].CGColor;
    view.layer.borderWidth = 2.0f; //make border 1px thick
}

#pragma mark Collection View Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.photoArray count] + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row < [self.photoArray count] ) {
        ProfileExistingPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EmployeePhotoCell" forIndexPath:indexPath];
        if (!cell) {
            cell = [[ProfileExistingPhotoCollectionViewCell alloc] init];
        }
        cell.delegate = self;
        NSDictionary *photoDict = [self.photoArray objectAtIndex:indexPath.row];
        NSURL *photoURL =[NSURL URLWithString:[NSString stringWithFormat:@"http://uwurk.tscserver.com%@",[photoDict objectForKey:@"url"]]];
        UrlImageRequest *photoRequest = [[UrlImageRequest alloc]initWithURL:photoURL];
        cell.photoID = [[photoDict objectForKey:@"id"]stringValue];
        [photoRequest startWithCompletion:^(UIImage *newImage, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [cell.img setImage:newImage];
            });
        }];
        return cell;
    } else {
        ProfileAddPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EmployeeAddPhotoCell" forIndexPath:indexPath];
        if (!cell) {
            cell = [[ProfileAddPhotoCollectionViewCell alloc] init];
        }
        cell.delegate = self;
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0) {
        return CGSizeMake(260, 260);
    } else {
        return CGSizeMake(120, 120);
    }
}

- (void)addImage
{
    NSLog(@"Add Image Press");
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil
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

- (void)moveItemAtIndexPath:(NSIndexPath *)indexPath
                toIndexPath:(NSIndexPath *)newIndexPath
{
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    AFHTTPRequestOperationManager *manager = [self getManager];
    [manager POST:@"http://uwurk.tscserver.com/api/v1/photos" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:UIImageJPEGRepresentation([info objectForKey:@"UIImagePickerControllerOriginalImage"], 0.5) name:@"photo_file" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [manager POST:@"http://uwurk.tscserver.com/api/v1/profile" parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
            NSLog(@"String: %@", operation.responseString);
            if([self validateResponse:responseObject]){
                [self alignUserPhotoArray];
                [self.imagesCollection reloadData];
            } else {
                [self handleErrorJsonResponse:@"Profile Edit Photos"];
            }
        }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [self handleErrorAccessError:@"Profile Edit Photos" withError:error];
        }];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [self handleErrorAccessError:@"Profile Edit Photos" withError:error];
    }];
}

- (void)removeImage:(NSString *)photoID
{
    if([[self getUserDefault:@"prefRemovePhoto"] intValue] == 1) {
    
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil
                                                                        message:@"Are you sure you want to delete this photo?"
                                                                 preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction
                          actionWithTitle:@"Remove"
                          style:UIAlertActionStyleDefault
                          handler:^(UIAlertAction * action)
                          {
                              NSLog(@"Remove Image Press");
                              AFHTTPRequestOperationManager *manager = [self getManager];
                              
                              NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
                              [self updateParamDict:params value:photoID key:@"delete[]"];
                              [manager POST:@"http://uwurk.tscserver.com/api/v1/photos" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                  [manager POST:@"http://uwurk.tscserver.com/api/v1/profile" parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
                                      NSLog(@"String: %@", operation.responseString);
                                      if([self validateResponse:responseObject]){
                                          [self alignUserPhotoArray];
                                          [self.imagesCollection reloadData];
                                      } else {
                                          [self handleErrorJsonResponse:@"Profile Edit Photos"];
                                      }
                                  }
                                        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                            [self handleErrorValidateLogin];
                                        }
                                   ];
                                  
                              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  NSLog(@"Error: %@", error);
                                  [self handleErrorAccessError:@"Profile Edit Photos" withError:error];
                              }];
                          }]];
        [alert addAction:[UIAlertAction
                          actionWithTitle:@"Cancel"
                          style:UIAlertActionStyleCancel
                          handler:^(UIAlertAction * action)
                          {
                              [alert dismissViewControllerAnimated:YES completion:nil];
                          }]];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [self updateParamDict:params value:photoID key:@"delete[]"];
        AFHTTPRequestOperationManager *manager = [self getManager];
        [manager POST:@"http://uwurk.tscserver.com/api/v1/photos" parameters:params
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 [manager POST:@"http://uwurk.tscserver.com/api/v1/profile" parameters:nil
                      success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
                          NSLog(@"Json: %@", responseObject);
                          if([self validateResponse:responseObject]){
                              [self alignUserPhotoArray];
                              [self.imagesCollection reloadData];
                          } else {
                              [self handleErrorJsonResponse:@"Profile Edit Photos"];
                          }
                       }
                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                           [self handleErrorValidateLogin];
                       }
                  ];
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 NSLog(@"Error: %@", error);
                 [self handleErrorAccessError:@"Profile Edit Photos" withError:error];
             }
         ];
    }
}

@end

@interface ProfileExistingPhotoCollectionViewCell()
@end

@implementation ProfileExistingPhotoCollectionViewCell

- (IBAction)removeButtonTapped:(id)sender
{
    [self.delegate removeImage:self.photoID];
}

@end

@interface ProfileAddPhotoCollectionViewCell()

@end

@implementation ProfileAddPhotoCollectionViewCell

- (IBAction)addButtonTapped:(id)sender
{
    [self.delegate addImage];
}

@end
