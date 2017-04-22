//
//  ReferralProgramViewController.m
//  uWurk2
//
//  Created by Avery Bonner on 9/11/15.
//  Copyright (c) 2015 Michael Brown. All rights reserved.
//  Copyright (c) 2017 Jim Bonner. All rights reserved.
//

#import "ReferralProgramViewController.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>


@interface ReferralProgramViewController () <MFMailComposeViewControllerDelegate>
@end

@implementation ReferralProgramViewController
- (IBAction)highlightIcon:(id)sender {
    [sender setHighlighted:UIControlStateHighlighted];
}

- (IBAction)pressFacebook:(id)sender {
    NSString *s = [NSString stringWithFormat:@"https://www.facebook.com/sharer/sharer.php?u=http://uwurk.tscserver.com/ref/%@",[self.appDelegate.user objectForKey:@"referral_code"]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:s]];
}
- (IBAction)pressTwitter:(id)sender {
    NSString *s = [NSString stringWithFormat:@"https://twitter.com/intent/tweet?text=http://uwurk.tscserver.com/ref/%@&source=webclient",[self.appDelegate.user objectForKey:@"referral_code"]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:s]];
}
- (IBAction)pressGooglePlus:(id)sender {

    NSString *s = [NSString stringWithFormat:@"https://plus.google.com/share?url=http://uwurk.tscserver.com/ref/%@",[self.appDelegate.user objectForKey:@"referral_code"]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:s]];
}
- (IBAction)pressPinterest:(id)sender {
    NSString *s = [NSString stringWithFormat:@"https://www.pinterest.com/pin/create/button/?url=http://uwurk.tscserver.com/ref/%@&media=http://uwurk.tscserver.com/images/uWurk_referral-dog.jpg&description=uWurk, Where Jobs Look for U!",[self.appDelegate.user objectForKey:@"referral_code"]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:s]];
}
- (IBAction)pressInstagram:(id)sender {
}
- (IBAction)pressMail:(id)sender {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController* composeVC = [[MFMailComposeViewController alloc] init];
        composeVC.mailComposeDelegate = self;
        
        // Configure the fields of the interface.
//        [composeVC setToRecipients:@[@"address@example.com"]];
        [composeVC setSubject:@"uWurk!"];
        [composeVC setMessageBody:@"Hello from uWurk!  Need to know what to put in the email." isHTML:NO];
        
        // Present the view controller modally.
        [self presentViewController:composeVC animated:YES completion:nil];
    }
    else {
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    // Check the result or perform other tasks.
    
    // Dismiss the mail compose view controller.
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
