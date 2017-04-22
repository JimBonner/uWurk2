//
//  EmployeeMessageDetailRightTableViewCell.h
//  uWurk2
//
//  Created by Rob Bonner on 11/29/15.
//  Copyright (c) 2015 Michael Brown. All rights reserved.
//  Copyright (c) 2017 Jim Bonner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmployeeMessageDetailRightTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblText;
@property (weak, nonatomic) IBOutlet UIView *textBubbleView;

@end
