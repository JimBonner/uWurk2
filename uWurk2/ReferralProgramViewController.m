//
//  ReferralProgramViewController.m
//  uWurk2
//
//  Created by Avery Bonner on 9/11/15.
//  Copyright (c) 2015 Michael Brown. All rights reserved.
//  Copyright (c) 2017 Jim Bonner. All rights reserved.
//

#import "ReferralProgramViewController.h"
#import "UrlImageRequest.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface ReferralProgramViewController () <MFMailComposeViewControllerDelegate>

@property (strong, nonatomic)IBOutlet UIImageView *imageView;

@property BOOL performInit;

@end

@implementation ReferralProgramViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.performInit = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"\nReferral Program - Init:\n%@",self.appDelegate.user);
    
    if(!self.performInit) {
        return;
    }
    self.performInit = NO;
    
    NSArray *photoArray = [[self.appDelegate user] objectForKey:@"photos"];
    for(NSDictionary *photoDict in photoArray) {
        if([[photoDict objectForKey:@"for_profile"] intValue] == 1) {
            NSURL *photoURL =[self serverUrlWith:[photoDict objectForKey:@"url"]];
            UrlImageRequest *photoRequest = [[UrlImageRequest alloc]initWithURL:photoURL];
            [photoRequest startWithCompletion:^(UIImage *newImage, NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.imageView setImage:newImage];
                });
            }];
        }
    }
    [self.view layoutIfNeeded];
}

- (IBAction)highlightIcon:(id)sender
{
    [sender setHighlighted:UIControlStateHighlighted];
}

- (IBAction)pressFacebook:(id)sender
{
    NSString *stringURL = [NSString stringWithFormat:@"https://www.facebook.com/sharer/sharer.php?u=http://uwurk.tscserver.com/ref/%@",[self.appDelegate.user objectForKey:@"referral_code"]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:stringURL]];
}

- (IBAction)pressTwitter:(id)sender
{
    NSString *stringURL = [NSString stringWithFormat:@"https://twitter.com/intent/tweet?text=http://uwurk.tscserver.com/ref/%@&source=webclient",[self.appDelegate.user objectForKey:@"referral_code"]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:stringURL]];
}

- (IBAction)pressGooglePlus:(id)sender
{
    NSString *stringURL = [NSString stringWithFormat:@"https://plus.google.com/share?url=http://uwurk.tscserver.com/ref/%@",[self.appDelegate.user objectForKey:@"referral_code"]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:stringURL]];
}

- (IBAction)pressPinterest:(id)sender
{
    NSString *stringURL = [NSString stringWithFormat:@"https://www.pinterest.com/pin/create/button/?url=http://uwurk.tscserver.com/ref/%@&media=http://uwurk.tscserver.com/images/uWurk_referral-dog.jpg&description=uWurk, Where Jobs Look for U!",[self.appDelegate.user objectForKey:@"referral_code"]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:stringURL]];
}

- (IBAction)pressInstagram:(id)sender
{
    NSString *stringURL = [NSString stringWithFormat:@"https://instragram.com"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:stringURL]];
}

- (IBAction)pressMail:(id)sender
{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *composeVC = [[MFMailComposeViewController alloc] init];
        composeVC.mailComposeDelegate = self;
        
        [composeVC setSubject:@"uWurk!"];
        [composeVC setMessageBody:@"Hello from uWurk development!\n\nNeed to know what to put in the email." isHTML:NO];
        
        [self presentViewController:composeVC animated:YES completion:nil];
    } else {
        
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
