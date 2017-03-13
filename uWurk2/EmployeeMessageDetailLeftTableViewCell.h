//
//  EmployeeMessageDetailLeftTableViewCell.h
//  uWurk2
//
//  Created by Rob Bonner on 11/29/15.
//  Copyright © 2015 Michael Brown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmployeeMessageDetailLeftTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblText;
@property (weak, nonatomic) IBOutlet UIView *textBubbleView;
@end
