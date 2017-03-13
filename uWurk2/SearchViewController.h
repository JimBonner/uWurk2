//
//  SearchViewController.h
//  uWurk2
//
//  Created by Avery Bonner on 9/8/15.
//  Copyright (c) 2015 Michael Brown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface SearchViewController : BaseViewController

@end

@protocol ExperienceFilterExistingCollectionViewCellDelegate <NSObject>

- (void)removeExperience:(NSString*)experienceID;

@end

@interface ExperienceFilterExistingCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *filterName;
@property (strong, nonatomic) NSString *experienceID;
@property (weak, nonatomic) id<ExperienceFilterExistingCollectionViewCellDelegate>delegate;
@end


@protocol ExperienceFilterAddCollectionViewCellDelegate <NSObject>

@end

@interface ExperienceFilterAddCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) id<ExperienceFilterAddCollectionViewCellDelegate>delegate;
@end

@interface ExperienceFilterItem : NSObject
@property (strong, nonatomic) NSString *fieldID;
@property (strong, nonatomic) NSString *fieldDesc;
@property (strong, nonatomic) NSString *jobID;
@property (strong, nonatomic) NSString *jobDesc;
@end
