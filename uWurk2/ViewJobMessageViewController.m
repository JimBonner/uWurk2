//
//  ViewJobMessageViewController.m
//  
//
//  Created by Avery Bonner on 11/23/15.
//  Copyright (c) 2017 Jim Bonner. All rights reserved.
//
//

#import "ViewJobMessageViewController.h"
#import "JobInterestViewController.h"

@interface ViewJobMessageViewController ()

@property (weak, nonatomic) IBOutlet UILabel *txtDate;

@end

@implementation ViewJobMessageViewController

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MMMM dd, yyyy"];
    format.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:[NSTimeZone localTimeZone].secondsFromGMT];
    [format setDateFormat:@"MMMM dd, yyyy"];
    NSString *sent = [self.MailMessagedict objectForKey:@"sent_at"];
    double unixTimeStamp = [sent intValue];
    NSTimeInterval _interval=unixTimeStamp;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    format.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:[NSTimeZone localTimeZone].secondsFromGMT];
    self.txtDate.text = [format stringFromDate:date];
}

- (IBAction)pressGo:(id)sender
{
    NSDictionary *dict = self.MailMessagedict;
    JobInterestViewController *myController = [[UIStoryboard storyboardWithName:@"Mail" bundle:nil] instantiateViewControllerWithIdentifier:@"JobInterestView"];
    [myController setMailMessagedict:dict];
    [self.navigationController setViewControllers:@[myController] animated:TRUE];
}

@end
