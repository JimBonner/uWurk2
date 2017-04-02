//
//  ProfileEditPhotosViewController.m
//  uWurk2
//
//  Created by Rob Bonner on 12/25/15.
//  Copyright © 2015 Michael Brown. All rights reserved.
//

#import "ProfileEditPhotosViewController.h"
#import "UrlImageRequest.h"
#import "PhotoImageView.h"

@interface ProfileEditPhotosViewController () <ProfileAddPhotoCollectionViewCellDelegate, ProfileExistingPhotoCollectionViewCellDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet PhotoImageView *imgMain;
@property (strong, nonatomic) NSMutableArray *photoArray;
@property (weak, nonatomic) IBOutlet UICollectionView *imagesCollection;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageCollectionViewHeight;
@property (weak, nonatomic) IBOutlet UIView *viewPhotoTip;


@end

@implementation ProfileEditPhotosViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    UILongPressGestureRecognizer *signInLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
//    [self.view addGestureRecognizer:signInLongPress];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.viewPhotoTip.layer.cornerRadius = 10;
    
    [self alignUserPhotoArray];
    [self.imagesCollection reloadData];
    
}
- (IBAction)saveChanges:(id)sender {
    
    AFHTTPRequestOperationManager *manager = [self getManager];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    for(int i=0; i < [self.photoArray count]; ++i) {
        NSDictionary *photoDict = [self.photoArray objectAtIndex:i];
        if(i == 0) {
            [self updateParamDict:params value:[photoDict objectForKey:@"id"] key:@"profile_photo_id"];
        }
        [self updateParamDict:params value:[photoDict objectForKey:@"id"] key:[NSString stringWithFormat:@"photo[%d]", i]];
    }
    
    
    
    [manager POST:@"http://uwurk.tscserver.com/api/v1/photos" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [manager POST:@"http://uwurk.tscserver.com/api/v1/profile" parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
            NSLog(@"String: %@", operation.responseString);
            
            
            if([self validateResponse:responseObject]){
                [self.navigationController popViewControllerAnimated:TRUE];
            }
        }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Oops!"
                                                                   message:@"Unable to contact server"
                                                                  delegate:self
                                                         cancelButtonTitle:@"OK"
                                                         otherButtonTitles: nil];
                  [alert show];
              }
         ];
        
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

//-(void) handleLongPress:(UILongPressGestureRecognizer *) gesture {
//    switch (gesture.state) {
//        case UIGestureRecognizerStateBegan:{
//            CGPoint point = [gesture locationInView:self.imagesCollection];
//            NSIndexPath *p = [self.imagesCollection indexPathForItemAtPoint:point];
//            [self.imagesCollection beginInteractiveMovementForItemAtIndexPath:p];
//            NSLog (@"Handling - Start");
//            break;
//        }
//        case UIGestureRecognizerStateChanged:
//            [self.imagesCollection updateInteractiveMovementTargetPosition:[gesture locationInView:self.imagesCollection]];
//            NSLog (@"Handling - Changed");
//            break;
//        case UIGestureRecognizerStateEnded:
//            [self.imagesCollection endInteractiveMovement];
//            NSLog (@"Handling - Ended");
//            break;
//        default:
//            [self.imagesCollection cancelInteractiveMovement];
//            NSLog (@"Handling - Default");
//    }
//}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath willMoveToIndexPath:(NSIndexPath *)toIndexPath {
    //NSDictionary *photoItem = [self.photoArray objectAtIndex:fromIndexPath.row];
    id object = [self.photoArray objectAtIndex:fromIndexPath.item];
    [self.photoArray removeObjectAtIndex:fromIndexPath.item];
    [self.photoArray insertObject:object atIndex:toIndexPath.item];
}


- (void)alignUserPhotoArray {
    self.photoArray = [NSMutableArray arrayWithArray:[[self.appDelegate user] objectForKey:@"photos"]];
    for(int i=0; i < [self.photoArray count]; ++i) {
        NSDictionary *photoDict = [self.photoArray objectAtIndex:i];
        if([[photoDict objectForKey:@"for_profile"] intValue] == 1) {
            NSURL *photoURL =[NSURL URLWithString:[NSString stringWithFormat:@"http://uwurk.tscserver.com%@",[photoDict objectForKey:@"url"]]];
            [self.imgMain loadPhoto:photoURL];
            //[self.photoArray removeObjectAtIndex:i];
            break;
        }
    }
    float n = self.photoArray.count +1;
    int nCount = ceil(n / 2);
    
    
    self.imageCollectionViewHeight.constant = 260 + 20  + (((nCount) * 120) + 10);
}

- (void)addBoarder:(UIImageView*)view {
    view.layer.borderColor = [UIColor colorWithWhite:1.0f alpha:1.0f].CGColor;
    view.layer.borderWidth = 2.0f; //make border 1px thick
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark Collection View Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.photoArray count] + 1;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row < [self.photoArray count] ) {
        ProfileExistingPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EmployeePhotoCell" forIndexPath:indexPath];
        if (!cell) {
            cell = [[ProfileExistingPhotoCollectionViewCell alloc] init];
        }
        cell.delegate = self;
        NSDictionary *photoDict = [self.photoArray objectAtIndex:indexPath.row];
        NSURL *photoURL =[NSURL URLWithString:[NSString stringWithFormat:@"http://uwurk.tscserver.com%@",[photoDict objectForKey:@"url"]]];
        UrlImageRequest *photoRequest = [[UrlImageRequest alloc]initWithURL:photoURL];
        cell.photoID = [photoDict objectForKey:@"id"];
        [photoRequest startWithCompletion:^(UIImage *newImage, NSError *error) {
            if(newImage) {
                [cell.img setImage:newImage];
            }
        }];
        return cell;
    }
    else {
        
        ProfileAddPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EmployeeAddPhotoCell" forIndexPath:indexPath];
        if (!cell) {
            cell = [[ProfileAddPhotoCollectionViewCell alloc] init];
        }
        cell.delegate = self;
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0)
        return CGSizeMake(260, 260);
    else
        return CGSizeMake(120, 120);
}
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
//    
//    return UIEdgeInsetsMake(10, 20, 10, 20);
//}

- (void)addImage {
    NSLog(@"Add Image Press");
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    
    UIAlertController * alert=   [UIAlertController
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
                toIndexPath:(NSIndexPath *)newIndexPath {
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self dismissViewControllerAnimated:YES completion:nil];

    // Send photo to server
    AFHTTPRequestOperationManager *manager = [self getManager];
    [manager POST:@"http://uwurk.tscserver.com/api/v1/photos" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:UIImageJPEGRepresentation([info objectForKey:@"UIImagePickerControllerOriginalImage"], 0.5) name:@"photo_file" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
      
        
        [manager POST:@"http://uwurk.tscserver.com/api/v1/profile" parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
            NSLog(@"String: %@", operation.responseString);
            
            
            if([self validateResponse:responseObject]){
                [self alignUserPhotoArray];
                [self.imagesCollection reloadData];
            }
        }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Oops!"
                                                              message:@"Unable to contact server"
                                                             delegate:self
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
             [alert show];
         }
         ];
        
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

- (void)removeImage: (NSString*)photoID {
    
    if([[self getUserDefault:@"prefRemovePhoto"] intValue] == 1) {
    
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:nil
                                  message:@"Are you sure you want to delete this photo?"
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction
                      actionWithTitle:@"Remove"
                      style:UIAlertActionStyleDefault
                      handler:^(UIAlertAction * action)
                      {
                          NSLog(@"Remove Image Press");
                          
                          // Send photo to server
                          AFHTTPRequestOperationManager *manager = [self getManager];
                          
                          NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
                          [self updateParamDict:params value:photoID key:@"delete[]"];
                          
                          [manager POST:@"http://uwurk.tscserver.com/api/v1/photos" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                              
                              [manager POST:@"http://uwurk.tscserver.com/api/v1/profile" parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
                                  NSLog(@"String: %@", operation.responseString);
                                  
                                  
                                  if([self validateResponse:responseObject]){
                                      [self alignUserPhotoArray];
                                      [self.imagesCollection reloadData];
                                  }
                              }
                                    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Oops!"
                                                                                         message:@"Unable to validate login"
                                                                                        delegate:self
                                                                               cancelButtonTitle:@"OK"
                                                                               otherButtonTitles: nil];
                                        [alert show];
                                    }
                               ];
                              
                          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                              NSLog(@"Error: %@", error);
                              UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Oops!"
                                                                               message:@"Unable to contact server"
                                                                              delegate:self
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles: nil];
                              [alert show];
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

    }
    else {
        // Send photo to server
        AFHTTPRequestOperationManager *manager = [self getManager];
        
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [self updateParamDict:params value:photoID key:@"delete[]"];
        
        [manager POST:@"http://uwurk.tscserver.com/api/v1/photos" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [manager POST:@"http://uwurk.tscserver.com/api/v1/profile" parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
                NSLog(@"String: %@", operation.responseString);
                
                
                if([self validateResponse:responseObject]){
                    [self alignUserPhotoArray];
                    [self.imagesCollection reloadData];
                }
            }
                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Oops!"
                                                                       message:@"Unable to validate login"
                                                                      delegate:self
                                                             cancelButtonTitle:@"OK"
                                                             otherButtonTitles: nil];
                      [alert show];
                  }
             ];
            
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
}

@end

@interface ProfileExistingPhotoCollectionViewCell()
@end

@implementation ProfileExistingPhotoCollectionViewCell
- (IBAction)removeButtonTapped:(id)sender {
    [self.delegate removeImage:self.photoID];
}
@end

@interface ProfileAddPhotoCollectionViewCell()

@end

@implementation ProfileAddPhotoCollectionViewCell

- (IBAction)addButtonTapped:(id)sender {
    [self.delegate addImage];
}


@end
