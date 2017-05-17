//
//  EditEmployerCompanyInfoViewController.h
//  uWurk2
//
//  Created by Avery Bonner on 2/19/16.
//  Copyright (c) 2016 Michael Brown. All rights reserved.
//  Copyright (c) 2017 Jim Bonner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

@interface EditEmployerCompanyInfoViewController : BaseViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnIndustry;

@end
