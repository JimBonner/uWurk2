//
//  EmployerMessageDetailRightTableViewCell.h
//  uWurk2
//
//  Created by Avery Bonner on 1/18/16.
//  Copyright (c) 2016 Michael Brown. All rights reserved.
//  Copyright (c) 2017 Jim Bonner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmployerMessageDetailRightTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblText;
@property (weak, nonatomic) IBOutlet UIView *textBubbleView;

@end
