//
//  SearchResultProfileViewController.h
//  uWurk2
//
//  Created by Avery Bonner on 9/27/15.
//  Copyright (c) 2015 Michael Brown. All rights reserved.
//  Copyright (c) 2017 Jim Bonner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface SearchResultProfileViewController : BaseViewController

@property (strong, nonatomic) NSMutableDictionary *searchedUserDict;
@property (strong, nonatomic) NSMutableDictionary *searchParams;
@property (strong, nonatomic) NSMutableDictionary *otherParams;
@property (strong, nonatomic) NSString            *profileID;
@property (strong, nonatomic) NSString            *searchID;

@end
