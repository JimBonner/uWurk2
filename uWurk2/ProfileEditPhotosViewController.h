//
//  ProfileEditPhotosViewController.h
//  uWurk2
//
//  Created by Rob Bonner on 12/25/15.
//  Copyright (c) 2015 Michael Brown. All rights reserved.
//  Copyright (c) 2017 Jim Bonner. All rights reserved.
//

#import "BaseViewController.h"

@interface ProfileEditPhotosViewController : BaseViewController

@end


@protocol ProfileExistingPhotoCollectionViewCellDelegate <NSObject>
- (void)removeImage:(NSString*)photoID;
@end

@interface ProfileExistingPhotoCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) id<ProfileExistingPhotoCollectionViewCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (nonatomic, strong) NSString *photoID;

@end

@protocol ProfileAddPhotoCollectionViewCellDelegate <NSObject>
- (void)addImage;
@end

@interface ProfileAddPhotoCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) id<ProfileAddPhotoCollectionViewCellDelegate>delegate;
@end

