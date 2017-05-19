//
//  Spinner.m
//  uWurk2
//
//  Created by Jim Bonner on 5/18/17.
//  Copyright © 2017 Michael Brown. All rights reserved.
//

#import "Spinner.h"

@interface Spinner ()

@end

@implementation Spinner

static Spinner *sharedSpinner = nil;

+ (Spinner *)sharedSpinner
{
    if(sharedSpinner == nil) {
        sharedSpinner = [[super alloc]init];
    }
    return sharedSpinner;
}

- (void)initWithView:(UIView *)spinView
{

}

@end
