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
//    public void onClickFacebook() {
//        launchBrowser("https://www.facebook.com/sharer/sharer.php?u=" + getString(R.string.hostname) + "/ref/" + employee.getReferralCode());
//    }
//
    NSURL *URL = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"https://www.facebook.com/sharer/sharer.php?u=http://uwurk.tscserver.com/ref/%@",[self.appDelegate.user objectForKey:@"referral_code"]]];
    [[UIApplication sharedApplication] openURL:URL];
}

- (IBAction)pressTwitter:(id)sender
{
//    public void onClickTwitter() {
//        launchBrowser("https://twitter.com/home?status=" + getString(R.string.hostname) + "/ref/" + employee.getReferralCode());
//    }
//
    NSURL *URL = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"https://twitter.com/home?status=http://uwurk.tscserver.com/ref/%@",[self.appDelegate.user objectForKey:@"referral_code"]]];
    [[UIApplication sharedApplication] openURL:URL];
}

- (IBAction)pressGooglePlus:(id)sender
{
//    public void onClickGoodle() {
//        launchBrowser("https://plus.google.com/share?url=" + getString(R.string.hostname) + "/ref/" + employee.getReferralCode());
//    }
//
    NSURL *URL = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"https://plus.google.com/share?url=http://uwurk.tscserver.com/ref/%@",[self.appDelegate.user objectForKey:@"referral_code"]]];
    [[UIApplication sharedApplication] openURL:URL];
}

- (IBAction)pressPinterest:(id)sender
{
//    public void onClickPinterest() {
//        launchBrowser("https://pinterest.com/pin/create/button/?url=" + getString(R.string.hostname) + "/ref/"  + employee.getReferralCode() + "&media=" + getString(R.string.hostname) + "/images/uWurk_referral-dog.jpg&description=uWurk,%20Where%20Jobs%20Look%20for%20U!");
//    }
    NSURL *URL = [[NSURL alloc]initWithString:@"https://www.pinterest.com/pin/create/button/?url=http%3A%2F%2Fuwurk.tscserver.com%2Fref%2F(null)&media=http%3A%2F%2Fuwurk.tscserver.com%2Fimages%2FuWurk_referral-dog.jpg&description=uWurk%2C%20Where%20Jobs%20Look%20for%20U!"];
    [[UIApplication sharedApplication] openURL:URL];
}

- (IBAction)pressInstagram:(id)sender
{
//    public void onClickInstagram() {
//        confirm(this, "SHARE TO INSTAGRAM", "Download the image and share with the link " + getString(R.string.hostname) + "/ref/" + employee.getReferralCode(),
//                "DOWNLOAD", "CANCEL", new View.OnClickListener() {
//                    @Override
//   public void onClick(View v) {
//                        launchBrowser(getString(R.string.hostname) + ServiceAPIImpl.API_PATH + "referralimage?type=instagram");
//                    }
//                });
//    }
//
//
    NSURL *URL = [[NSURL alloc]initWithString:@"https://www.instagram.com"];
    [[UIApplication sharedApplication] openURL:URL];
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
