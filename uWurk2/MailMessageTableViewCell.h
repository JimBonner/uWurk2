//
//  MailMessageTableViewCell.h
//  uWurk2
//
//  Created by Avery Bonner on 11/5/15.
//  Copyright (c) 2015 Michael Brown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MailMessageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblSubject;
@property (weak, nonatomic) IBOutlet UILabel *lblPosition;
@property (weak, nonatomic) IBOutlet UILabel *lblDateAndTime;
@property (weak, nonatomic) IBOutlet UIImageView *imageReply;
@property (weak, nonatomic) IBOutlet UIImageView *imageYesNo;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewYesNoWidth;

@end
