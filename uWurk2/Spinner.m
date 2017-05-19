//
//  Spinner.m
//  uWurk2
//
//  Created by Jim Bonner on 5/18/17.
//  Copyright © 2017 Michael Brown. All rights reserved.
//

#import "Spinner.h"

@interface Spinner ()

@property CGPoint center;
@property (nonatomic,strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation Spinner

static Spinner *sharedSpinner = nil;

+ (void)spinnerInitialize
{
    if(sharedSpinner == nil) {
        sharedSpinner = [[super alloc]init];
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGPoint center = CGPointMake(screenRect.origin.x + screenRect.size.width/2.0,
                                     screenRect.origin.y + screenRect.size.height/2.0);
        sharedSpinner.center = center;
        sharedSpinner.activityIndicator = [[UIActivityIndicatorView alloc]
                                           initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        sharedSpinner.activityIndicator.frame = CGRectMake(center.x - 30.0, center.y - 30.0,                                          60.0, 60.0);
        [sharedSpinner.activityIndicator setColor:[UIColor blackColor]];

        [[[UIApplication sharedApplication]keyWindow]addSubview:[sharedSpinner activityIndicator]];
    }
}

+ (void)startSpinner
{
    [Spinner spinnerInitialize];
    [sharedSpinner.activityIndicator setHidden:NO];
    [sharedSpinner.activityIndicator startAnimating];
}

+ (void)stopSpinner
{
    [sharedSpinner.activityIndicator stopAnimating];
}

@end
