//
//  SearchResultTableViewCell.h
//  uWurk2
//
//  Created by Avery Bonner on 9/23/15.
//  Copyright (c) 2015 Michael Brown. All rights reserved.
//  Copyright (c) 2017 Jim Bonner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel     *lblName;
@property (weak, nonatomic) IBOutlet UILabel     *line2;
@property (weak, nonatomic) IBOutlet UILabel     *line3;
@property (weak, nonatomic) IBOutlet UILabel     *line4;
@property (weak, nonatomic) IBOutlet UIImageView *imageProfile;
@property (weak, nonatomic) IBOutlet UILabel     *lblContacted;
@property (weak, nonatomic) IBOutlet UIButton    *btnFavorite;

@property (nonatomic, strong) NSString *searchID;
@property (nonatomic, strong) NSString *profileID;

@end
