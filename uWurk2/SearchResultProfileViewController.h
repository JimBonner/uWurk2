//
//  SearchResultProfileViewController.h
//  uWurk2
//
//  Created by Avery Bonner on 9/27/15.
//  Copyright (c) 2015 Michael Brown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface SearchResultProfileViewController : BaseViewController

@property (strong, nonatomic) NSString *profileID;
@property (strong, nonatomic) NSDictionary *searchedUserDict;
@property (strong, nonatomic) NSDictionary *paramholder;
@property (strong, nonatomic) NSString *searchID;

@end
