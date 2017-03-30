//
//  EmployeeStep3ViewController.h
//  uWurk2
//
//  Created by Avery Bonner on 9/4/15.
//  Copyright (c) 2015 Michael Brown. All rights reserved.
//  Copyright (c) 2017 Jim Bonner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface EmployeeStep3ViewController : BaseViewController

@end

@protocol LanguageSpokenCollectionViewCellDelegate <NSObject>
@end

@interface LanguageSpokenCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) id<LanguageSpokenCollectionViewCellDelegate>delegate;
@property (nonatomic, strong) NSString *lauguage;
@property (nonatomic, strong) NSString *lauguageID;

@end
